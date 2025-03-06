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
  let csv_data1 = Read_csv.parse_csv content1 in
  let csv_data2 = Read_csv.parse_csv content2  in

  print_endline " [MAIN] > Parsed CSV 1:";
  List.iter (fun row -> Printf.printf "[ %s ]\n" (String.concat "; " row)) csv_data1;

  print_endline " [MAIN] > Parsed CSV 2:";
  List.iter (fun row -> Printf.printf "[ %s ]\n" (String.concat "; " row)) csv_data2;