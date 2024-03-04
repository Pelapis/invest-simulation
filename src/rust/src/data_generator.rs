use rand;

#[derive(Clone)]
pub struct DataGenerator {
    return_vectors: Vec<Vec<f64>>,
    num_investors: usize,
    trading_cost: f64,
}

impl DataGenerator {
    pub fn from_data(
        return_vectors: Vec<Vec<f64>>,
        num_investors: usize,
        trading_cost: f64,
    ) -> Self {
        Self {
            return_vectors,
            num_investors,
            trading_cost,
        }
    }

    pub fn get_plot_function(self) -> impl Fn(f64, usize, f64, usize) -> (f64, f64) {
        // 返回一个闭包
        move |level: f64, hold: usize, participation: f64, stock_num: usize| {
            let return_vector = &self.return_vectors[stock_num];
            let num_holds = return_vector.len().div_ceil(hold);
            let adjusted_return: Vec<f64> = (0..num_holds)
                .map(|i| {
                    return_vector[i * hold..return_vector.len().min((i + 1) * hold)]
                        .iter()
                        .product()
                })
                .collect();
            let investors_return: Vec<f64> = (0..self.num_investors)
                .map(|_| {
                    adjusted_return.iter().fold(1., |acc, &e| {
                        let growing = e > 1.;
                        let win = rand::random::<f64>() < level;
                        let participating = rand::random::<f64>() < participation;
                        if growing == win && participating {
                            acc * e * (1. - self.trading_cost)
                        } else {
                            acc
                        }
                    })
                })
                .collect();
            let mean = investors_return.iter().sum::<f64>() / self.num_investors as f64;
            let sd = (investors_return
                .iter()
                .map(|&x| (x - mean).powi(2))
                .sum::<f64>()
                / self.num_investors as f64)
                .sqrt();
            (mean, sd)
        }
    }
}
