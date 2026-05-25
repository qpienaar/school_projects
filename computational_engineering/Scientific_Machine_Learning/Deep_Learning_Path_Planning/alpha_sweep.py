from map import Map
from astar import AStar

try:
    from cnnv2 import CNN
except ImportError:
    from cnn import CNN

from mainv2 import build_dataset, train_model

import numpy as np
import torch
import matplotlib.pyplot as plt


def run_alpha_sweep(
    alpha2_candidates=None,
    n_train_maps=500,
    n_sweep_maps=50,
    learning_rate=1e-3,
    batch_size=20,
    max_iter=20,
    alpha1=1.0,
):
    """Train a fresh model for each alpha2 and compare admissibility vs efficiency."""
    if alpha2_candidates is None:
        alpha2_candidates = [1.0, 2.0, 3.0, 5.0, 8.0, 12.0, 20.0]

    print('Generating alpha sweep data')
    maps = [Map() for _ in range(n_train_maps)]
    split = int(0.8 * len(maps))
    train_maps, val_maps = maps[:split], maps[split:]
    train_dataset = build_dataset(train_maps)
    val_dataset = build_dataset(val_maps)

    sweep_maps = [Map() for _ in range(n_sweep_maps)]

    results = []

    for a2 in alpha2_candidates:
        print(f"\nTraining sweep model for alpha2={a2}")
        model = CNN()
        model, _, _ = train_model(
            model,
            train_dataset,
            val_dataset,
            learning_rate=learning_rate,
            batch_size=batch_size,
            alpha1=alpha1,
            alpha2=a2,
            max_iter=max_iter,
            tol=1e-6,
        )

        model.eval()

        nodes_e_list = []
        nodes_l_list = []
        overestimates = 0
        total_cells = 0
        for m in sweep_maps:
            ae = AStar(m)
            pe = ae.run()
            h_fn = model.make_heuristic_fn(m)
            al = AStar(m, heuristic_fn=h_fn)
            pl = al.run()
            if pe is None or pl is None:
                continue
            nodes_e_list.append(len(ae.visited))
            nodes_l_list.append(len(al.visited))

            # Cell-by-cell overestimation check (matches experiment.py)
            cost_map = m.compute_cost_map()
            for r in range(m.grid_size):
                for c in range(m.grid_size):
                    if m.grid[r, c] == 1 or np.isinf(cost_map[r, c]):
                        continue
                    h_val = h_fn((r, c), m.goal)
                    h_star = cost_map[r, c]
                    total_cells += 1
                    if h_val > h_star:
                        overestimates += 1

        overest_rate = 100.0 * overestimates / total_cells if total_cells else np.nan

        if not nodes_e_list:
            print(f"  alpha2={a2} produced no valid A* runs; skipping.")
            continue

        avg_nodes_e = float(np.mean(nodes_e_list))
        avg_nodes_l = float(np.mean(nodes_l_list))
        node_reduction = 100.0 * (1.0 - avg_nodes_l / avg_nodes_e) if avg_nodes_e else np.nan

        results.append(
            {
                'alpha2': a2,
                'avg_nodes_e': avg_nodes_e,
                'avg_nodes_l': avg_nodes_l,
                'node_reduction': node_reduction,
                'overest_rate': overest_rate,
            }
        )

        print(
            f"  α₂={a2:5.1f} | reduction={node_reduction:+.1f}% | overest={overest_rate:.1f}%"
        )

    if not results:
        print('No sweep results were generated.')
        return results

    results = sorted(results, key=lambda r: r['alpha2'])

    fig, ax = plt.subplots(figsize=(8, 5))
    x = [r['overest_rate'] for r in results]
    y = [r['node_reduction'] for r in results]

    ax.plot(x, y, marker='o', linewidth=2, label='alpha2 sweep')

    for r in results:
        ax.annotate(
            f"α₂={r['alpha2']}",
            (r['overest_rate'], r['node_reduction']),
            textcoords='offset points',
            xytext=(6, 6),
            fontsize=8,
        )

    ax.set_xlabel('Admissibility (overestimate rate %)')
    ax.set_ylabel('Efficiency (% reduction in nodes explored)')
    ax.set_title('Alpha sweep: efficiency vs admissibility')
    ax.grid(True, alpha=0.3)
    ax.legend()
    plt.tight_layout()
    plt.savefig('alpha_sweep.png', dpi=150, bbox_inches='tight')
    plt.show()

    return results


if __name__ == '__main__':
    run_alpha_sweep()