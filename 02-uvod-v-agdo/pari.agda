record Pair (A B : Set) : Set where
  constructor _,_
  field 
    fst : A
    snd : B