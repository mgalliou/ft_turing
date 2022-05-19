open Core

type transition = {
    read: string;
    to_state: string;
    write: string;
    action: string
}

type state = {
    name: string;
    transitions: transition list
}

type machine = {
    name : string;
    alphabet : string list;
    blank : string;
    states_names : string list;
    initial : string;
    finals : string list;
    transitions : state list
}

exception Invalid_machine of string
exception Invalid_machine_state of string * string

