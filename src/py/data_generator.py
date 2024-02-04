import random
import math
import statistics

class Data_generator():
    def __init__(self, return_vectors, num_investors=1000, trading_cost=0.001):
        self.rng = random.Random()
        self.return_vectors = return_vectors
        self.num_investors = num_investors
        self.trading_cost = trading_cost
    def get_plot_function(self):
        def plot_function(level=0.5, hold=1, participation=1.0, include_individual=False) -> list[tuple[float, float]]:
            """
            函数应该根据return_vectors生成三个平均收益率和方差的双列序列，其中，参数应该包括投资者参数，超参数
            投资者参数应该包括：投资水平，持有时长，投资参与度
            超参数应该包括：投资者数量，交易成本
            """
            return_vectors = self.return_vectors if include_individual else [self.return_vectors[0]]
            result = [(0.0, 0.0)] * len(return_vectors)
            num_holds = -(-len(return_vectors[0]) // hold)
            adjusted_returns = [[math.prod(vector[j * hold: min((j + 1) * hold, num_holds)]) for j in range(num_holds)] for (i, vector) in enumerate(return_vectors)]
            for j, returns in enumerate(adjusted_returns):
                def get_single_return() -> float:
                    treasure = 1
                    for i, return_rate in enumerate(returns):
                        growing = return_rate > 1
                        win = self.rng.random() < level
                        participating = self.rng.random() < participation
                        treasure *= return_rate * (1 - self.trading_cost) if growing == win and participating else 1
                    return treasure
                single_returns: list[float] = [get_single_return() for _ in range(self.num_investors)]
                result[j] = (statistics.mean(single_returns), statistics.stdev(single_returns))
            return result
        return plot_function
