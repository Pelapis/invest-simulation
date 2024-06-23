# 导入包
import polars as pl
import random
from functools import reduce
import math

# 设置参数
path = '~/code/invest-simulation/data/data_index.csv'
level = 0.5
no = 100

# 读取数据
ror: pl.Series = pl.read_csv(path)['return']

# 生成随机数
random_matrix = [[random.random() < level for _ in ror] for _ in range(no)]

# 计算结果向量
current_return = [[(ror[i] > 1 == random_matrix[j][i]) * (ror[i] - 1) + 1 for i in range(len(ror))] for j in range(no)]
# 累计计算财富变化曲线
curve = list(map(lambda x: reduce(lambda acc, y: [acc.append(acc[-1] * y) or acc][-1], x, [1.]), current_return))
# 由于收益率恒正，分布按照对数正态分布计算
log_curve = list(map(lambda x: [math.log(y) for y in x], curve))
# 计算均值
log_mean = list(map(lambda x: sum(x) / len(x), zip(*log_curve)))
mean = list(map(lambda x: math.exp(x), log_mean))
# 计算标准差
log_std = list(map(lambda x: math.sqrt(sum([(y - x[0])**2 for y in x[1]]) / len(x[1])), zip(log_mean, zip(*log_curve))))
# 计算90%置信区间
log_90 = list(map(lambda x: x[0] + 1.645 * x[1] / math.sqrt(len(x)), zip(log_mean, log_std)))
interval_90 = list(map(lambda x: math.exp(x), log_90))
# 计算10%置信区间
log_10 = list(map(lambda x: x[0] - 1.645 * x[1] / math.sqrt(len(x)), zip(log_mean, log_std)))
interval_10 = list(map(lambda x: math.exp(x), log_10))

# 画图
import matplotlib.pyplot as plt
plt.plot(mean, label='mean')
plt.plot(interval_90, label='90%')
plt.plot(interval_10, label='10%')
plt.legend()
plt.show()
