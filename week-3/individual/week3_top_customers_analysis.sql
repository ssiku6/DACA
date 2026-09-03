-- Leia TOP 10 klienti kogumüügi järgi:
SELECT
    c.first_name || ' ' || c.last_name AS klient,
    c.city,
    COUNT(DISTINCT s.sale_id) AS ostude_arv,
    SUM(s.total_price) AS kogumüük
FROM sales s
INNER JOIN customers c ON s.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.city
ORDER BY kogumüük DESC
LIMIT 10;

-- Leia 10 enim müüdud toodet kogumüügi järgi:
SELECT
    p.product_name,
    p.category,
    p.subcategory,
    COUNT(s.sale_id) AS müüdud_kordi,
    SUM(s.total_price) AS kogumüük
FROM products p
INNER JOIN sales s ON p.product_id = s.product_id
GROUP BY p.product_id, p.product_name, p.category, p.subcategory
ORDER BY kogumüük DESC
LIMIT 10;

-- Leia tooted, mida pole kunagi müüdud:
SELECT
    p.product_name,
    p.category,
    p.subcategory,
    p.retail_price,
    s.sale_id
FROM products p
LEFT JOIN sales s ON p.product_id = s.product_id
WHERE s.sale_id IS NULL;

-- Näita toodete laoseisu ja kas on vaja juurde tellida:
SELECT
    p.product_name,
    p.category,
    i.location,
    i.quantity_available,
    i.reorder_point,
    CASE
        WHEN i.quantity_available <= i.reorder_point THEN 'TELLI JUURDE'
        ELSE 'OK'
    END AS staatus
FROM products p
LEFT JOIN inventory i ON p.product_id = i.product_id
ORDER BY i.quantity_available ASC;
