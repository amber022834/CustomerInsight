/* =====================================================================
   Customer Insight - Data Analysis SQL
   還原自 customer_insight.db，對應「Data Analysis / CRM Tag Design /
   Customer Segment Design / Use Case：App 高價值客群」分析文件
   ===================================================================== */


/* ---------------------------------------------------------------------
   1. 通路比較｜比較 App、Web、Branch 的客戶數與交易金額
   --------------------------------------------------------------------- */
CREATE VIEW channel_summary AS 
SELECT
    c.channel,
    COUNT(DISTINCT c.customer_id) AS customer_count,
    SUM(t.amount)                 AS total_amount,
    AVG(t.amount)                 AS avg_amount
FROM customer c
JOIN transactions t ON c.customer_id = t.customer_id
GROUP BY c.channel
ORDER BY total_amount DESC;

SELECT *
FROM channel_summary;

/* ---------------------------------------------------------------------
   2. 商品比較｜找出各通路主要交易的商品類別
   --------------------------------------------------------------------- */
CREATE VIEW channel_product AS
SELECT
    c.channel,
    p.product_category,
    COUNT(*)       AS transaction_count,
    SUM(t.amount)  AS total_amount
FROM customer c
JOIN transactions t ON c.customer_id = t.customer_id
JOIN products p     ON t.product_id  = p.product_id
GROUP BY c.channel, p.product_category
ORDER BY c.channel, total_amount DESC;


/* 2-1 進一步分析 Investment 商品（各方案交易筆數 / 總額 / 平均單筆金額）*/
CREATE VIEW investment_product AS
SELECT
    p.product_name,
    COUNT(*)                       AS transaction_count,
    SUM(t.amount)                  AS total_amount,
    AVG(t.amount)                  AS avg_amount
FROM transactions t
JOIN products p ON t.product_id = p.product_id
WHERE p.product_category = 'Investment'
GROUP BY p.product_name
ORDER BY total_amount DESC;
-- Key Finding: 進階理財方案 的總金額與平均單筆金額皆最高


/* ---------------------------------------------------------------------
   3. 客群分析｜各年齡、地區客群的「進階理財方案」交易情況
   --------------------------------------------------------------------- */
CREATE VIEW region_age_investment AS
SELECT
    c.region,
    CASE
        WHEN c.age BETWEEN 20 AND 29 THEN '20-29'
        WHEN c.age BETWEEN 30 AND 39 THEN '30-39'
        WHEN c.age BETWEEN 40 AND 49 THEN '40-49'
        ELSE '50+'
    END AS age_group,
    COUNT(*)      AS transaction_count,
    SUM(t.amount) AS total_amount
FROM customer c
JOIN transactions t ON c.customer_id = t.customer_id
JOIN products p     ON t.product_id  = p.product_id
WHERE p.product_name = '進階理財方案'
GROUP BY c.region, age_group
ORDER BY c.region, total_amount DESC;
-- Key Finding: 北部 40-49、中部 30-39、南部 30-39 為各地區交易金額最高的客群


/* =====================================================================
   CRM Tag Design ─ Customer Value Rule
   高價值：交易 >= 2 次 且 平均單筆金額 >= 1800
   中價值：交易次數、平均金額其中一項達標
   低價值：交易 < 2 次 且 平均單筆金額 < 1800
   ===================================================================== */
CREATE VIEW customer_tag AS
SELECT
    customer_id,
    transaction_count,
    avg_amount,
    CASE
        WHEN avg_amount >= 1800 AND transaction_count >= 2 THEN '高價值'
        WHEN avg_amount <  1800 AND transaction_count >= 2 THEN '中價值'
        WHEN avg_amount >= 1800 AND transaction_count <  2 THEN '中價值'
        ELSE '低價值'
    END AS value_tag
FROM (
    SELECT
        customer_id,
        COUNT(transaction_id) AS transaction_count,
        AVG(amount)           AS avg_amount
    FROM transactions
    GROUP BY customer_id
)
ORDER BY
    CASE
        WHEN value_tag = '高價值' THEN 1
        WHEN value_tag = '中價值' THEN 2
        ELSE 3
    END;

SELECT *
FROM customer_tag;


/* =====================================================================
   Customer Segment Design ─ App 高價值客群
   ===================================================================== */
CREATE VIEW app_high_value_transactions AS
SELECT
    app_transactions.customer_id,
    app_transactions.product_id,
    app_transactions.amount
FROM (
    SELECT
        transactions.customer_id,
        transactions.product_id,
        transactions.amount
    FROM transactions
    JOIN (
        SELECT
            customer.customer_id,
            customer.age,
            customer.region,
            customer.channel,
            customer_value.transaction_count,
            customer_value.avg_amount,
            customer_value.value_tag
        FROM customer
        JOIN (
            SELECT
                customer_id,
                transaction_count,
                avg_amount,
                CASE
                    WHEN avg_amount >= 1800 AND transaction_count >= 2 THEN '高價值'
                    WHEN avg_amount <  1800 AND transaction_count >= 2 THEN '中價值'
                    WHEN avg_amount >= 1800 AND transaction_count <  2 THEN '中價值'
                    ELSE '低價值'
                END AS value_tag
            FROM (
                SELECT
                    customer_id,
                    COUNT(transaction_id) AS transaction_count,
                    AVG(amount)           AS avg_amount
                FROM transactions
                GROUP BY customer_id
            )
            ORDER BY
                CASE
                    WHEN value_tag = '高價值' THEN 1
                    WHEN value_tag = '中價值' THEN 2
                    WHEN value_tag = '低價值' THEN 3
                END
        ) AS customer_value
        ON customer.customer_id = customer_value.customer_id
        WHERE customer.channel = 'App'
          AND customer_value.value_tag = '高價值'
    ) AS app_high_value
    ON transactions.customer_id = app_high_value.customer_id
) AS app_transactions;


/* ---------------------------------------------------------------------
   Use Case｜App 高價值客群 - Segment Overview 指標計算
   --------------------------------------------------------------------- */

/* 客戶數 */
SELECT COUNT(DISTINCT customer_id) AS segment_customer_count
FROM app_high_value_transactions;
-- 結果：44 人

/* 主要年齡層分布 */
SELECT
    CASE
        WHEN c.age BETWEEN 20 AND 29 THEN '20-29'
        WHEN c.age BETWEEN 30 AND 39 THEN '30-39'
        WHEN c.age BETWEEN 40 AND 49 THEN '40-49'
        ELSE '50+'
    END AS age_group,
    COUNT(*) AS customer_count
FROM customer c
WHERE c.customer_id IN (SELECT DISTINCT customer_id FROM app_high_value_transactions)
GROUP BY age_group
ORDER BY customer_count DESC;
-- 結果：20-29 = 13人、30-39 = 13人、50+ = 10人、40-49 = 8人

/* 主要地區分布 */
SELECT
    c.region,
    COUNT(*) AS customer_count
FROM customer c
WHERE c.customer_id IN (SELECT DISTINCT customer_id FROM app_high_value_transactions)
GROUP BY c.region
ORDER BY customer_count DESC;
-- 結果：北部 = 21人、南部 = 17人、中部 = 6人

/* Investment 交易筆數 / 金額 / 占比 */
SELECT
    (SELECT COUNT(*) FROM app_high_value_transactions t
        JOIN products p ON t.product_id = p.product_id
        WHERE p.product_category = 'Investment')                 AS investment_txn_count,
    (SELECT SUM(t.amount) FROM app_high_value_transactions t
        JOIN products p ON t.product_id = p.product_id
        WHERE p.product_category = 'Investment')                 AS investment_amount,
    (SELECT SUM(amount) FROM app_high_value_transactions)         AS segment_total_amount,
    ROUND(
        100.0 *
        (SELECT SUM(t.amount) FROM app_high_value_transactions t
            JOIN products p ON t.product_id = p.product_id
            WHERE p.product_category = 'Investment')
        /
        (SELECT SUM(amount) FROM app_high_value_transactions)
    , 1) AS investment_pct;
-- 結果：49 筆／419,700 元／占比約 84%
