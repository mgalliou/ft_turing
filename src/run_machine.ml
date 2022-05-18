open Core
open Read_json

let get_one_transition_string one_transition name =
    let str = "(" ^ name ^ ", " ^ one_transition#read ^ ") -> ("
    ^ one_transition#to_state ^ ", "
    ^ one_transition#write ^ ", "
    ^ one_transition#action ^ ")" in
    str

let get_list_transition_string transitions =
    let transition_list = String.concat ~sep:"\n" (List.map transitions#transition_list ~f:(fun one -> get_one_transition_string one transitions#name)) in
    transition_list

let get_transitions_string transitions =
    let str = String.concat ~sep:"" (List.map transitions ~f:(fun transi -> get_list_transition_string transi)) in
    str

let get_machine_string machine =
    let machine_string =
        "name: " ^ machine.name
        ^ "\nalphabet: [ " ^ String.concat ~sep:", " machine.alphabet ^ " ]"
        ^ "\nblank: " ^ machine.blank
        ^ "\nstates: [ " ^ String.concat ~sep:", " machine.states ^ " ]"
        ^ "\ninitial: " ^ machine.initial
        ^ "\nfinals: [ " ^ String.concat ~sep:", " machine.finals ^ " ]"
        ^ (get_transitions_string machine.transitions) in
        machine_string

let check_tape tape alphabet =
    true

let next_state tape index transition =
    (* return new_tape to_state *)
    true

let run_machine machine tape =
    print_string (get_machine_string machine);
    check_tape tape machine.alphabet;
    true
