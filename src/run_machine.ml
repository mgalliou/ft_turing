open Core
open Types
open Check_machine
open Print_machine

let err_state_not_in_machine_definition = "\"state\" not in machine definition"
let err_no_transition_in_state_with_read = "no \"transtition\" in state with matching \"read\""

let get_state machine state_name =
    match List.find machine.transitions ~f:(
            fun a -> String.equal a.name state_name
        )
        with
        | Some state -> state
        | None -> raise (Bad_instruction (err_state_not_in_machine_definition, state_name))

let get_transition (state : state) c =
    match List.find state.transitions ~f:(
        fun a -> String.equal a.read (c |> Char.to_string)
    )
    with
    | Some transition -> transition
    | None -> raise (Bad_instruction (err_no_transition_in_state_with_read, (c |> Char.to_string) ^ " in " ^ state.name))

let next_state tape index state_name machine =
    let state = get_state machine state_name in
    let transition = get_transition state tape.[index] in
    let new_tape = String.mapi tape ~f:(
        fun i c ->
            if i = index then
                transition.write.[0]
            else
                c
        )
    in
    let new_index =
        if String.equal transition.action "RIGHT" then
                index + 1
            else
                index -1
    in
    (new_tape, new_index, transition)

let print_tape tape i blank =
    let max_len = 20 in
    print_string (
        "[" ^ (if i = 0 then "" else String.slice tape 0 i)
        ^ "<" ^ String.slice tape i (i + 1) ^ ">" ^ String.slice tape (i + 1) 0
    ^ (String.make (max_len - String.length tape) (String.get blank 0)) ^ "]")

let rec loop_machine (tape, index, transition, machine) =
    if List.mem machine.finals transition.to_state ~equal:(String.equal) then
        ()
    else
        let (new_tape, new_index, new_transition) = next_state tape index transition.to_state machine in
        print_tape tape index machine.blank;
        print_string (get_transition_string transition transition.to_state);
        loop_machine (new_tape, new_index, new_transition, machine)

let check_tape tape alphabet =
    if not (String.for_all tape ~f:(fun c ->  List.mem alphabet (c |> Char.to_string) ~equal:(String.equal))) then
        raise (Invalid_machine "ft_turing: error: tape contains charaters not present in alphabet")
    else
        true

let run_machine machine tape =
    if check_tape tape machine.alphabet && check_machine machine then
        let transition = get_transition (get_state machine machine.initial) tape.[0] in
        print_string (get_machine_string machine);
        print_string "********************************************************\n";
        loop_machine (tape, 0, transition, machine)
    else
        ()

