open Core
open Types

let get_transition_string transition state_name =
    String.concat [
        "("; state_name; ", ";
        transition.read; ") -> (";
        transition.to_state; ", ";
        transition.write; ", ";
        transition.action; ")"
    ]

let get_list_state_string (state : state) =
    let map_function transition =
        get_transition_string transition state.name in
    String.concat ~sep:"\n" (List.map state.transitions ~f:map_function)

let get_transitions_string transitions =
    let map_function state =
        get_list_state_string state in
    String.concat ~sep:"\n" (List.map transitions ~f:map_function)

let get_machine_string  machine =
    let machine_string = String.concat [
        "name: "; machine.name;
        "\nalphabet: [ "; (String.concat ~sep:", " machine.alphabet); " ]";
        "\nblank: "; machine.blank;
        "\nstates: [ "; (String.concat ~sep:", " machine.states_names); " ]";
        "\ninitial: "; machine.initial;
        "\nfinals: [ "; (String.concat ~sep:", " machine.finals); " ]\n";
        get_transitions_string machine.all_transitions
    ] in
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
