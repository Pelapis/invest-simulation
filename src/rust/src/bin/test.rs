fn main() {
    let a = Vec::from([12, 34, 54]);
    let b = &a[0..2];
    println!("{:?}", b);
}
