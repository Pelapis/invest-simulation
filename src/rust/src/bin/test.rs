fn main() {
    let a = vec![1, 2, 3];
    let b = &[4, 5, 6][..];

    let c = a.iter().chain(b.iter());
}
