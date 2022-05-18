(*parse arguments *)
open Read_json
open Transitions
open One_transition
open Run_machine
open Get_args
(*let run_machine(machine, tape)*)

let main () =
    let (machine_file, tape) = get_args () in
    let valid_arg = check_args(machine_file, tape) in
    let machine = read_json (Option.get machine_file) in
    run_machine machine tape;
    ()

let () =
    main ();
