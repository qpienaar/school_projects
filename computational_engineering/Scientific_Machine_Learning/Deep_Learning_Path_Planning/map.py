import numpy as np
import matplotlib.pyplot as plt
from matplotlib.colors import ListedColormap
import random
import torch
import heapq
'''Module contains class definition for a map'''
class Map:
    def __init__(self, grid_size=20, obs_frac=0.3, style='mixed'):
        self.grid_size = grid_size
        self.obs_frac = obs_frac
        self.style = style
        self._max_obs_size = max(2, int(grid_size / 10))

        self.start = None
        self.goal = None
        self._is_connected = False
        self.grid = np.zeros((self.grid_size, self.grid_size), dtype=int)
        self._generate_map()

    def _generate_map(self):
        styles = ["random", "walls", "rooms", "mixed"]
        if self.style not in styles:
            raise ValueError(f"Unknown MAP_STYLE '{self.style}'. Choose from {styles}.")
        if self.style == "mixed":
            self.style = random.choice(styles[:-1])  # don't pick "mixed" again

        max_iter = 1000
        for _ in range(max_iter):
            self.grid = np.zeros((self.grid_size, self.grid_size), dtype=int)
            self._is_connected = False

            self.start = (random.randint(0, self.grid_size//3), random.randint(0, self.grid_size//3))
            self.goal = (random.randint(2*self.grid_size//3, self.grid_size-1), random.randint(2*self.grid_size//3, self.grid_size-1))

            if self.style == "random":
                self._random_obstacles()
            elif self.style == "walls":
                self._walls()
            elif self.style == "rooms":
                self._rooms()

            self.grid[self.start] = 0
            self.grid[self.goal] = 0

            if self._is_connected_check():
                return

        raise RuntimeError("Failed to generate a connected map.")
    
    def compute_cost_map(self):
        """True optimal cost from every free cell to goal via Dijkstra."""
        costs = np.full(self.grid.shape, np.inf)
        costs[self.goal] = 0
        pq = [(0, self.goal)]
        while pq:
            cost, pos = heapq.heappop(pq)
            if cost > costs[pos]:
                continue
            r, c = pos
            for dr, dc in [(-1,0),(1,0),(0,-1),(0,1)]:
                nr, nc = r+dr, c+dc
                if 0 <= nr < self.grid.shape[0] and 0 <= nc < self.grid.shape[1]:
                    if self.grid[nr, nc] == 0 and cost + 1 < costs[nr, nc]:
                        costs[nr, nc] = cost + 1
                        heapq.heappush(pq, (cost + 1, (nr, nc)))
        return costs
    
    def plot_map(self, path=None, visited=None, filename=None):
        """Plots the grid, start/goal, metadata, and optionally A* results."""
        import matplotlib.pyplot as plt
        from matplotlib.colors import ListedColormap

        plt.figure(figsize=(12, 12))
        
        # Colormap
        cmap = ListedColormap(['#ffffff', '#404040'])
        plt.imshow(self.grid, cmap=cmap, origin='upper')

        # --- Visited nodes (draw first so path overlays cleanly) ---
        if visited:
            vr = [p[0] for p in visited]
            vc = [p[1] for p in visited]
            plt.scatter(vc, vr, c='lightblue', s=10, label='Visited')

        # --- Path ---
        if path:
            pr = [p[0] for p in path]
            pc = [p[1] for p in path]
            plt.plot(pc, pr, 'r-', linewidth=2, label='Path')

        # --- Start and Goal ---
        if self.start is not None:
            plt.plot(self.start[1], self.start[0], 'gs', markersize=10, label=f"Start: {self.start}")
        if self.goal is not None:
            plt.plot(self.goal[1], self.goal[0], 'r*', markersize=15, label=f"Goal: {self.goal}")

        # --- Metadata ---
        actual_frac = np.sum(self.grid) / (self.grid_size**2)

        plt.title(f"Map Style: {self.style.capitalize()}", fontsize=14, fontweight='bold')

        info_text = (f"Target Obstacle Frac: {self.obs_frac:.2f}\n"
                    f"Actual Obstacle Frac: {actual_frac:.2f}\n"
                    f"Grid Size: {self.grid_size}x{self.grid_size}")

        plt.text(0, self.grid_size + 2, info_text, fontsize=10,
                verticalalignment='top', family='monospace',
                bbox=dict(boxstyle='round', facecolor='wheat', alpha=0.5))

        plt.legend(loc='upper right', bbox_to_anchor=(1.2, 1))
        plt.axis('off')
        plt.tight_layout()
        if filename:
            plt.savefig(filename, dpi=150, bbox_inches='tight')
        plt.show()

    def draw_panel(self, ax, grid, visited, path, start, goal, title, visited_color):
        """Render one A* result onto ax."""
        size = grid.shape[0]
        ax.imshow(grid.astype(float), cmap=ListedColormap(['#f7f7f7', '#2d2d2d']),
                origin='upper', interpolation='nearest', vmin=0, vmax=1, zorder=0)
        if visited:
            pts = [p for p in visited if p not in (start, goal)]
            if pts:
                vr, vc = zip(*pts)
                ax.scatter(vc, vr, c=visited_color, s=18, zorder=2, alpha=0.75, linewidths=0)
        if path:
            pr, pc = zip(*path)
            ax.plot(pc, pr, '-', color='#e63946', linewidth=2.2, zorder=3, solid_capstyle='round')
        ax.plot(start[1], start[0], 's', color='#2dc653', markersize=9,  zorder=4)
        ax.plot(goal[1],  goal[0],  '*', color='#e63946', markersize=12, zorder=4)
        ax.set_title(title, fontsize=10, pad=4)
        ax.set_xticks([]); ax.set_yticks([])
        ax.set_xticks(np.arange(-0.5, size, 1), minor=True)
        ax.set_yticks(np.arange(-0.5, size, 1), minor=True)
        ax.grid(which='minor', color='#cccccc', linewidth=0.3)
        ax.tick_params(which='minor', length=0)

    def _is_connected_check(self):
        if self.grid[self.start] == 1 or self.grid[self.goal] == 1:
            self._is_connected = False
            return False

        visited = {self.start}
        queue = [self.start]

        while queue:
            r, c = queue.pop()
            if (r, c) == self.goal:
                self._is_connected = True
                return True

            for dr, dc in [(-1,0), (1,0), (0,-1), (0,1)]:
                nr, nc = r + dr, c + dc
                if 0 <= nr < self.grid_size and 0 <= nc < self.grid_size:
                    if (nr, nc) not in visited and self.grid[nr, nc] == 0:
                        visited.add((nr, nc))
                        queue.append((nr, nc))

        self._is_connected = False
        return False
    
    def _random_obstacles(self):
        """Scatter random rectangles across the grid (clutter top-up happens after enforcement)."""
        size = self.grid.shape[0]
        while (np.sum(self.grid)/np.square(size) < self.obs_frac):
            h  = np.random.randint(1, self._max_obs_size)
            w  = np.random.randint(1, self._max_obs_size)
            r0 = np.random.randint(0, size - h)
            c0 = np.random.randint(0, size - w)
            self.grid[r0:r0+h, c0:c0+w] = 1
    
    def _walls(self):
        size = self.grid.shape[0]
        gaps = []
        while (np.sum(self.grid) / np.square(size) < self.obs_frac * 0.75):
            orientation = np.random.rand()
            obstacle = np.random.randint(0, size)
            gap = np.random.randint(0, size)

            if orientation < 0.5:
                self.grid[obstacle, :] = 1
                gaps.append((obstacle, gap))
            else:
                self.grid[:, obstacle] = 1
                gaps.append((gap, obstacle))

        self._fill_to_density()
        for r, c in gaps:
            for dr, dc in [(0,0), (-1,0), (1,0), (0,-1), (0,1)]:
                nr, nc = r + dr, c + dc
                if 0 <= nr < self.grid_size and 0 <= nc < self.grid_size:
                    self.grid[nr, nc] = 0

    def _rooms(self):
        """
        Uses Binary Space Partitioning to create a random number of rooms (4-32)
        with randomized doorway placement.
        """
        # 1. Determine how many rooms we want
        target_rooms = random.randint(4, 32)
        
        # Each 'room' is defined as (y1, x1, y2, x2)
        # Start with one room encompassing the whole grid
        rooms = [(0, 0, self.grid_size, self.grid_size)]
        
        # Minimum room dimension to prevent "sliver" rooms
        min_size = 4 

        # 2. Keep splitting until we hit our target count
        while len(rooms) < target_rooms:
            # Pick the largest room to split (keeps things more uniform)
            rooms.sort(key=lambda r: (r[2]-r[0]) * (r[3]-r[1]), reverse=True)
            y1, x1, y2, x2 = rooms.pop(0)
            
            height = y2 - y1
            width = x2 - x1
            
            # Determine split direction (prefer splitting the long side)
            can_split_h = height >= (min_size * 2)
            can_split_v = width >= (min_size * 2)
            
            if not can_split_h and not can_split_v:
                # This room is too small to split further; put it back and stop
                rooms.append((y1, x1, y2, x2))
                break
                
            # Decide orientation: True for Horizontal, False for Vertical
            if can_split_h and can_split_v:
                split_h = random.random() < 0.5
            else:
                split_h = can_split_h

            if split_h:
                # --- Horizontal Split ---
                split_at = random.randint(y1 + min_size, y2 - min_size)
                # Draw the wall
                self.grid[split_at, x1:x2] = 1
                # Punch a random doorway
                door_pos = random.randint(x1, x2 - 1)
                self.grid[split_at, door_pos] = 0
                
                # Add the two new rooms to our list
                rooms.append((y1, x1, split_at, x2))
                rooms.append((split_at + 1, x1, y2, x2))
            else:
                # --- Vertical Split ---
                split_at = random.randint(x1 + min_size, x2 - min_size)
                # Draw the wall
                self.grid[y1:y2, split_at] = 1
                # Punch a random doorway
                door_pos = random.randint(y1, y2 - 1)
                self.grid[door_pos, split_at] = 0
                
                # Add the two new rooms to our list
                rooms.append((y1, x1, y2, split_at))
                rooms.append((y1, split_at + 1, y2, x2))
        self._fill_to_density()

    def _fill_to_density(self):
        """A 'top-up' function to reach the desired obstacle fraction."""
        current_frac = np.sum(self.grid) / (self.grid_size**2)
        while current_frac < self.obs_frac:
            r, c = np.random.randint(0, self.grid_size, size=2)
            self.grid[r, c] = 1
            current_frac = np.sum(self.grid) / (self.grid_size**2)