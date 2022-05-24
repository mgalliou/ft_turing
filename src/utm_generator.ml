open Core
open Types

let blank = "."
let state_initial = "init"
let state_halt = "HALT"

let action_left = "LEFT"
let action_right = "RIGHT"

let sub_alphabet = ["1"; "+"; "."]
let sub_states = ["%"; "x"; "#"]

let i_name = "N"
let i_alphabet = "A"
let i_blank = "B"
let i_states = "S"
let i_initial = "I"
let i_finals = "F"
let i_transitions = "T"
let i_read = "r"
let i_to_state = "t"
let i_write = "w"
let i_action = "a"
let i_left = "L"
let i_right = "R"
let i_cursor = "C"
let i_separator = ";"
let tape_delimitor = "_"

let alphabet =
    [i_name; i_alphabet; i_blank; i_states; i_initial; i_finals;
    i_transitions; i_read; i_to_state; i_write; i_action; i_left; i_right; i_cursor;
    i_separator; tape_delimitor] |> List.append sub_alphabet |> List.append sub_states

let new_transition read to_state write action =
{
    read = read;
    to_state = to_state;
    write = write;
    action = action
}

let gen_state_go_to_states name target to_state find_action skip_action =
    {
        name = name;
        transitions = List.map alphabet ~f:(fun c -> 
            match c with
            | c when c |> String.(=) target -> new_transition target to_state target find_action
            | _ -> new_transition c name c skip_action
        )
    }

let gen_states_skip_state_def =
    List.map (List.cartesian_product alphabet sub_states) ~f:(fun (c,s) -> 
            let name = "skip_state_def_" ^ s ^ "_" ^ c in
            let to_state = ("check_transition_" ^ s ^ "_" ^ c ) in
                gen_state_go_to_states name i_separator to_state action_right action_right
            )

let gen_states_check_transition =
    List.map (List.cartesian_product alphabet sub_states) ~f:(fun (c,s) -> 
            let name = "check_transition_" ^ s ^ "_" ^ c in
            {
                name = name;
                transitions = List.map alphabet ~f:(fun a ->
                    match a with
                    | a when a |> String.(=) s -> new_transition a ("get_read_" ^ s ^ "_" ^ c) a action_right
                    | _ -> new_transition a ("skip_state_def_" ^ s ^ "_" ^ c) a action_right
                )
            }
        )

let gen_states_check_finals =
    List.map (List.cartesian_product alphabet sub_states) ~f:(fun (c,s) -> 
            let name = "check_finals_" ^ s ^ "_" ^ c in
            let to_state = ("check_transition_" ^ s ^ "_" ^ c ) in
            {
                name = name; 
                transitions = List.map alphabet ~f:(fun d ->
                    match d with
                    | d when d |> String.equal i_transitions -> new_transition d to_state d action_right
                    | d when d |> String.equal s             -> new_transition d state_halt d action_right
                    | _ -> new_transition d name d action_right
                )
            }
        )

let gen_states_go_to_finales =
    List.map (List.cartesian_product alphabet sub_states) ~f:(fun (c,s) -> 
            let name = "go_to_finals_" ^ s ^ "_" ^ c in
            let to_state = ("check_finals_" ^ s ^ "_" ^ c ) in
                gen_state_go_to_states name i_finals to_state action_right action_left
            )
let gen_states_go_to_cursor =
    let all_pairs = List.cartesian_product sub_states alphabet in
    let all_triplet = List.cartesian_product all_pairs [i_right; i_left] in
    List.map all_triplet ~f:(fun ((s,  c), a) ->
        let name = "go_to_cursor_" ^ s ^ "_" ^ c ^ "_" ^ a in
        {
           name = name;
           transitions = List.map alphabet ~f:(fun d ->
               match d with
               | "C" -> new_transition d ("set_cursor_" ^ s) c (if String.equal a i_right then action_right else action_left)
               | _ -> new_transition d name d action_right
               )
        })

let gen_states_get_to_action =
    let all_pairs = List.cartesian_product sub_states alphabet in
    List.map all_pairs ~f:(fun (s, c) ->
        {
           name = "get_to_action_" ^ s ^ "_" ^ c;
           transitions = List.map [i_left; i_right] ~f:(fun action ->
                new_transition action ("go_to_cursor_" ^ s ^ "_" ^ c ^ "_" ^ action) action action_right
               )
        })

let gen_states_go_to_action =
    let all_pairs = List.cartesian_product sub_states alphabet in
    List.map all_pairs ~f:(fun (s, c) ->
        {
           name = "go_to_action_" ^ s ^ "_" ^ c;
           transitions = [new_transition "a" ("get_to_action_" ^ s ^ "_" ^ c ) "a" action_right]
        })

let gen_states_get_to_write =
    List.map sub_states ~f:(fun s ->
        {
           name = "get_to_write_" ^ s;
           transitions = List.map alphabet ~f:(fun c->
               new_transition c ("go_to_action_" ^ s ^ "_" ^ c ) c action_right
           )}
    )

let gen_states_go_to_write =
    List.map sub_states ~f:(fun s ->
        {
           name = "go_to_write_" ^ s;
           transitions = [new_transition "w" ("get_to_write_" ^ s) "w" action_right]
        })

let gen_states_get_to_state=
        {
           name = "get_to_state";
           transitions = List.map sub_states ~f:(fun s->
               new_transition s ("go_to_write_" ^ s) s action_right
           )}

let gen_states_go_to_state =
    let all_pairs = List.cartesian_product sub_states alphabet in
    List.map all_pairs ~f:(fun (s, c) ->
        {
           name = "go_to_state_" ^ s ^ "_" ^ c;
           transitions = [new_transition "t" ("get_to_state") "t" action_right]
        })

let gen_states_check_read =
    let all_pairs = List.cartesian_product sub_states alphabet in
    List.map all_pairs ~f:(fun (s, c) ->
        {
           name = "check_read_" ^ s ^ "_" ^ c;
           transitions = List.map alphabet ~f:(fun a ->
               match a with
               | a when String.equal a c -> new_transition c ("go_to_state_" ^ s ^ "_" ^ c) c action_right
               | _ -> new_transition a ("get_read_" ^ s ^ "_" ^ c) a action_right
           )
        })

let gen_states_get_read =
    let all_pairs = List.cartesian_product sub_states alphabet in
    List.map all_pairs ~f:(fun (s, c) ->
        {
           name = "get_read_" ^ s ^ "_" ^ c;
           transitions = List.map alphabet ~f:(fun a ->
               match a with
               | "r" -> new_transition a ("check_read_" ^ s ^ "_" ^ c) a action_right
               | _ -> new_transition a ("get_read_" ^ s ^ "_" ^ c) a action_right
           )
        })

let gen_states_set_cursor =
    List.map sub_states ~f:(fun s ->
        {
           name = "set_cursor_" ^ s;
           transitions = List.map alphabet ~f:(fun c ->
               new_transition c ("go_to_finals_" ^ s ^ "_" ^ c) i_cursor action_left
               )
        })

let gen_states_go_to_tape =
    List.map sub_states ~f:(fun s ->
        gen_state_go_to_states ("go_to_tape_" ^ s) tape_delimitor ("set_cursor_" ^ s) action_right action_right
    )


let gen_state_get_first_state =
    {
        name = "get_first_state";
        transitions = List.map sub_states ~f:(fun c -> 
            new_transition c ("go_to_tape_" ^ c) c action_right
        )
    }


let gen_states =
    [gen_state_go_to_states state_initial i_initial "get_first_state" action_right action_right]
    @[gen_state_get_first_state]
    @gen_states_go_to_tape
    @gen_states_set_cursor
    @gen_states_go_to_finales
    @gen_states_check_finals
    @gen_states_check_transition
    @gen_states_skip_state_def
    @gen_states_go_to_cursor
    @gen_states_get_to_action
    @gen_states_go_to_action
    @gen_states_get_to_write
    @gen_states_go_to_write
    @[gen_states_get_to_state]
    @gen_states_go_to_state
    @gen_states_check_read
    @gen_states_get_read

let generate_utm () =
    let transitions = gen_states in
    let states_names = List.map transitions ~f:(fun state ->
        state.name)
    in
    let machine = {
        name = "utm";
        alphabet = alphabet;
        blank = blank;
        states_names = states_names@[ state_halt];
        initial = state_initial;
        finals = [state_halt];
        transitions = transitions
    } in
    machine


