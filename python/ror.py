# 导入包
import polars as pl
import random
from functools import reduce

# 设置参数
path = '~/code/invest-simulation/data/data_index.csv'
level = 0.5
no = 100

# 读取数据
ror: pl.Series = pl.read_csv(path)['return']

# 生成随机数
random_matrix = list(map(lambda _: list(map(lambda _: random.random() < level, ror)), range(no)))

# 计算实际收益率
current_return = list(map(lambda j: list(map(lambda i: (ror[i] > 1 == random_matrix[j][i]) * (ror[i] - 1) + 1, range(len(ror)))), range(no)))
# 累计计算财富变化曲线
def accumulate_product(acc, a):
    acc.append(acc[-1] * a)
    return acc
curve = list(map(lambda x: reduce(accumulate_product, x, [1.]), current_return))
# 计算均值和分位数代表的置信区间
mean_curve = list(map(lambda x: sum(x) / len(x), zip(*curve)))
interval_90_curve = list(map(lambda x: sorted(x)[int(0.9 * no)], zip(*curve)))
interval_10_curve = list(map(lambda x: sorted(x)[int(0.1 * no)], zip(*curve)))

# 画图
import matplotlib.pyplot as plt
plt.plot(mean_curve, label='mean')
plt.plot(interval_90_curve, label='90%')
plt.plot(interval_10_curve, label='10%')
plt.legend()
plt.show()
