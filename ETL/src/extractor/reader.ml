open Lwt
open Cohttp_lwt_unix


(* Reference: https://github.com/mirage/ocaml-cohttp#client-tutorial *)
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
let get_content (url: string) : (string t) =
  (* Make the HTTP request *)
  Client.get (Uri.of_string url) >>= (fun (_, body) ->  
    (* Convert the body to a string *)
    Cohttp_lwt.Body.to_string body >|= (fun body_string ->
      body_string
    )
  )