module S = Syntax

module IdentMap = Map.Make (struct
  type t = S.ident

  let compare (S.Ident x) (S.Ident y) = compare x y
end)

type 'a env = 'a IdentMap.t

type state = int env

type printed = int list

let print_state state =
  IdentMap.iter
    (fun id v ->
      print_endline (S.string_of_ident id ^ " = " ^ string_of_int v ^ "; "))
    state

type result = state * S.cmp * printed

let ( >> ) (state, exp, printed) f =
  let state, exp', printed' = f (state, exp) in
  (state, exp', printed @ printed')

let ( >-> ) (state, exp, printed) f =
  let state, exp' = f (state, exp) in
  (state, exp', printed)

let empty_print (state, exp) = (state, exp, [])

type 'a temp_result = Res of 'a | Exp of result

let ( >>= ) exp f = match exp with Exp exp -> exp | Res x -> x >> f

let is_terminal = function S.Raise _ | S.Return _ -> true | _ -> false

let eval_int_v = function S.Int x -> x | _ -> failwith "expected int"

let rec eval_cmp (state : state) (cmp : S.cmp) : result =
  let st v = empty_print (state, S.Return v) in
  (* match cmp with *)
  failwith "TODO"

let rec step (state : state) cmp =
  (* match cmp with *)
  failwith "TODO"

let empty_state = IdentMap.empty

let big_step state e =
  let state, v, printed = eval_cmp state e in
  print_endline "PRINTED:";
  List.iter
    (fun v ->
      print_int v;
      print_string ", ")
    printed;
  print_newline ();
  print_state state;
  print_endline (S.string_of_cmp v)

let rec small_step state e =
  print_state state;
  print_newline ();
  print_endline (S.string_of_cmp e);
  if not (is_terminal e) then (
    print_endline "  ~>";
    let state, e, printed = step state e in
    (match printed with
    | [] -> ()
    | _ ->
        print_endline "PRINTED:";
        List.iter
          (fun v ->
            print_int v;
            print_string ", ")
          printed;
        print_newline ());
    small_step state e)
