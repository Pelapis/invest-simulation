mod data_reader;
mod data_generator;
mod plotter;

use data_reader::Data_reader;
use data_generator::Data_generator;
use plotter::Plotter;

fn main() {
    // 主函数写主要逻辑
    // 读取数据
    let paths:[&str; 3] = ["", "", ""];
    let return_vectors = Data_reader::from_paths(&paths).get_return_vectors();
    // 生成数据
    let plot_function = Data_generator::from_data(&return_vectors).get_plot_function();
    // 画图
    Plotter::from_plot_function(&plot_function).plot();
}
