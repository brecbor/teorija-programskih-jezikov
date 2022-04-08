# NAVODILA ZA DRUGO DOMAČO NALOGO

Naloga obsega dve razširitvi jezika miniml, ki ste ga spoznali med predavanji.

Cilj domače naloge so izključno razširitve jezika, zato pri karkšnihkoli problemih z izgradnjo jezika pošljite e-mail, da problem čimprej rešimo.

### Izgradnja
Za izgradnjo jezika v konzoli pojdite do mape `domaca-naloga-02/miniml` in v njej poženite `dune build`.

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
3. V datoteko `map.mml` napišite funkcijo `map` in jo uporabite na primeru.
4. V datoteko `split.mml` napišite funkicjo `split` in jo uporabite na primeru.

(opis funkcij `map` in `split` lahko poiščete v Ocaml Documentaciji https://caml.inria.fr/pub/docs/manual-ocaml/libref/List.html)

## RAZŠIRITEV Z LENIM IZVAJANJEM

Jeziku mimiml (z dodanimi pari in seznami) dodajte leno izvajanje. V datoteki `interpreterLazy.ml` se nahaja kopija `interpreter.ml`, ki se uporabi kadar miniml pokličemo z besedo `lazy`.

Vaša naloga je:
1. Popravite izvajanje funkcij na leno izvajanje.
2. Dodajte leno izvajanje za pare in sezname.
3. V datoteko `lazy_good.mml` napišite program, ki se z lenim izvajanjem izvede mnogo hitreje. Nato v datoteko `lazy_bad.mml` napišite program, ki se z lenim izvajanjem izvede mnogo počasneje.


**NALOGO MORATE REŠEVATI SAMOSTOJNO! ČE NE VESTE, ALI DOLOČENA STVAR POMENI SODELOVANJE, RAJE VPRAŠAJTE!**