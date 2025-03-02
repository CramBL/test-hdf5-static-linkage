fn main() {
    #[cfg(feature = "hdf5")]
    {
        let _file = hdf5::File::create("pixels.h5").unwrap();
        println!("hdf5 feature enabled");
    }
    println!("done");
}
