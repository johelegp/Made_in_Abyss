include(mia_find_tests_dependencies)

add_library(mia_test_flags INTERFACE)
target_compile_options(mia_test_flags INTERFACE
    $<$<CXX_COMPILER_ID:GNU>:-DMIA_GCC_BUG_71504>
    -Wno-mismatched-tags)

# ```
# mia_add_test(<name>
#   [BUILD_ONLY]
#   [SOURCE source]
#   [COMPILE_OPTIONS options...]
#   [LINK_LIBRARIES libraries...])
# ```
# Adds the executable test target `mia_test_${name}`.
# `BUILD_ONLY` specifies that it doesn't need to be run by `ctest`.
# `SOURCE` specifies the its source file in `test/`. Defaults to `${name}.cpp`.
# `COMPILE_OPTIONS` specifies its `PRIVATE` compile options.
# `LINK_LIBRARIES` specifies its `PRIVATE` link libraries besides `mia::mia`.
function(mia_add_test name)
    cmake_parse_arguments(PARSE_ARGV 0 ADD_TEST
        "BUILD_ONLY" "SOURCE" "COMPILE_OPTIONS;LINK_LIBRARIES")

    list(APPEND ADD_TEST_SOURCE ${name}.cpp)
    list(GET ADD_TEST_SOURCE 0 source)

    add_executable(mia_test_${name} test/${source})
    target_compile_options(mia_test_${name} PRIVATE
        ${ADD_TEST_COMPILE_OPTIONS}
        -DMIA_TEST_EXTENSIVELY=$<BOOL:${MIA_TEST_EXTENSIVELY}>)
    target_link_libraries(mia_test_${name}
        PRIVATE ${ADD_TEST_LINK_LIBRARIES} mia::mia mia_test_flags)
    if(NOT ADD_TEST_BUILD_ONLY)
        add_test(mia_test_${name} mia_test_${name})
    endif()
endfunction()

macro(mia_add_concepts_tests)
    foreach(step RANGE 3)
        mia_add_test(concepts${step}
            BUILD_ONLY
            SOURCE concepts.cpp
            COMPILE_OPTIONS -DMIA_TEST_STEP=${step}
            LINK_LIBRARIES Boost::boost units)
        if(NOT MIA_TEST_EXTENSIVELY)
            break()
        endif()
    endforeach()
endmacro()

mia_add_test(include_ext_std_chrono BUILD_ONLY)
mia_add_test(include_concepts BUILD_ONLY)
mia_add_test(include_units BUILD_ONLY)
mia_add_test(include_spacial BUILD_ONLY)
mia_add_test(all_includes BUILD_ONLY)
mia_add_concepts_tests()
mia_add_test(units LINK_LIBRARIES range-v3 fmt::fmt-header-only units)
mia_add_test(spacial
    BUILD_ONLY
    LINK_LIBRARIES
        GSL
        Boost::boost
        range-v3
        jegp::jegp)
