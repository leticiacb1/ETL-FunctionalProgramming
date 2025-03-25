module Constants = struct
  (* ----- FETCH CONTENT URLS -----*)
  let url_order_csv = "https://raw.githubusercontent.com/leticiacb1/ETL-FunctionalProgramming-Data/refs/heads/main/order.csv"
  let url_order_item_csv = "https://raw.githubusercontent.com/leticiacb1/ETL-FunctionalProgramming-Data/refs/heads/main/order_item.csv"
  
  (* ----- GENERATED DATA PATHS -----*)
  let csv_data_path = "../Data/generated/csv/agg_order.csv"
  let db_data_path = "../Data/generated/database/agg_order.db"
  
  (* ----- DATABASE -----*)
  let db_tablename = "agg_order"
end