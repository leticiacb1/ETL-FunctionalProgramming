open OUnit2

open Extractor 
open Shared.Constants

(* ----------------------- *)
(*     TEST FUNCTIONS      *)
(* ----------------------- *)

let test_get_content _ =
  let order_response = Lwt_main.run (Reader.get_content Constants.url_order_csv) in
  let order_item_response = Lwt_main.run (Reader.get_content Constants.url_order_item_csv) in
  
  assert_bool "Response should not be empty" (String.length order_response > 0);
  assert_bool "Response should not be empty" (String.length order_item_response > 0)

let test_split_string _ =
  let input = "apple, banana, orange" in
  let expected = ["apple"; "banana"; "orange"] in
  
  assert_equal expected (Parser.split_string ',' input)

let test_parse_csv _ =
  let csv_data = "name,age\nAlice,30\nBob,25" in
  let expected = [["name"; "age"]; ["Alice"; "30"]; ["Bob"; "25"]] in
  
  assert_equal expected (Parser.parse_csv csv_data)

let test_split_header_and_data _ =
  let input = [["name"; "age"]; ["Alice"; "30"]; ["Bob"; "25"]] in
  let expected_header = ["name"; "age"] in
  let expected_data = [["Alice"; "30"]; ["Bob"; "25"]] in
  
  let header, data = Extractor_utils.split_header_and_data input in
  
  assert_equal expected_header header;
  assert_equal expected_data data

(* ----------------------- *)
(*         PIPELINE        *)
(* ----------------------- *)

let suite =
  "Extractor Tests" >::: [
    "test_get_content" >:: test_get_content;
    "test_split_string" >:: test_split_string;
    "test_parse_csv" >:: test_parse_csv;
    "test_split_header_and_data" >:: test_split_header_and_data
  ]

(* ----------------------- *)
(*          MAIN           *)
(* ----------------------- *)

let () =
  run_test_tt_main suite
