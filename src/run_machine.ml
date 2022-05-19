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

let err_blank_not_in_alphabet = "\"blank\" not in \"alphabet\""
let err_initial_state_not_in_states = "\"inital\" state not in \"states\""
let err_finals_state_not_in_states = "\"finals\" state not in \"states\""
let err_state_name_not_in_states = "\"state.name\" not in \"states\""
let err_read_not_in_alphabet = "\"read\" not in \"alphabet\""
let err_to_state_not_in_alphabet = "\"to_state\" not in \"alphabet\""
let err_write_not_in_alphabet = "\"to_state\" not in \"alphabet\""
let err_action_not_left_or_right = "\"to_state\" not in \"alphabet\""

let check_machine machine =
    (*check "blank" is in alphabet*)
    if not (List.mem machine.alphabet machine.blank ~equal:(String.equal)) then
        raise (Invalid_machine err_blank_not_in_alphabet)
    (*check "initial" is in states*)
    else if not (List.mem machine.states_names machine.initial ~equal:(String.equal)) then
        raise (Invalid_machine err_initial_state_not_in_states)
    (*check "finals" are in states*)
    else if not (List.for_all machine.finals ~f:(
        fun s -> List.mem machine.states_names s  ~equal:(String.equal))) then
            raise (Invalid_machine err_finals_state_not_in_states)
    (*check transitions.states are in "states"*)
    else List.for_all machine.transitions ~f:(
        fun state -> if not (List.mem machine.states_names state.name ~equal:(String.equal)) then
            raise (Invalid_machine err_state_name_not_in_states)
        else List.for_all state.transitions ~f:(
            (*check transitions.states.transition.read is in "alphabet"*)
            fun trans -> if not (List.mem machine.alphabet trans.read ~equal:(String.equal)) then
                raise (Invalid_machine_state (err_read_not_in_alphabet, trans.read))
                (*check transitions.states.transition.to_state is in "states"*)
            else if not (List.mem machine.states_names trans.to_state ~equal:(String.equal)) then
                raise (Invalid_machine_state (err_to_state_not_in_alphabet,trans.to_state))
            (*check transitions.states.transition.write is in "alphabet"*)
            else if not (List.mem machine.alphabet trans.write ~equal:(String.equal)) then
                raise (Invalid_machine_state (err_write_not_in_alphabet, trans.write))
                (*check transitions.states.transition.action is "LEFT" or "RIGHT"*)
            else if not (List.mem ["LEFT"; "RIGHT"] trans.action ~equal:(String.equal)) then
                raise (Invalid_machine_state (err_action_not_left_or_right, trans.action))
        else
            true
        )
    )

let check_tape tape alphabet =
    String.for_all tape ~f:(
        fun c ->  List.mem alphabet (c |> Char.to_string) ~equal:(String.equal)
        )


(*let next_state tape index (state : state) =
    let get_transition = List.find state.transitions ~f:(
            fun a -> String.equal a.read (tape.[index] |> Char.to_string)
        ) in
    if is_none get_transition then
        ("" "" 0)
    else
        let transition = Option.value get_transition in
        let new_tape = String.mapi tape ~f:(
            fun i c -> if i = index then
                transition.write.[0]
    else
        c
        ) in
            let new_index =
                if transition.action ="RIGHT" then
                    index + 1
                else
                    index -1
            in
    (new_tape transition.to_state new_index)
*)

let run_machine machine tape =
    if check_tape tape machine.alphabet && check_machine machine then
        print_string (get_machine_string machine)
    else
        ()

