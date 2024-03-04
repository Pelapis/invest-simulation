#[derive(Clone)]
pub struct Plotter<T: Fn(f64, usize, f64, usize) -> (f64, f64)> {
    pub plot_function: T,
}

impl<T: Fn(f64, usize, f64, usize) -> (f64, f64)> Plotter<T> {
    pub fn from_plot_function(plot_function: T) -> Self {
        Self { plot_function }
    }

    pub fn plot(&self) {
        let holds: Vec<usize> = (1..=8).collect();
        let (mean, sd): (Vec<f64>, Vec<f64>) = holds
            .iter()
            .map(|&hold| {
                return (self.plot_function)(0.5, hold, 1.0, 0);
            })
            .unzip();
        println!("x坐标是：{:?}", holds);
        println!("y坐标是：{:?}", mean);
        println!("y标准差是：{:?}", sd);
    }
}
