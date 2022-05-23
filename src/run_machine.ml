open Core
open Types
open Check_machine
open Print_machine

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

let write_to_tape index read write tape =
    String.substr_replace_first ~pos:index tape ~pattern:read ~with_:write

let longer_tape tape index blank =
    if index = String.length tape -1 then
        tape ^ blank
    else
        tape

let get_new_index action index =
    match action with
    | "RIGHT" -> index + 1
    | "LEFT" -> index - 1
    | _ -> raise (Bad_instruction (err_bad_action ,  " in " ^ action))

let print_tape tape i blank =
    let max_len = 20 in
    print_string (
        "[" ^ (if i = 0 then "" else String.slice tape 0 i)
        ^ "<" ^ String.slice tape i (i + 1) ^ ">" ^ String.slice tape (i + 1) 0
    ^ (String.make (max_len - String.length tape) (String.get blank 0)) ^ "]")

let rec loop_machine (tape, index, machine, state_name) =
    if not (List.mem machine.finals state_name ~equal:(String.equal)) then
        let new_transition = get_transition state_name tape.[index] machine in
        let new_index = get_new_index new_transition.action index in
        let new_tape = write_to_tape index new_transition.read new_transition.write tape in
        let new_tape = longer_tape new_tape index machine.blank in
        print_tape tape index machine.blank ;
        print_string (get_transition_string new_transition state_name);
        loop_machine (new_tape, new_index, machine, new_transition.to_state)
    else
        print_tape tape index machine.blank

let check_tape tape alphabet =
    if not (String.for_all tape ~f:(fun c ->  List.mem alphabet (c |> Char.to_string) ~equal:(String.equal))) then
        raise (Invalid_machine "ft_turing: error: tape contains charaters not present in alphabet")
    else
        true

let run_machine (machine: machine) tape =
    if check_tape tape machine.alphabet && check_machine machine then
        print_string (get_machine_string machine);
        print_string "********************************************************\n";
        loop_machine (tape, 0, machine, machine.initial)
