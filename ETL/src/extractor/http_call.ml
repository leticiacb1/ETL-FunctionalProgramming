open Lwt
open Cohttp
open Cohttp_lwt_unix


(*Reference: https://github.com/mirage/ocaml-cohttp#client-tutorial*)
(*
    Function that recive a string URL and return it content
    
    Input
    ------
      url : String
        Endpoint from which the information will be retrieved 

    Output
    ------
      content : String 
        Url content
*)
let fetch_content url =
  (* Make the HTTP request *)
  Client.get (Uri.of_string url) >>= (fun (resp, body) ->
  
    (* Extract the status and code *)
    let status = Response.status resp in
    let code = Code.code_of_status status in
    Printf.printf " [FETCH] > Response code: %d\n" code;
  
    (* Convert the body to a string *)
    Cohttp_lwt.Body.to_string body >|= (fun body_string ->
      Printf.printf " [FETCH] > Body of length: %d\n" (String.length body_string);
      body_string
    )
  )

