open Constants
open Types.Types

let () =

  (* Data url *)
  let url1 = "https://raw.githubusercontent.com/leticiacb1/ETL-FunctionalProgramming-Data/refs/heads/main/order.csv" in
  let url2 = "https://raw.githubusercontent.com/leticiacb1/ETL-FunctionalProgramming-Data/refs/heads/main/order_item.csv" in
  
  (* Get content from Data repository *)
  let content1 = Lwt_main.run (Http_call.fetch_content url1) in
    print_endline (" [MAIN] > Received body 1 \n" ^ content1);
  let content2 = Lwt_main.run (Http_call.fetch_content url2) in
    print_endline (" [MAIN] > Received body 2 \n" ^ content2);

  (* Read content in csv format*)
  let csv_content1 = Read_csv.parse_csv content1 in
  let csv_content2 = Read_csv.parse_csv content2  in

  print_endline " [MAIN] > Parsed CSV 1:";
  List.iter (fun row -> Printf.printf "[ %s ]\n" (String.concat "; " row)) csv_content1;

  print_endline " [MAIN] > Parsed CSV 2:";
  List.iter (fun row -> Printf.printf "[ %s ]\n" (String.concat "; " row)) csv_content2;

  (* Tranform data in a more readble type *)

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

  let record_data1 = Csv_helper.transform_csv Constants.order csv_data1 in 
  let record_data2 = Csv_helper.transform_csv Constants.order_item csv_data2 in
  
  Printf.printf "\nExtracted Header1: [ %s ]\n" (String.concat "; " header1);
  List.iter (fun record ->
    match record with
    | Order o -> Printf.printf "Order: id=%d, client_id=%d, date=%s, status=%s, origin=%s\n"
        o.id o.client_id o.order_date o.status o.origin
    | _ -> ()
  ) record_data1;
  
  Printf.printf "\nExtracted Header2: [ %s ]\n" (String.concat "; " header2);
  List.iter (fun record ->
    match record with
    | OrderItem oi -> Printf.printf "OrderItem: order_id=%d, product_id=%d, quantity=%d, price=%.2f, tax=%.2f\n"
        oi.order_id oi.product_id oi.quantity oi.price oi.tax
    | _ -> ()
  ) record_data2;