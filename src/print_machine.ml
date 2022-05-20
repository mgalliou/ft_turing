open Core
open Types

let get_transition_string transition state_name =
    String.concat [
        "("; state_name; ", ";
        transition.read; ") -> (";
        transition.to_state; ", ";
        transition.write; ", ";
        transition.action; ")\n"
    ]

let get_list_state_string (state : state) =
    let map_function transition =
        get_transition_string transition state.name in
    String.concat ~sep:"" (List.map state.transitions ~f:map_function)

let get_transitions_string transitions =
    let map_function state =
        get_list_state_string state in
    String.concat ~sep:"" (List.map transitions ~f:map_function)

let get_machine_string  machine =
    String.concat [
        "name: "; machine.name;
        "\nalphabet: [ "; (String.concat ~sep:", " machine.alphabet); " ]";
        "\nblank: "; machine.blank;
        "\nstates: [ "; (String.concat ~sep:", " machine.states_names); " ]";
        "\ninitial: "; machine.initial;
        "\nfinals: [ "; (String.concat ~sep:", " machine.finals); " ]\n";
        get_transitions_string machine.transitions
    ]

