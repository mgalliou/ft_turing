open OUnit2
open Types
open Run_machine

(*let machine = read_json "machine/test/test.json" in*)
let with_valid_params _ =
    let machine = {
        name = "test_machine";
        alphabet = ["1"; "."; "-"; "="];
        blank = ".";
        states_names = ["scanright"; "eraseone"; "subone"; "skip"; "HALT"];
        initial = "scanright";
        finals = ["HALT"];
        transitions = [{
            name = "scanright";
            transitions = [
                { read = "."; to_state = "scanright"; write = "."; action = "RIGHT"} ;
                { read = "1"; to_state = "scanright"; write = "1"; action = "RIGHT"};
                { read = "-"; to_state = "scanright"; write = "-"; action = "RIGHT"};
                { read = "="; to_state = "eraseone" ; write = "."; action = "LEFT" }
        ]};
        {
            name = "eraseone";
            transitions = [
                { read = "1"; to_state = "subone"; write = "="; action = "LEFT"};
                { read = "-"; to_state = "HALT" ; write = "."; action = "LEFT"}
            ]};
        {
            name = "subone";
            transitions = [
                { read = "1"; to_state = "subone"; write = "1"; action = "LEFT"};
                { read = "-"; to_state = "skip" ; write = "-"; action = "LEFT"}
            ]};
        {
            name = "skip";
            transitions = [
                { read = "."; to_state = "skip" ; write = "."; action = "LEFT"};
                { read = "1"; to_state = "scanright"; write = "."; action = "RIGHT"}
            ]}]} in
    assert_equal true (check_machine machine)

let with_blank_not_in_alphabet _ =
    let machine = {
        name = "test_machine";
        alphabet = ["1"; "."; "-"; "="];
        blank = "A";
        states_names = ["scanright"; "eraseone"; "subone"; "skip"; "HALT"];
        initial = "scanright";
        finals = ["HALT"];
        transitions = [{
            name = "scanrigh";
            transitions = [
                { read = "."; to_state = "scanright"; write = "."; action = "RIGHT"} ;
                { read = "."; to_state = "scanright"; write = "."; action = "RIGHT"};
                { read = "1"; to_state = "scanright"; write = "1"; action = "RIGHT"};
                { read = "-"; to_state = "scanright"; write = "-"; action = "RIGHT"};
                { read = "="; to_state = "eraseone" ; write = "."; action = "LEFT" }
        ]};
        {
            name = "eraseone";
            transitions = [
                { read = "1"; to_state = "subone"; write = "="; action = "LEFT"};
                { read = "-"; to_state = "HALT" ; write = "."; action = "LEFT"}
            ]};
        {
            name = "subone";
            transitions = [
                { read = "1"; to_state = "subone"; write = "1"; action = "LEFT"};
                { read = "-"; to_state = "skip" ; write = "-"; action = "LEFT"}
            ]};
        {
            name = "skip";
            transitions = [
                { read = "."; to_state = "skip" ; write = "."; action = "LEFT"};
                { read = "1"; to_state = "scanright"; write = "."; action = "RIGHT"}
            ]}]} in
    assert_raises (Invalid_machine err_blank_not_in_alphabet) (fun () -> check_machine machine)

let with_inital_not_in_states_names _ =
    let machine = {
        name = "test_machine";
        alphabet = ["1"; "."; "-"; "="];
        blank = ".";
        states_names = ["scanright"; "eraseone"; "subone"; "skip"; "HALT"];
        initial = "scanup";
        finals = ["HALT"];
        transitions = [{
            name = "scanrigh";
            transitions = [
                { read = "."; to_state = "scanright"; write = "."; action = "RIGHT"} ;
                { read = "."; to_state = "scanright"; write = "."; action = "RIGHT"};
                { read = "1"; to_state = "scanright"; write = "1"; action = "RIGHT"};
                { read = "-"; to_state = "scanright"; write = "-"; action = "RIGHT"};
                { read = "="; to_state = "eraseone" ; write = "."; action = "LEFT" }
        ]};
        {
            name = "eraseone";
            transitions = [
                { read = "1"; to_state = "subone"; write = "="; action = "LEFT"};
                { read = "-"; to_state = "HALT" ; write = "."; action = "LEFT"}
            ]};
        {
            name = "subone";
            transitions = [
                { read = "1"; to_state = "subone"; write = "1"; action = "LEFT"};
                { read = "-"; to_state = "skip" ; write = "-"; action = "LEFT"}
            ]};
        {
            name = "skip";
            transitions = [
                { read = "."; to_state = "skip" ; write = "."; action = "LEFT"};
                { read = "1"; to_state = "scanright"; write = "."; action = "RIGHT"}
            ]}]} in
    assert_raises (Invalid_machine err_initial_state_not_in_states) (fun () -> check_machine machine)

let with_finals_not_in_states_names _ =
    let machine = {
        name = "test_machine";
        alphabet = ["1"; "."; "-"; "="];
        blank = ".";
        states_names = ["scanright"; "eraseone"; "subone"; "skip"; "HALT"];
        initial = "scanright";
        finals = ["STOP"];
        transitions = [{
            name = "scanrigh";
            transitions = [
                { read = "."; to_state = "scanright"; write = "."; action = "RIGHT"} ;
                { read = "."; to_state = "scanright"; write = "."; action = "RIGHT"};
                { read = "1"; to_state = "scanright"; write = "1"; action = "RIGHT"};
                { read = "-"; to_state = "scanright"; write = "-"; action = "RIGHT"};
                { read = "="; to_state = "eraseone" ; write = "."; action = "LEFT" }
        ]};
        {
            name = "eraseone";
            transitions = [
                { read = "1"; to_state = "subone"; write = "="; action = "LEFT"};
                { read = "-"; to_state = "HALT" ; write = "."; action = "LEFT"}
            ]};
        {
            name = "subone";
            transitions = [
                { read = "1"; to_state = "subone"; write = "1"; action = "LEFT"};
                { read = "-"; to_state = "skip" ; write = "-"; action = "LEFT"}
            ]};
        {
            name = "skip";
            transitions = [
                { read = "."; to_state = "skip" ; write = "."; action = "LEFT"};
                { read = "1"; to_state = "scanright"; write = "."; action = "RIGHT"}
            ]}]} in
    assert_raises (Invalid_machine err_finals_state_not_in_states) (fun () -> check_machine machine)

let with_transition_state_name_not_in_state_name _ =
    let machine = {
        name = "test_machine";
        alphabet = ["1"; "."; "-"; "="];
        blank = ".";
        states_names = ["scanright"; "eraseone"; "subone"; "skip"; "HALT"];
        initial = "scanright";
        finals = ["HALT"];
        transitions = [{
            name = "scanrigh";
            transitions = [
                { read = "."; to_state = "scanright"; write = "."; action = "RIGHT"} ;
                { read = "."; to_state = "scanright"; write = "."; action = "RIGHT"};
                { read = "1"; to_state = "scanright"; write = "1"; action = "RIGHT"};
                { read = "-"; to_state = "scanright"; write = "-"; action = "RIGHT"};
                { read = "="; to_state = "eraseone" ; write = "."; action = "LEFT" }
        ]};
        {
            name = "eraseone";
            transitions = [
                { read = "1"; to_state = "subone"; write = "="; action = "LEFT"};
                { read = "-"; to_state = "HALT" ; write = "."; action = "LEFT"}
            ]};
        {
            name = "scanup";
            transitions = [
                { read = "1"; to_state = "subone"; write = "1"; action = "LEFT"};
                { read = "-"; to_state = "skip" ; write = "-"; action = "LEFT"}
            ]};
        {
            name = "skip";
            transitions = [
                { read = "."; to_state = "skip" ; write = "."; action = "LEFT"};
                { read = "1"; to_state = "scanright"; write = "."; action = "RIGHT"}
            ]}]} in
    assert_raises (Invalid_machine err_state_name_not_in_states) (fun () -> check_machine machine)

let with_duplicate_read _ =
    let machine = {
        name = "test_machine";
        alphabet = ["1"; "."; "-"; "="];
        blank = ".";
        states_names = ["scanright"; "eraseone"; "subone"; "skip"; "HALT"];
        initial = "scanright";
        finals = ["HALT"];
        transitions = [{
            name = "scanright";
            transitions = [
                { read = "."; to_state = "scanright"; write = "."; action = "RIGHT"} ;
                { read = "1"; to_state = "scanright"; write = "1"; action = "RIGHT"};
                { read = "-"; to_state = "scanright"; write = "-"; action = "RIGHT"};
                { read = "="; to_state = "eraseone" ; write = "."; action = "LEFT" };
                { read = "1"; to_state = "scanright"; write = "1"; action = "RIGHT"}
        ]};
        {
            name = "eraseone";
            transitions = [
                { read = "1"; to_state = "subone"; write = "="; action = "LEFT"};
                { read = "-"; to_state = "HALT" ; write = "."; action = "LEFT"}
            ]};
        {
            name = "subone";
            transitions = [
                { read = "1"; to_state = "subone"; write = "1"; action = "LEFT"};
                { read = "-"; to_state = "skip" ; write = "-"; action = "LEFT"}
            ]};
        {
            name = "skip";
            transitions = [
                { read = "."; to_state = "skip" ; write = "."; action = "LEFT"};
                { read = "1"; to_state = "scanright"; write = "."; action = "RIGHT"}
            ]}]} in
    assert_raises (Invalid_machine_state (err_read_duplicate, "scanright")) (fun () -> check_machine machine)

let with_read_not_in_alphabet _ =
    let machine = {
        name = "test_machine";
        alphabet = ["1"; "."; "-"; "="];
        blank = ".";
        states_names = ["scanright"; "eraseone"; "subone"; "skip"; "HALT"];
        initial = "scanright";
        finals = ["HALT"];
        transitions = [{
            name = "scanright";
            transitions = [
                { read = "."; to_state = "scanright"; write = "."; action = "RIGHT"} ;
                { read = "1"; to_state = "scanright"; write = "1"; action = "RIGHT"};
                { read = "-"; to_state = "scanright"; write = "-"; action = "RIGHT"};
                { read = "="; to_state = "eraseone" ; write = "."; action = "LEFT" }
        ]};
        {
            name = "eraseone";
            transitions = [
                { read = "1"; to_state = "subone"; write = "="; action = "LEFT"};
                { read = "-"; to_state = "HALT" ; write = "."; action = "LEFT"}
            ]};
        {
            name = "subone";
            transitions = [
                { read = "A"; to_state = "subone"; write = "1"; action = "LEFT"};
                { read = "-"; to_state = "skip" ; write = "-"; action = "LEFT"}
            ]};
        {
            name = "skip";
            transitions = [
                { read = "."; to_state = "skip" ; write = "."; action = "LEFT"};
                { read = "1"; to_state = "scanright"; write = "."; action = "RIGHT"}
            ]}]} in
    assert_raises (Invalid_machine_state (err_read_not_in_alphabet, "A")) (fun () -> check_machine machine)

let with_to_state_not_in_state_name _ =
    let machine = {
        name = "test_machine";
        alphabet = ["1"; "."; "-"; "="];
        blank = ".";
        states_names = ["scanright"; "eraseone"; "subone"; "skip"; "HALT"];
        initial = "scanright";
        finals = ["HALT"];
        transitions = [{
            name = "scanright";
            transitions = [
                { read = "."; to_state = "scanright"; write = "."; action = "RIGHT"} ;
                { read = "1"; to_state = "scanright"; write = "1"; action = "RIGHT"};
                { read = "-"; to_state = "scanright"; write = "-"; action = "RIGHT"};
                { read = "="; to_state = "eraseone" ; write = "."; action = "LEFT" }
        ]};
        {
            name = "eraseone";
            transitions = [
                { read = "1"; to_state = "subone"; write = "="; action = "LEFT"};
                { read = "-"; to_state = "HALT" ; write = "."; action = "LEFT"}
            ]};
        {
            name = "subone";
            transitions = [
                { read = "1"; to_state = "subone"; write = "1"; action = "LEFT"};
                { read = "-"; to_state = "skip" ; write = "-"; action = "LEFT"}
            ]};
        {
            name = "skip";
            transitions = [
                { read = "."; to_state = "skip" ; write = "."; action = "LEFT"};
                { read = "1"; to_state = "scanup"; write = "."; action = "RIGHT"}
            ]}]} in
    assert_raises (Invalid_machine_state (err_to_state_not_in_alphabet, "scanup")) (fun () -> check_machine machine)

let with_write_not_in_alphabet _ =
    let machine = {
        name = "test_machine";
        alphabet = ["1"; "."; "-"; "="];
        blank = ".";
        states_names = ["scanright"; "eraseone"; "subone"; "skip"; "HALT"];
        initial = "scanright";
        finals = ["HALT"];
        transitions = [{
            name = "scanright";
            transitions = [
                { read = "."; to_state = "scanright"; write = "."; action = "RIGHT"} ;
                { read = "1"; to_state = "scanright"; write = "1"; action = "RIGHT"};
                { read = "-"; to_state = "scanright"; write = "-"; action = "RIGHT"};
                { read = "="; to_state = "eraseone" ; write = "."; action = "LEFT" }
        ]};
        {
            name = "eraseone";
            transitions = [
                { read = "1"; to_state = "subone"; write = "="; action = "LEFT"};
                { read = "-"; to_state = "HALT" ; write = "."; action = "LEFT"}
            ]};
        {
            name = "subone";
            transitions = [
                { read = "1"; to_state = "subone"; write = "A"; action = "LEFT"};
                { read = "-"; to_state = "skip" ; write = "-"; action = "LEFT"}
            ]};
        {
            name = "skip";
            transitions = [
                { read = "."; to_state = "skip" ; write = "."; action = "LEFT"};
                { read = "1"; to_state = "scanright"; write = "."; action = "RIGHT"}
            ]}]} in
    assert_raises (Invalid_machine_state (err_write_not_in_alphabet, "A")) (fun () -> check_machine machine)

let with_action_not_left_or_right _ =
    let machine = {
        name = "test_machine";
        alphabet = ["1"; "."; "-"; "="];
        blank = ".";
        states_names = ["scanright"; "eraseone"; "subone"; "skip"; "HALT"];
        initial = "scanright";
        finals = ["HALT"];
        transitions = [{
            name = "scanright";
            transitions = [
                { read = "."; to_state = "scanright"; write = "."; action = "RIGHT"} ;
                { read = "1"; to_state = "scanright"; write = "1"; action = "RIGHT"};
                { read = "-"; to_state = "scanright"; write = "-"; action = "UP"};
                { read = "="; to_state = "eraseone" ; write = "."; action = "LEFT" }
        ]};
        {
            name = "eraseone";
            transitions = [
                { read = "1"; to_state = "subone"; write = "="; action = "LEFT"};
                { read = "-"; to_state = "HALT" ; write = "."; action = "LEFT"}
            ]};
        {
            name = "subone";
            transitions = [
                { read = "1"; to_state = "subone"; write = "1"; action = "LEFT"};
                { read = "-"; to_state = "skip" ; write = "-"; action = "LEFT"}
            ]};
        {
            name = "skip";
            transitions = [
                { read = "."; to_state = "skip" ; write = "."; action = "LEFT"};
                { read = "1"; to_state = "scanright"; write = "."; action = "RIGHT"}
            ]}]} in
    assert_raises (Invalid_machine_state (err_action_not_left_or_right, "UP")) (fun () -> check_machine machine)

let check_machine_suite =
    "check_machine_suite" >::: [
        "with_valid_params" >:: with_valid_params;
        "with_blank_not_in_alphabet" >:: with_blank_not_in_alphabet;
        "with_inital_not_in_states_names" >:: with_inital_not_in_states_names;
        "with_finals_not_in_states_names" >:: with_finals_not_in_states_names;
        "with_transition_state_name_not_in_state_name" >:: with_transition_state_name_not_in_state_name;
        "with_duplicate_read" >:: with_duplicate_read;
        "with_read_not_in_alphabet" >:: with_read_not_in_alphabet;
        "with_to_state_not_in_state_name" >:: with_to_state_not_in_state_name;
        "with_write_not_in_alphabet" >:: with_write_not_in_alphabet;
        "with_action_not_left_or_right" >:: with_action_not_left_or_right;
    ]
