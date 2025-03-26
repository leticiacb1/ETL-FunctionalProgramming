open Shared.Types

(*
  Filters a list of orders based on specified status and origin.

  Input
  ------
    orders_record : List[order]
      A list of Order records to be filtered.

    status : string
      The status to filter the orders by ("Pending" | "Complete" | "Cancelled").

    origin : string
      The origin to filter the orders by ("O" | "P").
  
  Output
  ------
    return : List[order]
      A list of Order records where each order has the specified status 
      and origin. If no orders match the criteria, an empty list is returned.

*)
let order_by (orders_record: Types.order list) (status: string) (origin: string) : (Types.order list) =
  List.filter_map (
    fun (order : Types.order) -> (
      if order.status = status && order.origin = origin 
        then Some order 
      else None
    )
  ) orders_record;;