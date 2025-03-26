open Shared.Types.Types

(* 
  Converts a result_record into a list of strings suitable for CSV output.

  Input
  ------
    record : result_record
      A record containing the order summary details 
      ( order ID, total amount, total taxes, date, status, origin )

  Output
  -------
    return : List[string]
      A list of strings representing the fields of the result_record, 
      formatted for CSV output.
*)
let result_record_to_csv_row (record: result_record) : (string list) =
  [
    string_of_int record.order_id;
    string_of_float record.total_amount;
    string_of_float record.total_taxes;
    record.date;
    record.status;
    record.origin;
  ];;

(* 
  Writes a list of result_records to a CSV file.

  Input
  ------
    filename : string
      The name of the file where the CSV data will be written.

    records : List[result_record]
      A list of result_record to be written to the CSV file. 

  Output
  -------
    return : void
*)
let save_csv (filename: string) (records: result_record list) : unit =
  let oc = open_out filename in
  let csv_out = Csv.to_channel oc in
  let headers = ["Order ID"; "Total Amount"; "Total Taxes"; "Date"; "Status"; "Origin"] in
  let rows = List.map result_record_to_csv_row records in
  Csv.output_all csv_out (headers :: rows);
  close_out oc;;

(* 
  Reference : https://ocaml.org/p/csv/2.3/doc/Csv/index.html#output
*)