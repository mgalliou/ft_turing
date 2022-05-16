open OUnit2
open Main

let test_when_all_arguments_with_no_args _ =
    let (machine , tape, help) = get_arguments() in
    assert_equal Option.none machine;
    assert_equal Option.none input;
    assert_equal true help
    

let suite =
  "get_arguements" >::: [
    "test_when_all_arguments_without_options" >:: test_when_all_arguments_without_options;
  ]

let () = 
    run_test_tt_main suite

