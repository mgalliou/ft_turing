open Core

class one_transition read to_state write action = object(self)

  val mutable read: string = read
  method read = read

  val mutable to_state: string = to_state
  method to_state = to_state

  val mutable write: string = write
  method write = write

  val mutable action: string = action
  method action = action

end
