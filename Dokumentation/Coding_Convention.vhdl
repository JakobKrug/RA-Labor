/*
=============================================================
VHDL-Coding Conventions

Based on https://google.github.io/swift/

General:
1. English is the language used in all documents associated with
   this project. It is used for commenting and naming
2. Code should strive to be self-explanatory, and comments should
   only be used when necessary.
3. Code has to be formatted consistently across the project: Usage
   of a code formatter is recommend. Avoid tabs.


Document structure:
1. Each file starts with a header comment, containing
   a) the file's author and contact info
   b) the date the file was last updated
   c) a short description
   d) the current version

2. Each file contains only one entity/testbench etc., but may
   contain multiple architectures
3. If a file contains ann entity definition, it should match the
   file name
4. If a file contains a testbench, it should be named after the 
   under test, followed by "_tb"
5. Each file follows the order: Library Imports > Entity > 
   Architecture

Naming:
1. All variables, ports and signals are written in camelCase
2. All constants are written in UPPER_CASE, using snake case
2. Names are always spelled out, even when long. Abriviations and 
   acronyms are to be avoided, unless they are common.
3. Names should be descriptive and unique.
4. Signals should be prefixed with "s_", variables with "v_", input ports
   with "pi_", po_output ports with "po_" functions with "f_".
   Constants are not prefixed. Other prefixes are not allowed.
5. The datatype is NOT included in the identifier.


VHDL:
1. Keywords and types are written in lowercase 
2. begin and end should always be used, even when a block contains
   only a single statement
3. Parentheses should be used to describe order of operations. Do
   not rely on operator precedence.
4. Signals and variables should always be initialized.
5. Processes should always be named
6. Explicit port mapping should be used, positional ports are not
   allowd.
7. Generics are to be used only when really necessary/benefitial
9. Timing operations like "after" or "wait" are only allowed in 
   testbenches, to prevent differences between simulation and 
   reality (e.g. emulation on an FPGA)
   
Testing:
1. Each entity is to be tested with its own testbench.
2. All input parameters should be tested when possible
3. Assertions and descriptive error messages are to be used when-
   ever possible


=============================================================
*/