open Syntax

let rec infer_exp ctx = function
  | Var x -> (List.assoc x ctx, [])
  | Int _ -> (IntTy, [])
  | Bool _ -> (BoolTy, [])
  | Plus (e1, e2) | Minus (e1, e2) | Times (e1, e2) ->
      let ty1, eqs1 = infer_exp ctx e1 in
      let ty2, eqs2 = infer_exp ctx e2 in
      (IntTy, ((ty1, IntTy) :: (ty2, IntTy) :: eqs1) @ eqs2)
  | Less (e1, e2) | Greater (e1, e2) | Equal (e1, e2) ->
      let ty1, eqs1 = infer_exp ctx e1 in
      let ty2, eqs2 = infer_exp ctx e2 in
      (BoolTy, ((ty1, IntTy) :: (ty2, IntTy) :: eqs1) @ eqs2)
  | IfThenElse (e, e1, e2) ->
      let ty, eqs = infer_exp ctx e in
      let ty1, eqs1 = infer_exp ctx e1 in
      let ty2, eqs2 = infer_exp ctx e2 in
      (ty1, ((ty, BoolTy) :: (ty1, ty2) :: eqs) @ eqs1 @ eqs2)
  | Lambda (x, e) ->
      let alpha = fresh_ty () in
      let ty, eqs = infer_exp ((x, alpha) :: ctx) e in
      (ArrowTy (alpha, ty), eqs)
  | RecLambda (f, x, e) ->
      let alpha = fresh_ty () in
      let beta = fresh_ty () in
      let ty, eqs =
        infer_exp ((x, alpha) :: (f, ArrowTy (alpha, beta)) :: ctx) e
      in
      (ArrowTy (alpha, ty), (beta, ty) :: eqs)
  | Apply (e1, e2) ->
      let ty1, eqs1 = infer_exp ctx e1 in
      let ty2, eqs2 = infer_exp ctx e2 in
      let alpha = fresh_ty () in
      (alpha, ((ty1, ArrowTy (ty2, alpha)) :: eqs1) @ eqs2)

let subst_eqs sbst eqs =
  List.map (fun (ty1, ty2) -> (subst_ty sbst ty1, subst_ty sbst ty2)) eqs

let compose_subst sbst1 sbst2 =
  sbst1 @ List.map (fun (p, ty) -> (p, subst_ty sbst1 ty)) sbst2

let rec unify = function
  | [] -> []
  | (ty1, ty2) :: eqs when ty1 = ty2 -> unify eqs
  | (ArrowTy (ty1, ty2), ArrowTy (ty1', ty2')) :: eqs ->
      unify ((ty1, ty1') :: (ty2, ty2') :: eqs)
  | (ParamTy p, ty) :: eqs when not (occurs p ty) ->
      let subst = unify (subst_eqs [ (p, ty) ] eqs) in
      compose_subst [ (p, ty) ] subst
  | (ty, ParamTy p) :: eqs when not (occurs p ty) ->
      let subst = unify (subst_eqs [ (p, ty) ] eqs) in
      compose_subst [ (p, ty) ] subst
  | (ty1, ty2) :: _ ->
      failwith
        ("Cannot unify types " ^ string_of_ty ty1 ^ " and " ^ string_of_ty ty2
       ^ ".")
