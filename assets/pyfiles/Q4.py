import numpy as np
import matplotlib.pyplot as plt
from pathlib import Path

class DiamondPriceNet:
    def __init__(self, hidden_size1=128, hidden_size2=64, hidden_size3=32, lr=1e-4, epochs=150, batch_size=1024, dropout_rate=0.2):
        self.hidden_size1 = hidden_size1
        self.hidden_size2 = hidden_size2
        self.hidden_size3 = hidden_size3
        self.lr = lr
        self.epochs = epochs
        self.batch_size = batch_size
        self.dropout_rate = dropout_rate
        self.loss_hist = []
        
    def load_data(self, filepath):
        data = np.genfromtxt(filepath, delimiter=',', skip_header=1, dtype='str')
        return self._process_data(data)
    
    def _process_data(self, data):
        numeric_cols = [0, 4, 5, 6]
        
        for i in numeric_cols:
            col = data[:, i].tolist() 
            col = [np.nan if val in ['', 'nan'] else float(val) for val in col]
            col = np.array(col)
            mean_val = np.nanmean(col)
            data[:, i] = np.where(np.isnan(col), mean_val, col)

        mappings = {
            'cut': {'Unknown': 0, 'Fair': 1, 'Good': 2, 'Very Good': 3, 'Premium': 4, 'Ideal': 5},
            'color': {'Unknown': 0, 'J': 1, 'I': 2, 'H': 3, 'G': 4, 'F': 5, 'E': 6, 'D': 7},
            'clarity': {'Unknown': 0, 'I1': 1, 'SI2': 2, 'SI1': 3, 'VS2': 4, 'VS1': 5, 
                    'VVS2': 6, 'VVS1': 7, 'IF': 8}
        }
        
        cat_cols = {'cut': 1, 'color': 2, 'clarity': 3}
        for col_name, col_idx in cat_cols.items():
            data[:, col_idx] = np.array([mappings[col_name].get(val, 0) for val in data[:, col_idx]])

        data = data.astype(float)
        prices = data[:, 6]
        features = np.delete(data, 6, axis=1)
        
        features_squared = features**2
        features_cubed = features**3
        
        n_features = features.shape[1]
        interactions = []
        for i in range(n_features):
            for j in range(i+1, n_features):
                interactions.append(features[:, i] * features[:, j])
        
        features = np.hstack((features, features_squared, features_cubed, np.column_stack(interactions)))
        
        prices = np.log1p(prices)
        
        shuffle_idx = np.random.permutation(len(prices))
        return features[shuffle_idx], prices[shuffle_idx]

    def init_network(self, input_size):
        self.weights1 = np.random.randn(input_size, self.hidden_size1) * np.sqrt(2.0/input_size)
        self.bias1 = np.zeros((1, self.hidden_size1))
        self.weights2 = np.random.randn(self.hidden_size1, self.hidden_size2) * np.sqrt(2.0/self.hidden_size1)
        self.bias2 = np.zeros((1, self.hidden_size2))
        self.weights3 = np.random.randn(self.hidden_size2, self.hidden_size3) * np.sqrt(2.0/self.hidden_size2)
        self.bias3 = np.zeros((1, self.hidden_size3))
        self.weights4 = np.random.randn(self.hidden_size3, 1) * np.sqrt(2.0/self.hidden_size3)
        self.bias4 = np.zeros((1, 1))

    def get_batches(self, X, y):
        indices = np.random.permutation(len(X))
        X, y = X[indices], y[indices]
        n_batches = len(X) // self.batch_size
        for i in range(n_batches):
            start = i * self.batch_size
            end = start + self.batch_size
            yield X[start:end], y[start:end]

    @staticmethod
    def leaky_relu(x, alpha=0.01):
        return np.where(x > 0, x, alpha * x)
    
    @staticmethod
    def leaky_relu_deriv(x, alpha=0.01):
        return np.where(x > 0, 1, alpha)

    def forward(self, x, training=True):
        layer1 = self.leaky_relu(x @ self.weights1 + self.bias1)
        if training:
            layer1 *= (np.random.rand(*layer1.shape) > self.dropout_rate) / (1 - self.dropout_rate)
        
        layer2 = self.leaky_relu(layer1 @ self.weights2 + self.bias2)
        layer3 = self.leaky_relu(layer2 @ self.weights3 + self.bias3)
        output = layer3 @ self.weights4 + self.bias4
        
        return output, layer3, layer2, layer1

    def train(self, features, prices, verbose=True):
        self.feat_mean = features.mean(axis=0)
        self.feat_std = features.std(axis=0)
        self.price_mean = prices.mean()
        self.price_std = prices.std()
        
        features_norm = (features - self.feat_mean) / (self.feat_std + 1e-8)
        prices_norm = (prices - self.price_mean) / (self.price_std + 1e-8)
        
        self.init_network(features.shape[1])
        
        if verbose:
            print("Starting training...")
        
        for epoch in range(self.epochs):
            epoch_loss = 0
            batch_count = 0
            
            for batch_X, batch_y in self.get_batches(features_norm, prices_norm):
                pred, layer3, layer2, layer1 = self.forward(batch_X)
                error = pred - batch_y.reshape(-1, 1)

                d_layer3 = error @ self.weights4.T
                d_layer3 *= self.leaky_relu_deriv(layer3)
                
                d_layer2 = d_layer3 @ self.weights3.T
                d_layer2 *= self.leaky_relu_deriv(layer2)
                
                d_layer1 = d_layer2 @ self.weights2.T
                d_layer1 *= self.leaky_relu_deriv(layer1)
                
                self.weights4 -= self.lr * (layer3.T @ error)
                self.bias4 -= self.lr * error.mean(axis=0, keepdims=True)
                self.weights3 -= self.lr * (layer2.T @ d_layer3)
                self.bias3 -= self.lr * d_layer3.mean(axis=0, keepdims=True)
                self.weights2 -= self.lr * (layer1.T @ d_layer2)
                self.bias2 -= self.lr * d_layer2.mean(axis=0, keepdims=True)
                self.weights1 -= self.lr * (batch_X.T @ d_layer1)
                self.bias1 -= self.lr * d_layer1.mean(axis=0, keepdims=True)
                
                epoch_loss += np.mean(error**2)
                batch_count += 1
            
            avg_loss = epoch_loss / batch_count
            self.loss_hist.append(avg_loss)
            
            if verbose and epoch % 10 == 0:
                print(f"Epoch {epoch}: Loss = {avg_loss:.6f}")

    def predict(self, features):
        features_norm = (features - self.feat_mean) / (self.feat_std + 1e-8)
        predictions, _, _, _ = self.forward(features_norm, training=False)
        predictions = predictions * self.price_std + self.price_mean
        return np.expm1(predictions)  

    def plot_results(self, features, prices):
        predictions = self.predict(features)
        actual_prices = np.expm1(prices) 
        
        plt.figure(figsize=(14.5, 11.6))  # Reduced by ~3% from (15, 12)
        
        plt.subplot(2, 1, 1)
        plt.scatter(actual_prices, predictions, color="red", alpha=0.5, s=1, label="Predictions")
        plt.plot([actual_prices.min(), actual_prices.max()], 
                [actual_prices.min(), actual_prices.max()], 
                'b--', label="Ideal (Zero Error) Line")
        plt.xlabel("Actual Price ($)")
        plt.ylabel("Predicted Price ($)")
        plt.title("Predictions vs Actual")
        plt.legend()
        
        plt.subplot(2, 2, 3)
        plt.plot(self.loss_hist)
        plt.xlabel("Epoch")
        plt.ylabel("Loss")
        plt.title("Full Training Loss")
        
        plt.subplot(2, 2, 4)
        start_epoch = 10 
        plt.plot(range(start_epoch, len(self.loss_hist)), self.loss_hist[start_epoch:])
        plt.xlabel("Epoch")
        plt.ylabel("Loss")
        plt.title("Training Loss (Zoomed)")
        
        plt.tight_layout(pad=2.0)  # Added padding to ensure labels fit
        plt.show()

def run_network():
    filepath = Path('M33174_CWK_Data_set.csv').resolve()

    while True:
        print("\nQuestion 4")
        print("=" * 35)
        try:
            hidden1 = int(input("First hidden layer size (default 128): ") or 128)
            hidden2 = int(input("Second hidden layer size (default 64): ") or 64)
            hidden3 = int(input("Third hidden layer size (default 32): ") or 32)
            lr = float(input("Learning rate (default 0.0001): ") or 0.0001)
            epochs = int(input("Number of epochs (default 150): ") or 150)
            batch_size = int(input("Batch size (default 1024): ") or 1024)
            dropout = float(input("Dropout rate (default 0.2): ") or 0.2)

            print(f"\nTraining network with:")
            print(f"Hidden layer sizes: {hidden1}, {hidden2}, {hidden3}")
            print(f"Learning rate: {lr}")
            print(f"Epochs: {epochs}")
            print(f"Batch size: {batch_size}")
            print(f"Dropout rate: {dropout}")

            net = DiamondPriceNet(
                hidden_size1=hidden1,
                hidden_size2=hidden2,
                hidden_size3=hidden3,
                lr=lr,
                epochs=epochs,
                batch_size=batch_size,
                dropout_rate=dropout
            )

            features, prices = net.load_data(filepath)
            net.train(features, prices)
            net.plot_results(features, prices)

            indices = np.random.choice(len(prices), 5)
            print("\nSample Predictions:")
            print("  Actual  | Predicted")
            print("-" * 25)

            predictions = net.predict(features)
            actual_prices = np.expm1(prices)

            for idx in indices:
                actual = actual_prices[idx]
                predicted = predictions[idx][0]
                print(f"${actual:7.0f} | ${predicted:7.0f}")

            if input("\nTry again? (y/n): ").lower() != 'y':
                break

        except ValueError:
            print("Invalid input. Please enter numerical values only.")
            continue

if __name__ == "__main__":
    run_network()