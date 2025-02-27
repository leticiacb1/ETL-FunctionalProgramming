# ETL-FunctionalProgramming
Data repository : https://github.com/leticiacb1/ETL-FunctionalProgramming-Data

* **E**xtract : Collect data from various sources 

* **T**ransform Clean and organize the data according to business rules 

* **L**oad : Store the data in a destination data store

### Prerequisite

1. **Ocaml**
```bash
$ sudo apt-get install opam
$ ocaml --version
  The OCaml toplevel, version 4.14.1

$ opam init -y
$ opam install ocaml-lsp-server odoc ocamlformat utop
$ eval $(opam env) # Update the current shell environment
```
To check the installation, start the UTop :

```bash
$ utop
# 21 * 2;;
# Ctrl + D 
```
See more, [here](https://ocaml.org/docs/installing-ocaml).

2. **Dune**

```bash
   # Install
   $  opam install dune

   # Init project
   $ dune init proj project_name

   # Build project
   $ cd project_name
   $ dune build

   # Run tests
   $ cd project_name
   $ dune test

    # Execute project
   $ cd project_name
   $ dune exec project_name
```
See more, [here](https://dune.readthedocs.io/en/stable/quick-start.html).


<div align="center">
  
**@2024, Insper**. 10° Semester, Computer Engineering.

_Funcional Programming Discipline_
  
</div>
