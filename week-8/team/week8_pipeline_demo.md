# Week 8 – UrbanStyle pipeline'i demo

## Eesmärk

Meie tiimi eesmärk oli ühendada andmete pärimine, töötlemine ja visualiseerimine üheks pipeline'iks, mida saab käivitada ühe käsuga.

## Tiimi rollid

- **Roll A – Merili:** andmete pärimine Supabase'ist (`data_fetcher.py`).
- **Roll B – Johanna:** andmete puhastamine ja töötlemine (`transform.py`).
- **Roll C – Katri:** tulemuste visualiseerimine ja salvestamine (`visualize_export.py`).
- **Roll D – Sigrid:** moodulite ühendamine ja kogu protsessi käivitamine (`pipeline.py`).

## Demo ja testimise tulemus

Käivitasime pipeline'i käsuga `python pipeline.py`.

Pipeline läbis edukalt järgmised etapid:
1. Andmete pärimine Supabase'ist.
2. Andmete puhastamine ja töötlemine.
3. Nädalase tulu ja KPI-de arvutamine.
4. Graafikute loomine ja tulemuste salvestamine.

Testimisel saime järgmised tulemused:
- Supabase'ist päriti 10 086 müügirida ja 3150 klienti.
- Pärast andmete puhastamist jäi alles 9045 müügirida.
- Analüüs hõlmas 114 nädalat.
- Kogutulu oli 2 601 594,59 €.
- Unikaalseid kliente oli 2549.
- Keskmine tellimus oli 287,63 €.
- Pipeline töötas algusest lõpuni 5,65 sekundiga.

## Väljundid

Pipeline lõi:
- CSV-faili nädalaste koondandmetega.
- HTML-faili nädalase tulu graafikuga.
- HTML-faili KPI-de kokkuvõttega.

## Peamised järeldused

**Järeldus:** nädalane müügitulu kõikus analüüsitud perioodil märkimisväärselt ning 2024. aastal oli see graafiku põhjal üldiselt kõrgem kui 2023. aastal.

**Võimalik otsus:** müügitulemusi tasub regulaarselt jälgida, et märgata olulisi langusi ja neile kiiremini reageerida.

**Mis meid üllatas:** Supabase'ist päringu tulemusel saadud 10 086 müügireast jäi pärast puhastamist analüüsiks 9045 rida.

## Edasiarenduse võimalused

Järgmise sammuna võiks pipeline'i käivitamist ajastada ning lisada automaatsed teavitused oluliste muutuste või vigade kohta.
