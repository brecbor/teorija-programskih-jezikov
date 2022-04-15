let explode str = List.init (String.length str) (String.get str)

let implode chrs = String.init (List.length chrs) (List.nth chrs)

type 'value parser = char list -> ('value * char list) option

(* BASIC PARSERS *)

let fail _ = None

let return v chrs = Some (v, chrs)

let character = function [] -> None | chr :: chrs -> Some (chr, chrs)

let ( || ) parser1 parser2 chrs =
  match parser1 chrs with
  | None -> parser2 chrs
  | Some (v, chrs') -> Some (v, chrs')

let ( >>= ) parser1 parser2 chrs =
  match parser1 chrs with None -> None | Some (v, chrs') -> parser2 v chrs'

(* DERIVED PARSERS *)

let ( >> ) parser1 parser2 = parser1 >>= fun _ -> parser2

let satisfy cond parser =
  let cond_parser v = if cond v then return v else fail in
  parser >>= cond_parser

let digit =
  let is_digit = String.contains "0123456789" in
  character |> satisfy is_digit

let alpha =
  let is_alpha = String.contains "_abcdefghijklmnopqrstvwuxyz" in
  character |> satisfy is_alpha

let space =
  let is_space = String.contains " \n\t\r" in
  character |> satisfy is_space

let exactly chr = character |> satisfy (( = ) chr)

let one_of parsers = List.fold_right ( || ) parsers fail

let word str =
  let chrs = explode str in
  List.fold_right (fun chr parser -> exactly chr >> parser) chrs (return ())

let rec many parser = many1 parser || return []

and many1 parser =
  parser >>= fun v ->
  many parser >>= fun vs -> return (v :: vs)

let integer =
  many1 digit >>= fun digits -> return (int_of_string (implode digits))

let spaces = many space >> return ()

let spaces1 = many1 space >> return ()

let parens parser =
  word "(" >> spaces >> parser >>= fun p -> spaces >> word ")" >> return p

let binop parser1 op parser2 f =
  parser1 >>= fun v1 ->
  spaces >> word op >> spaces >> parser2 >>= fun v2 -> return (f v1 v2)

(* LAMBDA PARSERS *)

let ident_ref = ref 0

let fresh_ident () =
  incr ident_ref;
  let name = "$_" ^ string_of_int !ident_ref in
  (Syntax.Ident name, Syntax.Var (Syntax.Ident name))

let comp cmp f =
  let pat, var = fresh_ident () in
  Syntax.Let (cmp, (pat, f var))

let comp2 e1 e2 f = comp e1 (fun e1 -> comp e2 (fun e2 -> f e1 e2))

let ident =
  alpha >>= fun chr ->
  many (alpha || digit || exactly '\'') >>= fun chrs ->
  return (Syntax.Ident (implode (chr :: chrs)))

let rec exp3 chrs =
  let if_then_else =
    word "IF" >> spaces1 >> exp3 >>= fun e ->
    spaces1 >> word "THEN" >> spaces1 >> exp3 >>= fun e1 ->
    spaces1 >> word "ELSE" >> spaces1 >> exp3 >>= fun e2 ->
    return (comp e (fun e -> Syntax.IfThenElse (e, e1, e2)))
  and lambda =
    word "FUN" >> spaces1 >> ident >>= fun x ->
    spaces1 >> word "->" >> spaces1 >> exp3 >>= fun e ->
    return (Syntax.Return (Syntax.Lambda (x, e)))
  and rec_lambda =
    word "REC" >> spaces1 >> ident >>= fun f ->
    spaces1 >> ident >>= fun x ->
    spaces1 >> word "->" >> spaces1 >> exp3 >>= fun e ->
    return (Syntax.Return (Syntax.RecLambda (f, (x, e))))
  and let_in =
    word "LET" >> spaces1 >> ident >>= fun x ->
    spaces >> word "=" >> spaces >> exp3 >>= fun e1 ->
    spaces1 >> word "IN" >> spaces1 >> exp3 >>= fun e2 ->
    return (Syntax.Let (e1, (x, e2)))
  and let_rec_in =
    word "LET" >> spaces1 >> word "REC" >> spaces1 >> ident >>= fun f ->
    spaces >> ident >>= fun x ->
    spaces >> word "=" >> spaces >> exp3 >>= fun e1 ->
    spaces1 >> word "IN" >> spaces1 >> exp3 >>= fun e2 ->
    return (Syntax.Let (Syntax.Return (Syntax.RecLambda (f, (x, e1))), (f, e2)))
  and try_catch =
    word "TRY" >> spaces1 >> exp3 >>= fun e1 ->
    spaces1 >> word "WITH" >> spaces1 >> exp3 >>= fun e2 ->
    return (Syntax.Try (e1, e2))
  in

  one_of
    [ if_then_else; lambda; rec_lambda; let_in; let_rec_in; try_catch; exp2 ]
    chrs

and exp2 chrs =
  one_of
    [
      binop exp1 "*" exp2 (fun e1 e2 ->
          comp2 e1 e2 (fun e1 e2 -> Syntax.Times (e1, e2)));
      binop exp1 "+" exp2 (fun e1 e2 ->
          comp2 e1 e2 (fun e1 e2 -> Syntax.Plus (e1, e2)));
      binop exp1 "-" exp2 (fun e1 e2 ->
          comp2 e1 e2 (fun e1 e2 -> Syntax.Minus (e1, e2)));
      binop exp1 "=" exp2 (fun e1 e2 ->
          comp2 e1 e2 (fun e1 e2 -> Syntax.Equal (e1, e2)));
      binop exp1 "<" exp2 (fun e1 e2 ->
          comp2 e1 e2 (fun e1 e2 -> Syntax.Less (e1, e2)));
      binop exp1 ">" exp2 (fun e1 e2 ->
          comp2 e1 e2 (fun e1 e2 -> Syntax.Greater (e1, e2)));
      exp1;
    ]
    chrs

and exp1 chrs =
  let apply =
    exp0 >>= fun e ->
    many1 (spaces1 >> exp0) >>= fun es ->
    return
      (List.fold_left
         (fun (e1 : Syntax.cmp) (e2 : Syntax.cmp) ->
           comp e1 (fun e1 -> comp e2 (fun e2 -> Syntax.Apply (e1, e2))))
         e es)
  and raise =
    word "RAISE" >> spaces1 >> ident >>= fun e -> return (Syntax.Raise e)
  and assign =
    ident >>= fun x ->
    spaces1 >> word ":=" >> spaces1 >> exp0 >>= fun e ->
    return (comp e (fun e -> Syntax.Assign (x, e)))
  and read = word "!" >> ident >>= fun x -> return (Syntax.Read x)
  and print_out =
    word "PRINT_INT" >> spaces1 >> exp0 >>= fun e ->
    return (comp e (fun e -> Syntax.Print e))
  in

  one_of [ apply; raise; assign; read; print_out; exp0 ] chrs

and exp0 chrs =
  one_of
    [
      (integer >>= fun n -> return (Syntax.Return (Syntax.Int n)));
      word "TRUE" >> return (Syntax.Return (Syntax.Bool true));
      word "FALSE" >> return (Syntax.Return (Syntax.Bool false));
      (ident >>= fun x -> return (Syntax.Return (Syntax.Var x)));
      parens exp3;
    ]
    chrs

let parse str =
  match str |> String.trim |> explode |> exp3 with
  | Some (v, []) -> v
  | Some (_, _ :: _) | None -> failwith "Parsing error"
