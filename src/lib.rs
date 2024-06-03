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
    number: usize,
    trading_cost: f64,
    level: f64,
    hold: usize,
    participation: f64,
) -> PlotData {
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
    let mut investors_return: Vec<f64> = (0..number)
        .map(|_| {
            adjusted_return.iter().fold(1., |acc, &e| {
                let growing = e > 1.;
                let win = random::<f64>() < level;
                let participating = random::<f64>() < participation;
                if growing == win && participating {
                    acc * e * (1. - trading_cost)
                } else {
                    acc
                }
            })
        })
        .collect();
    let mean = investors_return.iter().sum::<f64>() / number as f64;
    let sd = (investors_return
        .iter()
        .map(|&x| (x - mean).powi(2))
        .sum::<f64>()
        / number as f64)
        .sqrt();
    // 获取investors_return的分位数
    investors_return.sort_by(|a, b| a.partial_cmp(b).unwrap());
    let percentile90 = investors_return[(number as f64 * 0.9 - 1.).ceil() as usize];
    let percentile10 = investors_return[(number as f64 * 0.1 - 1.).ceil() as usize];
    let percentile95 = investors_return[(number as f64 * 0.95 - 1.).ceil() as usize];
    let percentile5 = investors_return[(number as f64 * 0.05 - 1.).ceil() as usize];
    PlotData {
        mean,
        sd,
        percentile90,
        percentile10,
        percentile95,
        percentile5,
    }
}
