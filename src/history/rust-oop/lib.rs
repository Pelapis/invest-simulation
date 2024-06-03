mod data_generator;
mod data_reader;
use wasm_bindgen::prelude::*;

#[wasm_bindgen]
pub fn data_generator(path: &str) -> data_generator::DataGenerator {
    let returns = data_reader::DataReader::return_vector_from_path(path);
    data_generator::DataGenerator::new(returns, 1000, 0.0)
}
