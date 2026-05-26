'''agent Class definition. This class can be used to define both the agent and the target'''

import numpy as np

class Agent:
    def __init__(self, x, y, vel=1, heading=0):
        self.x = x
        self.y = y
        self.vel = vel
        self.heading = heading

    def find_position(self, t):
        '''Determine the position of an agent given a time'''
        vx = np.cos(self.heading)*self.vel
        vy = np.sin(self.heading)*self.vel

        dx = vx*t
        dy = vy*t

        return (self.x + dx, self.y + dy)

    # def find_position(self, t):
    #     """Determine the position of an agent given a time using sine-wave motion"""
    #     vx = np.cos(self.heading) * self.vel

    #     dx = vx * t

    #     amplitude = 2.0      # wave height
    #     frequency = 0.5      # oscillations per second

    #     dy = amplitude * np.sin(2 * np.pi * frequency * t)

    #     return (self.x + dx, self.y + dy)