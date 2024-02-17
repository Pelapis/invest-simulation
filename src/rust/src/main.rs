mod data_generator;
mod data_reader;
mod plotter;

use data_generator::DataGenerator;
use data_reader::DataReader;
use plotter::Plotter;

fn main() {
    // 读取数据
    let paths: Vec<String> = vec![
        "../../data/data_index.csv".to_owned(),
        "../../data/data_maotai.csv".to_owned(),
        "../../data/data_mengjie.csv".to_owned(),
    ];
    let returns = DataReader::from_paths(paths).get_return_vectors();
    // 生成数据
    let plot_function = DataGenerator::from_data(returns, 1000, 0.0).get_plot_function();
    // 画图
    Plotter::from_plot_function(plot_function).plot();
}
