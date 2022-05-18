open Core

let check_args (machine, tape) =
    if Option.is_none machine || Option.is_none tape then
        false
    else
        true

let get_args () =
    let usage_msg = "usage: ft_turing [-h] jsonfile input" in
    let input_strs = ref [] in
    let help = ref false in
    let speclist = [
        ("jsonfile", Arg.Set (ref false) , "\t\tjson description of the machine\n");
            ("input", Arg.Set (ref false), "\t\tinput of the machine\n");
            ("-h, --help", Arg.Set (ref false), "\t\tshow this help message and exit\n");
            ("-h", Arg.Set help, "");
            ("--help", Arg.Set help, "");
            ("-help", Arg.Set (ref false), "")
    ] in
    let anon_fun filename = input_strs := filename :: !input_strs in
    let () = Arg.parse speclist anon_fun usage_msg in
    (List.nth !input_strs 1, List.nth !input_strs 0)
