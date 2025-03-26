open OUnit2

open Shared.Types.Types  
open Loader 

open Sqlite3

(* ----------------------- *)
(*      MOCK DATA          *)
(* ----------------------- *)

let sample_record = { order_id = 1; total_amount = 100.50; total_taxes = 10.05; date = "2024-03-25"; status = "Completed"; origin = "Online"} 

let mock_records = [{ order_id = 1; total_amount = 100.0; total_taxes = 10.0; date = "2025-03-26"; status = "Completed"; origin = "Online" };
                    { order_id = 2; total_amount = 200.0; total_taxes = 20.0; date = "2025-03-27"; status = "Pending"; origin = "Offline" }
                   ] 

let mocked_csv = "test.csv"

let mock_database = "test.db"

let mock_tablename = "orders"

(* ----------------------- *)
(*     TEST FUNCTIONS      *)
(* ----------------------- *)

let test_result_record_to_csv_row _ =
  let expected = ["1"; "100.5"; "10.05"; "2024-03-25"; "Completed"; "Online"] in
  
  assert_equal expected (Csv_writer.result_record_to_csv_row sample_record)

let test_save_csv _ =
  let filename = mocked_csv in
  Csv_writer.save_csv filename mock_records;
  
  let csv_data = Csv.load filename in
  assert_equal 3 (List.length csv_data);
  assert_equal "Order ID" (List.nth (List.hd csv_data) 0);
  assert_equal "Total Amount" (List.nth (List.hd csv_data) 1);
  assert_equal "Total Taxes" (List.nth (List.hd csv_data) 2);
  assert_equal "Date" (List.nth (List.hd csv_data) 3);
  assert_equal "Status" (List.nth (List.hd csv_data) 4);
  assert_equal "Origin" (List.nth (List.hd csv_data) 5);
  
  Sys.remove filename

let test_save_database _ =  
  Database_writer.save_data_database mock_database mock_tablename mock_records;
  
  let db = Sqlite3.db_open mock_database in
    let query = "SELECT COUNT(*) FROM orders;" in
    match Sqlite3.exec db query with
    | Rc.OK -> ignore(Sqlite3.db_close db)
    | _ -> assert_failure "Failed to save data to the database"
  
(* ----------------------- *)
(*         PIPELINE        *)
(* ----------------------- *)

let suite =
  "Loader Tests" >::: [
    "test_result_record_to_csv_row" >:: test_result_record_to_csv_row;
    "test_save_csv" >:: test_save_csv;
    "test_save_database" >:: test_save_database
  ]

(* ----------------------- *)
(*          MAIN           *)
(* ----------------------- *)

let () =
  run_test_tt_main suite