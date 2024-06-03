mod data_generator;
mod data_reader;

use data_generator::DataGenerator;
use data_reader::DataReader;
use plotter::Plotter;

fn main() {
    let paths = [
        "./data/data_index.csv",
        "./data/data_maotai.csv",
        "./data/data_mengjie.csv",
    ];
    let returns = DataReader::return_vector_from_path(paths[0]);
    let data_generator = DataGenerator::new(returns, 1000, 0.);
    let plotter = Plotter::new(data_generator);
    plotter.plot();
}

mod plotter {
    use crate::data_generator::DataGenerator;
    pub struct Plotter {
        data_generator: DataGenerator,
    }

    impl Plotter {
        pub fn new(data_generator: DataGenerator) -> Self {
            Self { data_generator }
        }

        pub fn plot(&self) {
            let holds: Vec<usize> = (1..=3).collect();
            let (mean, sd): (Vec<f64>, Vec<f64>) = holds
                .iter()
                .map(|&hold| {
                    let plot_data = self.data_generator.plot_data(0.5, hold, 1.0);
                    (plot_data.mean, plot_data.sd)
                })
                .unzip();
            println!("x坐标是：{:?}", holds);
            println!("y坐标是：{:?}", mean);
            println!("y标准差是：{:?}", sd);
        }
    }
}
