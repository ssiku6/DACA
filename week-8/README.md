# Week 8 – Python APIs ja automatiseeritud pipeline

## Minu roll: Roll D – Pipeline

Minu ülesanne oli ühendada tiimiliikmete moodulid üheks töötavaks pipeline'iks.

Fail `pipeline.py` käivitab kogu protsessi järjest:
1. Andmete pärimine Supabase'ist.
2. Andmete puhastamine ja töötlemine.
3. Tulemuste visualiseerimine.
4. Tulemuste salvestamine CSV- ja HTML-failidena.

Pipeline sisaldab logimist ja veakäsitlust, et jälgida protsessi edenemist ning tuvastada võimalikke vigu.

## Testimise tulemus

Pipeline'i testimisel:
- Päris Supabase'ist 10 086 müügirida ja 3150 klienti.
- Pärast andmete puhastamist jäi analüüsiks 9045 müügirida.
- Kogu pipeline töötas algusest lõpuni 5,65 sekundiga.
- Loodi CSV-fail ja kaks HTML-faili.

## Meeskonnatöö

- **Roll A – Merili:** andmete pärimine (`data_fetcher.py`)
- **Roll B – Johanna:** andmete töötlemine (`transform.py`)
- **Roll C – Katri:** visualiseerimine ja salvestamine (`visualize_export.py`)
- **Roll D – Sigrid:** pipeline'i ühendamine (`pipeline.py`)

[Tiimi ühine töö – products-analytics](https://github.com/merili-reck/products-analytics/tree/main/week-8)

## Kuidas AI aitas sel nädalal?

Kasutasin AI-d koodi koostamisel ja selgitamisel, vigade leidmisel ning pipeline'i testimise ja tulemuste kontrollimise juures. Lõplikku lahendust testisin ise Supabase'i andmetega.

## Refleksioon

- **Kuidas API parandab töövoogu võrreldes CSV-failidega?** Andmeid saab pärida otse andmebaasist, ilma et peaks iga kord CSV
