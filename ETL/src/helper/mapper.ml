open Shared.Types
(* 
  Transforms a list of string lists representing CSV rows into a list of records 
  using a specified conversion function.

  The function takes two parameters:
  - convert_fn: A function that converts a single CSV row (list of strings) 
    into a specific record type (e.g., Order or OrderItem).
  - csv_data: A list of lists, where each inner list represents a row in the CSV file.

  The function returns a list of records, each created by applying the 
  conversion function to the corresponding CSV row.

  E.g:
    Input: 
      csv_data = [['1', '1000', '2025-03-25', 'Pending', 'O'], 
                  ['2', '1001', '2025-03-24', 'Cancelled', 'P']]
      convert_fn = to_order


    Output: [Order { id = 1; client_id = 1000; date = "2025-03-25"; status = "Pending"; origin = "O" },
             Order { id = 2; client_id = 1001; date = "2025-03-24"; status = "Cancelled"; origin = "P" }]
  
  Input
  ------
    convert_fn :  List[string] -> csv_record
      A function that converts a single CSV row into a specific record type (Order | OrderItem)
    csv_data : List[List[String]]
      A list of lists, where each inner list represents a row in the CSV file.
  Output
  ------
    return : List[csv_record] 
*)
let run (convert_fn : string list -> Types.csv_record) (csv_data : string list list) : (Types.csv_record list) =
  List.map convert_fn csv_data