#[derive(Clone)]
pub struct Plotter<T: FnMut(f64, usize, f64, bool) -> Vec<(f64, f64)>> {
    pub plot_function: T,
}

impl<T: FnMut(f64, usize, f64, bool) -> Vec<(f64, f64)>> Plotter<T> {
    pub fn from_plot_function(plot_function: T) -> Self {
        Self { plot_function }
    }
    pub fn plot(&mut self) {
        let holds = (1..=8).collect::<Vec<usize>>();
        let (mean, sd): (Vec<_>, Vec<_>) = holds
            .iter()
            .map(|hold| {
                let a = (self.plot_function)(0.5, *hold, 1.0, false);
                a.into_iter().unzip::<f64, f64, Vec<f64>, Vec<f64>>()
            })
            .unzip();
        println!("x坐标是：{:?}", holds);
        println!("y坐标是：{:?}", mean);
        println!("y标准差是：{:?}", sd);
    }
}
