mod data_generator;
mod data_reader;

use data_generator::DataGenerator;
use data_reader::DataReader;
use wasm_bindgen::prelude::*;

#[wasm_bindgen]
pub fn data_generator(path: &str) -> DataGenerator {
    let returns = DataReader::return_vector_from_path(path);
    DataGenerator::new(returns, 1000, 0.0)
}
