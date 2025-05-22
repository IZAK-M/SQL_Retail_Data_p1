-- Analyse des ventes au détail en SQL
-- Création de la base de données
CREATE DATABASE retail_sales;

-- Création de la table des ventes
DROP TABLE IF EXISTS ventes;
CREATE TABLE ventes(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,
    sale_time   TIME,
    customer_id INT,
    gender  VARCHAR(15),
    age INT,
    category VARCHAR(15),   
    quantity    INT,
    price_per_unit  FLOAT,
    cogs FLOAT, 
    total_sale FLOAT
);

SELECT * FROM ventes;

-- NETTOYAGE DES DONNÉES
-- Recherche des valeurs NULL
SELECT * 
FROM ventes
WHERE transactions_id IS NULL
      OR sale_date IS NULL
      OR sale_time IS NULL
      OR customer_id IS NULL
      OR gender IS NULL
      OR age IS NULL
      OR category IS NULL
      OR quantity IS NULL
      OR price_per_unit IS NULL
      OR cogs IS NULL
      OR total_sale IS NULL;

-- Suppression de toutes les lignes contenant des valeurs NULL
DELETE FROM ventes
WHERE transactions_id IS NULL
      OR sale_date IS NULL
      OR sale_time IS NULL
      OR customer_id IS NULL
      OR gender IS NULL
      OR age IS NULL
      OR category IS NULL
      OR quantity IS NULL
      OR price_per_unit IS NULL
      OR cogs IS NULL
      OR total_sale IS NULL;

-- Comptage du nombre de lignes restantes
SELECT COUNT(*) FROM ventes;

-- EXPLORATION DES DONNÉES
-- Nombre total de ventes
SELECT COUNT(*) AS "Nombre de ventes total"
FROM ventes; 

-- Nombre total de clients distincts
SELECT COUNT(DISTINCT customer_id) AS "Nombre de clients distincts"
FROM ventes;

-- Nombre total de catégories
SELECT COUNT(DISTINCT category) AS "Nombre total de catégories"
FROM ventes;

-- ANALYSE DES DONNÉES & CONCLUSIONS

-- Q1 : Récupérer toutes les ventes effectuées le “2022-11-05”
SELECT *
FROM ventes 
WHERE sale_date = '2022-11-05';

-- Q2 : Trouver toutes les transactions où la catégorie est 'Clothing' avec une quantité supérieure à 4 uniquement pour le mois de novembre
SELECT *
FROM ventes 
WHERE category = 'Clothing' 
      AND quantity > 4
      AND EXTRACT(MONTH FROM sale_date) = 11;

-- Q3 : Calculer le total des ventes pour chaque catégorie
SELECT 
    category,
    COUNT(*) AS total_commandes,
    SUM(total_sale) AS ventes_net
FROM ventes
GROUP BY category;

-- Q4 : Trouver l'âge moyen des clients ayant acheté des produits de beauté
SELECT 
    ROUND(AVG(age), 2) AS age_moyen
FROM ventes
WHERE category = 'Beauty'
GROUP BY category;

-- Q5 : Trouver toutes les transactions avec un total de ventes supérieur à 1000
SELECT *
FROM ventes
WHERE total_sale > 1000;

-- Q6 : Trouver le nombre total de transactions pour chaque genre et pour chaque catégorie
SELECT
    category,
    gender,
    COUNT(transactions_id) AS total_transactions
FROM ventes
GROUP BY category, gender
ORDER BY category;

-- Q7 : Trouver la moyenne des ventes pour chaque mois, puis identifier le meilleur mois pour chaque année
WITH rank_table AS
(
SELECT 
    EXTRACT(YEAR FROM sale_date) AS annee,
    EXTRACT(MONTH FROM sale_date) AS mois,
    AVG(total_sale) AS ventes_moyenne,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS rang
FROM ventes
GROUP BY annee, mois
)
SELECT
    annee,
    mois,
    ventes_moyenne
FROM rank_table 
WHERE rang = 1;

-- Q8 : Trouver le Top 5 des clients basés sur le total des ventes le plus élevé
SELECT 
customer_id,
SUM(total_sale) AS ventes_totales
FROM ventes 
GROUP BY customer_id
ORDER BY ventes_totales DESC LIMIT 5;

-- Q9 : Trouver le nombre de clients uniques ayant acheté un élément dans chaque catégorie
SELECT 
    category,
    COUNT(DISTINCT customer_id) AS clients_distincts
FROM ventes
GROUP BY category;

-- Q10 : Trouver le nombre de commandes pour chaque période de la journée (Matin <= 12h, Après-midi entre 12h et 17h, Soir > 17h)
SELECT 
 COUNT(CASE WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 1 END) AS ventes_matin,
 COUNT(CASE WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 1 END) AS ventes_apres_midi,
 COUNT(CASE WHEN EXTRACT(HOUR FROM sale_time) > 17 THEN 1 END) AS ventes_soir
FROM ventes;

-- ALTERNATIVE :
WITH horaires AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Matin'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Après-midi'
        ELSE 'Soir'
    END AS shift
FROM ventes
)
SELECT
    shift,
    COUNT(*) AS total_commandes
FROM horaires
GROUP BY shift;
