mod data_reader;
mod data_generator;
mod plotter;

use data_reader::DataReader;
use data_generator::DataGenerator;
use plotter::Plotter;

fn main() {
    // 读取数据
    let paths: Vec<String> = vec![
        "../../data/data_index.csv".to_string(),
        "../../data/data_maotai.csv".to_string(),
        "../../data/data_mengjie.csv".to_string(),
        ];
    let returns = DataReader::from_paths(paths.clone()).get_return_vectors();
    // 生成数据
    let plot_function = DataGenerator::from_data(
        returns.clone(), 1000, 0.
    ).get_plot_function();
    // 画图
    Plotter::from_plot_function(plot_function).plot();
}
