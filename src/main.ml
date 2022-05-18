(*parse arguments *)
open Core
open Types
open Read_json
open Run_machine
open Get_args
(*let run_machine(machine, tape)*)

let main () =
    let (machine_file, tape) = get_args () in
    let valid_arg = check_args(machine_file, tape) in
    let machine = read_json (Option.value machine_file ~default:"") in
    run_machine machine (Option.value tape ~default:"");
    ()

let () =
    main ();
