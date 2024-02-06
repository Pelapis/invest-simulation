pub struct Plotter<'a> {
    plot_function: &'a dyn Fn(),
}

impl<'a> Plotter<'a> {
    pub fn from_plot_function(plot_function: &'a dyn Fn()) -> Self { Self { plot_function } }
    pub fn plot(&self) {
        // 画图
    }
}