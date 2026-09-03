-- Kontrollin, kas inventory andmed on tiimi Supabase'is olemas -- OK
SELECT COUNT(*) AS inventuuri_ridu
FROM inventory;

-- Milliseid tooteid pole kunagi müüdud?
SELECT
    p.product_id,
    p.product_name,
    p.category,
    p.retail_price
FROM products p
LEFT JOIN sales s ON p.product_id = s.product_id
WHERE s.sale_id IS NULL;


-- Mitu toodet pole kunagi müüdud? --12 toodet
SELECT COUNT(*) AS müümata_tooteid
FROM products p
LEFT JOIN sales s ON p.product_id = s.product_id
WHERE s.sale_id IS NULL;

-- Millised on enim müüdud tooted?
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


-- Millised tootekategooriad on edukaimad?
SELECT
    p.category,
    COUNT(DISTINCT p.product_id) AS tooteid,
    COUNT(s.sale_id) AS müüke,
    SUM(s.total_price) AS kogumüük
FROM products p
LEFT JOIN sales s ON p.product_id = s.product_id
GROUP BY p.category
ORDER BY kogumüük DESC;



-- Millised tooted on laos ja kas neid tuleb juurde tellida?
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


-- Mitu toodet vajab juurde tellimist?
SELECT COUNT(*) AS juurde_tellitavaid
FROM products p
INNER JOIN inventory i ON p.product_id = i.product_id
WHERE i.quantity_available <= i.reorder_point;


-- INVENTUURI SOOVITUSED
-- 12 toodet pole kunagi müüdud, mistõttu tasub nende toodete laos hoidmine üle vaadata ning kaaluda nende eemaldamist või allahindlust.
-- 231 toodet vajavad juurde tellimist, kuna nende laoseis on liiga madal.
-- Kõige edukam kategooria on jalanõud, mille kogumüük on 774 034,75 €.
-- Soovitame keskenduda edukamate kategooriate toodete saadavusele ning vähendada müümata toodete laovaru.
