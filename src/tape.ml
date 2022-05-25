open Core
open Types

let write_to_tape index read write tape =
    String.substr_replace_first ~pos:index tape ~pattern:read ~with_:write

let longer_tape tape index blank =
    if index = String.length tape -1 then
        tape ^ blank
    else
        tape

let get_tape_string tape i blank =
    let min_len = 20 in
    let padding = if String.length tape <= min_len then
        min_len - String.length tape
    else
        0
    in
    let before_cursor = (if i = 0 then "" else String.slice tape 0 i) in
    let cursor = String.slice tape i (i + 1) in
    let after_cursor = String.slice tape (i + 1) 0 in
    sprintf "[%s<%s>%s%s]" before_cursor cursor after_cursor (String.make padding blank.[0])

let check_tape tape alphabet =
    String.for_all tape ~f:(fun c ->
        match c with
        | a when (List.mem alphabet (a |> Char.to_string) ~equal:(String.equal)) -> true
        | _  -> raise (Invalid_machine ("ft_turing: error: tape contains charaters not present in alphabet: " ^ Char.to_string c))
        )
