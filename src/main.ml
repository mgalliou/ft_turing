(*let () = Print_help.print_help ();;
*)
let usage_msg = "ft_turing [--help] jsonfile input"
let help = ref false
let jsonfile = ref ""
let input = ref ""
let input_strings = ref []
let speclist = 
    [
        ("--help", Arg.Set help, "\t\tshow this help message and exit\n");
        ("jsonfile", Arg.Set_string jsonfile, "\t\tjson description of the machine\n");
        ("input", Arg.Set_string input, "\t\tinput of the machine\n");
    ]
let anon_fun filename = input_strings := filename :: !input_strings
let () = Arg.parse speclist anon_fun usage_msg;;
if !help == false && List.length !input_strings < 2 then
    print_string (Arg.usage_string speclist usage_msg)
;;
(*
!jsonfile = List.nth !input_strings 0
!input = List.nth !input_strings 1
print_string !jsonfile;;
print_string !input;;
*)

