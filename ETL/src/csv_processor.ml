open Types.Types

(*
  1. Realizar join das tabelas por order_id
    1.1 calculate_total_amount()
    1.2 calculate total_taxes()

             Order.csv
  id	client_id	order_date	status	origin
  1	112	2024-10-02T03:05:39	Pending	P
  2	117	2024-08-17T03:05:39	Complete	O
  3	120	2024-09-10T03:05:39	Cancelled	O

             Order_item.csv

  order_id	product_id	quantity	  price	    tax
      12	    224	          8	     139.42	   0.12
      13	    213	          1	     160.6	   0.16
      2	      203	          7	     110.37	   0.15

  Return column:

  order_id total_amount  total_taxes
    1       1345.88       20.34
    5        34.54         2.35
    14      334.44         30.4

  total_amount = somatorio(receita = preço * quantidade)
  total_taxes  = somatirio( tax * receita )
*)

(* Function to calculate total income for an order item *)
let calculate_income item =
  item.price *. float_of_int item.quantity

(* Function to calculate total tax for an order item *)
let calculate_tax item income =
  item.tax *. income

(* Process a single order item into (order_id, income, total_tax) *)
let process_order item =
  let income = calculate_income item in
  let total_tax = calculate_tax item income in
  (item.order_id, income, total_tax);;

(* Function to process all order items and print results *)
let calculate_order_summary order_items =
  let orders_resume = List.map process_order order_items in 
  Printf.printf "\nDone processing\n";
  orders_resume;;


(*
Join by order_id

let sum = List.fold_left (fun acc x -> acc + x) 0 [1; 2; 3; 4; 5]
(* sum = 15 *)

let orders = [(1, "Pending"); (2, "Completed"); (3, "Cancelled")]
let status = List.assoc_opt 2 orders
(* status = Some "Completed" *)

let not_found = List.assoc_opt 5 orders
(* not_found = None *)

let numbers = [Some 1; None; Some 3; Some 5; None]
let filtered = List.filter_map (fun x -> x) numbers
(* filtered = [1; 3; 5] *)


let join_by_order_id orders_record order_items_record =
  let order_items = extract_order_items order_items_record in
  let order = extract_order orders_record in
*)


(* Calculate aggragate informations like total_ammount and total_taxes
   for a specific order_id
*)

let calculate_agg (order_id : int) (order_items : order_item list) =
  List.fold_left
    (fun (total_amount, total_taxes) (item : order_item) ->
      if item.order_id = order_id then
        let revenue = calculate_income item in
        let taxes = calculate_tax item revenue in
        (total_amount +. revenue, total_taxes +. taxes)
      else
        (total_amount, total_taxes))
    (0.0, 0.0) (* (accumulate_amount, accumulate_taxes) *)
    order_items;;

let agg_information order_items orders =
  List.map
    (fun order ->
      let total_amount, total_taxes = calculate_agg order.id order_items in 
        { 
          order_id = order.id;
          total_amount = total_amount;
          total_taxes = total_taxes;
          date = order.date;
          status = order.status;
          origin = order.origin
        };
    ) orders;;
  

(*
Filter orders using status and origin gived by user
*)

let filter_order (orders_record: order list) (status: string) (origin: string) =
  List.filter_map (
    fun (order : order) -> (
      if order.status = status && order.origin = origin 
        then Some order 
      else None
    )
  ) orders_record;;