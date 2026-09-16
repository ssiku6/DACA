-- Milline oli iga kuu müük 2024. aastal?
SELECT
    TO_CHAR(sale_date, 'YYYY-MM') AS kuu,
    COUNT(*) AS tellimusi,
    SUM(total_price) AS käive,
    ROUND(AVG(total_price), 2) AS keskmine_tellimus
FROM sales
WHERE sale_date >= '2024-01-01'
  AND sale_date < '2025-01-01'
GROUP BY TO_CHAR(sale_date, 'YYYY-MM')
ORDER BY kuu;


-- Milline on müük linnade kaupa ning millises linnas on suurim kogukäive?
SELECT
    c.city AS linn,
    COUNT(s.sale_id) AS tellimuste_arv,
    SUM(s.total_price) AS kogukaive,
    ROUND(AVG(s.total_price), 2) AS keskmine_tellimus
FROM customers c
JOIN sales s
    ON c.customer_id = s.customer_id
GROUP BY c.city
ORDER BY kogukaive DESC;


-- Millisel nädalapäeval tehakse kõige rohkem tellimusi ja milline on kogukäive?
SELECT
    TO_CHAR(sale_date, 'Day') AS nadalapaev,
    COUNT(*) AS tellimuste_arv,
    SUM(total_price) AS kogukaive,
    ROUND(AVG(total_price), 2) AS keskmine_tellimus
FROM sales
GROUP BY TO_CHAR(sale_date, 'Day'), EXTRACT(ISODOW FROM sale_date)
ORDER BY tellimuste_arv DESC;


-- Millised kliendid on ostnud kokku üle 500 euro?
SELECT
    c.customer_id,
    c.first_name || ' ' || c.last_name AS nimi,
    COUNT(s.sale_id) AS tellimuste_arv,
    SUM(s.total_price) AS kogukaive
FROM customers c
JOIN sales s
    ON c.customer_id = s.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING SUM(s.total_price) > 500
ORDER BY kogukaive DESC;


-- Mitu klienti ületas 500 euro kogukäibe piiri?
SELECT
    COUNT(*) AS klientide_arv
FROM (
    SELECT
        c.customer_id
    FROM customers c
    JOIN sales s
        ON c.customer_id = s.customer_id
    GROUP BY c.customer_id
    HAVING SUM(s.total_price) > 500
) AS yle_500_klient;

-- Millistes kategooriates on müüdud üle 1000 ühiku?
SELECT
    p.category AS kategooria,
    SUM(s.quantity) AS muudud_yhikud,
    ROUND(AVG(p.retail_price), 2) AS keskmine_hind,
    COUNT(DISTINCT p.product_id) AS toodete_arv
FROM products p
JOIN sales s
    ON p.product_id = s.product_id
GROUP BY p.category
HAVING SUM(s.quantity) > 1000
ORDER BY muudud_yhikud DESC;

-- Milline oli 2024. aasta esimese kvartali kuude käive, kui see ületas 5000 eurot?
SELECT
    TO_CHAR(sale_date, 'YYYY-MM') AS kuu,
    COUNT(*) AS tellimuste_arv,
    SUM(total_price) AS kogukaive,
    ROUND(AVG(total_price), 2) AS keskmine_tellimus
FROM sales
WHERE sale_date >= '2024-01-01'
  AND sale_date < '2024-04-01'
GROUP BY TO_CHAR(sale_date, 'YYYY-MM')
HAVING SUM(total_price) > 5000
ORDER BY kuu;


-- Milline oli iga kuu käive ja kuidas see võrreldes eelmise kuuga muutus?
WITH kuu_myyk AS (
    SELECT
        DATE_TRUNC('month', sale_date) AS kuu,
        SUM(total_price) AS kaive
    FROM sales
    WHERE sale_date >= '2024-01-01'
    GROUP BY DATE_TRUNC('month', sale_date)
)
SELECT
    kuu,
    kaive,
    LAG(kaive) OVER (ORDER BY kuu) AS eelmine_kuu,
    kaive - LAG(kaive) OVER (ORDER BY kuu) AS kasv,
    ROUND(
        100.0 * (kaive - LAG(kaive) OVER (ORDER BY kuu))
        / LAG(kaive) OVER (ORDER BY kuu), 1
    ) AS kasv_protsent
FROM kuu_myyk
ORDER BY kuu;


-- Mitu klienti kuulub igasse segmenti ja kui suur on nende keskmine käive?
WITH kliendi_kokkuvote AS (
    SELECT
        c.customer_id,
        c.first_name || ' ' || c.last_name AS nimi,
        c.city,
        COUNT(s.sale_id) AS tellimuste_arv,
        SUM(s.total_price) AS kogukaive
    FROM customers c
    JOIN sales s
        ON c.customer_id = s.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name, c.city
),
segmendid AS (
    SELECT
        nimi,
        city,
        tellimuste_arv,
        kogukaive,
        CASE
            WHEN kogukaive > 1000 THEN 'VIP'
            WHEN kogukaive > 500 THEN 'Aktiivne'
            ELSE 'Tavaline'
        END AS segment
    FROM kliendi_kokkuvote
)
SELECT
    segment,
    COUNT(*) AS kliente,
    ROUND(AVG(kogukaive), 2) AS keskmine_kaive
FROM segmendid
GROUP BY segment
ORDER BY keskmine_kaive DESC;


-- Millised on iga kategooria kolm enim müüdud toodet?
WITH toote_myyk AS (
    SELECT
        p.category AS kategooria,
        p.product_name AS toode,
        SUM(s.quantity) AS myydud_kogus,
        ROW_NUMBER() OVER (
            PARTITION BY p.category
            ORDER BY SUM(s.quantity) DESC
        ) AS koht
    FROM products p
    JOIN sales s
        ON p.product_id = s.product_id
    GROUP BY p.category, p.product_name
)
SELECT
    kategooria,
    toode,
    myydud_kogus,
    koht
FROM toote_myyk
WHERE koht <= 3
ORDER BY kategooria, koht;

-- Millised on TOP 5 linna kogukäibe järgi ja milline on nende müügitulemus?
WITH linna_myyk AS (
    SELECT
        c.city AS linn,
        COUNT(DISTINCT s.sale_id) AS tellimusi,
        SUM(s.total_price) AS kogukaive,
        ROUND(AVG(s.total_price), 2) AS keskmine_tellimus
    FROM customers c
    JOIN sales s
        ON c.customer_id = s.customer_id
    WHERE s.sale_date >= '2024-01-01'
    GROUP BY c.city
    HAVING COUNT(DISTINCT s.sale_id) > 5
),
linna_jarjestus AS (
    SELECT
        linn,
        tellimusi,
        kogukaive,
        keskmine_tellimus,
        ROW_NUMBER() OVER (
            ORDER BY kogukaive DESC
        ) AS koht
    FROM linna_myyk
)
SELECT *
FROM linna_jarjestus
WHERE koht <= 5
ORDER BY koht;
