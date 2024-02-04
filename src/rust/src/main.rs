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
    let data_reader = Data_reader::read_data(&paths);    
    let return_vectors = data_reader.get_return_vectors();
    // 生成数据
    let data_generator = Data_generator::set_data(&return_vectors);
    let plot_function = data_generator.get_plot_function();
    // 画图
    let plotter = Plotter::set_plot_function(&plot_function);
    plotter.plot();
}
