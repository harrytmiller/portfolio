import random
import matplotlib.pyplot as plt
from typing import List, Tuple
import time

class GeneticAlgorithm:
    def __init__(self, pop_size: int = 50, gens: int = 100, mut_rate: float = 0.1):
        self.pop_size = pop_size
        self.gens = gens
        self.mut_rate = mut_rate
        self.best_history = []
        self.avg_history = []

    def make_random(self) -> List[int]:
        return [random.randint(0, 1) for _ in range(32)]
   
    def calculate_fitness(self, bits: List[int]) -> int:
        blocks = [bits[i:i+8] for i in range(0, 32, 8)]
        blue = sum(blocks[0]) + sum(blocks[3])
        green = sum(blocks[1]) + sum(blocks[2])
        return blue - green
   
    def roulette_wheel_selection(self, pop: List[List[int]], scores: List[int]) -> List[int]:
        total = sum(scores)
        if total == 0:
            return random.choice(pop)
       
        rand = random.uniform(0, total)
        current = 0
       
        for i in range(len(pop)):
            current += scores[i]
            if current > rand:
                return pop[i]
        return pop[-1]
   
    def crossover(self, p1: List[int], p2: List[int]) -> Tuple[List[int], List[int]]:
        point = random.randint(0, 31)
        c1 = p1[:point] + p2[point:]
        c2 = p2[:point] + p1[point:]
        return c1, c2
   
    def mutate(self, bits: List[int]) -> List[int]:
        new_bits = bits.copy()
        for i in range(len(bits)):
            if random.random() < self.mut_rate:
                new_bits[i] = 1 - bits[i]
        return new_bits
   
    def visualize_results(self):
        plt.figure(figsize=(12, 6))
        plt.plot(self.best_history, label='Best Fitness')
        plt.plot(self.avg_history, label='Average Fitness')
        plt.xlabel('Generation')
        plt.ylabel('Fitness Score')
        plt.title('Fitness Evolution Over Generations')
        plt.legend()
        plt.grid(True)
        plt.show()

    def print_block_analysis(self, bits: List[int]):
        blocks = [bits[i:i+8] for i in range(0, 32, 8)]

        print("\nBlocks:")
        print(f"Blue Block 1:  {blocks[0]} -> {sum(blocks[0])} ones")
        print(f"Green Block 1: {blocks[1]} -> {sum(blocks[1])} ones")
        print(f"Green Block 2: {blocks[2]} -> {sum(blocks[2])} ones")
        print(f"Blue Block 2:  {blocks[3]} -> {sum(blocks[3])} ones")

        print(f"\nTotal blue ones: {sum(blocks[0]) + sum(blocks[3])}")
        print(f"Total green ones: {sum(blocks[1]) + sum(blocks[2])}")

    def run(self, verbose: bool = True) -> Tuple[List[int], int]:
        pop = [self.make_random() for _ in range(self.pop_size)]
        best = None
        best_score = float('-inf')
        
        for gen in range(self.gens):
            scores = [self.calculate_fitness(p) for p in pop]
            avg_fitness = sum(scores) / len(scores)
            self.avg_history.append(avg_fitness)
            
            gen_best_score = max(scores)
            self.best_history.append(gen_best_score)

            if gen_best_score > best_score:
                best_score = gen_best_score
                best = pop[scores.index(gen_best_score)]

            new_pop = []
            while len(new_pop) < self.pop_size:
                p1 = self.roulette_wheel_selection(pop, scores)
                p2 = self.roulette_wheel_selection(pop, scores)
                c1, c2 = self.crossover(p1, p2)
                c1 = self.mutate(c1)
                c2 = self.mutate(c2)
                new_pop.extend([c1, c2])

            pop = new_pop[:self.pop_size]

            if verbose and gen % 10 == 0:
                print(f"Generation {gen}: Current best = {best_score}")

        return best, best_score

def interactive_run():
    valid_mut = False
    while True:
        print("\nQuestion 1")
        print("=================================")
        try:
            pop_size = int(input("Enter population size (defaults 50): ") or 50)
            gens = int(input("Enter number of generations (defaults 100): ") or 100)
            while valid_mut is False:
                mut_rate = float(input("Enter mutation rate (0-1, defaults 0.1): ") or 0.1)
                if 1 < mut_rate or mut_rate < 0:
                    print('Invalid input, only between 0-1. Try again \n')
                    time.sleep(1)
                    valid_mut = False
                else:
                    valid_mut = True
           
            print("\nRunning algorithm with:")
            print(f"Population Size: {pop_size}")
            print(f"Generations: {gens}")
            print(f"Mutation Rate: {mut_rate}")
           
            ga = GeneticAlgorithm(pop_size, gens, mut_rate)
            best, score = ga.run()
           
            print(f"\nFinal Result:")
            print(f"Best Score: {score}")   
            ga.print_block_analysis(best)
            ga.visualize_results()
           
            if input("\nTry again? (y/n): ").lower() != 'y':
                break
               
        except ValueError:
            print("Invalid input")

if __name__ == "__main__":
    interactive_run()