# Week 2 – Sales andmete puhastamisraport

## Roll A – Müügiandmete puhastamine

Puhastamine viidi läbi testtabelis `sales_test`, mitte production-tabelis `sales`.

### Leitud probleemid

| Kategooria | Leitud probleeme | Kirjeldus |
|---|---:|---|
| Duplikaadid | 5 116 | Korduvad `invoice_id` väärtused ehk duplikaatsed read |
| NULL `customer_id` | 1 487 | Puuduv kliendi viide; tegemist võib olla külalisostuga |
| NULL `sale_date` | 0 | Puuduvad kuupäevad puudusid |
| NULL `total_price` | 0 | Puuduvad summad puudusid |
| Tuleviku kuupäevad | 0 | Kuupäevad ei olnud tänasest hilisemad |
| **KOKKU** | **6 603** | |

### Puhastamise tulemused

- Enne puhastamist oli `sales_test` tabelis **15 234 rida**.
- Leiti **4 013 duplikaatset arvet (`invoice_id`)**.
- Duplikaatide eemaldamisel kustutati **5 116 duplikaatset rida**.
- Pärast puhastamist jäi alles **10 118 rida**.
- `customer_id` oli NULL **1 487 real** enne duplikaatide eemaldamist; pärast puhastamist jäi **988 külalisostu**.
- NULL `sale_date` väärtusi ei leitud.
- NULL `total_price` väärtusi ei leitud.
- Tuleviku kuupäevi ei leitud.

### Soovitus

Esmalt tuleks parandada **duplikaatsete arvete tekkimise põhjus**, sest need põhjustavad müügiandmetes kõige suurema moonutuse. 
Enne analüüside tegemist tuleks tagada, et sama `invoice_id` ei satuks andmestikku korduvalt.

NULL `customer_id` väärtusi ei tohiks automaatselt käsitleda andmeveana, sest need võivad tähistada kehtivaid külalisoste. 
Analüüsis saab neid eristada näiteks sildiga `KÜLALINE`.
