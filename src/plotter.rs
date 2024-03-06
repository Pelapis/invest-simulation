use crate::data_generator::DataGenerator;

pub struct Plotter {
    data_generator: DataGenerator,
}

impl Plotter {
    pub fn new(data_generator: DataGenerator) -> Self {
        Self { data_generator }
    }

    pub fn plot(&self) {
        let holds: Vec<usize> = (1..=8).collect();
        let (mean, sd): (Vec<f64>, Vec<f64>) = holds
            .iter()
            .map(|&hold| {
                let plot_data = self.data_generator.plot_data(0.5, hold, 1.0);
                (plot_data[0], plot_data[1])
            })
            .unzip();
        println!("x坐标是：{:?}", holds);
        println!("y坐标是：{:?}", mean);
        println!("y标准差是：{:?}", sd);
    }
}
