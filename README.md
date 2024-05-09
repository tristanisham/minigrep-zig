# Minigrep (in Zig)


This project recreates the
[mini-grep I/O project](https://doc.rust-lang.org/book/ch12-01-accepting-command-line-arguments.html)
from the Rust Book in Zig. 

# Install

```sh
$ git clone https://github.com/tristanisham/minigrep-zig; cd minigrep-zig

```

Need to install Zig? Try [ZVM](https://github.com/tristanisham/zvm).

# Run the program

```sh
$ zig build run -- "query" ./path/to/file
```

You can also find your compiled binary in `zig-out`. 

## Build for Release

```sh
zig build -Doptimize=ReleaseFast
```

<!-- ## Accepting Command Line Arguments

To create a new project with Zig (<= 0.11.0-dev.3301+230ea411f) create and cd
into a directory called `minigrep`. Next, run `zig init-exe` to generate a new
project.

```sh
$ mkdir minigrep; cd minigrep
$ zig init-exe
```

As in the Rust book, "The first task is to make `minigrep` accept its two
command line arguemnts: the file path and string to search for". We'll want to
run our program with `zig build run`, using two hyphens to indicate the
following arguments are for our program instead of `zig`.

```sh
$ zig build run -- searchString example-file-path.txt
```

Right now our program won't accept any argument. We'll have to implement that
functionality ourselves. Try running `zig build run` with the default generated
program.You should see somethine like:

```sh
$ zig build run

# All your codebase are belong to us.
# Run `zig build test` to run the tests.
```

### Reading the Argument Values

Unlike in higher-level languages like Go or Rust 😉, to enable `minigrep` to
read values from the command line we'll jump directly into manual memory
management. Introducing, allocators!

```zig
const std = @import("std");

pub fn main() !void {
   var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
   defer arena.deinit();
   const allocator = arena.allocator();
   _ = allocator;
}
```

Before we start, let's go over some Zig basics.

- Use `var` to declare a mutable variable
- Use `const` to declare a immutable variable
- Use `defer` to execute a statement while exiting the current block. Multiple
  defers follow the _first in, last out_ policy.
 -->
