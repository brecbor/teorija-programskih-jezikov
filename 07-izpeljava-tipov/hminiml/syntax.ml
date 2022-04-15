type param = Param of int

let counter = ref 0

let fresh_param () =
  incr counter;
  Param !counter

type ty = IntTy | BoolTy | ArrowTy of ty * ty | ParamTy of param | UnitTy

let rec occurs p = function
  | IntTy | BoolTy | UnitTy -> false
  | ArrowTy (ty1, ty2) -> occurs p ty1 || occurs p ty2
  | ParamTy p' -> p = p'

let rec subst_ty sbst = function
  | (IntTy | BoolTy | UnitTy) as ty -> ty
  | ArrowTy (ty1, ty2) -> ArrowTy (subst_ty sbst ty1, subst_ty sbst ty2)
  | ParamTy p as ty -> List.assoc_opt p sbst |> Option.value ~default:ty

let fresh_ty () = ParamTy (fresh_param ())

let string_of_param (Param p) = "'a" ^ string_of_int p

let rec string_of_ty = function
  | IntTy -> "int"
  | BoolTy -> "bool"
  | UnitTy -> "unit"
  | ArrowTy (ty1, ty2) ->
      "(" ^ string_of_ty ty1 ^ " -> " ^ string_of_ty ty2 ^ ")"
  | ParamTy p -> string_of_param p

type ident = Ident of string

type value =
  | V

and abs = ident * cmp

and cmp =
  | C

(* let let_in (x, e1, e2) = Apply (Lambda (x, e2), e1)

let let_rec_in (f, x, e1, e2) = let_in (f, RecLambda (f, x, e1), e2) *)

let rec subst_val sbst = function
  | Var x as e -> (
      match List.assoc_opt x sbst with None -> e | Some e' -> e')
  | (Int _ | Bool _ | Unit) as e -> e
  | Lambda abs -> Lambda (sub_abs sbst abs)
  | RecLambda (f, (x, e)) ->
      let sbst' = List.remove_assoc f (List.remove_assoc x sbst) in
      RecLambda (f, (x, subst_cmp sbst' e))

and sub_abs sbst (x, c) =
  let sbst' = List.remove_assoc x sbst in
  (x, subst_cmp sbst' c)

and subst_cmp sbst = function
  | Raise _ as e -> e
  | Plus (e1, e2) -> Plus (subst_val sbst e1, subst_val sbst e2)
  | Minus (e1, e2) -> Minus (subst_val sbst e1, subst_val sbst e2)
  | Times (e1, e2) -> Times (subst_val sbst e1, subst_val sbst e2)
  | Equal (e1, e2) -> Equal (subst_val sbst e1, subst_val sbst e2)
  | Less (e1, e2) -> Less (subst_val sbst e1, subst_val sbst e2)
  | Greater (e1, e2) -> Greater (subst_val sbst e1, subst_val sbst e2)
  | IfThenElse (v, e1, e2) ->
      IfThenElse (subst_val sbst v, subst_cmp sbst e1, subst_cmp sbst e2)
  | Apply (e1, e2) -> Apply (subst_val sbst e1, subst_val sbst e2)
  | Try (e1, e2) -> Try (subst_cmp sbst e1, subst_cmp sbst e2)
  | Assign (x, e) -> Assign (x, subst_val sbst e)
  | Read x -> Read x
  | Print e -> Print (subst_val sbst e)
  | Let (c, abs) -> Let (subst_cmp sbst c, sub_abs sbst abs)
  | Return value -> Return (subst_val sbst value)

let string_of_ident (Ident x) = x

let rec string_of_value3 = function
  | Lambda (x, e) -> "FUN " ^ string_of_ident x ^ " -> " ^ string_of_cmp3 e
  | RecLambda (f, (x, e)) ->
      "REC " ^ string_of_ident f ^ " " ^ string_of_ident x ^ " -> "
      ^ string_of_cmp3 e
  | e -> string_of_value2 e

and string_of_value2 = function e -> string_of_value1 e

and string_of_value1 = function e -> string_of_value0 e

and string_of_value0 = function
  | Int n -> string_of_int n
  | Bool b -> if b then "TRUE" else "FALSE"
  | Var x -> string_of_ident x
  | Unit -> "UNIT"
  | e -> "(" ^ string_of_value3 e ^ ")"

and string_of_cmp3 = function
  | IfThenElse (e, e1, e2) ->
      "IF " ^ string_of_value2 e ^ " THEN " ^ string_of_cmp2 e1 ^ " ELSE "
      ^ string_of_cmp3 e2
  | Try (e1, e2) -> "TRY " ^ string_of_cmp2 e1 ^ " WITH " ^ string_of_cmp2 e2
  | Let (c, (x, c2)) ->
      "LET " ^ string_of_ident x ^ " <- " ^ string_of_cmp2 c ^ " IN "
      ^ string_of_cmp2 c2
  | e -> string_of_cmp2 e

and string_of_cmp2 = function
  | Equal (e1, e2) -> string_of_value1 e1 ^ " = " ^ string_of_value1 e2
  | Less (e1, e2) -> string_of_value1 e1 ^ " < " ^ string_of_value1 e2
  | Greater (e1, e2) -> string_of_value1 e1 ^ " > " ^ string_of_value1 e2
  | Plus (e1, e2) -> string_of_value1 e1 ^ " + " ^ string_of_value1 e2
  | Minus (e1, e2) -> string_of_value1 e1 ^ " - " ^ string_of_value1 e2
  | Times (e1, e2) -> string_of_value1 e1 ^ " * " ^ string_of_value1 e2
  | e -> string_of_cmp1 e

and string_of_cmp1 = function
  | Apply (e1, e2) -> string_of_value0 e1 ^ " " ^ string_of_value0 e2
  | e -> string_of_cmp0 e

and string_of_cmp0 = function
  | Raise (Ident s) -> "(RAISE " ^ s ^ ")"
  | Read x -> "(READ " ^ string_of_ident x ^ ")"
  | Assign (x, e) -> "" ^ string_of_ident x ^ " := " ^ string_of_value0 e ^ ""
  | Print e -> "(PRINT " ^ string_of_value0 e ^ ")"
  | Return v -> "(RETURN " ^ string_of_value0 v ^ ")"
  | e -> "(" ^ string_of_cmp3 e ^ ")"

let string_of_cmp = string_of_cmp3
