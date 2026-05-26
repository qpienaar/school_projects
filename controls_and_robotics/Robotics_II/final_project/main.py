"""
main.py — Performance test: execution time vs number of obstacle sets.

Scene layout  (20 × 20 map):
  Agent   :  (1, 10)  vel=1
  Target  : (19, 19)  vel=1, heading=180° (moving left toward agent)
  Obstacles: N sets of 8 equilateral triangles (side=1) stacked vertically,
             equally spaced between agent and target.

Each obstacle SET is a single vertical column of N_TRI triangles.
Sets are spaced evenly in x between agent and target (small fixed margins).

Test range : 1 – 100 obstacle sets.
Outputs    : console log, performance_plot.png,
             performance_difference_plot.png,
             visibility_graph_1set.png, visibility_graph_100sets.png
"""

import time
import numpy as np
import matplotlib.pyplot as plt

from agent import Agent
from map   import Map

# ── fixed geometry ────────────────────────────────────────────────────────────
AGENT_X,  AGENT_Y  =  1, 10
TARGET_X, TARGET_Y = 39, 19
MAP_NX,   MAP_NY   = 40, 20
CENTER_Y            = 10

TRI_SIDE  = 1.0
N_TRI     = 8

TRI_H     = TRI_SIDE * np.sqrt(3) / 2
TRI_GAP   = (MAP_NY - N_TRI * TRI_H) / (N_TRI - 1)

SET_MARGIN = 1.5

SIM_TF    = 200.0
SIM_DT    = 0.5

SET_RANGE = range(1, 11)


def upward_triangle(x_left: float, y_bottom: float, side: float = TRI_SIDE):
    h = side * np.sqrt(3) / 2
    return [
        (x_left,          y_bottom),
        (x_left + side,   y_bottom),
        (x_left + side/2, y_bottom + h),
    ]


def make_obstacle_set(x_centre: float):
    step    = TRI_H + TRI_GAP
    y_start = 0.0

    triangles = []
    for i in range(N_TRI):
        y_base = y_start + i * step
        x_left = x_centre - TRI_SIDE / 2
        triangles.append(upward_triangle(x_left, y_base))
    return triangles


def generate_obstacles(n_sets: int):
    x_lo = AGENT_X  + SET_MARGIN
    x_hi = TARGET_X - SET_MARGIN

    if n_sets == 1:
        xs = [(x_lo + x_hi) / 2]
    else:
        xs = list(np.linspace(x_lo, x_hi, n_sets))

    obstacles = []
    for x in xs:
        obstacles.extend(make_obstacle_set(x))
    return obstacles


def run_trial(n_sets: int, save_path: str | None = None):
    agent     = Agent(x=AGENT_X,  y=AGENT_Y,  vel=1)
    target    = Agent(x=TARGET_X, y=TARGET_Y, vel=1,
                      heading=np.radians(270))
    obstacles = generate_obstacles(n_sets)

    sim_map = Map(
        Nx=MAP_NX, Ny=MAP_NY,
        obstacles=obstacles,
        agent=agent,
        target=target,
        tf=SIM_TF,
        dt=SIM_DT,
    )

    t_mtvg_start = time.perf_counter()
    t_static_start = time.perf_counter()
    sim_map.build_visibility_graph()
    t_static = time.perf_counter() - t_static_start

    sim_map.build_visbility_intervals()
    edge_costs = sim_map.compute_edge_cost(sim_map.visibility_intervals)

    t_mtvg = time.perf_counter() - t_mtvg_start

    if save_path:
        _save_visibility_graph(sim_map, edge_costs, n_sets, save_path)

    return t_mtvg, t_static


def _save_visibility_graph(sim_map, edge_costs, n_sets: int, path: str):
    fig, ax = plt.subplots(figsize=(14, 7))

    # obstacles
    for obs in sim_map.obstacles:
        xs = [p[0] for p in obs] + [obs[0][0]]
        ys = [p[1] for p in obs] + [obs[0][1]]
        ax.fill(xs[:-1], ys[:-1], color='gray', alpha=0.45)
        ax.plot(xs, ys, 'k-', linewidth=0.8)

    # visibility graph edges
    for (p1, p2) in sim_map.Edges:
        ax.plot([p1[0], p2[0]], [p1[1], p2[1]],
                color='steelblue', linewidth=0.3, alpha=0.4)

    # interception trajectories
    target = sim_map.target
    first_agent_label = True
    first_target_label = True

    for node, cost in edge_costs.items():
        if cost[0] >= 1e9:
            continue

        delta_t, va, theta = cost

        ix = node[0] + va * np.cos(theta) * delta_t
        iy = node[1] + va * np.sin(theta) * delta_t

        # agent intercept path
        ax.plot([node[0], ix], [node[1], iy], 'orange', linestyle='--', linewidth=1.2,
                label='Agent intercept path' if first_agent_label else None)

        # target path to intercept
        ts = np.linspace(0, delta_t, max(2, int(delta_t / SIM_DT)))
        tgt_xs = [target.find_position(t)[0] for t in ts]
        tgt_ys = [target.find_position(t)[1] for t in ts]
        ax.plot(tgt_xs, tgt_ys, 'crimson', linestyle=':', linewidth=1.0,
                label='Target path' if first_target_label else None)

        # intercept point
        ax.plot(ix, iy, 'x', markersize=6)

        first_agent_label = False
        first_target_label = False

    ax.plot(sim_map.agent.x, sim_map.agent.y, 'bo', markersize=10, label='Agent')
    ax.plot(sim_map.target.x, sim_map.target.y, 'r*', markersize=12, label='Target')

    ax.set_xlim(0, MAP_NX)
    ax.set_ylim(0, MAP_NY)
    ax.set_aspect('equal')
    ax.grid(True, alpha=0.3)
    ax.legend(loc='upper left', fontsize=8)
    ax.set_title(f"Visibility Graph — {n_sets} obstacle set(s)")

    plt.tight_layout()
    plt.savefig(path, dpi=120)
    plt.show()


def plot_performance_and_difference(n_sets_list, times_mtvg, times_static):
    differences = [mtvg - static for mtvg, static in zip(times_mtvg, times_static)]

    fig, (ax1, ax2) = plt.subplots(2, 1, figsize=(10, 9), sharex=True)

    ax1.plot(n_sets_list, times_mtvg, 'b-o', markersize=3, linewidth=1.2,
             label='Moving Target Visibility Graph (full pipeline)')
    ax1.plot(n_sets_list, times_static, 'r-o', markersize=3, linewidth=1.2,
             label='Static Visibility Graph only')
    ax1.set_ylabel("Execution time (s)")
    ax1.set_title("Performance Test: MTVG vs Static Visibility Graph")
    ax1.legend(loc='upper left')
    ax1.grid(True, alpha=0.4)

    ax2.plot(n_sets_list, differences, 'g-o', markersize=3, linewidth=1.2)
    ax2.set_xlabel("Number of obstacle sets")
    ax2.set_ylabel("Time difference (s)")
    ax2.set_title("MTVG - Static VG vs Number of Obstacle Sets")
    ax2.grid(True, alpha=0.4)

    plt.tight_layout()
    #plt.savefig("performance_plot.png", dpi=120)
    plt.savefig("performance_difference_plot.png", dpi=120)
    plt.show()


def main():
    n_sets_list  = list(SET_RANGE)
    times_mtvg   = []
    times_static = []

    for i, n in enumerate(n_sets_list):
        print(f"Running trial {n}")
        save_path = None
        if i == 0:
            save_path = "visibility_graph_1set.png"
        elif i == len(n_sets_list) - 1:
            save_path = "visibility_graph_100sets.png"

        t_mtvg, t_static = run_trial(n, save_path=save_path)
        times_mtvg.append(t_mtvg)
        times_static.append(t_static)

    plot_performance_and_difference(n_sets_list, times_mtvg, times_static)


if __name__ == "__main__":
    main()
