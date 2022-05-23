open Core
open Yojson
open Types

let err_invalid_field_in_json = "\"field\" invalid in json"

let get_member_string json field_name =
    let open Yojson.Basic.Util in
    try json |> member field_name |> to_string with
    | Type_error (msg,yojson) -> raise (Invalid_json (err_invalid_field_in_json ^ " for " ^ field_name ))

let get_member_list json field_name =
    let open Yojson.Basic.Util in
    let field = try json |> member field_name with
        | Type_error (msg,yojson) -> raise (Invalid_json (err_invalid_field_in_json ^ " for " ^ field_name ))
    in
    try field |> to_list with
    | Type_error (test, i) -> raise (Invalid_json (err_invalid_field_in_json ^ " for " ^ field_name ))

let rec filter_list all = function
    | [] -> []
    | h :: t -> if List.mem all h ~equal:(=) then h :: filter_list all t else filter_list all t


let get_transitions state_name transitions =
    let open Yojson.Basic.Util in
    let map_transitions tmp = {
        read = get_member_string tmp "read";
        to_state = get_member_string tmp "to_state";
        write = get_member_string tmp "write";
        action = get_member_string tmp "action";
    } in
    let state_list = get_member_list transitions state_name in
    let state_transitions = List.map state_list ~f:map_transitions in
    {
        name = state_name;
        transitions = state_transitions
    }

let read_json file_name =
    let json = try Yojson.Basic.from_file file_name with
        | Sys_error str  -> raise (Invalid_json str)
        | Json_error str -> raise (Invalid_json str)
    in
    let open Yojson.Basic.Util in
    let finals = List.map (get_member_list json "finals") ~f:(to_string) in
    let states_names = List.map (get_member_list json "states") ~f:(to_string) in
    let filter_names state_name =
        List.mem  finals state_name ~equal:(String.(<>)) in
    let states_names_filtered = List.filter states_names ~f:filter_names in
    let json_transitions = match json |> member "transitions" with
    | `Null -> raise (Invalid_json (err_invalid_field_in_json ^ " for " ^ "transitions" ))
    | json_transitions -> json_transitions
    in
    let map_transitions state = try get_transitions state json_transitions with
        | Type_error (msg,yojson) -> raise (Invalid_json (err_invalid_field_in_json ^ " for " ^ "transitions" ))
        | Json_error msg -> raise (Invalid_json (err_invalid_field_in_json ^ " for " ^ "transitions" ))
    in
    let transitions = List.map states_names_filtered ~f:map_transitions in
    {
        name = get_member_string json "name";
        alphabet = List.map (get_member_list json "alphabet") ~f:(to_string);
        blank = get_member_string json "blank";
        states_names = states_names;
        initial = get_member_string json "initial";
        finals = finals;
        transitions = transitions
    }
