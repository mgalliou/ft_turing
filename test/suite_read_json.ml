open OUnit2
open Types
open Read_json

let with_valid_json _ =
    let file_name = "machine/test/test.json" in
    let _ = read_json file_name in
    assert_equal true true

let with_no_field_name _ =
    let file_name = "machine/test/no_name.json" in
    assert_raises (Invalid_json (err_invalid_field_in_json ^ " for " ^ "name")) (fun () -> read_json file_name)

let with_no_field_alphabet _ =
    let file_name = "machine/test/no_alphabet.json" in
    assert_raises (Invalid_json (err_invalid_field_in_json ^ " for " ^ "alphabet")) (fun () -> read_json file_name)

let with_no_field_blank _ =
    let file_name = "machine/test/no_blank.json" in
    assert_raises (Invalid_json (err_invalid_field_in_json ^ " for " ^ "blank")) (fun () -> read_json file_name)

let with_no_field_states _ =
    let file_name = "machine/test/no_states.json" in
    assert_raises (Invalid_json (err_invalid_field_in_json ^ " for " ^ "states")) (fun () -> read_json file_name)

let with_no_field_transitions _ =
    let file_name = "machine/test/no_transitions.json" in
    assert_raises (Invalid_json (err_invalid_field_in_json ^ " for " ^ "transitions")) (fun () -> read_json file_name)

let with_no_field_finals _ =
    let file_name = "machine/test/no_finals.json" in
    assert_raises (Invalid_json (err_invalid_field_in_json ^ " for " ^ "finals")) (fun () -> read_json file_name)

let with_no_field_initial _ =
    let file_name = "machine/test/no_initial.json" in
    assert_raises (Invalid_json (err_invalid_field_in_json ^ " for " ^ "initial")) (fun () -> read_json file_name)

let with_bad_formating _ =
    let file_name = "machine/test/bad_formating.json" in
    assert_raises (Invalid_json "Line 28, bytes -1-0:\nUnexpected end of input") (fun () -> read_json file_name)

let tests =
    "suite_read_json" >::: [
        "with_valid_json" >:: with_valid_json;
        "with_no_field_finals" >:: with_no_field_finals;
        "with_no_field_initial" >:: with_no_field_initial;
        "with_no_field_name" >:: with_no_field_name;
        "with_no_field_alphabet" >:: with_no_field_alphabet;
        "with_no_field_blank" >:: with_no_field_blank;
        "with_no_field_states" >:: with_no_field_states;
        "with_no_field_transitions" >:: with_no_field_transitions;
        "with_bad_formating" >:: with_bad_formating;
    ]
