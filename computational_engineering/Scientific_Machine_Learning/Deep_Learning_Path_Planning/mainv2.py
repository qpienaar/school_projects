from map import Map
from astar import AStar
from cnn import CNN, PiecewiseLoss

import numpy as np
import torch
import os
import torch.nn as nn
import torch.optim as optim
from torch.utils.data import TensorDataset, DataLoader


# set device - I only have a cpu
device = torch.device('cpu')

# flag for the alpha sweep experiments
RUN_ALPHA_SWEEP = False

def build_dataset(maps):
    """Build (X, y, h_min) tensors from a list of Map objects."""
    X_list, y_list, h_min_list = [], [], []
    for i, m in enumerate(maps):
        cost_map = m.compute_cost_map()
        for r in range(m.grid_size):
            for c in range(m.grid_size):
                if m.grid[r, c] == 1 or np.isinf(cost_map[r, c]):
                    continue
                x = np.zeros((3, m.grid_size, m.grid_size), dtype=np.float32)
                x[0] = m.grid.astype(np.float32)
                x[1, r, c] = 1.0
                x[2, m.goal[0], m.goal[1]] = 1.0
                X_list.append(x)
                max_cost = m.grid_size * 2
                y_list.append(float(cost_map[r, c]) / max_cost)

                euclidean = np.sqrt((r - m.goal[0]) ** 2 + (c - m.goal[1]) ** 2)
                h_min_val = euclidean / (m.grid_size * 2)
                h_min_list.append(h_min_val)

        if (i + 1) % 10 == 0:
            print(f"  Processed map {i + 1:3d}")

    X = torch.tensor(np.array(X_list), dtype=torch.float32)
    y = torch.tensor(np.array(y_list), dtype=torch.float32).unsqueeze(1)
    h_min = torch.tensor(np.array(h_min_list), dtype=torch.float32).unsqueeze(1)
    return TensorDataset(X, y, h_min)


def train_model(model, train_dataset, val_dataset, learning_rate=1e-3, batch_size=20,
                alpha1=1.0, alpha2=5.0, max_iter=20, tol=1e-6):
    """Train a model with the PiecewiseLoss."""
    loss_fn = PiecewiseLoss(alpha1=alpha1, alpha2=alpha2)
    optimizer = optim.Adam(model.parameters(), lr=learning_rate, weight_decay=1e-4)

    train_loader = DataLoader(train_dataset, batch_size=batch_size, shuffle=True)
    val_loader = DataLoader(val_dataset, batch_size=batch_size)

    train_loss_history = []
    val_loss_history = []

    print('Beginning Training')
    for epoch in range(max_iter):
        model.train()
        running_loss = 0.0
        for xb, yb, hb in train_loader:
            xb, yb, hb = xb.to(device), yb.to(device), hb.to(device)
            pred = model(xb)
            train_loss = loss_fn(pred, yb, hb)
            optimizer.zero_grad()
            train_loss.backward()
            optimizer.step()
            running_loss += train_loss.item() * xb.size(0)

        epoch_loss = running_loss / len(train_dataset)
        train_loss_history.append(epoch_loss)

        model.eval()
        with torch.no_grad():
            val_loss = 0.0
            for xb, yb, hb in val_loader:
                xb, yb, hb = xb.to(device), yb.to(device), hb.to(device)
                val_loss += loss_fn(model(xb), yb, hb).item() * xb.size(0)
            val_loss /= len(val_dataset)
            val_loss_history.append(val_loss)

        print(f"Epoch {epoch + 1:02d} | Train loss: {epoch_loss:.6f} | Val loss: {val_loss:.6f}")
        if epoch > 0 and abs(val_loss_history[-1] - val_loss_history[-2]) < tol:
            print('Stopping: val loss change is below tolerance.')
            break

    return model, train_loss_history, val_loss_history


def evaluate_model(model, test_dataset, test_maps):
    """Print summary metrics and compare A* node visits."""
    test_X, test_y, _ = test_dataset.tensors

    model.eval()
    with torch.no_grad():
        test_pred = model(test_X.to(device))
        test_mae = torch.mean(torch.abs(test_pred - test_y.to(device))).item()
        overestimates = (test_pred > test_y.to(device)).float().mean().item()

    print(f"  Test examples:     {len(test_dataset):,}")
    print(f"  Test MAE:          {test_mae:.3f} steps")
    print(f"  Overestimate rate: {100 * overestimates:.1f}%")

    print(f"\nRunning A* comparison on {len(test_maps)} test maps...")
    results = []
    for i, m in enumerate(test_maps):
        astar_e = AStar(m)
        path_e = astar_e.run()
        astar_l = AStar(m, heuristic_fn=model.make_heuristic_fn(m))
        path_l = astar_l.run()

        if path_e is None or path_l is None:
            continue

        results.append((astar_e, path_e, astar_l, path_l))

    if not results:
        print('  No valid A* runs to summarize.')
        return {
            'test_mae': test_mae,
            'overestimate_rate': overestimates,
            'avg_nodes_e': np.nan,
            'avg_nodes_l': np.nan,
            'node_reduction': np.nan,
        }

    nodes_e = [len(r[0].visited) for r in results]
    nodes_l = [len(r[2].visited) for r in results]

    avg_e = float(np.mean(nodes_e))
    avg_l = float(np.mean(nodes_l))
    node_reduction = 100.0 * (1.0 - avg_l / avg_e) if avg_e else np.nan

    print("\n" + "=" * 55)
    print("  Summary")
    print("=" * 55)
    print(f"  Avg nodes (Euclidean):   {avg_e:.1f}")
    print(f"  Avg nodes (Learned):     {avg_l:.1f}")
    print(f"  Node reduction:          {node_reduction:+.1f}%")
    print(f"  Overestimate rate:       {100 * overestimates:.1f}%")
    print(f"  Test MAE:                {test_mae:.3f} steps")

    return {
        'test_mae': test_mae,
        'overestimate_rate': overestimates,
        'avg_nodes_e': avg_e,
        'avg_nodes_l': avg_l,
        'node_reduction': node_reduction,
    }


def main():

    MODEL_PATH = 'heuristic_model.pt'

    if not os.path.exists(MODEL_PATH):

        print('Generating training data')

        # gather data
        maps = [Map() for _ in range(500)]
        split = int(0.8 * len(maps))
        train_maps, val_maps = maps[:split], maps[split:]

        # hyper parameters
        learning_rate = 0.001
        batch_size = 20

        # initialize network - default parameters work for my application
        model = CNN()

        train_dataset = build_dataset(train_maps)
        val_dataset = build_dataset(val_maps)

        # train model until change in validation loss is small
        model, train_loss_history, val_loss_history = train_model(
            model,
            train_dataset,
            val_dataset,
            learning_rate=learning_rate,
            batch_size=batch_size,
            alpha1=1.0,
            alpha2=10.0,
            max_iter=30,
            tol=1e-6,
        )

        print(f'Training complete. Final val loss: {val_loss_history[-1]:.6f}\nBeginning Testing')

        # Save after training
        torch.save({
            'model_state_dict': model.state_dict(),
            'alpha1': 1.0,
            'alpha2': 20.0,   # use your best alpha2 from the sweep
        }, 'heuristic_model.pt')
        print("Model saved to heuristic_model.pt")
    else:
        print("Loading saved model...")
        model = CNN()
        checkpoint = torch.load(MODEL_PATH, map_location='cpu')
        model.load_state_dict(checkpoint['model_state_dict'])
        model.eval()
        print("Model loaded.")

    N_tests = 100
    test_maps = [Map() for _ in range(N_tests)]
    test_dataset = build_dataset(test_maps)

    summary = evaluate_model(model, test_dataset, test_maps)

    print('\nFinished.')

    if RUN_ALPHA_SWEEP:
        from alpha_sweep import run_alpha_sweep
        run_alpha_sweep()

    return summary


if __name__ == '__main__':
    main()
