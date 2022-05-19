open Core
open Yojson
open Types


let check_json (name, alphabet, blank, states, initial, finals, transitions) =
    true

let rec filter_list all = function
  | [] -> []
  | h :: t -> if List.mem all h ~equal:(=) then h :: filter_list all t else filter_list all t


let get_transitions state_name transitions =
    let open Yojson.Basic.Util in
    let map_transitions tmp = {
        read = tmp |> member "read" |>  to_string;
        to_state = tmp |> member "to_state" |> to_string;
        write = tmp |> member "write" |> to_string;
        action = tmp |> member "action" |> to_string
    } in
    let state_list = try transitions |> member state_name |> to_list with
          | Yojson.Basic.Util.Type_error (test, i) -> []
    in
    let state_transitions = List.map state_list ~f:map_transitions in
    {
        name = state_name;
        transitions = state_transitions
    }

let read_json file_name =
    let json = Yojson.Basic.from_file file_name in
    let open Yojson.Basic.Util in
    let finals = List.map (json |> member "finals" |> to_list) ~f:(to_string) in
    let states_names = List.map (json |> member "states" |> to_list) ~f:(to_string) in
    let map_transitions state = get_transitions state (json |> member "transitions") in
    let transitions = List.map states_names ~f:map_transitions in
    {
        name = json |> member "name" |> to_string;
        alphabet = List.map (json |> member "alphabet" |> to_list) ~f:(to_string);
        blank = json |> member "blank" |> to_string;
        states_names = states_names;
        initial = json |> member "initial" |> to_string;
        finals = finals;
        transitions = transitions
    }

let get_json file_name =
    try read_json file_name with e ->
        let msg = Exn.to_string e in
        Printf.eprintf "there was an error: %s\n" msg ;
        exit 0
