(*parse arguments *)
open Read_json
open Transitions
open One_transition
open Get_args
(*let run_machine(machine, tape)*)

let main () =
    let (machine, tape) = get_args () in
    let valid_arg = check_args(machine, tape) in
    let (name, alphabet, blank, states, initial, finals, transitions) = read_json (Option.get machine) in
    Base.List.iter transitions ~f:(fun one -> Base.List.iter one#transition_list ~f:(fun two -> Core.printf "%s" two#read))

let () =
    main ();
