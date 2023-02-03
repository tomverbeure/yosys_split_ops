*This repo is work in progress...*

#  Yosys Split Operations

This repo contains Yosys techmap files to split operations on large vectors 
into multiple smaller ones. 

This can be useful for cases where, for example, you want to split, say,
a 40-bit addition into additions that are each 32-bits or less.

Yosys already comes standard with such a techmap for multiplications.
See the section about 
[Mapping a multiplication to an FPGA DSP Cell](https://tomverbeure.github.io/2022/11/18/Primitive-Transformations-with-Yosys-Techmap.html#mapping-a-multiplication-to-an-fpga-dsp-cell)
in one of my blog posts.

## Supported operations

* [`add_reduce`](/src/add_reduce.v)

    For operation `Y <= A + B`, reduces the width of vector Y to a maximum of the `WIDTH_OF_A` +1, `WIDTH_OF_B` + 1,
    or some programmable minimum width (whichever is the largest).

* [`add_split`](/src/add_split.v)

    Split a single large addition into multiple smaller additions.

    The split operation does not assume the presence of carry logic.


## Running test

The `./test` directory contains test cases.

You can run them by doing `cd test && make`.


