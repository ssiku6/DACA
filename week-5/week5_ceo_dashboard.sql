-- KPI-d
SELECT 
    SUM(total_price) AS kogutulu, 
    COUNT(DISTINCT customer_id) AS kliendid, 
    AVG(total_price) AS kesk_tellimus, 
    SUM(CASE WHEN EXTRACT(YEAR FROM sale_date) = 2023 THEN total_price ELSE 0 END) AS tulu_2023, 
    SUM(CASE WHEN EXTRACT(YEAR FROM sale_date) = 2024 THEN total_price ELSE 0 END) AS tulu_2024 
FROM sales;


-- 26 kuu joondiagramm
SELECT 
    CASE EXTRACT(MONTH FROM sale_date)
        WHEN 1 THEN 'jaan'
        WHEN 2 THEN 'veebr'
        WHEN 3 THEN 'märts'
        WHEN 4 THEN 'apr'
        WHEN 5 THEN 'mai'
        WHEN 6 THEN 'juuni'
        WHEN 7 THEN 'juuli'
        WHEN 8 THEN 'aug'
        WHEN 9 THEN 'sept'
        WHEN 10 THEN 'okt'
        WHEN 11 THEN 'nov'
        WHEN 12 THEN 'dets'
    END || ' ''' || TO_CHAR(sale_date, 'YY') AS kuu,
    TO_CHAR(sale_date, 'YYYY-MM') AS sort_key,
    SUM(total_price) AS tulu
FROM sales
WHERE sale_date >= '2023-01-01' AND sale_date <= '2025-02-28'
GROUP BY kuu, sort_key
ORDER BY sort_key;
