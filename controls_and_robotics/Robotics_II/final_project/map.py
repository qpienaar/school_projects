'''This module contains the class definition for a map'''

import numpy as np
import matplotlib.pyplot as plt
from scipy.optimize import minimize

class Map:
    def __init__(self, Nx, Ny, obstacles, agent, target, tf=100, dt=0.01):
        '''
        Initalize map

        Inputs:
            Nx, Ny: Integer - number of points in x and y direction
            obstacles: 2d numpy array - each row is a collection of tuples defining a point of an obstacle. Each row is a complete obstacle
            agent: Agent object - agent
            target: target object - target

        Outputs:
            None
        '''
        print("Initializing map")
        self.grid = np.zeros((Nx, Ny))
        self.agent = agent
        self.target = target

        self.tf = tf
        self.dt = dt

        self.Vis = {(agent.x, agent.y)}
        self.Edges = set()

        self.obstacles = obstacles
        self._add_obstacles(obstacles)

    # public

    def build_visbility_intervals(self):
        print("Creating visibility intervals")
        # plot target trajectory
        t = 0
        visibility_intervals = {}
        previous_nodes = set()

        while t < self.tf: 
            t += self.dt
            pt1 = self.target.find_position(t)
            # find connected nodes
            connected_nodes = self._find_connected_nodes(pt1)

            for node in connected_nodes:
                
                if node not in visibility_intervals:                                # first time seeing node
                    visibility_intervals[node] = [[t, t]]

                elif node in visibility_intervals and node not in previous_nodes:   # seen node before, but not in last time step
                    visibility_intervals[node].append([t, t])

                elif node in visibility_intervals and node in previous_nodes:       # continuing to see node
                    visibility_intervals[node][-1][1] = t

            # clean up previous_nodes
            previous_nodes.clear()
            previous_nodes.update(connected_nodes)

        self.visibility_intervals = visibility_intervals
    
    def compute_edge_cost(self, visibility_intervals):
        '''
        Compute the minimum cost to intercept target from each node

        Inputs:
            visibility_intervals: dictionary - each nodes visibility time intervals

        Outputs:
            edge_costs: dictionary - each nodes edge cost and interception location
        '''
        print("Computing edge costs")
        edge_costs = {}
        # loop over each node
        for node, interval in visibility_intervals.items():
            edge_costs[node] = (1e10, 0, 0) # initialize to large edge cost
            # for each visibility interval find closest interception point
            for dt in interval: # loop over each time interval

                # calculate time to intercept
                result = self._find_intercept(node, dt)

                try:
                    deltat = result[0]
                    va = result[1]
                    theta = result[2]
                except:
                    continue

                t_intercept = dt[0] + deltat

                if t_intercept < edge_costs[node][0]:
                    edge_costs[node] = (deltat, va, theta)
        return edge_costs

    def build_visibility_graph(self):
        print("Building visibility map")
        # for point in obstacles and agents
        for pt1 in self.Vis:
            # for another point in obstacles and agents
            connected_nodes = self._find_connected_nodes(pt1)

            for node in connected_nodes:
                line = (pt1, node)
                self.Edges.add(line)
    
    def plot_map(self, edge_costs=None, save_path="visibility_graph.png"):
        '''
        Plot the map, visibility graph, and (optionally) interception trajectories.

        Inputs:
            edge_costs: dict (optional) - output of compute_edge_cost.
                        Values are (deltat, va, theta).
            save_path:  str - filepath to save the figure.
        '''
        print("Plotting map")
        fig, ax = plt.subplots(figsize=(10, 10))

        # --- Target trajectory ---
        t_vals = np.arange(0, self.tf, self.dt * 10)
        traj = [self.target.find_position(t) for t in t_vals]
        tx, ty = zip(*traj)
        ax.plot(tx, ty, 'g--', linewidth=1, alpha=0.4, label='Target trajectory')

        # --- Start markers ---
        ax.plot(self.agent.x, self.agent.y, 'bo', markersize=10, zorder=5, label='Agent start')
        ax.plot(self.target.x, self.target.y, 'g^', markersize=10, zorder=5, label='Target start')

        # --- Obstacles ---
        first_obs = True
        for obstacle in self.obstacles:
            xs = [pt[0] for pt in obstacle] + [obstacle[0][0]]
            ys = [pt[1] for pt in obstacle] + [obstacle[0][1]]
            label = 'Obstacle' if first_obs else None
            ax.fill(xs[:-1], ys[:-1], color='gray', alpha=0.35)
            ax.plot(xs, ys, 'k-', linewidth=2, label=label)
            first_obs = False

        # --- Visibility edges ---
        first_vis = True
        for edge in self.Edges:
            pt1, pt2 = edge
            label = 'Visibility edge' if first_vis else None
            ax.plot([pt1[0], pt2[0]], [pt1[1], pt2[1]],
                    'r--', linewidth=0.8, alpha=0.5, label=label)
            first_vis = False

        # --- Interception trajectories ---
        if edge_costs:
            best_node, best_cost, best_intercept = None, 1e10, None
            first_traj = True

            for node, (deltat, va, theta) in edge_costs.items():
                if deltat >= 1e9:
                    continue
                ix = node[0] + va * np.cos(theta) * deltat
                iy = node[1] + va * np.sin(theta) * deltat
                label = 'Intercept trajectory' if first_traj else None
                ax.plot([node[0], ix], [node[1], iy],
                        '-', color='darkorange', linewidth=1.4, alpha=0.6, label=label)
                ax.plot(ix, iy, 'r*', markersize=10, zorder=6)
                first_traj = False
                if deltat < best_cost:
                    best_cost, best_node, best_intercept = deltat, node, (ix, iy)

            # Highlight optimal
            if best_node is not None:
                bx, by = best_intercept
                _, va_b, th_b = edge_costs[best_node]
                ax.plot([best_node[0], bx], [best_node[1], by],
                        '-', color='red', linewidth=2.5, zorder=7, label='Optimal trajectory')
                ax.plot(bx, by, 'r*', markersize=18, zorder=8,
                        markeredgecolor='darkred', markeredgewidth=0.8,
                        label=f'Best intercept (dt={best_cost:.2f}s)')
                ax.annotate(
                    f'dt = {best_cost:.2f} s\nv  = {va_b:.2f}\nth = {np.degrees(th_b):.1f} deg',
                    xy=(bx, by), xytext=(bx + 0.3, by + 0.3), fontsize=9, color='darkred',
                    bbox=dict(boxstyle='round,pad=0.3', fc='white', ec='darkred', alpha=0.85)
                )

        ax.set_xlim(0, self.grid.shape[1])
        ax.set_ylim(0, self.grid.shape[0])
        ax.set_aspect('equal')
        ax.grid(True, linestyle=':', alpha=0.4)
        ax.legend(loc='upper left', fontsize=8)
        ax.set_title("Map, Visibility Graph & Interception Trajectories", fontsize=13)
        ax.set_xlabel("X")
        ax.set_ylabel("Y")
        plt.tight_layout()
        plt.savefig(save_path, dpi=150)
        plt.show()

    # private

    def _add_obstacles(self, obstacles):
        for obstacle in obstacles:
            for point in obstacle:

                self.Vis.add(point)

                x = point[0]
                y = point[1]
                self.grid[0][1] = 1

    def _check_collisions(self, line1, line2):
        '''Check if 2 points are collision free
        Inputs:
            line1: Array - 2 tuples denoting two ends of line of intererst
            line2: Array - 2 tuples denoting two ends of other line of interest
        
        Returns:
            Boolean: True if there exists a collision
        '''
        pt1 = line1[0]
        pt2 = line1[1]
        pt3 = line2[0]
        pt4 = line2[1]

        x1 = pt1[0]
        y1 = pt1[1]
        x2 = pt2[0]
        y2 = pt2[1]

        x3 = pt3[0]
        y3 = pt3[1]
        x4 = pt4[0]
        y4 = pt4[1]
        
        denom = (x4 - x3) * (y2 - y1) - (y4 - y3) * (x2 - x1)
        num_t = (x4 - x3) * (y3 - y1) - (y4 - y3) * (x3 - x1)
        num_u = (x2 - x1) * (y3 - y1) - (y2 - y1) * (x3 - x1)

        if denom == 0:
            # parallel or collinear
            cross = (x3 - x1) * (y2 - y1) - (y3 - y1) * (x2 - x1)

            if cross != 0:
                # parallel, separate lines
                return False
            else: # collinear
                return True

        t = num_t / denom
        u = num_u / denom

        # fix 6: both parameters must be in [0, 1] for a real intersection
        return (0 <= t <= 1) and (0 <= u <= 1)
    
    def _find_connected_nodes(self, pt1):
        '''
        Given a point find all connected nodes on the map

        Inputs:
            pt: tuple - the pt to find connections from

        Outputs:
            connected_nodes: array - all points which are visible from another point
        '''
        connected_nodes = []
        for pt2 in self.Vis:
                if pt1 == pt2:
                    continue
                # now we have one line segment
                line1 = (pt1, pt2)
                valid_edge = True

                # for each obstacle
                for obstacle in self.obstacles:
                    collision = False
                    # assume adjacent vertices in obstacle define an obstacle edge (first and last vertex are adjacent)
                    for i in range(len(obstacle)):
                        pt3 = obstacle[i]
                        pt4 = obstacle[i-1]

                        if {pt1, pt2} == {pt3, pt4}:
                            collision = True
                            break

                        if pt3 == pt1 or pt3 == pt2 or pt4 == pt1 or pt4 == pt2:
                            continue

                        line2 = (pt3, pt4)
                        if self._check_collisions(line1, line2):
                            # collision found, line1 is infeasible
                            collision = True
                            break
                    if collision:
                        valid_edge = False
                        break

                if valid_edge:
                    connected_nodes.append(pt2)
        return connected_nodes
    
    def _find_intercept(self, q, dt):
        '''
        Given a node q, and time interval dt, find optimal interception point and time for agent intercept

        Inputs:
            q: tuple - node position
            dt: list - [t0, tf] initial and final time of target visibility interval

        Returns:
            x: tuple - intercept position
            t: float - time for agent intercept
        '''
        def obj(x):
            return x[0]
        
        def intercept_constraint(x):
            deltat = x[0]
            Va = x[1]
            theta = x[2]

            A0 = np.array([q[0], q[1]])
            A1 = A0 + Va * np.array([np.cos(theta), np.sin(theta)]) * deltat
            T1 = self.target.find_position(deltat)
            return A1 - np.array([T1[0], T1[1]])
             
        x0 = [1.0, self.agent.vel, 0]   #deltat, Va, theta
        bounds = [(dt[0], dt[1]), (0, self.agent.vel), (0, 2*np.pi)]
        cons = [{'type': 'eq', 'fun': intercept_constraint}]
        res = minimize(obj, x0, method='SLSQP', bounds=bounds, constraints=cons)

        if res.success:
            return res.x
        else:
            return None