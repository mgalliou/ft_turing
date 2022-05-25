open Core
open Types
open Check_machine
open Print_machine
open Tape

let err_state_not_in_machine_definition = "\"state\" not in machine definition"
let err_no_transition_in_state_with_read = "no \"transtition\" in state with matching \"read\""
let err_bad_action = "Bad action"

let get_state machine state_name =
    match List.find machine.transitions ~f:(
        fun a -> String.equal a.name state_name
    )
        with
        | Some state -> state
        | None -> raise (Bad_instruction (err_state_not_in_machine_definition, state_name))

let get_transition state_name c machine =
    let this_state = get_state machine state_name in
    match List.find this_state.transitions ~f:(
        fun a -> String.equal a.read (c |> Char.to_string)
        )
    with
    | Some transition -> transition
    | None -> raise (Bad_instruction (err_no_transition_in_state_with_read, (c |> Char.to_string) ^ " in " ^ state_name))

let get_new_index action index =
    match action with
    | "RIGHT" -> index + 1
    | "LEFT" -> index - 1
    | _ -> raise (Bad_instruction (err_bad_action ,  " in " ^ action))


let rec loop_machine (tape, index, machine, state_name) =
    if not (List.mem machine.finals state_name ~equal:(String.equal)) then
        let new_tape = longer_tape tape index machine.blank in
        let transition = get_transition state_name new_tape.[index] machine in
        let new_index = get_new_index transition.action index in
        if new_index < 0 then
            raise (Bad_instruction (err_bad_action ,  " \"LEFT\" when index is 0 " ));
        print_string (get_tape_string new_tape index machine.blank);
        let new_tape = write_to_tape index transition.read transition.write new_tape in
        print_string (get_transition_string transition state_name);
        loop_machine (new_tape, new_index, machine, transition.to_state)
    else
        print_endline (get_tape_string tape index machine.blank)

let run_machine (machine: machine) tape =
    if check_tape tape machine.alphabet && check_machine machine then
        print_string (get_machine_string machine);
        print_string "********************************************************\n";
        loop_machine (tape, 0, machine, machine.initial)
