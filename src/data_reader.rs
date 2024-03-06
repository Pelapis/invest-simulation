use std::{
    fs::File,
    io::{BufRead, BufReader},
};
use wasm_bindgen::prelude::*;

#[wasm_bindgen]
pub struct DataReader;

#[wasm_bindgen]
impl DataReader {
    pub fn return_vector_from_path(path: &str) -> Vec<f64> {
        let file = File::open(path).expect("file not found 文件打不开");
        let buf_reader = BufReader::new(file);
        buf_reader
            .lines()
            .filter_map(|line| {
                let line = line.expect("line not found 行找不到");
                line.split(",").nth(2)?.parse::<f64>().ok()
            })
            .collect()
    }

    pub fn return_vector_from_string(content: &str) -> Vec<f64> {
        content
            .lines()
            .filter_map(|line| line.split(",").nth(2)?.parse::<f64>().ok())
            .collect()
    }
}
