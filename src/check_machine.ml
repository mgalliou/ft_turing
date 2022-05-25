open Core
open Types


let err_blank_not_in_alphabet = "\"blank\" not in \"alphabet\""
let err_initial_state_not_in_states = "\"inital\" state not in \"states\""
let err_finals_state_not_in_states = "\"finals\" state not in \"states\""
let err_state_name_not_in_states = "\"state.name\" not in \"states\""
let err_state_duplicate = "duplicate \"state\" in \"transitions\""
let err_read_duplicate = "duplicate \"read\" in \"state\""
let err_read_not_in_alphabet = "\"read\" not in \"alphabet\""
let err_to_state_not_in_alphabet = "\"to_state\" not in \"states\""
let err_write_not_in_alphabet = "\"write\" not in \"alphabet\""
let err_action_not_left_or_right = "\"action\" not \"LEFT\" or \"RIGHT\""

let check_state (state : state) machine =
    if 1 < List.count machine.transitions ~f:(fun t -> String.equal state.name t.name) then
        raise (Invalid_machine_state (err_state_duplicate, state.name))
    else if not (List.mem machine.states_names state.name ~equal:(String.equal)) then
        raise (Invalid_machine err_state_name_not_in_states)
    else List.for_all state.transitions ~f:(fun trans -> 
        (*check transitions.states.transition.read is in "alphabet"*)
        if 1 < List.count state.transitions ~f:(fun t -> String.equal t.read trans.read) then
            raise (Invalid_machine_state (err_read_duplicate, state.name))
        else if not (List.mem machine.alphabet trans.read ~equal:(String.equal)) then
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
            true)

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
    else List.for_all machine.transitions ~f:(fun state -> check_state state machine)


