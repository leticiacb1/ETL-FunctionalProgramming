## 🚀 OCamlETL

Data processing project built using OCaml. It focuses on efficiently **E**xtracting, **T**ransforming, and **L**oading data.


> [!NOTE] 
> 
> * **E**xtract : Collect data from various sources 
> * **T**ransform Clean and organize the data according to business rules 
> * **L**oad : Store the data in a destination data store

> [!IMPORTANT]  
> Data repository : https://github.com/leticiacb1/ETL-FunctionalProgramming-Data

**#TODO: Diagram**

### 📌 Description

As data input, we consume two tables. One stores **order** information and the other stores **product information in those orders**. Table examples :

<div style="display: flex; justify-content: space-between;">

  <table style="width: 45%;">
    <tr>
      <th>id</th>
      <th>client_id</th>
      <th>order_date</th>
      <th>status</th>
      <th>origin</th>
    </tr>
    <tr>
      <td>1</td>
      <td>112</td>
      <td>2024-10-02T03:05:39</td>
      <td>Pending</td>
      <td>P</td>
    </tr>
    <tr>
      <td>2</td>
      <td>117</td>
      <td>2024-08-17T03:05:39</td>
      <td>Complete</td>
      <td>O</td>
    </tr>
    <tr>
      <td>3</td>
      <td>120</td>
      <td>2024-09-10T03:05:39</td>
      <td>Cancelled</td>
      <td>O</td>
    </tr>
  </table>

  <table style="width: 45%;">
    <tr>
      <th>order_id</th>
      <th>product_id</th>
      <th>quantity</th>
      <th>price</th>
      <th>tax</th>
    </tr>
    <tr>
      <td>12</td>
      <td>224</td>
      <td>8</td>
      <td>139.42</td>
      <td>0.12</td>
    </tr>
    <tr>
      <td>13</td>
      <td>213</td>
      <td>1</td>
      <td>160.6</td>
      <td>0.16</td>
    </tr>
    <tr>
      <td>2</td>
      <td>203</td>
      <td>7</td>
      <td>110.37</td>
      <td>0.15</td>
    </tr>
  </table>

</div>



<br>

The goal of the project is to **aggregate information related to the total amount paid and the total taxes** for each order. 

The return should be **filtered** according to the **order status (Pending | Cancelled | Complete)** and the desired **store type (O - Online | P - Physical)**.


### ⚙️ Requirements

##### **Ocaml**
```bash
$ sudo apt-get install opam
$ ocaml --version
  The OCaml toplevel, version 4.14.1

$ opam init -y
$ opam install ocaml-lsp-server odoc ocamlformat utop
$ eval $(opam env) # Update the current shell environment
```
To check the installation, start the _UTop_ :

```bash
$ utop
# 21 * 2;;
# Ctrl + D 
```
See more, [here](https://ocaml.org/docs/installing-ocaml).

##### Dune 

```bash
   # Install
   $ opam install dune
   $ dune --version
     3.17.2

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

See more, [here](https://dune.build/).


##### Libraries

```bash
# Activate env
$ eval $(opam env) 

# Install
$ opam install cohttp cohttp-lwt cohttp-lwt-unix \
               csv \
               lwt lwt_ssl \
               sqlite3 \
               ounit2
```

### 🐫 How to use

Overview project information ate in file `ETL/dune-project`, with required dependencies.

##### 1. Make sure you have all the necessary libraries and tools

```bash 
$ ocaml --version
  The OCaml toplevel, version 4.14.1

$ dune --version
     3.17.2

$ opam list | grep cohttp cohttp-lwt cohttp-lwt-unix \
               csv \
               lwt lwt_ssl \
               sqlite3 \
               ounit2

```

##### 2. Run

```bash
# Change directory
$ cd ETL/

# Build
$ dune clean && dune build 

# Execute
$ dune exec main
```

<br>

##### 3. Tests

```bash
# Change directory
$ cd ETL/

# Build
$ dune clean && dune build 

# Run tests
$ dune runtest
```

See more, [here](https://dune.readthedocs.io/en/stable/quick-start.html).

<br>

##### 4. Outputs

Inside `Data/generated/` there will be two generated files, a **agg_order.csv** and a **agg_order.db** with the calculated result.

###### SQLite3

Checking `agg_order.db` file :

```bash
# Install
$ sudo apt install sqlite3

# Inside SQLite prompt
$ sqlite3 ../Data/agg_order.db
  
  sqlite> .tables
  sqlite> SELECT * FROM results;
  sqlite> .exit
```

<br>

<div align="center">
  
**@2024, Insper**. 10° Semester, Computer Engineering.

_Funcional Programming Discipline_
  
</div>
