open OUnit2
open Suite_check_args
open Suite_check_machine
open Suite_read_json

let () =
    run_test_tt_main
    ("ft_turing" >:::
        [
            Suite_check_args.tests;
            Suite_check_machine.tests;
            Suite_read_json.tests

  ])
