fn main() {
    // // Windows-specific linking configuration
    // #[cfg(target_os = "windows")]
    // {
    //     // Force static CRT linkage
    //     println!("cargo:rustc-link-lib=static=libucrt");
    //     println!("cargo:rustc-link-lib=static=libvcruntime");
    //     println!("cargo:rustc-link-lib=static=libcmt");

    //     // Prevent MSVCRT linking
    //     println!("cargo:rustc-link-arg=/NODEFAULTLIB:libcmt.lib");
    //     println!("cargo:rustc-link-arg=/NODEFAULTLIB:msvcrt.lib");
    //     println!("cargo:rustc-link-arg=/NODEFAULTLIB:msvcrtd.lib");
    // }
}
