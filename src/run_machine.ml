open Core
open Types
open Check_machine


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

let get_state machine state_name =
    match List.find machine.transitions ~f:(
            fun a -> String.equal a.name state_name
        )
        with
        | Some state -> state
        | None -> {name="";transitions=[]}

let get_transition (state : state) c =
    match List.find state.transitions ~f:(
        fun a -> String.equal a.read (c |> Char.to_string)
    )
    with
    | Some transition -> transition
    | None -> {read= "";to_state="";write="";action=""}

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


let rec loop_machine (tape, index, transition, machine) =
    if List.mem machine.finals transition.to_state ~equal:(String.equal) then
        ()
    else
        let (new_tape, new_index, new_transition) = next_state tape index transition.to_state machine in
        print_string (get_transition_string transition transition.to_state);
        print_string "\n";
        loop_machine (new_tape, new_index, new_transition, machine)

let check_tape tape alphabet =
    if not (String.for_all tape ~f:(fun c ->  List.mem alphabet (c |> Char.to_string) ~equal:(String.equal))) then
        raise (Invalid_machine "ft_turing: error: tape contains charathers not present in alphabet")
    else
        true

let run_machine machine tape =
    if check_tape tape machine.alphabet && check_machine machine then
        let transition = get_transition (get_state machine machine.initial) tape.[0] in
        print_string (get_machine_string machine);
        loop_machine (tape, 0, transition, machine)
    else
        ()

