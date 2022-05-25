open Core
open Types
open Get_args
open Read_json
open Run_machine


let print_error msg =
    eprintf "ft_turing: error: %s\n" msg

let main () =
    try
        let (machine_file, tape) = get_args () in
        let machine = read_json(Option.value machine_file ~default:"") in
        run_machine machine (Option.value tape ~default:"");
    with
    | Arg.Help e -> print_string e
    | Invalid_machine e -> print_error e
    | Invalid_machine_state (e, v) -> print_error (sprintf "%s : %s" e v)
    | Bad_instruction (msg, error) -> print_error (msg ^ error)
    | Invalid_json e -> print_error e

let () =
    main ();
