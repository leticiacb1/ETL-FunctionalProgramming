open Shared.Types

(* 
  Converts a list of string lists representing CSV rows into an OrderItem record.
  
  Each inner list corresponds to a row in the CSV file, containing the following elements:
  - order_id (string): The ID of the order to which the item belongs.
  - product_id (string): The ID of the product being ordered.
  - quantity (string): The quantity of the product ordered.
  - price (string): The price of the product.
  - tax (string): The tax rate applicable to the product.

  The function returns an OrderItem record populated with the corresponding values from the CSV row.

  E.g:
    Input: ['1', '101', '2', '50.0', '0.1']
    Output: OrderItem { order_id = 1; product_id = 101; quantity = 2; price = 50.0; tax = 0.1 

  Input
  ------
    row : List[string]

  Output
  ------
    return : OrderItem 

*)
let transform (row : string list) : (Types.csv_record) =
  match row with
  | [order_id_str; product_id_str; quantity_str; price_str; tax_str] ->
      OrderItem { 
        order_id = int_of_string order_id_str;
        product_id = int_of_string product_id_str;
        quantity = int_of_string quantity_str;
        price = float_of_string price_str;
        tax = float_of_string tax_str;
      }
  | _ -> failwith " [ERROR] Invalid order_item CSV format"