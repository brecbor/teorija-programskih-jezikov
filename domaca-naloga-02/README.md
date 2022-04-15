# NAVODILA ZA DRUGO DOMAČO NALOGO

Naloga obsega razširitve jezika miniml, ki ste ga spoznali med predavanji.

Cilj domače naloge so izključno razširitve jezika, zato pri karkšnihkoli problemih z izgradnjo jezika pošljite e-mail, da problem čimprej rešimo.

Za pomoč pri pisanju naloge je nekaj primerov uporabe novih konstruktov že podanih, predalgamo pa, da dodate tudi svoje.

### Izgradnja
Za izgradnjo jezika v konzoli pojdite do mape `domaca-naloga-02/miniml` in v njej poženite `dune build`.

Če na računalniku nimate nameščenega orodja dune, lahko program prevedete tudi z

```
ocamlc -g syntax.ml parser.ml interpreter.ml interpreterLazy.ml typechecker.ml miniml.ml -O2 -o miniml.exe
```

Če ste si OCaml namestili na sistemu Windows s pomočjo `fdopen` namesto `ocamlc` uporabite (kjer pot do ocamlc ustrezno zamenjate z veljavno potjo na vašem računalniku):

```
C:\OCaml64\usr\local\bin\ocaml-env.exe exec -- C:\OCaml64\home\???\.opam\4.12.0+mingw64c\bin\ocamlc.exe
```

Če se vam zdi končni program počasen lahko namesto ocamlc uporabite `ocamlopt`, ki pa bo za prevajanje potreboval več časa.

Prevajalnik vam bo zgradil datoteko `mml.exe`, ki jo uporabljate kot

```./miniml.exe eager ime_datoteke.mml```

(za leno izvajanje `eager` zamenjajte z `lazy`).

**Kadar vam miniml javi napako `End_of_file`, morate spremeniti 'end of line sequence'**. To lahko storite v VSCode meniju (ukaz `Change End of Line Sequence`) ali pa v spodnjem desnem kotu okna, kjer je izbrana opcija `CRLF`, ki jo spremenite na `LF`.

## RAZŠIRITEV S PARI IN SEZNAMI

Jezik smo na vajah idejno že razširili s pari in seznami. Tako pari kot seznami so že dodani v parser in sintakso jezika.

Dodan je konstruktor za pare `{e1, e2} ~ Pair (e1, e2)`, prazen seznam `[] ~ Nil` in konstruiran seznam `e :: es ~ Cons (e, es)` (seznam več elementov se mora končati s praznim seznamom, torej `1::2::3::[]`). Prav tako sta dodani projekciji na komponente `FST e ~ Fst e` in `SND e ~ Snd e` in pa `MATCH e WITH | [] -> e1 | x :: xs -> e2 ~ Match (e, e1, x, xs, e2)`.

Vaša naloga je:

1. V `syntax.ml` dopolnite substitucijo za nove konstrukte.
2. Dopolnite evaluator `interpreter.ml` za nove konstrukte. Pomembno je, da pravilno deluje za smiselne programe (torej ne rabite skrbeti kaj se zgodi s programom `FST 1`).

## RAZŠIRITEV Z LENIM IZVAJANJEM

Jeziku mimiml (z dodanimi pari in seznami) dodajte leno izvajanje. V datoteki `interpreterLazy.ml` se nahaja kopija `interpreter.ml`, ki se uporabi kadar miniml pokličemo z besedo `lazy`.

Vaša naloga je:

1. Popravite izvajanje funkcij na leno izvajanje.
2. Dodajte leno izvajanje za pare in sezname.

## RAZŠIRITEV ALGORITMA ZA IZPELJAVO TIPOV

Izpeljavo tipov smo na vajah razširili za pare in sezname.
Sistem tipov jezika miniml že dopolnjen s konstruktoma `ProdTy` in `ListTy`, ki predstavljata tip produktov in seznamov.

Vaše naloge so:

- Dopolnite funkcije v datoteki `typechecker.ml.`, da bo pravilno izpeljal tipe programov v miniml.

## Oddaja

Datoteke domače naloge morate oddati prek spletne učilnice.
Priporočamo, da nalogo vseeno pišete prek Gita, vendar v ločenem in zasebnem repozitoriju, da je ne bi kdo prepisal brez vaše vednosti.

**NALOGO MORATE REŠEVATI SAMOSTOJNO! ČE NE VESTE, ALI DOLOČENA STVAR POMENI SODELOVANJE, RAJE VPRAŠAJTE!**
