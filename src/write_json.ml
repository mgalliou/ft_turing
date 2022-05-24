open Core
open Yojson
open Types
open Utm_generator

let create_json machine =
    let build_transition transition =
        let open Yojson.Basic.Util in
        `Assoc [
            ("read", `String transition.read);
            ("to_state", `String transition.to_state);
            ("write", `String transition.write);
            ("action", `String transition.action);
        ]
    in

    let build_state (state : state) =
        let open Yojson.Basic.Util in
        (state.name, `List (List.map state.transitions ~f:build_transition))
    in

    let json_output =
        let open Yojson.Basic.Util in
  `Assoc
    [
      ("name", `String machine.name);
      ("alphabet", `List (List.map machine.alphabet ~f:(fun a-> `String a)));
      ("blank", `String machine.blank);
      ( "states", `List (List.map machine.states_names ~f:(fun a-> `String a)));
      ("initial", `String machine.initial);
      ("finals", `List (List.map machine.finals ~f:(fun a-> `String a)));
      ("transitions", `Assoc (List.map machine.transitions ~f:build_state))
    ]
    in
    json_output

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
    if !help then
        raise (Arg.Help (Arg.usage_string speclist usage_msg));
    List.nth !input_strs 0

let main () =
        (*let valid_arg = check_args(machine_file, tape) in*)
        let machine = generate_utm () in
        let json = create_json machine in
        let oc = stdout in
        Yojson.Basic.pretty_to_channel oc json;
        output_string oc "\n"

let () =
    main ();
