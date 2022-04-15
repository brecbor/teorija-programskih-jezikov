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
    let ty, eqs = Typechecker.infer_exp [] e in
    print_string "NESUBSTITUIRANI TIP:";
    print_endline (Syntax.string_of_ty ty);
    print_endline "ENAČBE:";
    List.iter
      (fun (ty1, ty2) ->
        print_endline
          ("- " ^ Syntax.string_of_ty ty1 ^ " = " ^ Syntax.string_of_ty ty2))
      eqs;
    let subst = Typechecker.unify eqs in
    print_endline "REŠITEV:";
    List.iter
      (fun (p, ty) ->
        print_endline
          ("- " ^ Syntax.string_of_param p ^ " -> " ^ Syntax.string_of_ty ty))
      subst;
    print_string "SUBSTITUIRANI TIP: ";
    print_endline (Syntax.string_of_ty (Syntax.subst_ty subst ty));
    print_endline "MALI KORAKI: ";
    if eager then Interpreter.small_step e else InterpreterLazy.small_step e;
    print_endline "VELIKI KORAKI:";
    if eager then Interpreter.big_step e else InterpreterLazy.big_step e

let _ = main ()
