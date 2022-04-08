let read_source filename =
  let channel = open_in filename in
  let source = really_input_string channel (in_channel_length channel) in
  close_in channel;
  source

let main () =
  if
    Array.length Sys.argv <> 3
    || (Sys.argv.(1) <> "eager" && Sys.argv.(1) <> "lazy")
  then
    failwith
      ("Run MINIML as '" ^ Sys.argv.(0) ^ " eager <filename>.mml' or '"
     ^ Sys.argv.(0) ^ " lazy <filename>.mml' ")
  else
    let eager = Sys.argv.(1) = "eager" in
    let filename = Sys.argv.(2) in
    let source = read_source filename in
    let e = Parser.parse source in
    print_endline "MALI KORAKI:";
    if eager then Interpreter.small_step e else InterpreterLazy.small_step e;
    print_endline "VELIKI KORAKI:";
    if eager then Interpreter.big_step e else InterpreterLazy.big_step e

let _ = main ()
