# Week 2

SQL andmete puhastamine ja kvaliteedikontroll.

## Minu osa – Roll A

Töötasin `sales` andmestiku kvaliteedi kontrolli ja puhastamisega.

- Lõin puhastamiseks testtabeli `sales_test`.
- Kontrollisin ja tuvastasin duplikaatsed `invoice_id` väärtused.
- Eemaldasin testtabelist duplikaatsed read.
- Kontrollisin NULL väärtusi ja tulevikukuupäevi.
- Kontrollisin puhastamise tulemust ja dokumenteerisin leitud probleemid.

### Tulemused

- Algne ridade arv: **15 234**
- Duplikaatseid arveid: **4 013**
- Eemaldatud duplikaatseid ridu: **5 116**
- Ridu pärast puhastamist: **10 118**
- Külalisoste pärast puhastamist: **988**

### Failid

- [`week2_sales_cleaning.sql`](./individual/week2_sales_cleaning.sql) – puhastamise SQL-skript
- [`week2_sales_report.md`](./individual/week2_sales_report.md) – puhastamisraport
