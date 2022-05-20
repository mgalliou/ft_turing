open OUnit2
open Types
open Read_json

let compare_machine one two =
    if (one.name = two.name &&
    List.equal String.equal one.alphabet two.alphabet &&
    one.blank = two.blank
    ) then
        true
    else
        false
let with_valid_json _ =
    let file_name = "machine/test/test.json" in
    read_json file_name;
    assert_equal true true

let tests =
    "suite_read_json" >::: [
        "with_valid_json" >:: with_valid_json;
    ]
