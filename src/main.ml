(*parse arguments *)
let get_arguments () =
    let usage_msg = "usage: ft_turing [-h] jsonfile input" in
    let help = ref false in
    let jsonfile = ref "" in
    let input = ref "" in
    let input_strings = ref [] in
    let speclist = 
        [
            ("jsonfile", Arg.Set_string jsonfile, "\t\tjson description of the machine\n");
        ("input", Arg.Set_string input, "\t\tinput of the machine\n");
        ("-h, --help", Arg.Set (ref false), "\t\tshow this help message and exit\n");
        ("-h", Arg.Set help, "");
        ("--help", Arg.Set help, "");
        ("-help", Arg.Set (ref false), "");
    ] in
    let anon_fun filename = input_strings := filename :: !input_strings in
    let () = Arg.parse speclist anon_fun usage_msg in
    if !help == true || !help == false && List.length !input_strings < 2 then
        (print_string (Arg.usage_string speclist usage_msg);
        (None, None, help))
    else
        Option.some(List.nth !input_strings 1), Option.some(List.nth !input_strings 0), help
;;

let (machine, tape, help) = get_arguments()

(*
!jsonfile = List.nth !input_strings 0
!input = List.nth !input_strings 1
print_string !jsonfile;;
print_string !input;;
*)

