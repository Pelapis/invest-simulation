mod data_generator;
mod data_reader;
mod plotter;

use data_generator::DataGenerator;
use data_reader::DataReader;
use plotter::Plotter;

fn main() {
    let paths = vec![
        "./data/data_index.csv",
        "./data/data_maotai.csv",
        "./data/data_mengjie.csv",
    ];
    let returns = DataReader::return_vector_from_path(&paths[0]);
    let data_generator = DataGenerator::new(returns, 1000, 0.);
    let plotter = Plotter::new(data_generator);
    plotter.plot();
}
