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

let main () =
        (*let valid_arg = check_args(machine_file, tape) in*)
        let machine = generate_utm () in
        let json = create_json machine in
        let oc = stdout in
        Yojson.Basic.pretty_to_channel oc json;
        output_string oc "\n"

let () =
    main ();
