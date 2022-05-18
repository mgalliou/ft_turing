open Core
open One_transition

class transitions name transition_list = object(self)

    val mutable name: string = name
    method name = name

    val mutable transition_list: one_transition list = transition_list
    method transition_list = transition_list
end
