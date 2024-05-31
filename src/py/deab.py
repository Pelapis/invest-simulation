# 导入包
import polars as pl
import random
import functools as ft

# 设置参数
path = '../../data/data_index.csv'
level = 0.5
no = 100

# 读取数据
ror: pl.Series = pl.read_csv(path)['return']

# 生成随机数
rng = random.Random()
random_matrix = [[rng.random() < level for _ in ror] for _ in range(no)]

# 计算结果向量
result = [[(ror[i] > 1 == random_matrix[j][i]) * (ror[i] - 1) + 1 for i in range(len(ror))] for j in range(no)]
# 初始化curve
curve = [[1. for j in range(len(ror))] for _ in range(no)]
for i in range(no):
    curve[i][0] = result[i][0]
    for j in range(1, len(ror)):
        curve[i][j] = curve[i][j - 1] * result[i][j]

# 画图
import matplotlib.pyplot as plt
plt.plot(curve[0])
plt.show()
