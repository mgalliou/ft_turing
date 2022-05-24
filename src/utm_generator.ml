open Core
open Types

let state_initial = "init"
let state_halt = "HALT"

let action_left = "LEFT"
let action_right = "RIGHT"

let sub_alphabet = ["1"; "+"; "."]
let sub_states = [">"; "x"; "#"]

let i_name = "N"
let i_alphabet = "A"
let i_blank = "B"
let i_states = "S"
let i_initial = "I"
let i_finals = "F"
let i_transitions = "T"
let i_read = "r"
let i_to_state = "t"
let i_write = "w"
let i_action = "a"
let i_left = "L"
let i_right = "R"
let i_cursor = "C"
let i_separator = ";"

let get_alphabet () =
    [i_name; i_alphabet; i_blank; i_states; i_initial; i_finals;
    i_transitions; i_read; i_to_state; i_write; i_action; i_left; i_right; i_cursor;
    i_separator] |> List.append sub_alphabet |> List.append sub_states

(*constants*)

let gen_state_get_first_state machine =
    List.map sub_states ~f:(fun c -> 
        {
            read = c;
            to_state = "go_to_tape_" ^ c;
            write = c;
            action = action_right;
        })


let gen_skip_transitions to_state action alphabet =
    List.map alphabet ~f:(fun c -> 
        {
            read = c;
            to_state = to_state;
            write = c;
            action = action;
        })

let gen_state_go_to_states name target to_state action alphabet =
    let tmp = [{read = target; to_state = to_state; write = target; action = action_right}]@(gen_skip_transitions name action alphabet) in
    {
        name = name;
        transitions = tmp
    }


let generate_utm () =
    let alphabet = get_alphabet () in
    let machine = {
        name = "utm";
        alphabet = alphabet;
        blank = "_";
        states_names = [state_initial; state_halt];
        initial = state_initial;
        finals = [state_halt];
        transitions = [(gen_state_go_to_states state_initial i_initial "get_first_state" action_right alphabet)]
    } in
    (*List.append machine.transitions (gen_state_get_first_state machine);*)
    machine


