# Made in Abyss

This is a project to create a game based on the anime Made in Abyss.
No promises made.

## Specification

This project is an application.
Its internal library is documented in the [doc](doc) directory,
starting at [doc/intro.md](doc/intro.md).

## Getting started

[CMake](#cmake) is the primary way of building the game.

### Dependencies

This project uses C++17.
CMake takes care of the following missing dependencies.

- [Range v3](https://github.com/ericniebler/range-v3)
- [units](https://github.com/nholthaus/units)

### Building

Execute these commands from the root of your project's clone
to configure and build the game:

    cmake -E make_directory build
    cmake -E chdir build cmake ..
    cmake --build build

### Testing

All testing is done at compile-time.
The lack of compile-time errors after building the library
means that the tests passed.
