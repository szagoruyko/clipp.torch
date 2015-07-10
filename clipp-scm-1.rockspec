package = "clipp"
version = "scm-1"

source = {
   url = "git://github.com/szagoruyko/clipp.torch.git",
}

description = {
   summary = "Torch7 FFI bindings for OpenCLIPP",
   detailed = [[
     Powerful image processing functions for CPU and GPU
   ]],
   homepage = "https://github.com/szagoruyko/clipp.torch",
   license = "GNU"
}

dependencies = {
   "torch >= 7.0",
}

build = {
   type = "command",
   build_command = [[
cmake -E make_directory build && cd build && cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH="$(LUA_BINDIR)/.." -DCMAKE_INSTALL_PREFIX="$(PREFIX)" && $(MAKE)
]],
   install_command = "cd build && $(MAKE) install"
}
