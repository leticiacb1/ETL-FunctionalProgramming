let () =

  (* Data url *)
  let url1 = "https://raw.githubusercontent.com/leticiacb1/ETL-FunctionalProgramming-Data/refs/heads/main/order.csv" in
  let url2 = "https://raw.githubusercontent.com/leticiacb1/ETL-FunctionalProgramming-Data/refs/heads/main/order_item.csv" in
    
    let content1 = Lwt_main.run (Http_call.fetch_content url1) in
      print_endline (" [MAIN] > Received body 1 \n" ^ content1);
    let content2 = Lwt_main.run (Http_call.fetch_content url2) in
      print_endline (" [MAIN] > Received body 2 \n" ^ content2);