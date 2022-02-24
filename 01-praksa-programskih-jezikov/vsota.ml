let rec sum n =
  if n = 0 then 0 else
  n + sum (n-1)

let sum_repna n = 
  let rec sum_repna' n acc =
    if n = 0 then acc else
    sum_repna' (n - 1) (n + acc)
  in
    sum_repna' n 0
