open Types.Types

open Sqlite3

(* Function to convert a result_record to a list of strings *)
let result_record_to_csv_row (record: result_record) : string list =
  [
    string_of_int record.order_id;
    string_of_float record.total_amount;
    string_of_float record.total_taxes;
    record.date;
    record.status;
    record.origin;
  ];;

(* Function to write a result_record list to a CSV file *)
let save_csv (filename: string) (records: result_record list) =
  let oc = open_out filename in
  let csv_out = Csv.to_channel oc in
  let headers = ["Order ID"; "Total Amount"; "Total Taxes"; "Date"; "Status"; "Origin"] in
  let rows = List.map result_record_to_csv_row records in
  Csv.output_all csv_out (headers :: rows);
  close_out oc;;

(* 
reference : https://github.com/cedlemo/ocaml-sqlite3-notes
*)

let clean_table db tablename =
  let query = Printf.sprintf "DELETE FROM %s;" tablename in
  match exec db query with
  | Rc.OK -> ()
  | _ -> Printf.eprintf "[ERROR] Unable to clean the table %s\n" tablename

let create_table db tablename =
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
  match exec db query with
  | Rc.OK -> Printf.printf "[INFO] Table %s created successfully.\n" tablename
  | _ -> Printf.eprintf "[ERROR] Creating table: %s\n" (errmsg db)

let insert_order db tablename (record: result_record) =
  let query = Printf.sprintf "INSERT INTO %s (order_id, total_amount, total_taxes, date, status, origin)
                              VALUES (%d, %f, %f, '%s', '%s', '%s');"
    tablename record.order_id record.total_amount record.total_taxes record.date record.status record.origin in               
  match exec db query with
  | Rc.OK -> Printf.printf "[INFO] Inserted data into %s\n" tablename
  | _ -> Printf.eprintf "[ERROR] Inserting data: %s\n" (errmsg db)

let insert_orders db tablename (data: result_record list) =
  List.iter (insert_order db tablename) data

let save_data_database filename tablename data =
  let db = db_open filename in
  clean_table db tablename;
  create_table db tablename;
  insert_orders db tablename data;
  print_endline "[INFO] Data saved successfully on database!";
  ignore(db_close db);