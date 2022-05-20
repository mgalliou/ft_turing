open Core
open Types
open Get_args
open Read_json
open Run_machine


let main () =
    try
        let (machine_file, tape) = get_args () in
        (*let valid_arg = check_args(machine_file, tape) in*)
        let machine = get_json(Option.value machine_file ~default:"") in
        run_machine machine (Option.value tape ~default:"");
    with
    | Arg.Help e -> print_endline e 
    | Invalid_machine e -> print_endline e
    | Invalid_machine_state (e, v) -> printf "%s : %s" e v

let () =
    main ();
