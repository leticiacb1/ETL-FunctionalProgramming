module Types = struct
  
  type order = {
    id : int;
    client_id : int;
    order_date : string;
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

   type csv_record =
   | Order of order
   | OrderItem of order_item
   
end