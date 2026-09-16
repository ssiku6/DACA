-- Milline on iga turunduskanali klientide arv, tellimuste arv, kogukäive ja keskmine tellimusväärtus?
SELECT
    w.source AS turunduskanal,
    COUNT(DISTINCT c.customer_id) AS kliente,
    COUNT(DISTINCT o.sale_id) AS tellimusi,
    SUM(o.total_price) AS kogukäive,
    ROUND(AVG(o.total_price), 2) AS keskmine_tellimus
FROM sales o
JOIN customers c
    ON o.customer_id = c.customer_id
LEFT JOIN web_logs w
    ON c.customer_id = w.customer_id
GROUP BY w.source
ORDER BY kogukäive DESC;

-- Millised turunduskanalid toovad üle 1000 tellimuse ning kui suur on nende käive ühe kliendi kohta?
WITH kanali_kaive AS (
    SELECT
        w.source AS turunduskanal,
        SUM(o.total_price) AS kogukaive,
        COUNT(DISTINCT o.sale_id) AS tellimusi
    FROM sales o
    JOIN customers c
        ON o.customer_id = c.customer_id
    LEFT JOIN web_logs w
        ON c.customer_id = w.customer_id
    GROUP BY w.source
    HAVING COUNT(DISTINCT o.sale_id) > 1000
),
kanali_kliendid AS (
    SELECT
        w.source AS turunduskanal,
        COUNT(DISTINCT c.customer_id) AS kliente
    FROM sales o
    JOIN customers c
        ON o.customer_id = c.customer_id
    LEFT JOIN web_logs w
        ON c.customer_id = w.customer_id
    GROUP BY w.source
)
SELECT
    k.turunduskanal,
    k.kogukaive,
    k.tellimusi,
    c.kliente,
    ROUND(k.kogukaive / NULLIF(c.kliente, 0), 2) AS kaive_klienti_kohta
FROM kanali_kaive k
JOIN kanali_kliendid c
    ON k.turunduskanal = c.turunduskanal
ORDER BY kaive_klienti_kohta DESC;


-- Millised on turunduskanalite kuised käibe- ja klienditrendid?
SELECT
    w.source AS turunduskanal,
    DATE_TRUNC('month', o.sale_date) AS kuu,
    SUM(o.total_price) AS kogukaive,
    COUNT(DISTINCT o.customer_id) AS kliente,
    COUNT(DISTINCT o.sale_id) AS tellimusi
FROM sales o
JOIN customers c
    ON o.customer_id = c.customer_id
LEFT JOIN web_logs w
    ON c.customer_id = w.customer_id
GROUP BY
    w.source,
    DATE_TRUNC('month', o.sale_date)
HAVING COUNT(DISTINCT o.sale_id) > 100
ORDER BY
    kuu,
    kogukaive DESC;
