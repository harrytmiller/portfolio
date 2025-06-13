import random
from typing import List, Tuple
import matplotlib.pyplot as plt

class Question2:
    def __init__(self, items: dict, limit: int, pop_size: int = 50, gens: int = 100, mut_rate: float = 0.1):
        self.items = items  
        self.limit = limit  
        self.pop_size = pop_size  
        self.gens = gens  
        self.mut_rate = mut_rate  

        self.best_weight_history = []  
        self.best_value_history = []   
        self.avg_weight_history = []   
        self.avg_value_history = []   

    def make_random(self):
        return [random.randint(0, 1) for _ in range(len(self.items))]

    def calculate_fitness(self, bits):
        weight = 0
        value = 0

        for i, bit in enumerate(bits, 1):
            if bit == 1:
                weight += self.items[i]["weight"]
                value += self.items[i]["value"]

        if weight > self.limit:  
            return 0, 0  

        return weight, value

    def roulette_wheel_selection(self, pop, scores):
        total = sum(scores)
        if total == 0:
            rand_choi = random.choice(pop)
            print(f"All solutions invalid (total = 0), picking random: {rand_choi}")
            return rand_choi

        rand = random.uniform(0, total)
        curr = 0

        for i in range(len(pop)):
            curr += scores[i]
            if curr > rand:
                return pop[i]

        return pop[-1]

    def crossover(self, p1, p2):
        point = random.randint(0, len(p1) - 1)
        c1 = p1[:point] + p2[point:]
        c2 = p2[:point] + p1[point:]
        return c1, c2

    def mutate(self, bits):
        new = bits.copy()
        for i in range(len(new)):
            if random.random() < self.mut_rate:
                new[i] = 1 - new[i]
        return new

    def run_genetic_algorithm(self):
        print("Creating initial population...")
        pop = [self.make_random() for _ in range(self.pop_size)]

        best = None
        best_score = float('-inf')  

        print("Starting evolution...")
        for gen in range(self.gens):
            scores = [self.calculate_fitness(p) for p in pop]
            weights = [score[0] for score in scores]  
            values = [score[1] for score in scores]   

            max_weight = max(weights)
            max_value = max(values)

            avg_weight = sum(weights) / len(weights)
            avg_value = sum(values) / len(values)

            self.best_weight_history.append(max_weight)
            self.best_value_history.append(max_value)
            self.avg_weight_history.append(avg_weight)
            self.avg_value_history.append(avg_value)

            if max_value > best_score:
                best_score = max_value
                best = pop[values.index(max_value)]
                print(f"Gen {gen}: Found better solution! Value = {best_score}")

            new_pop = []
            while len(new_pop) < self.pop_size:
                p1 = self.roulette_wheel_selection(pop, values)
                p2 = self.roulette_wheel_selection(pop, values)
                c1, c2 = self.crossover(p1, p2)
                c1 = self.mutate(c1)
                c2 = self.mutate(c2)
                new_pop.append(c1)
                new_pop.append(c2)

            pop = new_pop[:self.pop_size]

            if gen % 10 == 0:
                print(f"Gen {gen}: Current best = {best_score}")

        return best, best_score

    def visualize_results(self):
        """Visualizes the weight, value, and price-per-kilo evolution over generations."""
        plt.figure(figsize=(18, 6))  
        
       
        plt.subplot(1, 3, 1)
        plt.plot(self.best_weight_history, label="Best Weight")
        plt.plot(self.avg_weight_history, label="Average Weight")
        plt.xlabel("Generation")
        plt.ylabel("Weight (Tonnes)")
        plt.title("Weight Evolution Over Generations")
        plt.legend()
        plt.grid(True)

     
        plt.subplot(1, 3, 2)
        plt.plot(self.best_value_history, label="Best Value")
        plt.plot(self.avg_value_history, label="Average Value")
        plt.xlabel("Generation")
        plt.ylabel("Value (thousands £)")
        plt.title("Value Evolution Over Generations")
        plt.legend()
        plt.grid(True)

       
        best_price_per_kilo = [
            val / wt if wt != 0 else 0
            for val, wt in zip(self.best_value_history, self.best_weight_history)
        ]
        avg_price_per_kilo = [
            val / wt if wt != 0 else 0
            for val, wt in zip(self.avg_value_history, self.avg_weight_history)
        ]

        plt.subplot(1, 3, 3)
        plt.plot(best_price_per_kilo, label="Best Value/Tonne")
        plt.plot(avg_price_per_kilo, label="Average Value/Tonne")
        plt.xlabel("Generation")
        plt.ylabel("Value (thousands £) per Tonne")
        plt.title("Value/Tonne Evolution")
        plt.legend()
        plt.grid(True)

        
        plt.tight_layout()
        plt.show()

    def main(self):
        best, score = self.run_genetic_algorithm()

        print("\nFound best solution:")
        print(f"Bits: {best}")
        print(f"Total value (£ thousands): {score}")

        total_w = 0
        print("\nBreakdown of items:")
        print("Item | Weight | Value")
        print("-" * 25)

        for i, selected in enumerate(best, 1):
            if selected:
                w = self.items[i]["weight"]
                v = self.items[i]["value"]
                total_w += w
                print(f"{i:4d} | {w:6d} | {v:5d}")

        print("-" * 25)
        print(f"Total weight (tonnes): {total_w}")
        print(f"Total value (£ thousands): {score}")

    @staticmethod
    def interactive_run():
        while True:
            print("\nQuestion 2")
            print("=================================")
            try:
                pop_size = int(input("Enter population size (defaults 50): ") or 50)
                gens = int(input("Enter number of generations (defaults 100): ") or 100)
                mut_rate = float(input("Enter mutation rate (0-1, defaults 0.1): ") or 0.1)

                print("\nRunning algorithm with:")
                print(f"Population Size: {pop_size}")
                print(f"Generations: {gens}")
                print(f"Mutation Rate: {mut_rate}")

                items = {
                    1: {"weight": 3, "value": 126},
                    2: {"weight": 8, "value": 154},
                    3: {"weight": 2, "value": 256},
                    4: {"weight": 9, "value": 526},
                    5: {"weight": 7, "value": 388},
                    6: {"weight": 1, "value": 245},
                    7: {"weight": 8, "value": 210},
                    8: {"weight": 13, "value": 442},
                    9: {"weight": 10, "value": 671},
                    10: {"weight": 9, "value": 348}
                }

                ga = Question2(items, limit=35, pop_size=pop_size, gens=gens, mut_rate=mut_rate)
                ga.main()
                ga.visualize_results()

                if input("\nRun again? (y/n): ").lower() != 'y':
                    break

            except ValueError:
                print("Invalid input")

if __name__ == "__main__":
    Question2.interactive_run()