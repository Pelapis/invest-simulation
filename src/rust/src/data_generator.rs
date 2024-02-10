use rand::Rng;

#[derive(Clone)]
pub struct DataGenerator {
    return_vectors: Vec<Vec<f64>>,
    num_investors: usize,
    trading_cost: f64,
}

impl DataGenerator {
    pub fn from_data(return_vectors: Vec<Vec<f64>>, num_investors: usize, trading_cost: f64,)
        -> Self { Self { return_vectors, num_investors, trading_cost, } }
    pub fn get_plot_function(self) -> impl FnMut(f64, usize, f64, bool) -> Vec<(f64, f64)> {
        // 返回一个闭包
        let mut rng = rand::thread_rng();
        move |level: f64, hold: usize, participation: f64, include_individuals: bool|
            -> Vec<(f64, f64)> {
            let return_vectors = if include_individuals {
                self.return_vectors.clone()
            } else { self.return_vectors[0..1].to_vec() };
            let num_holds = return_vectors[0].len().div_ceil(hold);
            let adjusted_returns: Vec<Vec<f64>> = return_vectors.iter().map(
                |vector| { (0..num_holds).map(|j| {
                    (*vector)[j * hold..vector.len().min((j + 1) * hold)].iter().product()
                }).collect()
            }).collect();
            let result = adjusted_returns.iter().map(|returns| {
                let investors_return: Vec<f64> = (0..self.num_investors).map(|_| {
                    returns.iter().fold(1.0, |acc, &ret| {
                        let growing = ret > 1.;
                        let win = rng.gen::<f64>() < level;
                        let participating = rng.gen::<f64>() < participation;
                        if growing == win && participating {
                            acc * ret * (1. - self.trading_cost)
                        } else { acc } }) }).collect();
                let mean_return = investors_return.iter()
                    .sum::<f64>() / self.num_investors as f64;
                let sd_return = (investors_return.iter()
                    .map(|&x| (x - mean_return).powi(2))
                    .sum::<f64>() / self.num_investors as f64).sqrt();
                (mean_return, sd_return)
            } ).collect();
            result
        }
    }
}
