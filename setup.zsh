rm -rf benchmarks
mkdir -p benchmarks

unzip 'setup/benchmarks/*.zip' -d benchmarks
tar -xf setup/simplesim-3.0_acx2.tgz
make -C simplesim-3.0_acx2/ config-alpha
make -C simplesim-3.0_acx2/
