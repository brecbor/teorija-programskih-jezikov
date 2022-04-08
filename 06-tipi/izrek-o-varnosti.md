# Izrek o varnosti za λ-račun

## Definicija jezika

### Sintaksa

Vzemimo λ-račun, kot smo ga spoznali na predavanjih:

    M ::= x
        | true
        | false
        | if M then M₁ else M₂
        | ⟨n⟩
        | M₁ + M₂
        | M₁ * M₂
        | M₁ < M₂
        | λx. M
        | M₁ M₂

### Operacijska semantika

Za vrednosti vzamemo:

    V ::= true
        | false
        | ⟨n⟩
        | λx. M

Operacijsko semantiko podamo z malimi koraki:

    M  ↝  M'
    ----------------------------------------------
    if M then M₁ else M₂  ↝  if M' then M₁ else M₂

    ------------------------------
    if true then M₁ else M₂  ↝  M₁

    -------------------------------
    if false then M₁ else M₂  ↝  M₂

    M₁  ↝  M₁'
    --------------------
    M₁ + M₂  ↝  M₁' + M₂

    M₂  ↝  M₂'
    --------------------
    V₁ + M₂  ↝  V₁ + M₂'

    ---------------------------
    ⟨n₁⟩ + ⟨n₂⟩  ↝  ⟨n₁ + n₂⟩

    M₁  ↝  M₁'
    --------------------
    M₁ * M₂  ↝  M₁' * M₂

    M₂  ↝  M₂'
    --------------------
    V₁ * M₂  ↝  V₁ * M₂'

    ---------------------------
    ⟨n₁⟩ * ⟨n₂⟩  ↝  ⟨n₁ · n₂⟩

    M₁  ↝  M₁'
    --------------------
    M₁ < M₂  ↝  M₁' < M₂

    M₂  ↝  M₂'
    --------------------
    V₁ < M₂  ↝  V₁ < M₂'

    n₁ < n₂
    --------------------
    ⟨n₁⟩ < ⟨n₂⟩  ↝  true

    n₁ ≮ n₂
    ---------------------
    ⟨n₁⟩ < ⟨n₂⟩  ↝  false

    M₁  ↝  M₁'
    ----------------
    M₁ M₂  ↝  M₁' M₂

    M₂  ↝  M₂'
    ----------------
    V₁ M₂  ↝  V₁ M₂'

    ----------------------
    (λx. M) V  ↝  M[V / x]

### Tipi

Tipi so:

    A, B ::= bool
           | int
           | A → B

Pravila za določanje tipov pa so:

    (x : A) ∈ Γ
    -----------
    Γ ⊢ x : A

    ---------------
    Γ ⊢ true : bool

    ----------------
    Γ ⊢ false : bool

    Γ ⊢ M : bool   Γ ⊢ M₁ : A   Γ ⊢ M₂ : A
    ---------------------------------------
    Γ ⊢ if M then M₁ else M₂ : A

    -------------
    Γ ⊢ ⟨n⟩ : int

    Γ ⊢ M₁ : int   Γ ⊢ M₂ : int
    ----------------------------
    Γ ⊢ M₁ + M₂ : int

    Γ ⊢ M₁ : int   Γ ⊢ M₂ : int
    ----------------------------
    Γ ⊢ M₁ * M₂ : int

    Γ ⊢ M₁ : int   Γ ⊢ M₂ : int
    ----------------------------
    Γ ⊢ M₁ < M₂ : bool

    Γ, x : A ⊢ M : B
    -----------------
    Γ ⊢ λx. M : A → B

    Γ ⊢ M₁ : A → B   Γ ⊢ M₂ : A
    ----------------------------
    Γ ⊢ M₁ M₂ : B

## Izrek o varnosti

### Lema (o substituciji)

Če velja `Γ, x : A, Γ' ⊢ M : B` in `Γ, Γ' ⊢ N : A`, tedaj velja `Γ, Γ' ⊢ M[N / x] : B`.

#### Dokaz

Z indukcijo na izpeljavo `Γ, x : A, Γ' ⊢ M : B`.
Če je zaključek zadnjega uporabljenega pravila:

* `Γ, x : A, Γ' ⊢ x : A`, je `M = x`, zato velja `M[N / x] = N`,
    torej velja `Γ, Γ' ⊢ M[N / x] : B` po drugi predpostavki.

* `Γ, x : A, Γ' ⊢ y : B` za `y ≠ x`, iz prvi predpostavke sledi `(y : B) ∈ Γ, Γ'`.
    Iz tega sledi `Γ, Γ' ⊢ M[N / x] : B`, saj je `M[N / x] = y`.

* `Γ, x : A, Γ' ⊢ true : bool`, velja tudi `Γ, Γ' ⊢ true : bool`

* `Γ, x : A, Γ' ⊢ false : bool`, velja tudi `Γ, Γ' ⊢ false : bool`

* `Γ, x : A, Γ' ⊢ if M then M₁ else M₂ : A`, mora veljati
    `Γ, x : A, Γ' ⊢ M : bool`, `Γ, x : A, Γ' ⊢ M₁ : A` in `Γ, x : A, Γ' ⊢ M₂ : A`.
    Po indukcijski predpostavki zato velja
    `Γ, Γ' ⊢ M[N / x] : bool`, `Γ, Γ' ⊢ M₁[N / x] : A` in `Γ, Γ' ⊢ M₂[N / x] : A`,
    iz česar sledi `Γ, Γ' ⊢ (if M then M₁ else M₂)[N / x] : A`, saj je
    `(if M then M₁ else M₂)[N / x] = if M[N / x] then M₁[N / x] else M₂[N / x]`.

* `Γ, x : A, Γ' ⊢ ⟨n⟩ : int`, velja tudi `Γ, Γ' ⊢ ⟨n⟩ : int`

* `Γ, x : A, Γ' ⊢ M₁ + M₂ : int`, mora veljati
    `Γ, x : A, Γ' ⊢ M₁ : int` in `Γ, x : A, Γ' ⊢ M₂ : int`.
    Po indukcijski predpostavki zato velja
    `Γ, Γ' ⊢ M₁[N / x] : int` in `Γ, Γ' ⊢ M₂[N / x] : int`
    iz česar sledi `Γ, Γ' ⊢ (M₁ + M₂)[N / x] : int`, saj je
    `(M₁ + M₂)[N / x] = M₁[N / x] + M₂[N / x]`.

* `Γ, x : A, Γ' ⊢ M₁ * M₂ : int`, mora veljati
    `Γ, x : A, Γ' ⊢ M₁ : int` in `Γ, x : A, Γ' ⊢ M₂ : int`.
    Po indukcijski predpostavki zato velja
    `Γ, Γ' ⊢ M₁[N / x] : int` in `Γ, Γ' ⊢ M₂[N / x] : int`
    iz česar sledi `Γ, Γ' ⊢ (M₁ * M₂)[N / x] : int`, saj je
    `(M₁ * M₂)[N / x] = M₁[N / x] * M₂[N / x]`.

* `Γ, x : A, Γ' ⊢ M₁ < M₂ : int`, mora veljati
    `Γ, x : A, Γ' ⊢ M₁ : int` in `Γ, x : A, Γ' ⊢ M₂ : int`.
    Po indukcijski predpostavki zato velja
    `Γ, Γ' ⊢ M₁[N / x] : int` in `Γ, Γ' ⊢ M₂[N / x] : int`
    iz česar sledi `Γ, Γ' ⊢ (M₁ < M₂)[N / x] : int`, saj je
    `(M₁ < M₂)[N / x] = M₁[N / x] < M₂[N / x]`.

* `Γ, x : A, Γ' ⊢ λy. M' : A' → B'`, mora veljati
    `Γ, x : A, Γ', y : A' ⊢ M' : B'`.
    Po indukcijski predpostavki zato velja
    `Γ, Γ', y : A' ⊢ M'[N / x] : B'`
    iz česar sledi `Γ, Γ' ⊢ (λy. M')[N / x] : A' → B'`, saj je
    `(λy. M')[N / x] = λy. M'[N / x]`.

* `Γ, x : A, Γ' ⊢ M₁ M₂ : B`, mora veljati
    `Γ, x : A, Γ' ⊢ M₁ : A' → B` in `Γ, x : A, Γ' ⊢ M₂ : A'`.
    Po indukcijski predpostavki zato velja
    `Γ, Γ' ⊢ M₁[N / x] : A' → B` in `Γ, Γ' ⊢ M₂[N / x] : A'`
    iz česar sledi `Γ, Γ' ⊢ (M₁ M₂)[N / x] : int`, saj je
    `(M₁ M₂)[N / x] = M₁[N / x] M₂[N / x]`.

### Trditev (napredek)

Če velja `⊢ M : A`, tedaj:
1. je `M` vrednost ali
2. obstaja `M'`, da velja `M ↝ M'`.

#### Dokaz

Z indukcijo na predpostavko o določenem tipu.
Če je zaključek zadnjega uporabljenega pravila:

* `⊢ x : A`, imamo protislovje, saj je kontekst prazen.

* `⊢ true : bool`, imamo vrednost (1).

* `⊢ false : bool`, imamo vrednost (1).

* `⊢ if M then M₁ else M₂ : A`, mora veljati `⊢ M : bool`.
    Po indukciji dobimo dva primera:
    1. `M` je vrednost, torej `true`, `false`, `⟨n⟩` ali `λx. M`.
    Ker velja `⊢ M : bool`, zadnji dve možnosti odpadeta.
    Če je `M = true`, velja `if M then M₁ else M₂ ↝ M₁`,
    če je `M = false`, velja `if M then M₁ else M₂ ↝ M₂`.
    2. Obstaja `M'`, da velja `M ↝ M'`, zato velja tudi `if M then M₁ else M₂ ↝ if M' then M₁ else M₂`.

    V vseh primerih izraz torej lahko naredi korak (2).

* `⊢ ⟨n⟩ : int`, imamo vrednost (1).

* `⊢ M₁ + M₂ : int`, mora veljati `⊢ M₁ : int` in `⊢ M₂ : int`.
    Po indukciji za `M₁` dobimo dva primera:
    1. `M₁` je vrednost tipa `int`, torej število `⟨n₁⟩`. V tem primeru po indukciji za `M₂` dobimo dva primera:
        1. Tudi `M₂` je vrednost tipa `int`, torej število `⟨n₂⟩`. Tedaj velja `M₁ + M₂ = ⟨n₁⟩ + ⟨n₂⟩ ↝ ⟨n₁ + n₂⟩`.
        2. Obstaja `M₂'`, da velja `M₂ ↝ M₂'`, zato velja tudi `M₁ M₂ = V₁ M₂ ↝ V₁ M₂'`.
    2. Obstaja `M₁'`, da velja `M₁ ↝ M₁'`, zato velja tudi `M₁ M₂ ↝ M₁' M₂`.

    V vseh primerih izraz torej lahko naredi korak (2).

* `⊢ M₁ * M₂ : int`, je dokaz podoben kot za vsoto.

* `⊢ M₁ < M₂ : bool`, je dokaz podoben kot za vsoto.

* `⊢ λx. M : A → B`, imamo vrednost (1).

* `⊢ M₁ M₂ : B`, mora veljati `⊢ M₁ : A → B` in `⊢ M₂ : A` za nek `A`.
    Po indukciji za `M₁` dobimo dva primera:
    1. `M₁` je vrednost `V₁`. V tem primeru po indukciji za `M₂` dobimo dva primera:
        1. Tudi `M₂` je vrednost `V₂`. Ker velja `⊢ M₁ : A → B`, mora veljati `M₁ = λx. M` za neka `x` in `M`. Tedaj velja `M₁ M₂ = (λx. M) V₂ ↝ M[V₂ / x]`.
        2. Obstaja `M₂'`, da velja `M₂ ↝ M₂'`, zato velja tudi `M₁ M₂ = V₁ M₂ ↝ V₁ M₂'`.
    2. Obstaja `M₁'`, da velja `M₁ ↝ M₁'`, zato velja tudi `M₁ M₂ ↝ M₁' M₂`.

    V vseh primerih izraz torej lahko naredi korak (2).

### Trditev (ohranitev)

Če velja `Γ ⊢ M : A` in `M ↝ M'`, tedaj velja tudi `Γ ⊢ M' : A`.

#### Dokaz

Z indukcijo na predpostavko o koraku.
Če je zaključek zadnjega uporabljenega pravila:

* `if M then M₁ else M₂ ↝ if M' then M₁ else M₂`, mora veljati `M ↝ M'`,
  iz `Γ ⊢ if M then M₁ else M₂ : A` pa sledi
  `Γ ⊢ M : bool`, `Γ ⊢ M₁ : A` in `Γ ⊢ M₂ : A`.
  Po indukcijski predpostavki velja `Γ ⊢ M' : bool`, iz česar sledi tudi
  `Γ ⊢ if M' then M₁ else M₂ : A`.

* `if true then M₁ else M₂ ↝ M₁`,
  iz `Γ ⊢ if M then M₁ else M₂ : A` sledi `Γ ⊢ M₁ : A`, kar želimo.

* `if false then M₁ else M₂ ↝ M₂`
  iz `Γ ⊢ if M then M₁ else M₂ : A` sledi `Γ ⊢ M₂ : A`, kar želimo.

* `M₁ + M₂ ↝ M₁' + M₂`, mora veljati `M₁ ↝ M₁'`,
  iz `Γ ⊢ M₁ + M₂ : int` pa sledi
  `Γ ⊢ M₁ : int` in `Γ ⊢ M₂ : int`.
  Po indukcijski predpostavki velja `Γ ⊢ M₁' : int`, iz česar sledi tudi
  `Γ ⊢ M₁' M₂ : int`.

* `V₁ + M₂ ↝ V₁ + M₂'`, mora veljati `M₂ ↝ M₂'`,
  iz `Γ ⊢ V₁ + M₂ : int` pa sledi
  `Γ ⊢ V₁ : int` in `Γ ⊢ M₂ : int`.
  Po indukcijski predpostavki velja `Γ ⊢ M₂' : int`, iz česar sledi tudi
  `Γ ⊢ M₁ + M₂' : int`.

* `⟨n₁⟩ + ⟨n₂⟩ ↝ ⟨n₁ + n₂⟩`, kjer sta obe strani tipa `int`.

* Dokazi ohranitve za produkt in primerjavo števil so enaki kot pri vsoti.

* `M₁ M₂ ↝ M₁' M₂`, mora veljati `M₁ ↝ M₁'`,
  iz `Γ ⊢ M₁ M₂ : A` pa sledi
  `Γ ⊢ M₁ : B → A` in `Γ ⊢ M₂ : B` za nek `B`.
  Po indukcijski predpostavki velja `Γ ⊢ M₁' : B → A`, iz česar sledi tudi
  `Γ ⊢ M₁' M₂ : A`.

* `V₁ M₂ ↝ V₁ M₂'`, mora veljati `M₂ ↝ M₂'`,
  iz `Γ ⊢ V₁ M₂ : A` pa sledi
  `Γ ⊢ V₁ : B → A` in `Γ ⊢ M₂ : B` za nek `B`.
  Po indukcijski predpostavki velja `Γ ⊢ M₂' : B`, iz česar sledi tudi
  `Γ ⊢ V M₂' : A`.

* `(λx. M) V ↝ M[V / x]`,
  iz `Γ ⊢ (λx. M) V : A` sledi
  `Γ ⊢ (λx. M) : B → A` in `Γ ⊢ V : B` za nek `B`.
  Iz prvega sledi `Γ, x : B ⊢ M : A`,
  z drugim pa prek leme o substituciji izpeljemo `Γ ⊢ M[V / x] : A`.
