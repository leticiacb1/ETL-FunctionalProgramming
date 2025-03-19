open Types.Types

(* Function to convert a result_record to a list of strings *)
let result_record_to_csv_row (record: result_record) : string list =
  [
    string_of_int record.order_id;
    string_of_float record.total_amount;
    string_of_float record.total_taxes;
    record.date;
    record.status;
    record.origin;
  ];;

(* Function to write a result_record list to a CSV file *)
let write_csv (filename: string) (records: result_record list) =
  let oc = open_out filename in
  let csv_out = Csv.to_channel oc in
  let headers = ["Order ID"; "Total Amount"; "Total Taxes"; "Date"; "Status"; "Origin"] in
  let rows = List.map result_record_to_csv_row records in
  Csv.output_all csv_out (headers :: rows);
  close_out oc;;
