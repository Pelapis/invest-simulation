from functools import reduce
import random
import math
import statistics

from numpy import mean

class Data_generator():
    def __init__(self, return_vectors, num_investors=1000, trading_cost=0.001):
        self.return_vectors = return_vectors
        self.num_investors = num_investors
        self.trading_cost = trading_cost
    def get_plot_function(self):
        rng = random.Random()
        def plot_function(level=0.5, hold=1, participation=1.0, include_individuals=False
            ) -> list[tuple[float, float]]:
            """
            函数根据收益向量生成收益率和方差。
            投资者参数：投资水平，持有时长，投资参与度
            超参数：投资者数量，交易成本
            返回值：平均收益率和方差的元组列表
            """
            return_vectors = (self.return_vectors
                              ) if include_individuals else [self.return_vectors[0]]
            num_holds = -(-len(return_vectors[0]) // hold)
            adjusted_returns = [[math.prod(vector[j * hold: min((j + 1) * hold, num_holds)])
                for j in range(num_holds)]
                for vector in return_vectors]
            def get_result(returns):
                def get_investor_return(treasure, ret) -> float:
                    growing = ret > 1
                    win = rng.random() < level
                    participating = rng.random() < participation
                    if growing == win and participating:
                        return treasure * (ret * (1 - self.trading_cost))
                    return treasure
                investors_return: list[float] = [reduce(get_investor_return, returns, 1.) for _ in range(self.num_investors)]
                mean = statistics.mean(investors_return)
                sd = statistics.stdev(investors_return)
                return mean, sd
            return list(map(get_result, adjusted_returns))
        return plot_function
