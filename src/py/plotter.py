import enum
from math import log
import matplotlib.pyplot as plt
import statistics

class Plotter():
    def __init__(self, plot_function, save_path="./plots/py"):
        self.plot_function = plot_function
        self.save_path = save_path
    def plot(self):
        """
        根据plot_function绘制图像，plot_function有三个参数，分别是投资水平，持有时长，投资参与度，并返回期望收益和方差
        我们绘制两幅图，一副是期望收益关于持有时长的函数，另一副是投资水平关于投资参与度的函数
        每个图像分为至少9个子图，分别对应其他两个参数的不同取值
        """
        for stock, stock_name in enumerate(["index", "maotai", "mengjie"]):
            fig, ax = plt.subplots(3, 5)
            fig.set_size_inches(3 * 5, 2.2 * 3)
            for i, level in enumerate([0.55, 0.5, 0.45]):
                for j, participation in enumerate([1.0, 0.8, 0.6, 0.4, 0.2]):
                    # 超参数置信度alpha，默认为0.05
                    alpha = 0.05
                    shift = statistics.NormalDist().inv_cdf(1 - alpha/2)
                    holds_tick = [1, 7, 30, 365, 3650]
                    holds = list(range(1, 3650))
                    data_list = [self.plot_function(hold=hold, level=level, participation=participation) for hold in holds]
                    x = [log(hold) for hold in holds]
                    # Index
                    y = [data[stock][0] for data in data_list]
                    y_lower: list[float] = [data[stock][0] - data[stock][1] * shift for data in data_list]
                    y_upper: list[float] = [data[stock][0] + data[stock][1] * shift for data in data_list]
                    ax[i][j].plot(x, y)
                    ax[i][j].fill_between(x, y_lower, y_upper, alpha=0.3)
                    ax[i][j].set_xticks([log(hold) for hold in holds_tick])
                    ax[i][j].set_xticklabels(holds_tick)
                    if i == 2:
                        ax[i][j].set_xlabel(f"Participation={participation}")
                    if j == 0:
                        ax[i][j].set_ylabel(f"Level={level}")
            fig.legend(["Expected return", "95% Confidence interval"], loc="upper right")
            fig.suptitle("Expected return on holding days")
            fig.supxlabel("Holding days")
            fig.supylabel("Expected return")
            fig.savefig(self.save_path + f"/{stock_name}.png", dpi=300)
