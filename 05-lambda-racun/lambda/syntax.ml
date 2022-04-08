type ident = Ident of string
type exp = Var of ident | Lambda of ident * exp | Apply of exp * exp

let let_in (x, e1, e2) = Apply (Lambda (x, e2), e1)

let rec subst_exp sbst = function
  | Var x as e -> (
      match List.assoc_opt x sbst with None -> e | Some e' -> e')
  | Lambda (x, e) ->
      let sbst' = List.remove_assoc x sbst in
      Lambda (x, subst_exp sbst' e)
  | Apply (e1, e2) -> Apply (subst_exp sbst e1, subst_exp sbst e2)

let string_of_ident (Ident x) = x

let rec string_of_exp3 = function
  | Lambda (x, e) -> "\\" ^ string_of_ident x ^ ". " ^ string_of_exp3 e
  | e -> string_of_exp2 e

and string_of_exp2 = function e -> string_of_exp1 e

and string_of_exp1 = function
  | Apply (e1, e2) -> string_of_exp0 e1 ^ " " ^ string_of_exp0 e2
  | e -> string_of_exp0 e

and string_of_exp0 = function
  | Var x -> string_of_ident x
  | e -> "(" ^ string_of_exp3 e ^ ")"

let string_of_exp = string_of_exp3
