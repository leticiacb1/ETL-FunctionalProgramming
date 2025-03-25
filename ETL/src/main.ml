open Shared.Constants
open Shared.Types.Types
open Helper
open Extractor
open Processor
open Loader

let () =

  (* ------ Extract ------ *)
  (* Data url *)
  let url1 = Constants.url_order_csv in
  let url2 = Constants.url_order_item_csv in
  
  (* Get content from Data repository *)
  let content1 = Lwt_main.run (Http_call.fetch_content url1) in
    print_endline (" [MAIN] > Received body 1 \n" ^ content1);
  let content2 = Lwt_main.run (Http_call.fetch_content url2) in
    print_endline (" [MAIN] > Received body 2 \n" ^ content2);

  (* Read content in csv format*)
  let csv_content1 = Csv_reader.parse_csv content1 in
  let csv_content2 = Csv_reader.parse_csv content2  in

  print_endline " [MAIN] > Parsed CSV 1:";
  List.iter (fun row -> Printf.printf "[ %s ]\n" (String.concat "; " row)) csv_content1;

  print_endline " [MAIN] > Parsed CSV 2:";
  List.iter (fun row -> Printf.printf "[ %s ]\n" (String.concat "; " row)) csv_content2;

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

  let (record_data1 : order list) = Csv_helper.extract_order (Csv_helper.csv_to_records Constants.c_order csv_data1) in 
  let record_data2 = Csv_helper.extract_order_items (Csv_helper.csv_to_records Constants.c_order_item csv_data2) in

  Printf.printf "\nExtracted Header1: [ %s ]\n" (String.concat "; " header1);
  List.iter (fun o ->
    Printf.printf "Order: id=%d, client_id=%d, date=%s, status=%s, origin=%s\n"
      o.id o.client_id o.date o.status o.origin
  ) record_data1;
  
  Printf.printf "\nExtracted Header2: [ %s ]\n" (String.concat "; " header2);
  List.iter (fun (oi : order_item) ->
    Printf.printf "OrderItem: order_id=%d, product_id=%d, quantity=%d, price=%.2f, tax=%.2f\n"
        oi.order_id oi.product_id oi.quantity oi.price oi.tax
  ) record_data2;

  (* ------ Process data ------ *)

  (* Get user information *)
  print_string " [INPUT] Enter the filter (status = Pending , Complete or Cancelled): ";
  let input_status = read_line () in

  print_string " [INPUT] Enter the filter (origin = O for Online or P for Physical): ";
  let input_origin = read_line () in
  
  (* Filter order list using user status and origin *)
  let (filtered_record_data1 : order list) = Csv_processor.filter_order record_data1 input_status input_origin in
  Printf.printf "\nFilter orders using status = [ %s ] and origin = [ %s ]\n" input_status input_origin;
  List.iter (fun (order: order) ->
    Printf.printf "Order: id=%d, client_id=%d, date=%s, status=%s, origin=%s\n"
      order.id order.client_id order.date order.status order.origin
  ) filtered_record_data1;

  (* Proccess *)
  let order_summary = Csv_processor.calculate_order_summary record_data2 in (* Pass orders ids filtered *)
  List.iter (fun (order_id, income, total_tax) ->
      Printf.printf "Order ID: %d, Total Income: %.2f, Total Tax: %.2f\n" order_id income total_tax
    ) order_summary;


  print_string "\n Agg data: \n";

  let results = Csv_processor.agg_information record_data2 filtered_record_data1 in
  List.iter
    (fun (r : result_record) ->
      Printf.printf "order_id: %d, total_amount: %.2f, total_taxes: %.2f, order_date: %s, status: %s, origin: %s\n"
        r.order_id r.total_amount r.total_taxes r.date r.status r.origin)
    results;

  (* Write to CSV file *)
  Csv_writer.save_csv Constants.result_data_path results;

  (* Load SQLite3 module *)
  let db_filename = "../Data/agg_order.db" in
  let tablename = "results" in
  Csv_writer.save_data_database db_filename tablename results;
  
  (*
   Next steps:
   2. Fix files names 
   3. add documentation in all functions
   4. Refactor
   5. Create unitary tests
   6. Create a diagram and update README.md
  *)


(*
Exemplo: status : complete, origin : online (O).
Saída em CSV:
  order_id,total_amount,total_taxes
  1,1345.88,20.34
  5,34.54,2.35
  14,334.44,30.4  
  
*)