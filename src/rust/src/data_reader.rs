use std::{
    fs::File,
    io::{BufRead, BufReader},
};
pub struct DataReader {
    paths: Vec<String>,
}

impl DataReader {
    pub fn from_paths(paths: Vec<String>) -> Self {
        Self { paths }
    }
    pub fn get_return_vectors(&self) -> Vec<Vec<f64>> {
        self.paths
            .iter()
            .map(|path| {
                let file = File::open(path).expect("file not found 文件打不开");
                let buf_reader = BufReader::new(file);
                buf_reader
                    .lines()
                    .filter_map(|line| {
                        let line = line.expect("line not found 行找不到");
                        line.split(",").nth(2)?.parse::<f64>().ok()
                    })
                    .collect::<Vec<f64>>()
            })
            .collect::<Vec<Vec<f64>>>()
    }
}
