use rust::data_generator::DataGenerator;

fn main() {
    let return_vectors = vec![vec![0.9, 1.0, 1.1]];
    let mut plot_function = DataGenerator::from_data(return_vectors.clone(), 1000, 0.001).get_plot_function();
    println!("结果是{:?}", plot_function(0.5, 1, 1.0, false));
}
