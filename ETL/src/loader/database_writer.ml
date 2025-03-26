open Sqlite3
open Shared.Types

(*
  Delete table.
  
  Input
  ------
    db : database connector
      A reference to the database file from which the table will be deleted

    tablename : string
      The name of the table to be deleted
      
  Output
  ------
    return : void
*)
let clean_table (db : Sqlite3.db) (tablename : string) : unit =
  let query = Printf.sprintf "DELETE FROM %s;" tablename in
  match Sqlite3.exec db query with
  | Rc.OK -> ()
  | _ -> Printf.eprintf "[ERROR] Unable to clean the table %s\n" tablename

(*
  Create table.
  
  Input
  ------
    db : database connector
      A reference to the database file from which the table will be created

    tablename : string
      Name of the table that will be created
      
  Output
  ------
    return : void
*)
let create_table (db : Sqlite3.db) (tablename : string) : unit =
  let query = Printf.sprintf "
    CREATE TABLE IF NOT EXISTS %s (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      order_id INTEGER,
      total_amount REAL,
      total_taxes REAL,
      date TEXT,
      status TEXT,
      origin TEXT
    );" tablename in
  match Sqlite3.exec db query with
  | Rc.OK -> ()
  | _ -> Printf.eprintf "[ERROR] Creating table: %s\n" (errmsg db)

(*
  Insert the order in the table.
  
  Input
  ------
    db : database connector
      A reference to the database file from which the table will be created

    tablename : string
      Name of the table that will be created

    record : result_record 
      result_record to be inserted into the table

  Output
  ------
    return : void
*)
let insert_order (db : Sqlite3.db) (tablename : string) (record : Types.result_record) : unit =
  let query = Printf.sprintf "INSERT INTO %s (order_id, total_amount, total_taxes, date, status, origin)
                              VALUES (%d, %f, %f, '%s', '%s', '%s');"
    tablename record.order_id record.total_amount record.total_taxes record.date record.status record.origin in               
  match Sqlite3.exec db query with
  | Rc.OK -> ()
  | _ -> Printf.eprintf "\n [ERROR] Inserting data: %s\n" (errmsg db)

let insert_orders (db : Sqlite3.db) (tablename : string) (data: Types.result_record list) : unit =
  List.iter (insert_order db tablename) data

(*
  Saves data to a specified table in the database.
  
  Input
  ------
    db : database connector
      A reference to the database file from which the table will be created

    tablename : string
      Name of the table that will be created
    
    data : result_record
      List of result_record to be inserted into the table

  Output
  ------
    return : void
*)
let save_data_database (filename : string) (tablename : string) (data : Types.result_record list) : unit =
  let db = Sqlite3.db_open filename in
  
  clean_table db tablename;
  create_table db tablename;
  insert_orders db tablename data;
  
  Printf.printf "\n [INFO] Data saved successfully on database %s ! \n" filename;
  
  ignore(Sqlite3.db_close db);

(* 
  Reference : https://github.com/cedlemo/ocaml-sqlite3-notes
*)