open OUnit2
open Suite_check_machine
open Types
open Get_args
open Run_machine
open Read_json

let with_no_args _ =
    let valid = check_args(None, None) in 
    assert_equal valid false
    
let with_only_machine_file _ =
    let valid = check_args(Option.some "machine", None) in
    assert_equal valid false

let with_only_input_file _ =
    let valid = check_args(None, Option.some "input") in
    assert_equal valid false

let with_both_args _ =
    let valid = check_args(Option.some "machine", Option.some "input") in
    assert_equal valid true

let check_args_suite =
  "check_args_suite" >::: [
    "with_no_args" >:: with_no_args;
    "with_only_machine_file" >:: with_only_machine_file;
    "with_only_input_file " >:: with_only_input_file;
    "with_both_args" >:: with_both_args;
  ]


let () = 
    run_test_tt_main check_args_suite;
    run_test_tt_main check_machine_suite

