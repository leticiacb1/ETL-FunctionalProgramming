open OUnit2
open Shared.Types.Types
open Processor.Csv_processor


(* ----------------------- *)
(*     MOCK DATA          *)
(* ----------------------- *)

let mock_order_item = { order_id = 1; product_id = 101; quantity = 2; price = 50.0; tax = 0.1 }

let mock_order_items = [
  { order_id = 1; product_id = 101; quantity = 2; price = 50.0; tax = 0.1 };
  { order_id = 1; product_id = 102; quantity = 1; price = 100.0; tax = 0.2 };
  { order_id = 2; product_id = 201; quantity = 1; price = 200.0; tax = 0.15 };
  { order_id = 3; product_id = 202; quantity = 2; price = 75.0; tax = 0.1 };
]

let mock_orders = [
  { id = 1; client_id = 1000; date = "03/25/2025"; status = "Pending"; origin = "O" };
  { id = 2; client_id = 1001; date = "03/24/2025"; status = "Cancelled"; origin = "P" };
  { id = 3; client_id = 1002; date = "03/23/2025"; status = "Complete"; origin = "O" };
]

let mock_order_id = 1 
let mock_status = "Complete"
let mock_origin = "O"

(* ----------------------- *)
(*     TEST FUNCTIONS      *)
(* ----------------------- *)

let test_calculate_income _ =
  let expected_result = 100.0 in
  let result_obtained = calculate_income mock_order_item in
  
  assert_equal expected_result result_obtained

let test_calculate_tax _ =
  let expected_result = 10.0 in
  let income = calculate_income mock_order_item in
  let result_obtained = calculate_tax mock_order_item income in

  assert_equal expected_result result_obtained

let test_process_order _ =
  let expected_result = (1, 100.0, 10.0) in
  let result_obtained = process_order mock_order_item in
  
  assert_equal expected_result result_obtained

let test_calculate_agg _ =
  let expected_total_amount = 200.0 in
  let expected_total_taxes = 30.0 in
  let total_amount_obtained, total_taxes_obtained = calculate_agg mock_order_id mock_order_items in
  
  assert_equal expected_total_amount total_amount_obtained;
  assert_equal expected_total_taxes total_taxes_obtained

let test_agg_information _ =
  let expected_result = [
    { order_id = 1; total_amount = 200.0; total_taxes = 30.0; date = "03/25/2025"; status = "Pending"; origin = "O" };
    { order_id = 2; total_amount = 200.0; total_taxes = 30.0; date = "03/24/2025"; status = "Cancelled"; origin = "P" };
    { order_id = 3; total_amount = 150.0; total_taxes = 15.0; date = "03/23/2025"; status = "Complete"; origin = "O" };
  ] in
  let result_obtained = agg_information mock_order_items mock_orders in
  
  assert_equal expected_result result_obtained

let test_filter_order _ =
  let expected_result = [{ id = 3; client_id = 1002; date = "03/23/2025"; status = "Complete"; origin = "O" }] in
  let result_obtained = filter_order mock_orders mock_status mock_origin in

  assert_equal expected_result result_obtained

(* ----------------------- *)
(*         PIPELINE        *)
(* ----------------------- *)

let pipeline =
  "Processor Tests" >::: [
    "test_calculate_income" >:: test_calculate_income;
    "test_calculate_tax" >:: test_calculate_tax;
    "test_process_order" >:: test_process_order;
    "test_calculate_agg" >:: test_calculate_agg;
    "test_agg_information" >:: test_agg_information;
    "test_filter_order" >:: test_filter_order
  ]

(* ----------------------- *)
(*          MAIN           *)
(* ----------------------- *)

let () =
  run_test_tt_main pipeline