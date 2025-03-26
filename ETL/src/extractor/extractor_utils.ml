(* 
  Auxiliary function.
  
  Decompose a list into its first element (the "header") and the rest of the list 
  
  E.g :
    Input = [ ["id", "client_id", "order_date", "status", "origin"],
              ['1', '1000', '2025-03-25', 'Pending', 'O'],
              ['2', '1001', '2025-02-23', 'Cancelled', 'P']
            ]

    Output = 
      header = ["id", "client_id", "order_date", "status", "origin"]

      tail = [['1', '1000', '2025-03-25', 'Pending', 'O'],
              ['2', '1001', '2025-02-23', 'Cancelled', 'P']]

  Input
  ------
    content : List[List[String]]
      Csv raw data

  Output
  ------
    return : (List[String], List[List[String]])
      Content splited by delimiter.
  
*)
let split_header_and_data (content : string list list) : (string list * string list list) =
  match content with
  | [] -> failwith " [ERROR] CSV data is empty! "
  | header :: tail -> (header, tail)