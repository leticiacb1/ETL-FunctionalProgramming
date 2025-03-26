open Shared.Types

(* 
  Converts a list of string lists representing CSV rows into an Order record.
  
  Each inner list corresponds to a row in the CSV file, containing the following elements:
  - id (string): The order ID.
  - client_id (string): The client ID associated with the order.
  - date (string): The date of the order.
  - status (string): The status of the order.
  - origin (string): The origin of the order.

  The function returns an Order record populated with the corresponding values from the CSV row.

  E.g:
    Input: ['1', '1000', '2025-03-25', 'Pending', 'O']
    Output: Order { id = 1; client_id = 1000; date = "2025-03-25"; status = "Pending"; origin = "O" }

  Input
  ------
    row : List[string]

  Output
  ------
    return : Order 

*)
let transform (row : string list) : (Types.csv_record) =
  match row with
  | [id_str; client_id_str; order_date_str; status_str; origin_str] -> 
      Order { 
        id = int_of_string id_str;
        client_id = int_of_string client_id_str;
        date = order_date_str;
        status = status_str;
        origin = origin_str;
      }
  | _ -> failwith " [ERROR] Invalid order CSV format"