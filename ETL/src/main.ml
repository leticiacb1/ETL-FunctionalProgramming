open Shared.Constants
open Shared.Types
open Helper
open Extractor
open Processor
open Loader

let () =

  print_endline "\n ====================================";
  print_endline "        🚀 WELCOME TO ETL PROJECT 🚀    ";
  print_endline " =====================================\n";

  Printf.printf  "\n [INFO] Order.csv URL = %s " Constants.url_order_csv;
  Printf.printf  "\n [INFO] Order_item.csv URL = %s \n" Constants.url_order_item_csv;


  print_endline "\n -------------------------------------";
  print_endline "        BEGINNING EXTRACTION...       ";
  print_endline " -------------------------------------\n";
  
  (* Get content from Data repository *)
  let order_raw_data = Lwt_main.run (Reader.get_content Constants.url_order_csv) in
  let order_item_raw_data = Lwt_main.run (Reader.get_content Constants.url_order_item_csv) in

  if (String.length order_raw_data > 0 && String.length order_item_raw_data > 0) 
    then Printf.printf  " [INFO] Fetch content complete ! \n"
  else
    failwith " [ERROR] Fetch empty data !";

  (* Read content in csv format*)
  let csv_order = Parser.parse_csv order_raw_data in
  let csv_order_item = Parser.parse_csv order_item_raw_data in

  (* Extract header and data *)
  let ( _ , csv_order_data) = Extractor_utils.split_header_and_data csv_order in
  let ( _ , csv_order_item_data) = Extractor_utils.split_header_and_data csv_order_item in

  (* Helper *)
  let (order_record : Types.order list) = Helper_utils.get_orders (Mapper.run (Order.transform) (csv_order_data)) in 
  let (order_item_record : Types.order_item list) = Helper_utils.get_order_items (Mapper.run (Order_item.transform) (csv_order_item_data)) in

  print_endline "\n -------------------------------------";
  print_endline "        BEGINNING TRANFORMER...       ";
  print_endline " -------------------------------------\n";

  (* Get user information *)
  print_string " [INPUT] Enter the filter (status = Pending , Complete or Cancelled): ";
  let input_status = read_line () in

  print_string "\n [INPUT] Enter the filter (origin = O for Online or P for Physical): ";
  let input_origin = read_line () in
  
  (* Filter order list using user status and origin *)
  let (filter_order_record : Types.order list) = Filter.order_by order_record input_status input_origin in
  Printf.printf "\n [INFO] Filter orders using status = [ %s ] and origin = [ %s ]\n" input_status input_origin;

  (* Grouping information *)
  let results = Summary.run order_item_record filter_order_record in

  print_endline "\n -------------------------------------";
  print_endline "        BEGINNING LOADING...       ";
  print_endline " -------------------------------------\n";

  (* Write to CSV file *)
  Csv_writer.save_csv Constants.csv_data_path results;

  (* Load in SQLite3 database *)
  Database_writer.save_data_database Constants.db_data_path Constants.db_tablename results;