# build_check_linkage.ps1
# PowerShell script to build and check linkage of hdf5-static-linking

# Set environment variables
$env:RUSTFLAGS = "--codegen target-feature=+crt-static"
$TARGET = "x86_64-pc-windows-msvc"

# Build without HDF5
Write-Host "Building without HDF5..." -ForegroundColor Cyan
cargo build --target $TARGET
if ($LASTEXITCODE -ne 0) {
    Write-Host "Error building without HDF5!" -ForegroundColor Red
    exit $LASTEXITCODE
}

# Build WITH HDF5
Write-Host "Building WITH HDF5..." -ForegroundColor Cyan
cargo build --target $TARGET --features hdf5
if ($LASTEXITCODE -ne 0) {
    Write-Host "Error building with HDF5!" -ForegroundColor Red
    exit $LASTEXITCODE
}

Write-Host "All steps completed successfully!" -ForegroundColor Green