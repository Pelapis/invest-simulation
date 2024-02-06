use rand::Rng;

pub struct DataGenerator {
    return_vectors: Vec<Vec<f64>>,
    num_investors: usize,
    trading_cost: f64,
    pub rng: rand::rngs::ThreadRng,
}

impl DataGenerator {
    pub fn from_data(return_vectors: Vec<Vec<f64>>, num_investors: usize, trading_cost: f64) -> Self {
        Self { return_vectors, num_investors, trading_cost, rng: rand::thread_rng() }
    }
    pub fn get_plot_function(mut self) -> impl FnMut(f64, i32, f64, bool) -> Vec<(f64, f64)> {
        // 返回一个函数对象
        move |level: f64, hold: i32, participation: f64, include_individuals: bool| -> Vec<(f64, f64)> {
            let return_vectors =  if include_individuals {
                self.return_vectors.clone()
            } else {self.return_vectors.clone()[0..1].into()};
            let mut result: Vec<(f64, f64)> = Vec::with_capacity(return_vectors.len());
            let num_holds = return_vectors[0].len().div_ceil(hold as usize) as usize;
            let mut adjusted_returns: Vec<Vec<f64>> = Vec::with_capacity(return_vectors.len());
            for (i, vector) in return_vectors.iter().enumerate() {
                for j in 0..num_holds {
                    adjusted_returns[i][j] = vector[j*hold as usize..num_holds.min((j+1)*hold as usize)].iter().product();
                }
            }
            for (j, returns) in adjusted_returns.iter().enumerate() {
                let mut get_single_return = || {
                    let mut cumulative_return = 1.0;
                    for &ret in returns.iter() {
                        let growing = ret > 1.;
                        let win = self.rng.gen::<f64>() < level;
                        let participating = self.rng.gen::<f64>() < participation;
                        cumulative_return *= if growing == win && participating {ret} else {1.};
                    }
                    cumulative_return
                };
                let single_returns = (0..self.num_investors).map(|_| get_single_return()).collect::<Vec<f64>>();
                let mean_return = single_returns.iter().sum::<f64>() / self.num_investors as f64;
                let sd_return = (
                    single_returns.iter().map(|&x| (x - mean_return).powi(2)).sum::<f64>() / self.num_investors as f64
                ).sqrt();
                result[j] = (mean_return, sd_return);
            }
            result
        }
    }
}