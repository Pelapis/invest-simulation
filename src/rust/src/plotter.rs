pub struct Plotter<T: FnOnce(f64, i32, f64, bool) -> Vec<(f64, f64)>> {
    plot_function: T,
}

impl<T: FnOnce(f64, i32, f64, bool) -> Vec<(f64, f64)>> Plotter<T> {
    pub fn from_plot_function(plot_function: T) -> Self { Self { plot_function } }
    pub fn plot(&self) {
        // 画图
    }
}