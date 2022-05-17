open Base
open Yojson
open Transitions
open One_transition

let rec filter_list all = function
  | [] -> []
  | h :: t -> if List.mem all h ~equal:(=) then h :: filter_list all t else filter_list all t


let get_transitions state transitions =
    let open Yojson.Basic.Util in
    let transition_list =  transitions |> member state  |> to_list in
    let tmp = List.map transition_list ~f:(fun one -> new one_transition (one |> member "read" |> to_string) (one |> member "to_state" |> to_string) (one |> member "write" |> to_string) (one |> member "action" |> to_string)) in
    new transitions state tmp

let read_json file_name =
    let json = Yojson.Basic.from_file file_name in
    let open Yojson.Basic.Util in
    let name = json |> member "name" |> to_string in
    let alphabet = json |> member "alphabet" |> to_list in
    let blank = json |> member "blank" |> to_string in
    let initial = json |> member "initial" |> to_string in
    let states = List.map (json |> member "states" |> to_list) ~f:(fun state -> state |> to_string) in
    let finals = List.map (json |> member "finals" |> to_list) ~f:(fun state -> state |> to_string) in
    let states_filtered = List.filter states ~f:(fun a -> List.mem  finals a ~equal:(fun a b -> not(String.equal a b))) in
    let transitions = List.map states_filtered ~f:(fun state -> get_transitions state (json |> member "transitions")) in
    (*List.iter all_transitions ~f:(fun one -> List.iter one#transition_list ~f:(fun two -> Core.printf "%s" two#read))*)
    (name, alphabet, blank, states, initial, finals, transitions)
