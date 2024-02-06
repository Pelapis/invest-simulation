pub struct Data_reader<'a> {
    paths: &'a [&'a str]
}

impl<'a, 'b> Data_reader<'a> {
    pub fn from_paths(paths: &'a [&'a str]) -> Self { Self { paths } }
    pub fn get_return_vectors(&self) -> &'b[&'b[f64]] {
        // 返回数据
        &[&[0.0]]
    }
}
