use std::{fs::File, io::{BufRead, BufReader}};
pub struct DataReader {
    paths: Vec<String>
}

impl DataReader {
    pub fn from_paths(paths: Vec<String>) -> Self { Self { paths } }
    pub fn get_return_vectors(&self) -> Vec<Vec<f64>> {
        let mut vectors: Vec<Vec<f64>> = Vec::new();
        for path in &self.paths {
            let mut vector: Vec<f64> = Vec::new();
            let file = File::open(path).unwrap();
            let buf_reader = BufReader::new(file);
            for line in buf_reader.lines() {
            if let Ok(line) = line {
                let item = line.split(",").collect::<Vec<&str>>()[2];
                if let Ok(item) = item.parse::<f64>() {
                    vector.push(item);
                }
            }}
            vectors.push(vector);
        }
        vectors
    }
}
