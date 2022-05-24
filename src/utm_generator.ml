open Core
open Types

let blank = "_"
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

let alphabet =
    [i_name; i_alphabet; i_blank; i_states; i_initial; i_finals;
    i_transitions; i_read; i_to_state; i_write; i_action; i_left; i_right; i_cursor;
    i_separator] |> List.append sub_alphabet |> List.append sub_states

let new_transition read to_state write action =
{
    read = read;
    to_state = to_state;
    write = write;
    action = action
}

let gen_state_go_to_states name target to_state find_action skip_action =
    {
        name = name;
        transitions = List.map alphabet ~f:(fun c -> 
            match c with
            | c when c |> String.(=) target -> new_transition target to_state target find_action
            | _ -> new_transition c name c skip_action
        )
    }

let gen_states_skip_state_def =
    List.map (List.cartesian_product alphabet sub_states) ~f:(fun (c,s) -> 
            let name = "skip_state_def_" ^ s ^ "_" ^ c in
            let to_state = ("check_transition_" ^ s ^ "_" ^ c ) in
                gen_state_go_to_states name i_separator to_state action_right action_right
            )

let gen_states_check_transitions =
    List.map (List.cartesian_product alphabet sub_states) ~f:(fun (c,s) -> 
            let name = "check_transition_" ^ s ^ "_" ^ c in
            {
                name = name; 
                transitions = List.map alphabet ~f:(fun c ->
                    match c with
                    | c when c |> String.(=) s -> new_transition c ("get_read_" ^ s ^ "_" ^ c) c action_right
                    | _ -> new_transition c ("skip_state_def_" ^ s ^ "_" ^ c) c action_right
                )
            }
        )

let gen_states_check_finals =
    List.map (List.cartesian_product alphabet sub_states) ~f:(fun (c,s) -> 
            let name = "check_finals" ^ s ^ "_" ^ c in
            let to_state = ("check__transition_" ^ s ^ "_" ^ c ) in
            {
                name = name; 
                transitions = List.map alphabet ~f:(fun c ->
                    match c with
                    | c when c |> String.(=) i_transitions -> new_transition c to_state c action_right
                    | c when c |> String.(=) s             -> new_transition c state_halt c action_right
                    | _ -> new_transition c state_halt c action_right
                )
            }
        )

let gen_states_go_to_finales =
    List.map (List.cartesian_product alphabet sub_states) ~f:(fun (c,s) -> 
            let name = "go_to_finals_" ^ s ^ "_" ^ c in
            let to_state = ("check_finals_" ^ s ^ "_" ^ c ) in
                gen_state_go_to_states name i_finals to_state action_right action_left
            )

let gen_states_set_cursor =
    List.map sub_states ~f:(fun s ->
        {
           name = "set_cursor_" ^ s;
           transitions = List.map alphabet ~f:(fun c ->
               new_transition c ("go_to_finals_" ^ s ^ "_" ^ c) c action_left
               )
        })

let gen_states_go_to_tape =
    List.map sub_states ~f:(fun s ->
        gen_state_go_to_states ("go_to_tape_" ^ s) blank ("set_cursor_" ^ s) action_right action_right
    )


let gen_state_get_first_state =
    {
        name = "get_first_state";
        transitions = List.map sub_states ~f:(fun c -> 
            new_transition c ("go_to_tape_" ^ c) c action_right
        )
    }


let gen_states =
    [gen_state_go_to_states state_initial i_initial "get_first_state" action_right action_right]
    @[gen_state_get_first_state]
    @gen_states_go_to_tape
    @gen_states_set_cursor
    @gen_states_go_to_finales
    @gen_states_check_finals
    @gen_states_skip_state_def

let generate_utm () =
    let machine = {
        name = "utm";
        alphabet = alphabet;
        blank = blank;
        states_names = [state_initial; state_halt];
        initial = state_initial;
        finals = [state_halt];
        transitions = gen_states
    } in
    machine


