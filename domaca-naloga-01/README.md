# Prva domača naloga

Na predavanjih in vajah smo na kratko pogledali jezik `imp` in pripravili delno implementacijo tolmača, ki se (z manjšimi popravki) nahaja v datoteki `imp.agda`. Vaša naloga je tolmač dokončati in razširiti z dodatnimi konstrukti, tako da se bo uspešno prevedel in bo pravilno izvedel dane primere ukazov. Priporočamo, da si za testiranje pripravite še nekaj svojih primerov.

Da bo implementacija lažja, bomo predpostavili, da so vse spremenljivke vnaprej definirane, ukazi pa le spreminjajo njihove vrednosti. Stanje z `n` spremenljivkami bomo predstavili z vektorji `Vec n`, lokacije pa kar z indeksi tipa `Fin n`, ki jih bomo pisali kot `k / (n - k)`. Na primer, lokacije stanja s štirimi spremenljivkami bi pisali kot `0 / 3`, `1 / 2`, `2 / 1` in `3 / 0`. Če bi se zelo potrudili, bi drugi del Agda lahko izračunala sama.

Za domačo nalogo morate:

- Zapolniti vse luknje v obstoječi implementaciji.
- Dodati potenciranje `_**_`, konjunkcijo `_AND_`, disjunkcijo `_OR_` in negacijo `NOT`.
- Dodati zanko for oblike `FOR_:=_TO_DO_DONE`, ki sprejme obstoječo lokacijo, dva aritmetična izraza za meji in ukaz, ki naj ga ponavlja.
- Dodati izpisovanje števil `PRINT`, ki ga modelirajte tako, da izvajanje ukazov poleg stanja vrne še seznam izpisanih števil.
- Izvajanje ukazov popraviti tako, da se bo iz rezultata videlo, ali se je izvajanje uspešno zaključilo ali je vmes zmanjkalo goriva. V priloženi implementaciji imate naveden primer ustreznega tipa, ki ga lahko uporabite, lahko pa napišete tudi svoj tip.

Datoteke domače naloge morate oddati prek spletne učilnice. Priporočamo, da nalogo vseeno pišete prek Gita, vendar v ločenem in zasebnem repozitoriju, da je ne bi kdo prepisal brez vaše vednosti.

Dovoljno je brskanje in uporaba idej iz Agdine standardne knjižnice, zapiskov s predavanj in vaj ter pogovor s sošolci o idejah in težavah. Strogo prepovedano pa je kakršno koli deljenje kode, tako med sošolci kot prek interneta.

**NALOGO MORATE REŠEVATI SAMOSTOJNO! ČE NE VESTE, ALI DOLOČENA STVAR POMENI SODELOVANJE, RAJE VPRAŠAJTE!**
