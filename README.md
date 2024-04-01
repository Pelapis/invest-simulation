# 股票10年投资模拟——基于沪深300指数、贵州茅台和梦洁股份
## 短期，中期还是长期投资？
假设投资者具有不同投资水平（预测明日股票涨跌的准确率），投资参与率（十年中参与投资的天数占比），每次投资的持有时间（短期还是长期投资）。模拟并分析10年中，不同投资者对沪深300指数、贵州茅台、梦洁股份的投资收益情况。探究对他们来说，短期、中期和长期投资策略哪个更合适，即择时交易是否是好的交易策略。
## 收益率模拟函数
通过ROR生成函数返回n个随机模拟投资者的收益情况，分别变动函数的不同参数，通过对他们的收益率的统计学性质进行分析来研究投资收益的种种特性，并进行可视化展示。
```python
  ROR生成函数（生成数量，收益数据，交易水平 = 0.5，交易频率 = 1，持有期 = 1天，交易成本 = 0.001）
```

# 10-year Stock Investment Simulation — Based on CSI 300 Index, Kweichow Moutai, and Mendale Hometextile
## Short-term, Medium-term, or Long-term Investment?
Assuming investors have different levels of investment proficiency (accuracy in predicting daily stock price movements), participation rates (percentage of days participated in investments over ten years), and holding periods for each investment (short-term or long-term). Simulate and analyze the investment returns of different investors on the CSI 300 Index, Kweichow Moutai, and Mendale Hometextile over a period of ten years. Explore which investment strategy — short-term, medium-term, or long-term — is more suitable for them, i.e., whether timing the market is a good trading strategy.
## Rate of Return (ROR) Simulation Function
The ROR generation function returns the simulated returns of n random investors through statistical analysis of their ROI properties, providing insights into various characteristics of investment returns.
```python
generate_ROR(number of investors, return data, invest level = 0.5, invest frequency = 1, holding period = 1 day, trading cost = 0.001)
```
