-- Loo test tabel
CREATE TABLE sales_test AS
SELECT * FROM sales;

-- Taga unikaalne rea-tunnus dedup'i jaoks
ALTER TABLE sales_test ADD COLUMN IF NOT EXISTS id SERIAL;

-- Kontrolli ridade arvu -- Samm 1 – enne puhastamist: 15 234 rida
SELECT COUNT(*) AS ridade_arv
FROM sales_test;

-- Samm 2: Leia duplikaatsed arved
SELECT invoice_id, COUNT(*) AS koopiate_arv
FROM sales_test
GROUP BY invoice_id
HAVING COUNT(*) > 1
ORDER BY koopiate_arv DESC;

-- Mitu erinevat arvet on duplikaatsed? -- Duplikaatseid arveid (invoice_id): 4 013
SELECT COUNT(*) AS duplikaatsete_arvete_arv
FROM (
    SELECT invoice_id
    FROM sales_test
    GROUP BY invoice_id
    HAVING COUNT(*) > 1
) AS duplikaadid;

-- Samm 3: Loe kokku duplikaatsete ridade arv -- Duplikaatseid ridu: 5 116
SELECT COUNT(*) AS duplikaat_read
FROM sales_test
WHERE id NOT IN (
    SELECT MIN(id)
    FROM sales_test
    GROUP BY invoice_id
);

-- Samm 4: Leia NULL väärtused --NULL customer_id  1487
SELECT
    COUNT(*) FILTER (WHERE customer_id IS NULL) AS null_customer_id,
    COUNT(*) FILTER (WHERE sale_date IS NULL) AS null_sale_date,
    COUNT(*) FILTER (WHERE total_price IS NULL) AS null_total_price
FROM sales_test;

-- Samm 5: Kontrolli tuleviku kuupäevi
SELECT COUNT(*) AS tuleviku_kuupaevad
FROM sales_test
WHERE sale_date > CURRENT_DATE;

-- Samm 6: Kustuta duplikaadid testtabelist
DELETE FROM sales_test
WHERE id NOT IN (
    SELECT MIN(id)
    FROM sales_test
    GROUP BY invoice_id
);

-- Samm 7: Kontrolli ridade arvu pärast puhastamist -- 10118
SELECT COUNT(*) AS ridu_parast_puhastamist
FROM sales_test;

-- Samm 8: Külalisostude arv --988 külalisostu.
SELECT COUNT(*) AS kulalisostud
FROM sales_test
WHERE customer_id IS NULL;

-- Samm 9: Näita NULL kliendi asemel teksti KÜLALINE
SELECT
    sale_id,
    COALESCE(customer_id::text, 'KÜLALINE') AS klient
FROM sales_test
WHERE customer_id IS NULL;

-- Samm 10: Kontrolli tuleviku kuupäevi pärast puhastamist -- 0
SELECT COUNT(*) AS tuleviku_kuupaevad_parast
FROM sales_test
WHERE sale_date > CURRENT_DATE;

-- Kontrolli tulemust -- 10118
SELECT COUNT(*) AS ridu_parast FROM sales_test;

-- Tulemused:
-- Sales: 15 234 → 10 118 rida pärast duplikaatide eemaldamist.
-- Kustutatud 5 116 duplikaatset rida.
-- 4 013 arvet oli duplikaatne.
-- Pärast puhastamist jäi 988 külalisostu.
-- NULL kuupäevi ega summasid ei olnud ning tulevikukuupäevi ei olnud.
