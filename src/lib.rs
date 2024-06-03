use rand::random;
use wasm_bindgen::prelude::*;

#[wasm_bindgen]
pub struct PlotData {
    pub mean: f64,
    pub sd: f64,
    pub percentile90: f64,
    pub percentile10: f64,
    pub percentile95: f64,
    pub percentile5: f64,
}

#[wasm_bindgen]
pub fn curve_data(
    text: &str,
    investors_no: usize,
    trading_cost: f64,
    level: f64,
    hold: usize,
    participation: f64,
) -> PlotData {
    // 数据预处理
    let return_vector: Vec<f64> = text
        .lines()
        .filter_map(|line| line.split(',').nth(2)?.parse::<f64>().ok())
        .collect();
    let holds_no = return_vector.len().div_ceil(hold);
    let adjusted_return: Vec<f64> = (0..holds_no)
        .map(|i| {
            return_vector[i * hold..return_vector.len().min((i + 1) * hold)]
                .iter()
                .product()
        })
        .collect();
    // 生成需要的随机数
    let random_matrix: Vec<Vec<f64>> = (0..investors_no)
        .map(|_| (0..holds_no).map(|_| random::<f64>()).collect())
        .collect();
    // 计算各投资者的最终收益率
    let mut investors_return: Vec<f64> = (0..investors_no)
        .map(|i| {
            adjusted_return
                .iter()
                .zip(random_matrix[i].iter())
                .fold(1., |acc, (&e, &r)| {
                    let growing = e > 1.;
                    let win = r < level;
                    let participating = r < participation;
                    if growing == win && participating {
                        acc * e * (1. - trading_cost)
                    } else {
                        acc
                    }
                })
        })
        .collect();
    // 计算统计学特征，只保留一个数值
    let mean = investors_return.iter().sum::<f64>() / investors_no as f64;
    let sd = (investors_return
        .iter()
        .map(|&x| (x - mean).powi(2))
        .sum::<f64>()
        / investors_no as f64)
        .sqrt();
    investors_return.sort_by(|a, b| a.partial_cmp(b).unwrap());
    let percentile90 = investors_return[(investors_no as f64 * 0.9 - 1.).ceil() as usize];
    let percentile10 = investors_return[(investors_no as f64 * 0.1 - 1.).ceil() as usize];
    let percentile95 = investors_return[(investors_no as f64 * 0.95 - 1.).ceil() as usize];
    let percentile5 = investors_return[(investors_no as f64 * 0.05 - 1.).ceil() as usize];
    PlotData {
        mean,
        sd,
        percentile90,
        percentile10,
        percentile95,
        percentile5,
    }
}
