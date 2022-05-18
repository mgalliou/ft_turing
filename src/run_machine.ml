open Read_json

let get_machine_string machine =
    let machine_string =
        "name: " ^ machine.name
        ^ "\nalphabet: " ^ "[ " ^ String.concat ", " machine.alphabet ^ " ]" in
    machine_string

let check_tape tape alphabet =
    true

let next_state tape index transition =
    (* return new_tape to_state *)
    true

let run_machine machine tape =
    print_string (get_machine_string machine);
    check_tape tape machine.alphabet;
    true
