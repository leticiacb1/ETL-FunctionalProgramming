open Shared.Constants
open Shared.Types.Types
open Helper
open Extractor
open Processor
open Loader

let () =

  (* ------ Extract ------ *)
  
  (* Get content from Data repository *)
  let content1 = Lwt_main.run (Reader.get_content Constants.url_order_csv) in
  let content2 = Lwt_main.run (Reader.get_content Constants.url_order_item_csv) in

  (* Read content in csv format*)
  let csv_content1 = Parser.parse_csv content1 in
  let csv_content2 = Parser.parse_csv content2  in

  (* ------ Tranform to Records ------ *)
  (* Extract header and remaining rows safely *)
  let (header1, csv_data1) =
    match csv_content1 with
    | [] -> failwith "[ERROR] CSV data 1 is empty!"
    | header :: tail -> (header, tail)
    in

  let (header2, csv_data2) =
    match csv_content2 with
    | [] -> failwith "[ERROR] CSV data 2 is empty!"
    | header :: tail -> (header, tail)
    in

  let (record_data1 : order list) = Csv_helper.extract_order (Csv_helper.transform Csv_helper.to_order csv_data1) in 
  let record_data2 = Csv_helper.extract_order_items (Csv_helper.transform Csv_helper.to_order_item csv_data2) in

  Printf.printf "\nExtracted Header1: [ %s ]\n" (String.concat "; " header1);
  Printf.printf "\nExtracted Header2: [ %s ]\n" (String.concat "; " header2);


  (* ------ Process data ------ *)

  (* Get user information *)
  print_string " [INPUT] Enter the filter (status = Pending , Complete or Cancelled): ";
  let input_status = read_line () in

  print_string " [INPUT] Enter the filter (origin = O for Online or P for Physical): ";
  let input_origin = read_line () in
  
  (* Filter order list using user status and origin *)
  let (filtered_record_data1 : order list) = Csv_processor.filter_order record_data1 input_status input_origin in
  Printf.printf "\nFilter orders using status = [ %s ] and origin = [ %s ]\n" input_status input_origin;

  let results = Csv_processor.agg_information record_data2 filtered_record_data1 in

  (* Write to CSV file *)
  Csv_writer.save_csv Constants.csv_data_path results;

  (* Load SQLite3 module *)
  Csv_writer.save_data_database Constants.db_data_path Constants.db_tablename results;