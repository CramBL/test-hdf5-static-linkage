# build_check_linkage.ps1
# PowerShell script to build and check linkage of hdf5-static-linking

# Set environment variables
$env:RUSTFLAGS = "--codegen target-feature=+crt-static"
$TARGET = "x86_64-pc-windows-msvc"

# Create a function for checking linkage similar to ldd/grep
function Check-Linkage {
    param (
        [string]$executable,
        [switch]$checkNoHdf5
    )

    Write-Host "Checking linkage for: $executable"

    # Use PowerShell's built-in way to check DLL dependencies
    $deps = dumpbin /dependents $executable | Select-String "\.dll"

    # Display all dependencies
    $deps | ForEach-Object { Write-Host $_.Line.Trim() }

    # Check if HDF5 is not present (equivalent to grep --invert-match)
    if ($checkNoHdf5) {
        $hdf5Deps = $deps | Where-Object { $_.Line -match "hdf5" }
        if ($hdf5Deps) {
            Write-Host "ERROR: HDF5 dependencies found when they shouldn't be present!" -ForegroundColor Red
            return $false
        } else {
            Write-Host "SUCCESS: No HDF5 dependencies found, as expected." -ForegroundColor Green
            return $true
        }
    }

    return $true
}

# Make sure we're in the repo directory (equivalent of checkout)
# Uncomment if needed to change to a specific directory
# Set-Location -Path "C:\path\to\your\repo"

# Build without HDF5
Write-Host "Building without HDF5..." -ForegroundColor Cyan
cargo build --target $TARGET
if ($LASTEXITCODE -ne 0) {
    Write-Host "Error building without HDF5!" -ForegroundColor Red
    exit $LASTEXITCODE
}

# Check linkage (without HDF5)
$exePath = "target\$TARGET\debug\hdf5-static-linking.exe"
if (-not (Test-Path $exePath)) {
    Write-Host "Error: Executable not found at $exePath" -ForegroundColor Red
    exit 1
}
Check-Linkage -executable $exePath

# Build WITH HDF5
Write-Host "Building WITH HDF5..." -ForegroundColor Cyan
cargo build --target $TARGET --features hdf5
if ($LASTEXITCODE -ne 0) {
    Write-Host "Error building with HDF5!" -ForegroundColor Red
    exit $LASTEXITCODE
}

# Check linkage (with HDF5)
Check-Linkage -executable $exePath
Check-Linkage -executable $exePath -checkNoHdf5

Write-Host "All steps completed successfully!" -ForegroundColor Green