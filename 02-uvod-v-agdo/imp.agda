module imp where

import naravna
open naravna using (ℕ; O; S)
open import seznami
open import boole


data Loc : Set where
    #_ : ℕ → Loc

data Exp (L : 𝕊 Loc) : Set where
    `_ : ℕ → Exp L
    !_ : {ℓ : Loc} → ℓ ∈ L → Exp L
    _+_ : Exp L → Exp L → Exp L
    _*_ : Exp L → Exp L → Exp L

primer : Exp ((# O) ∷ [])
primer = (` (S O)) + (! here)

data BExp (L : 𝕊 Loc) : Set where
    _≡_ : Exp L → Exp L → BExp L
    _<_ : Exp L → Exp L → BExp L
    _>_ : Exp L → Exp L → BExp L

data Cmd : 𝕊 Loc → 𝕊 Loc → Set where
    IF_THEN_ELSE_END : {L L' : 𝕊 Loc} → BExp L → Cmd L L' → Cmd L L' → Cmd L L'
    WHILE_DO_DONE : {L : 𝕊 Loc} → BExp L → Cmd L L → Cmd L L
    _；_ : {L L' L'' : 𝕊 Loc} → Cmd L L' → Cmd L' L'' → Cmd L L''
    _:=_ : {L : 𝕊 Loc} → (ℓ : Loc) → Exp L → Cmd L (ℓ ∷ L)
    SKIP : {L : 𝕊 Loc} → Cmd L L
    FOR_:=_TO_DO_DONE : {L : 𝕊 Loc} (ℓ : Loc) → Exp L → Exp L → Cmd (ℓ ∷ L) (ℓ ∷ L) → Cmd L L

data State : 𝕊 Loc → Set where
    [] : State []
    _↦_∷_ : {L : 𝕊 Loc} (ℓ : Loc) → ℕ → State L → State (ℓ ∷ L)

lookup : {L : 𝕊 Loc} {ℓ : Loc} → ℓ ∈ L → State L → ℕ
lookup here (ℓ ↦ x ∷ st) = {!   !}
lookup (there mem) (_ ↦ x ∷ st) = lookup mem st

evalExp : {L : 𝕊 Loc} → State L → Exp L → ℕ
evalExp st (` x) = x
evalExp st (! mem) = lookup mem  st
evalExp st (exp₁ + exp₂) = (evalExp st exp₁) naravna.+ (evalExp st exp₂)
evalExp st (exp₁ * exp₂) = {!   !}

evalBExp : {L : 𝕊 Loc} → State L → BExp L → 𝔹
evalBExp st bexp = {!   !}


evalCmd : {L L' : 𝕊 Loc} → ℕ → State L → Cmd L L' → State L'
evalFor : {L L' : 𝕊 Loc} → ℕ → (ℓ : Loc) → ℕ → ℕ → State L → Cmd (ℓ ∷ L) (ℓ ∷ L) → State L

evalCmd n st (IF bexp THEN cmd₁ ELSE cmd₂ END) = {!   !}
evalCmd (S n) st (WHILE bexp DO cmd DONE) =
    if evalBExp st bexp then
        evalCmd n (evalCmd n st cmd) (WHILE bexp DO cmd DONE)
    else
        st
evalCmd n st (cmd₁ ； cmd₂) = evalCmd n (evalCmd n st cmd₁) cmd₂
evalCmd _ st (ℓ := exp) = ℓ ↦ evalExp st exp ∷ st
evalCmd _ st SKIP = st
evalCmd O st (WHILE bexp DO cmd DONE) = st
evalCmd n st (FOR ℓ := exp₁ TO exp₂ DO cmd DONE) =
    evalFor n ℓ (evalExp st exp₁) (evalExp st exp₂) st cmd

evalFor n ℓ from to st cmd with naravna._≤_ from to
...                           | 𝕗 = st
...                           | 𝕥 with evalCmd n (ℓ ↦ from ∷ st) cmd
...                                  | .ℓ ↦ _ ∷ st' = evalFor n ℓ (S from) to st' cmd
