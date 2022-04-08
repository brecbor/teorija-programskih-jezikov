let read_source filename =
  let channel = open_in filename in
  let source = really_input_string channel (in_channel_length channel) in
  close_in channel;
  source

let main () =
  if Array.length Sys.argv <> 2 then
    failwith ("Run HMINIML as '" ^ Sys.argv.(0) ^ " <filename>.hml'")
  else
    let filename = Sys.argv.(1) in
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
    print_string "SUBSTITUIRANI TIP:";
    print_endline (Syntax.string_of_ty (Syntax.subst_ty subst ty))

(* print_endline "MALI KORAKI:";
   Interpreter.small_step e;
   print_endline "VELIKI KORAKI:";
   Interpreter.big_step e *)

let _ = main ()
