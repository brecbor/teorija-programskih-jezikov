module vektorji where

open import naravna
open import fin

data Vec : Set → ℕ → Set where
    [] : {A : Set} → Vec A O
    _∷_ : {A : Set} {n : ℕ} → A → Vec A n → Vec A (S n)

_++_ : {A : Set} {m n : ℕ} → Vec A m → Vec A n → Vec A (m + n)
[] ++ ys = ys
(x ∷ xs) ++ ys = x ∷ (xs ++ ys)

map : {A B : Set} {m : ℕ} → (A → B) → Vec A m → Vec B m
map f [] = []
map f (x ∷ xs) = f x ∷ map f xs

hd : {A : Set} {m : ℕ} → Vec A (S m) → A
hd (x ∷ _) = x

_[_] : {A : Set} {n : ℕ} -> Vec A n -> Fin n -> A
[] [ () ]
(x ∷ v) [ Fo ] = x
(x ∷ v) [ Fs ind ] = v [ ind ]

_[_]←_ : {A : Set} {n : ℕ} -> Vec A n -> Fin n → A -> Vec A n
_[_]←_ [] ()
_[_]←_ (x ∷ xs) Fo v = v ∷ xs
_[_]←_ (x ∷ xs) (Fs i) v = x ∷ (xs [ i ]← v)