# Building project 

## Dependencies
This project uses autotools to build the library and `libmicrohttpd` for the HTTPS server. **The libmicrohttpd library should be compiled and installed including TLS support.**

On Ubuntu:
```shell
$ sudo apt-get update
$ sudo apt-get install autoconf libtool make automake gcc pkg-config        # autotools and gcc
$ sudo apt-get install libgnutls28-dev libgcrypt20                          # libgnutls for microhttpd
$ mkdir microhttpd && cd microhttpd                                         # Use a tmp directory
$ wget https://ftp.gnu.org/gnu/libmicrohttpd/libmicrohttpd-0.9.73.tar.gz
$ tar -xf libmicrohttpd-0.9.73.tar.gz
$ cd libmicrohttpd-0.9.73
$ ./configure               # Check HTTPS support is activated
$ make
$ sudo make install
```

On Centos (tested on `Centos 8`):
```shell
$ sudo yum install gcc autoconf libtool make automake pkgconf           # autotools and gcc
$ sudo yum install gnutls-devel
$ mkdir microhttpd && cd microhttpd                                     # Use a tmp directory
$ wget https://ftp.gnu.org/gnu/libmicrohttpd/libmicrohttpd-0.9.73.tar.gz
$ tar -xf libmicrohttpd-0.9.73.tar.gz
$ cd libmicrohttpd-0.9.73
$ ./configure               # Check HTTPS support is activated at this step
$ make
$ sudo make install
$ sudo cp /usr/local/lib/pkgconfig/libmicrohttpd.pc /usr/lib64/pkgconfig/libmicrohttpd.pc # Centos installs pkgconfig files in /usr/lib64 instead.
```

### Optional Dependencies
#### Using tcmalloc (Optional)
This project can use tcmalloc for memory management allowing better performance.

On Ubuntu:
```shell
$ sudo apt-get install libgoogle-perftools-dev
```

On Centos (tested on `Centos 8`):
```shell
$ sudo yum install gperftools gperftools-devel
```

#### Using eBPF loadbalancer based on IP only
To use eBPF loadbalancing `Python3` is needed for eBPF compilation.

On Ubuntu:
```shell
$ sudo apt install linux-headers-$(uname -r) clang libbpf-dev linux-tools-$(uname -r)
```

On Centos (tested on `Centos 8`):
```shell
$ sudo yum install kernel-headers clang
$ sudo dnf --enablerepo=powertools install libbpf-devel
$ sudo dnf install bpftool
```

## Compiling project 
This project uses autotools to compile and install the library.

### Installing
To install the library on a linux machine.
```shell
$ ./bootstrap
$ ./configure         # See "./configure --help" for options
$ make
$ make install        # Usually needs sudo permissions
$ ./export.sh         # Optional: export LD_LIBRARY_PATH with /usr/local/lib in global variable to allow linking process
```

#### Configure options
There are some custom `./configure` options : 
- `--with-examples`: compile examples directory. Not compiled by default.
- `--with-ebpf-example`: compile eBPF example. Not compiled by default. Allows to launch multiple instances of the collector on the same port and use IP loadbalancing for the reuseport socket pool instead of IP/port (default by the kernel).
- `--with-pkgconfigdir=[/own_path/pkgconfig]`: overwrite pkgconfig directory to install .pc file [default: ${PREFIX}/lib/pkgconfig].
- `--enable-tcmalloc`: enable compilation with tcmalloc instead of native malloc. tcmalloc should be installed first.
- `--with-linux=[/own_path/linux/src]`: linux source code necesary for eBPF compilation [default: /usr/src/linux]. (On Ubuntu use /usr/src/<linux>-generic version)

### Uninstalling
```shell
$ sudo make uninstall
```
You should remove the export of the lib in your `.bashrc` manually yourself to fully remove the lib.
