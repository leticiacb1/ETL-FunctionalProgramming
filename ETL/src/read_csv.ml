(* 
  Auxiliar function.
  Split a string by a given delimiter.
  
    Input
    ------
      sep : String
        Separator that will be used to split the string.

      content : String
        Content in String format that we want to reformat.

    Output
    ------
      return : List[String]
        Content splited by delimiter.
*)
let split_string sep content =
  String.split_on_char sep content |> List.map String.trim;;



(*
    Function that recive a string od content and return a List[List(String)] of content,
    where each line represente a element of the list.
    
    E.g:
      Input = '1,2,3\n4,5,6\n' 
      Output = [['1','2','3'], ['4','5','6']]

    Input
    ------
      content : String
        Csv content in String format

    Output
    ------
      return : List[List(String)]
        Csv content in format [[elements row 1], [elements row 2], ... ]
*)
let parse_csv csv_content =
  csv_content
  |> String.split_on_char '\n'                        (* Split into lines *)
  |> List.filter (fun line -> String.trim line <> "") (* Remove empty lines *)
  |> List.map (split_string ',');; 