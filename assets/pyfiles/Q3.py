import numpy as np
import matplotlib.pyplot as plt

class NeuralNet:
    def __init__(self, hidden_size=32, lr=0.0005, epochs=5000):
        self.hidden_size = hidden_size
        self.lr = lr  # learning rate
        self.epochs = epochs
        
        self.w1 = None
        self.b1 = None
        self.w2 = None
        self.b2 = None
        self.loss_hist = []
        
    def make_data(self):
        # create data for y = 3x + 0.7x^2
        x = np.linspace(-10, 10, 200).reshape(-1, 1)
        y = 3 * x + 0.7 * x**2
        return x, y
    
    def normalise(self, data):
        mean = data.mean()
        std = data.std()
        return (data - mean) / std, mean, std
    
    def init_network(self):
        # xavier initialization for weights
        input_size = 1
        output_size = 1
        self.w1 = np.random.randn(input_size, self.hidden_size) / np.sqrt(input_size)
        self.b1 = np.zeros((1, self.hidden_size))
        self.w2 = np.random.randn(self.hidden_size, output_size) / np.sqrt(self.hidden_size)
        self.b2 = np.zeros((1, output_size))
    
    def relu(self, x):
        return np.maximum(0, x)
    
    def relu_deriv(self, x):
        return (x > 0).astype(float)
    
    def forward(self, x):
        # run input through network
        h_sum = np.dot(x, self.w1) + self.b1
        h_out = self.relu(h_sum)
        out = np.dot(h_out, self.w2) + self.b2
        return out, h_out, h_sum
    
    def train(self, verbose=True):
        # prep data
        x, y = self.make_data()
        x_norm, x_mean, x_std = self.normalise(x)
        y_norm, y_mean, y_std = self.normalise(y)
        
        self.init_network()
        
        if verbose:
            print("Starting training...")
            
        for epoch in range(self.epochs):
            # forward pass
            pred, h_out, h_sum = self.forward(x_norm)
            
            # backprop
            error = pred - y_norm
            
            # output layer gradients
            w2_delta = np.dot(h_out.T, error) / x.shape[0]
            b2_delta = error.mean(axis=0, keepdims=True)
            
            # hidden layer gradients
            h_error = np.dot(error, self.w2.T) * self.relu_deriv(h_sum)
            w1_delta = np.dot(x_norm.T, h_error) / x.shape[0]
            b1_delta = h_error.mean(axis=0, keepdims=True)
            
            # update weights
            self.w2 -= self.lr * w2_delta
            self.b2 -= self.lr * b2_delta
            self.w1 -= self.lr * w1_delta
            self.b1 -= self.lr * b1_delta
            
            # track loss
            loss = (error**2).mean()
            self.loss_hist.append(loss)
            
            if verbose and epoch % 500 == 0:
                print(f"Epoch {epoch}: Loss = {loss:.6f}")
    
    def plot_results(self):
        x, y = self.make_data()
        x_norm, x_mean, x_std = self.normalise(x)
        _, y_mean, y_std = self.normalise(y)
        
        pred_norm = self.forward(x_norm)[0]
        pred = pred_norm * y_std + y_mean
        
        plt.figure(figsize=(12, 6))
        
        # plot predictions vs actual
        plt.subplot(1, 2, 1)
        plt.plot(x, y, 'b-', label='True function', alpha=0.5)
        plt.plot(x, pred, 'r--', label='Network prediction', linewidth=2)
        plt.xlabel('x')
        plt.ylabel('y')
        plt.title('Network Prediction vs True Function')
        plt.legend()
        plt.grid(True)
        
        # plot loss history
        plt.subplot(1, 2, 2)
        plt.plot(self.loss_hist)
        plt.xlabel('Epoch')
        plt.ylabel('Loss')
        plt.title('Training Loss')
        plt.grid(True)
        
        plt.tight_layout()
        plt.show()
        
    def test_predictions(self):
        test_x = np.array([-8, -4, 0, 4, 8]).reshape(-1, 1)
        x, _ = self.make_data()
        test_norm, x_mean, x_std = self.normalise(test_x)
        _, y_mean, y_std = self.normalise(3 * test_x + 0.7 * test_x**2)
        
        pred_norm = self.forward(test_norm)[0]
        pred = pred_norm * y_std + y_mean
        
       # print("\nTest Point Predictions:")
       # print("    x    |  Actual y  | Predicted y")
       # print("-" * 40)
       # for x, y_pred in zip(test_x, pred):
       #     y_true = 3 * x + 0.7 * x**2
       #     print(f"{float(x):8.1f} | {float(y_true):10.2f} | {float(y_pred):10.2f}")

def run_network():
    while True:
        print("\nQuestion 3")
        print("=" * 20)
        try:
            hidden = int(input("Hidden layer size (defaults 64): ") or 64)
            lr = float(input("Learning rate (defaults 0.001): ") or 0.001)
            epochs = int(input("Number of (defaults epochs 10000): ") or 10000)
            
            print(f"\nTraining network with:")
            print(f"Hidden nodes: {hidden}")
            print(f"Learning rate: {lr}")
            print(f"Epochs: {epochs}")
            
            net = NeuralNet(hidden_size=hidden, lr=lr, epochs=epochs)
            net.train()
            net.test_predictions()
            net.plot_results()
            
            if input("\nTry again? (y/n): ").lower() != 'y':
                break
                
        except ValueError:
            print("Bad input, try again")

if __name__ == "__main__":
    run_network()