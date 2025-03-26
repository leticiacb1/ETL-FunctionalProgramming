open Shared.Types

(*
  Calculates the total income of a order_item.

  Input
  ----------
    order_item : order_item

  Output
  -------
    return : float
      The total income calculated from the order item. 

*)
let calculate_income (order_item : Types.order_item) : (float) =
  order_item.price *. float_of_int order_item.quantity



(*
  Calculates the total tax for a given order_item.

  Input
  ----------
    order_item : order_item

  Output
  -------
    return : float
      The total taxes calculated from the order item. 

*)
let calculate_taxes (order_item : Types.order_item) (income : float) : (float) =
  order_item.tax *. income