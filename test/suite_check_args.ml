open OUnit2
open Get_args

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

let tests =
  "suite_check_args" >::: [
    "with_no_args" >:: with_no_args;
    "with_only_machine_file" >:: with_only_machine_file;
    "with_only_input_file " >:: with_only_input_file;
    "with_both_args" >:: with_both_args;
  ]
