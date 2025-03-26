open OUnit2
open Shared.Types.Types

open Helper

(* ----------------------- *)
(*      MOCK DATA          *)
(* ----------------------- *)

let mock_order_row = ["1"; "101"; "2023-05-10"; "Shipped"; "Online"]
let mock_order_item_row = ["1"; "201"; "2"; "49.99"; "5.00"]

(* ----------------------- *)
(*     TEST FUNCTIONS      *)
(* ----------------------- *)

let test_transform_order _ =
  match Order.transform mock_order_row with
  | Order o ->
      assert_equal o.id 1;
      assert_equal o.client_id 101;
      assert_equal o.date "2023-05-10";
      assert_equal o.status "Shipped";
      assert_equal o.origin "Online"
  | _ -> assert_failure "Expected Order record"

let test_transform_order_item _ =
  match Order_item.transform mock_order_item_row with
  | OrderItem oi ->
      assert_equal oi.order_id 1;
      assert_equal oi.product_id 201;
      assert_equal oi.quantity 2;
      assert_equal oi.price 49.99;
      assert_equal oi.tax 5.00
  | _ -> assert_failure "Expected OrderItem record"

(* ----------------------- *)
(*         PIPELINE        *)
(* ----------------------- *)

let suite =
  "TransformTests" >::: [
    "test_transform_order" >:: test_transform_order;
    "test_transform_order_item" >:: test_transform_order_item
  ]

(* ----------------------- *)
(*          MAIN           *)
(* ----------------------- *)

let () =
  run_test_tt_main suite
