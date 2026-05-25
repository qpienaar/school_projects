import torch
import torch.nn as nn
import torch.optim as optim
import torch.nn.functional as F
import torchvision.transforms as transforms
import numpy as np

class CNN(nn.Module):
    # 3 channels - map, start, goal
    # 1 output class - the heuristic value
    def __init__(self, in_channels=3, num_classes=1):
        super(CNN, self).__init__()
        # start with 2 convolution layers
        self.conv1 = nn.Conv2d(in_channels=in_channels, out_channels=8, kernel_size=(3,3), stride=(1,1), padding=(1,1))
        self.bn1 = nn.BatchNorm2d(8)
        self.pool1 = nn.MaxPool2d(kernel_size=(2,2), stride=(2,2))

        self.conv2 = nn.Conv2d(in_channels=8, out_channels=16, kernel_size=(3,3), stride=(1,1), padding=(1,1))
        self.bn2 = nn.BatchNorm2d(16)

        self.fc1 = nn.Linear(16*10*10, 256)
        self.fc2 = nn.Linear(256, 64)
        self.fc3 = nn.Linear(64, 1)
        self.dropout = nn.Dropout(p=0.1)

    def forward(self, x):
        x = self.pool1(F.relu(self.bn1(self.conv1(x))))
        x = F.relu(self.bn2(self.conv2(x)))
        x = x.reshape(x.shape[0], -1)
        x = F.relu(self.fc1(x))
        x = self.dropout(x)
        x = F.relu(self.fc2(x))
        x = self.dropout(x)
        x = self.fc3(x)
        return x
    
    def make_heuristic_fn(self, m):
        """Wraps the CNN as a (pos, goal) -> float callable for AStar."""
        goal, grid = m.goal, m.grid
        def h(pos, _goal):
            x = np.zeros((1, 3, m.grid_size, m.grid_size), dtype=np.float32)
            x[0, 0] = grid.astype(np.float32)
            x[0, 1, pos[0], pos[1]] = 1.0
            x[0, 2, goal[0], goal[1]] = 1.0
            with torch.no_grad():
                pred = self(torch.tensor(x)).item()
                pred = pred*m.grid_size*2
            euclidean = np.sqrt((pos[0]-goal[0])**2 + (pos[1]-goal[1])**2)
            #return min(pred, euclidean)
            return pred
        return h

class PiecewiseLoss(nn.Module):
    def __init__(self, alpha1=1.0, alpha2=20.0):
        super().__init__()
        self.alpha1 = alpha1
        self.alpha2 = alpha2

    def forward(self, pred, target, h_min):
        """
        pred, target, h_min: all shape (N, 1), normalized by grid_size*2
        """
        abs_err = torch.abs(pred - target)
        below_min  = (pred < h_min).float()          # Region 1
        admissible = ((pred >= h_min) & (pred <= target)).float()  # Region 2
        overest    = (pred > target).float()         # Region 3

        loss = (self.alpha1 * below_min + admissible + self.alpha2 * overest) * abs_err
        return loss.mean()