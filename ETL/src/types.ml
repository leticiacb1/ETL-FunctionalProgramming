module Types = struct
  
  type order = {
    id : int;
    client_id : int;
    date : string;
    status : string;
    origin : string;
  };;

  type order_item = {
    order_id : int;
    product_id : int;
    quantity : int;
    price : float;
    tax : float;
  };;

  type result_record = {
    order_id : int;
    total_amount : float;
    total_taxes : float;
    date : string;
    status : string;
    origin : string;
  };;

  type csv_record =
  | Order of order
  | OrderItem of order_item;;

end