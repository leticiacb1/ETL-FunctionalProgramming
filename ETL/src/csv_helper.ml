open Constants
open Types.Types


(* 
  Specific transform for 'order' type 
*)
let to_order row =
  match row with
  | [id_str; client_id_str; order_date_str; status_str; origin_str] -> 
      Order { 
        id = int_of_string id_str;
        client_id = int_of_string client_id_str;
        order_date = order_date_str;
        status = status_str;
        origin = origin_str;
      }
  | _ -> failwith " [ERROR] Invalid order CSV format"

(* 
  Specific transform for 'order_item' type 
*)
let to_order_item row =
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


(* 
  Recive a List[[row 1 element 1, row 1 element 2, ..], [row 2 element 1, row 2 element 2, ..],] that represent
  the csv content and the data type that you want to transform.
  Return a Record with specific {transform_type} of the csv data .

  Maps each row of csv to a record.

    E.g:
      Input = [['1','pending','3.78'], ['2','failed','6.00']]
      Output = 


    Input
    ------
      transform_type : String (Constant)
      csv_data : List[List[String]
      
    Output
    ------
      return : csv_record 
        Csv content in Record {transform_type} format
*)
let csv_to_records transform_type csv_data =
  if transform_type = Constants.order 
    then List.map to_order csv_data
  else if transform_type = Constants.order_item 
    then List.map to_order_item csv_data
  else failwith " [ERROR] Invalid transform_type"