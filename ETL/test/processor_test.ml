(*
open OUnit2
open My_library

let test_calculate_income _ =
  let item = { order_id = 1; product_id = 101; quantity = 2; price = 50.0; tax = 0.1 } in
  assert_equal 100.0 (Csv_processor.calculate_income item)

let test_calculate_tax _ =
  let item = { order_id = 1; product_id = 101; quantity = 2; price = 50.0; tax = 0.1 } in
  let income = calculate_income item in
  assert_equal 10.0 (Csv_processor.calculate_tax item income)

let test_process_order _ =
  let item = { order_id = 1; product_id = 101; quantity = 2; price = 50.0; tax = 0.1 } in
  assert_equal (1, 100.0, 10.0) (Csv_processor.process_order item)

let test_calculate_agg _ =
  let items = [
    { order_id = 1; product_id = 101; quantity = 2; price = 50.0; tax = 0.1 };
    { order_id = 1; product_id = 102; quantity = 1; price = 100.0; tax = 0.2 };
    { order_id = 2; product_id = 201; quantity = 1; price = 200.0; tax = 0.15 };
  ] in
  let total_amount, total_taxes = Csv_processor.calculate_agg 1 items in
  assert_equal 200.0 total_amount;
  assert_equal 20.0 total_taxes
*)
