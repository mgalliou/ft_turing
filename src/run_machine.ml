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
        get_transitions_string machine.transitions
    ] in
    machine_string

let check_machine machine =
    (*check "blank" is in alphabet*)
    List.mem machine.alphabet machine.blank ~equal:(String.equal)
    (*check "initial" is in states*)
    && List.mem machine.states_names machine.initial ~equal:(String.equal)
    (*check "finals" are in states*)
    && List.for_all machine.finals ~f:(fun s -> List.mem machine.states_names s  ~equal:(String.equal))
    (*check transitions.states are in "states"*)
    && List.for_all machine.transitions ~f:(fun state -> List.mem machine.states_names state.name ~equal:(String.equal))
    (*check transitions.states.transition.read is in "alphabet"*)
    (*check transitions.states.transition.to_state is in "states"*)
    (*check transitions.states.transition.write is in "alphabet"*)
    (*check transitions.states.transition.action is "LEFT" or "RIGHT"*)
    && List.for_all machine.transitions ~f:(
        fun state -> List.for_all state.transitions ~f:(
            fun trans -> List.mem machine.alphabet trans.read ~equal:(String.equal)
            && List.mem machine.states_names trans.to_state ~equal:(String.equal)
            && List.mem machine.alphabet trans.write ~equal:(String.equal)
            && List.mem ["LEFT"; "RIGHT"] trans.action ~equal:(String.equal)
        )
    )

let check_tape tape alphabet =
    let char_in_str_lst c lst = List.mem alphabet (c |> Char.to_string) ~equal:(String.equal) in
    String.for_all tape ~f:(fun c -> char_in_str_lst c tape)


let next_state tape index transition =
    (* return new_tape to_state *)
    true

let run_machine machine tape =
    if check_tape tape machine.alphabet && check_machine machine then
        print_string (get_machine_string machine)
    else
        ()

