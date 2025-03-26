open Shared.Types

(* 
  Auxiliary function.
  Recive records with type csv_record (Order of order | OrderItem of ordem_item) 
  an return element with order_item type.
  
  Input
  ------
    records : List[csv_record]

  Output
  ------
    return : List[order_item]
*)
let get_order_items (records : Types.csv_record list) : (Types.order_item list) =
  List.filter_map (function
    | Types.OrderItem oi -> Some oi
    | _ -> None
  ) records


(* 
  Auxiliary function.
  Recive records with type csv_record (Order of order | OrderItem of ordem_item) 
  an return element with order type.
  
  Input
  ------
    records : List[csv_record]

  Output
  ------
    return : List[order]
*)
let get_orders (records : Types.csv_record list) : (Types.order list) =
    List.filter_map (function
      | Types.Order o -> Some o
      | _ -> None
    ) records