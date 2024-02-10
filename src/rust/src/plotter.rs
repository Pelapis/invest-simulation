#[derive(Clone)]
pub struct Plotter<T: FnMut(f64, usize, f64, bool) -> Vec<(f64, f64)>> {
    pub plot_function: T,
}

impl<T: FnMut(f64, usize, f64, bool) -> Vec<(f64, f64)>> Plotter<T> {
    pub fn from_plot_function(plot_function: T) -> Self { Self { plot_function } }
    pub fn plot(&mut self) {
        let holds = (1..=8).collect::<Vec<usize>>();
        let mut mean = vec![0.0; holds.len()];
        let mut sd = vec![0.0; holds.len()];
        for (i, &hold) in holds.iter().enumerate() {
            mean[i] = (self.plot_function)(0.5, hold, 1.0, false)[0].0;
            sd[i] = (self.plot_function)(0.5, hold, 1.0, false)[0].1;
        }
        println!("x坐标是：{:?}", holds);
        println!("y坐标是：{:?}", mean);
        println!("y坐标上下界是：{:?}", sd);
        }
}