import heapq
import numpy as np

class AStar:
    def __init__(self, map_obj, heuristic_fn=None):
        self.map = map_obj
        self.grid = map_obj.grid
        self.start = map_obj.start
        self.goal = map_obj.goal
        self._heuristic_fn=heuristic_fn

        self.came_from = {}
        self.g_score = {}
        self.visited = set()
        self.path = []

    def heuristic(self, a, b):
        if self._heuristic_fn is not None:
            return self._heuristic_fn(a, b)
        # Default: Euclidean distance
        else:
            return np.sqrt((a[0] - b[0])**2 + (a[1] - b[1])**2)
    
    def get_neighbors(self, node):
        r, c = node
        neighbors = []
        for dr, dc in [(-1,0),(1,0),(0,-1),(0,1)]:
            nr, nc = r + dr, c + dc
            if 0 <= nr < self.grid.shape[0] and 0 <= nc < self.grid.shape[1]:
                if self.grid[nr, nc] == 0:
                    neighbors.append((nr, nc))
        return neighbors

    def reconstruct_path(self):
        node = self.goal
        path = [node]
        while node in self.came_from:
            node = self.came_from[node]
            path.append(node)
        path.reverse()
        self.path = path
        return path

    def run(self):
        open_set = []
        heapq.heappush(open_set, (0, self.start))

        self.g_score = {self.start: 0}
        f_score = {self.start: self.heuristic(self.start, self.goal)}

        while open_set:
            _, current = heapq.heappop(open_set)

            if current in self.visited:
                continue

            self.visited.add(current)

            if current == self.goal:
                return self.reconstruct_path()

            for neighbor in self.get_neighbors(current):
                tentative_g = self.g_score[current] + 1

                if neighbor not in self.g_score or tentative_g < self.g_score[neighbor]:
                    self.came_from[neighbor] = current
                    self.g_score[neighbor] = tentative_g
                    f = tentative_g + self.heuristic(neighbor, self.goal)
                    heapq.heappush(open_set, (f, neighbor))

        return None  # no path found