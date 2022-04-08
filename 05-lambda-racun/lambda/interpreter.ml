module S = Syntax

let rec eval_exp = function
  | S.Var _ -> failwith "Expected a closed term"
  | S.Lambda _ as e -> e
  | S.Apply (e1, e2) -> (
      let f = eval_exp e1 and v = eval_exp e2 in
      match f with
      | S.Lambda (x, e) -> eval_exp (S.subst_exp [ (x, v) ] e)
      | _ -> failwith "Function expected")

let is_value = function S.Lambda _ -> true | S.Var _ | S.Apply _ -> false

let rec step = function
  | S.Var _ | S.Lambda _ -> failwith "Expected a non-terminal expression"
  | S.Apply (S.Lambda (x, e), v) when is_value v -> S.subst_exp [ (x, v) ] e
  | S.Apply ((S.Lambda _ as f), e) -> S.Apply (f, step e)
  | S.Apply (e1, e2) -> S.Apply (step e1, e2)

let big_step e =
  let v = eval_exp e in
  print_endline (S.string_of_exp v)

let rec small_step e =
  print_endline (S.string_of_exp e);
  if not (is_value e) then (
    print_endline "  ~>";
    small_step (step e))
