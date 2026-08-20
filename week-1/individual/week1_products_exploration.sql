-- Mitu toodet on kokku? v:362
SELECT COUNT(*) AS toodete_arv FROM products;

-- Millised veerud ja andmed tabelis on? v: jalanõud, meeste_riided, laste_riided, naiste_riided, aksessuaarid
SELECT * FROM products LIMIT 10;

-- Kõik unikaalsed tootekategooriad v: jalanõud, laste_riided, aksessuaarid, naiste_riided, meeste_riided
SELECT DISTINCT category FROM products;

-- 10 kallimat toodet
SELECT product_name, category, retail_price
FROM products
ORDER BY retail_price DESC
LIMIT 10;

-- 10 odavaimat toodet
SELECT product_name, category, retail_price
FROM products
ORDER BY retail_price ASC
LIMIT 10;

-- Näiteks kõik kindla kategooria tooted
SELECT * FROM products
WHERE category = 'naiste_riided'
ORDER BY retail_price DESC;

-- Puuduvad hinnad v 0
SELECT COUNT(*) - COUNT(retail_price) AS puuduvad_hinnad
FROM products;

-- Puuduvad kategooriad v 0
SELECT COUNT(*) - COUNT(category) AS puuduvad_kategooriad
FROM products;
