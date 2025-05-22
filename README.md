# 📊 Analyse des ventes au détail en SQL

## Présentation du projet

**Titre du projet**: Analyse des ventes au détail 
**Database**: `retail_sales`

Dans ce projet j'utilise des requêtes SQL pour explorer, nettoyer et analyser les données de ventes au détail. Il inclut la création d'une base de données, l'exploration et le nettoyage des données, ainsi que l'analyse de tendances et de comportements clients à l'aide de requêtes SQL. Ce projet est idéal pour débuter en SQL et renforcer ses compétences en analyse de données.

## 🎯 Objectifs

1. **Créer une base de données de ventes**: Définir et structurer les données des transactions de vente.
2. **Data Cleaning**: Identifier et supprimer les valeurs nulles pour garantir la qualité des analyses.
3. **Exploratory Data Analysis (EDA)**: Réaliser une analyse exploratoire pour comprendre la structure et les tendances des ventes.
4. **Business Analysis**: Répondre à des questions métier à l'aide de requêtes SQL avancées.

## Project Structure

### 1.Mise en place de la base de données

- **Création de la base de données**:  `retail_sales`.
- **Création de la table**: A table named `ventes` pour stocker les données de vente.

```sql
CREATE DATABASE retail_sales;

CREATE TABLE ventes
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE, 
    sale_time TIME,
    customer_id INT,    
    gender VARCHAR(15),
    age INT,
    category VARCHAR(15),
    quantity INT,
    price_per_unit FLOAT,   
    cogs FLOAT,
    total_sale FLOAT
);
```

### 2. Exploration et nettoyage des données

- **Compter le nombre total d'enregistrements**: Determine the total number of records in the dataset.
- **Nombre de clients distincts**: Find out how many unique customers are in the dataset.
- **Nombre de catégories distinctes**: Identify all unique product categories in the dataset.
- **Recherche des valeurs nulles**: Check for any null values in the dataset and delete records with missing data.

```sql
SELECT COUNT(*) AS "Nombre de ventes total" FROM ventes;
SELECT COUNT(DISTINCT customer_id) AS "Nombre de clients distincts" FROM ventes;
SELECT COUNT(DISTINCT category) AS "Nombre total de catégories" FROM ventes;

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
```

### 3. Analyse des données et résultats

Les requêtes ci-dessous permettent de répondre à différentes questions métier :

**🛍️ 1. Récupérer toutes les ventes effectuées le "2022-11-05"**:
```sql
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';
```

**👕 2. Trouver toutes les transactions où la catégorie est 'Clothing' avec une quantité supérieure à 4 uniquement pour le mois de novembre**:
```sql
SELECT *
FROM ventes 
WHERE category = 'Clothing' 
      AND quantity > 4
      AND EXTRACT(MONTH FROM sale_date) = 11;
```

**💰 3. Calculer le total des ventes pour chaque catégorie**:
```sql
SELECT 
    category,
    COUNT(*) AS total_commandes,
    SUM(total_sale) AS ventes_net
FROM ventes
GROUP BY category;
```

**💄 4. Trouver l'âge moyen des clients ayant acheté des produits de beauté**:
```sql
SELECT 
    ROUND(AVG(age), 2) AS age_moyen
FROM ventes
WHERE category = 'Beauty'
GROUP BY category;
```

**🔥 5. Trouver toutes les transactions avec un total de ventes supérieur à 1000**:
```sql
SELECT *
FROM ventes
WHERE total_sale > 1000;
```

**📊 6. Nombre total de transactions pour chaque genre et chaque catégorie**:
```sql
SELECT
    category,
    gender,
    COUNT(transactions_id) AS total_transactions
FROM ventes
GROUP BY category, gender
ORDER BY category;
```

**📈 7. Identifier le meilleur mois de ventes pour chaque année**:
```sql
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
```

**🏆 8. Trouver le Top 5 des clients basés sur le total des ventes le plus élevé**:
```sql
SELECT 
customer_id,
SUM(total_sale) AS ventes_totales
FROM ventes 
GROUP BY customer_id
ORDER BY ventes_totales DESC LIMIT 5;
```

**🛒 9. Nombre de clients uniques ayant acheté un produit dans chaque catégorie**:
```sql
SELECT 
    category,
    COUNT(DISTINCT customer_id) AS clients_distincts
FROM ventes
GROUP BY category;
```

**🕒 10. Nombre de commandes par période de la journée**:
```sql
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
```

## 📌 Résultats et conclusions

- **Tendances des ventes :** Identification des meilleurs mois de ventes et des périodes de la journée les plus actives.

- **Analyse client :** Identification des clients les plus dépensiers et des préférences par catégorie.

- **Découverte de valeurs aberrantes :** Identification des transactions à fort montant (total_sale > 1000).

- **Segmentation des ventes :** Répartition des ventes par genre, catégorie et période de la journée.

