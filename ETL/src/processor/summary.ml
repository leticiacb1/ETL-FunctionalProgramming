open Shared.Types.Types

(*
  Groups order items by a specific order ID and calculates the total income and total taxes for that order.

  E.g:
    Input: 
      order_id = 1 
      order_items = [ { order_id = 1; product_id = 101; quantity = 2; price = 50.0; tax = 0.1 };
                      { order_id = 1; product_id = 102; quantity = 1; price = 100.0; tax = 0.2 };
                      { order_id = 2; product_id = 201; quantity = 1; price = 200.0; tax = 0.15 };
                    ]
    Output: 
      (200.0, 30.0)

  Input
  -------
    order_id : int
      The ID of the order for which to group the order items.

    order_items : List[order_item]
      A list of order_item records to be processed.

  Output
  -------
    return : float
      A tuple containing the total income and total taxes for the specified 
      order ID. If no items match the order ID, both values will be 0.0.
*)

let group_by (order_id : int) (order_items : order_item list) : (float * float) =
  List.fold_left
    (fun (total_amount, total_taxes) (item : order_item) ->
      if item.order_id = order_id then
        let revenue = Calculator.calculate_income item in
        let taxes = Calculator.calculate_taxes item revenue in
        (total_amount +. revenue, total_taxes +. taxes)
      else
        (total_amount, total_taxes)
    )
    (0.0, 0.0) (* (accumulate_amount, accumulate_taxes) *)
    order_items;;

(*
  Processes a list of orders and calculates the total income and total taxes for each order based on the provided order items.

  * Important : The status and origin must be the same in each order.

  E.g:
    Input: 
      orders = [
        { id = 1; client_id = 1000; date = "2025-03-25"; status = "Pending"; origin = "O" };
        { id = 2; client_id = 1001; date = "2025-03-24"; status = "Pending"; origin = "O" };
      ]
      order_items = [
        { order_id = 1; product_id = 101; quantity = 2; price = 50.0; tax = 0.1 };
        { order_id = 1; product_id = 102; quantity = 1; price = 100.0; tax = 0.2 };
        { order_id = 2; product_id = 201; quantity = 1; price = 200.0; tax = 0.15 };
      ]

    Output: 
      [
        { order_id = 1; total_amount = 200.0; total_taxes = 30.0; date = "2025-03-25"; status = "Pending"; origin = "O" };
        { order_id = 2; total_amount = 200.0; total_taxes = 30.0; date = "2025-03-24"; status = "Pending"; origin = "0" };
      ]

  Input
  -------
    order_items : List[order_item]
      A list of order_item records used to calculate totals for each order.

    orders : List[order]
      A list of order records to be processed.

  Output
  -------
    return : List[result_record]
*)
let run ( order_items : order_item list ) (orders : order list) : (result_record list)=
  List.map
    (fun order ->
      let total_amount, total_taxes = group_by order.id order_items in 
        { 
          order_id = order.id;
          total_amount = total_amount;
          total_taxes = total_taxes;
          date = order.date;
          status = order.status;
          origin = order.origin
        };
    ) orders;;