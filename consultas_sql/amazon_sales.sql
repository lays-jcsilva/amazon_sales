 # Verificando se há valores nulos em todas AS variáveis na tabela amazon_product:
  SELECT
  COUNT(*) AS total_linhas,
  COUNTIF(product_id IS NULL) AS product_id_nulos,
  COUNTIF(product_name IS NULL) AS product_name_nulos,
  COUNTIF(category IS NULL) AS category_nulos,
  COUNTIF(discounted_price IS NULL) AS discounted_price_nulos,
  COUNTIF(actual_price IS NULL) AS actual_prices_nulos,
  COUNTIF( discount_percentage IS NULL) AS discount_percentage_nulos,
  COUNTIF(about_product IS NULL) AS about_product_nulos
FROM
  `amazon_sales.amazon_product`; 
  --Resultados da consulta: Somente a variável about_product 4 tem nulos 

  # Verificando se há valores nulos em todas AS variáveis na tabela amazon_review:
  SELECT
  COUNT(*) AS total_linhas,
  COUNTIF(user_id IS NULL) AS user_id_nulos,
  COUNTIF(user_name IS NULL) AS user_name_nulos,
  COUNTIF(review_id IS NULL) AS review_id_nulos,
  COUNTIF(review_title IS NULL) AS review_title_nulos,
  COUNTIF(img_link IS NULL) AS img_link_nulos,
  COUNTIF(product_link IS NULL) AS product_link_nulos,
  COUNTIF(product_id IS NULL) AS product_id_nulos,
  COUNTIF(rating IS NULL) AS rating_id_nulos,
  COUNTIF(rating_count IS NULL) AS rating_count_id_nulos
FROM
  `amazon_sales.amazon_review`; 
  --Resultados da consulta: Somente a variáves img_link 466 e product_link 466 e rating count tem nulos 2

  Tratamento dos valores nulos na tabela amazon_review:
  UPDATE amazon_sales.amazon_completa
SET rating_count = (
    SELECT APPROX_QUANTILES(rating_count, 2)[OFFSET(1)]
    FROM amazon_sales.amazon_completa
    WHERE rating_count IS NOT NULL
)
WHERE rating_count IS NULL;
  
   # Verificar duplicados por product_id na tabela amazon product
SELECT
  product_id,
  COUNT(*) AS num_duplicatas
FROM
  `amazon_sales.amazon_product`
GROUP BY
  product_id
HAVING
  COUNT(*) > 1; 
  --Resultado da consulta: 96 id duplicados
SELECT
  COUNT(*) AS total_product_id_duplicados
FROM (
  SELECT
    product_id
  FROM
    `amazon_sales.amazon_product`
  GROUP BY
    product_id
  HAVING
    COUNT(*) > 1 ) AS duplicados; 

  #Consultar duplicados na tabela amazon_review
SELECT
  product_id,
  COUNT(*) AS num_duplicatas
FROM
  `amazon_sales.amazon_review`
GROUP BY
  product_id
HAVING
  COUNT(*) > 1;
SELECT
  COUNT(*) AS total_product_id_duplicados
FROM (
  SELECT
    product_id
  FROM
    `amazon_sales.amazon_review`
  GROUP BY
    product_id
  HAVING
    COUNT(*) > 1 ) AS duplicados; 
  --Resultado: 92 duplicados

  #Tratamento dos duplicados para criação da tabela sem registros duplicados
CREATE TABLE  `amazon_sales.amazon_compilada` AS
WITH ranked_reviews AS (
  SELECT
    user_id,
    user_name,
    review_id,
    review_title,
    review_content,
    img_link,
    product_link,
    product_id,
    rating,
    rating_count,
    ROW_NUMBER() OVER (
      PARTITION BY product_id
      ORDER BY product_id
    ) AS row_num
  FROM
    `amazon_sales.amazon_review`
),
unique_reviews AS (
  SELECT
    user_id,
    user_name,
    review_id,
    review_title,
    review_content,
    img_link,
    product_link,
    product_id,
    rating,
    rating_count
  FROM
    ranked_reviews
  WHERE
    row_num = 1
),
ranked_products AS (
  SELECT
    product_id,
    product_name,
    category,
    discounted_price,
    actual_price,
    discount_percentage,
    about_product,
    ROW_NUMBER() OVER (
      PARTITION BY product_id
      ORDER BY product_id
    ) AS row_num
  FROM
    `amazon_sales.amazon_product`
),
unique_products AS (
  SELECT
    product_id,
    product_name,
    category,
    discounted_price,
    actual_price,
    discount_percentage,
    about_product
  FROM
    ranked_products
  WHERE
    row_num = 1
)
SELECT
  up.product_id,
  up.product_name,
  up.category,
  up.discounted_price,
  up.actual_price,
  up.discount_percentage,
  up.about_product,
  ur.user_id,
  ur.user_name,
  ur.review_id,
  ur.review_title,
  ur.review_content,
  ur.img_link,
  ur.product_link,
  ur.rating,
  ur.rating_count
FROM
  unique_products AS up
INNER JOIN
  unique_reviews AS ur
ON
  up.product_id = ur.product_id;

  #Verificando se a base de dados possui outliers ou inconsistências
  -- Encontrar produtos com preços negativos ou excessivamente altos
SELECT product_id, product_name, discounted_price, actual_price
FROM amazon_sales.amazon_product
WHERE discounted_price < 0
   OR actual_price < 0
   OR discounted_price > actual_price;

-- Encontrar avaliações com classificações fora do intervalo válido
SELECT review_id, product_id, rating
FROM amazon_sales.amazon_completa
WHERE rating < 1 OR rating > 5;

-- Encontrar avaliações com contagens de classificações negativas ou zeros
SELECT review_id, product_id, rating_count
FROM amazon_sales.amazon_completa
WHERE rating_count <= 0;


-- Verificar se todos os product_ids em amazon_review existem em amazon_product
SELECT r.product_id
FROM amazon_sales.amazon_review r
LEFT JOIN amazon_sales.amazon_product p ON r.product_id = p.product_id
WHERE p.product_id IS NULL;

#Verificando as categorias 
SELECT 
  category,
  COUNT(product_id) AS num_products
FROM 
  `datalab-amazon-produtos.amazon_sales.amazon_completa`
GROUP BY 
  category
ORDER BY 
  num_products DESC;

# Criando tabela unindo as duas tabelas amazon_review e amazon_product
CREATE TABLE  `amazon_sales.amazon_compilada` AS
WITH ranked_reviews AS (
  SELECT
    user_id,
    user_name,
    review_id,
    review_title,
    review_content,
    img_link,
    product_link,
    product_id,
    rating,
    rating_count,
    ROW_NUMBER() OVER (
      PARTITION BY product_id
      ORDER BY product_id
    ) AS row_num
  FROM
    `amazon_sales.amazon_review`
),
unique_reviews AS (
  SELECT
    user_id,
    user_name,
    review_id,
    review_title,
    review_content,
    img_link,
    product_link,
    product_id,
    rating,
    rating_count
  FROM
    ranked_reviews
  WHERE
    row_num = 1
),
ranked_products AS (
  SELECT
    product_id,
    product_name,
    category,
    discounted_price,
    actual_price,
    discount_percentage,
    about_product,
    ROW_NUMBER() OVER (
      PARTITION BY product_id
      ORDER BY product_id
    ) AS row_num
  FROM
    `amazon_sales.amazon_product`
),
unique_products AS (
  SELECT
    product_id,
    product_name,
    category,
    discounted_price,
    actual_price,
    discount_percentage,
    about_product
  FROM
    ranked_products
  WHERE
    row_num = 1
)
SELECT
  up.product_id,
  up.product_name,
  up.category,
  up.discounted_price,
  up.actual_price,
  up.discount_percentage,
  up.about_product,
  ur.user_id,
  ur.user_name,
  ur.review_id,
  ur.review_title,
  ur.review_content,
  ur.img_link,
  ur.product_link,
  ur.rating,
  ur.rating_count
FROM
  unique_products AS up
INNER JOIN
  unique_reviews AS ur
ON
  up.product_id = ur.product_id;

#Criando uma tabela limpando os caracteres especiais e alterando o tipo de dados
CREATE TABLE `amazon_sales.amazon_compilada_cleaned` AS
SELECT
  REGEXP_REPLACE(product_id, r'[^a-zA-Z0-9]', '') AS product_id,
  REGEXP_REPLACE(product_name, r'[^a-zA-Z0-9 ]', '') AS product_name,
  REGEXP_REPLACE(category, r'[^a-zA-Z0-9 ]', '') AS category,
  discounted_price,
  actual_price,
  discount_percentage,
  REGEXP_REPLACE(about_product, r'[^a-zA-Z0-9 ]', '') AS about_product,
  REGEXP_REPLACE(user_id, r'[^a-zA-Z0-9]', '') AS user_id,
  REGEXP_REPLACE(user_name, r'[^a-zA-Z0-9 ]', '') AS user_name,
  REGEXP_REPLACE(review_id, r'[^a-zA-Z0-9]', '') AS review_id,
  REGEXP_REPLACE(review_title, r'[^a-zA-Z0-9 ]', '') AS review_title,
  REGEXP_REPLACE(review_content, r'[^a-zA-Z0-9 ]', '') AS review_content,
  img_link,
  product_link,
  SAFE_CAST(REGEXP_REPLACE(rating, r'[^0-9.]', '') AS FLOAT64) AS rating, # alterando o tipo de dado 
  rating_count
FROM
  `amazon_sales.amazon_compilada`;

#Transformando as variáveis em dummy
SELECT 
    product_id,
    img_link,
    product_link,
    CASE 
        WHEN img_link IS NOT NULL THEN 1 
        ELSE 0 
    END AS img_link_dummy,
    CASE 
        WHEN product_link IS NOT NULL THEN 1 
        ELSE 0 
    END AS product_link_dummy
FROM 
   `amazon_sales.amazon_compilada_cleaned`

#Limpando as categorias
SELECT
  LOWER(
    CASE
      WHEN REGEXP_CONTAINS(category, r'^HomeKitchen') THEN 'Home Kitchen'
      WHEN REGEXP_CONTAINS(category, r'^ComputersAccessories') THEN 'Computer Accessories'
      WHEN REGEXP_CONTAINS(category, r'^MusicalInstruments') THEN 'Musical Instruments'
      WHEN REGEXP_CONTAINS(category, r'^HomeImprovement') THEN 'Home Improvement'
      WHEN REGEXP_CONTAINS(category, r'^HealthPersonal') THEN 'Health Personal'
      WHEN REGEXP_CONTAINS(category, r'^OfficeProducts') THEN 'Office Products'
      WHEN REGEXP_CONTAINS(category, r'^ElectronicsMobiles') THEN 'Electronics'
      WHEN REGEXP_CONTAINS(category, r'^ElectronicsHomeTheater') THEN 'Electronics'
      WHEN REGEXP_CONTAINS(category, r'^ElectronicsWearable') THEN 'Electronics'
      WHEN REGEXP_CONTAINS(category, r'^ElectronicsGeneral') THEN 'Electronics'
      WHEN REGEXP_CONTAINS(category, r'^ElectronicsAccessories') THEN 'Electronics'
      WHEN REGEXP_CONTAINS(category, r'^ElectronicsHomeAudio') THEN 'Electronics'
      WHEN REGEXP_CONTAINS(category, r'^ElectronicsCameras') THEN 'Electronics'
      WHEN REGEXP_CONTAINS(category, r'^ToysGames') THEN 'Toys Games'
      WHEN REGEXP_CONTAINS(category, r'^ElectronicsHeadphone') THEN 'Electronics'
      WHEN REGEXP_CONTAINS(category, r'^CarMotorbikeCar') THEN 'Car Motorbike '
      ELSE REGEXP_EXTRACT(category, r'^[a-zA-Z]+')
    END
  ) AS category_limpa
FROM
  amazon_sales.amazon_tratada_limpa;

WITH discount_quartil AS (
  -- Criação da nova variável discount_quartil na tabela amazon_completa
  SELECT
    product_id,
    product_name,
    category,
    discount_percentage,
    rating,
    score_sentimento,
    CASE
      WHEN discount_percentage < 0.10 THEN 1
      WHEN discount_percentage BETWEEN 0.10 AND 0.20 THEN 2
      WHEN discount_percentage BETWEEN 0.21 AND 0.40 THEN 3
      WHEN discount_percentage > 0.40 THEN 4
      ELSE NULL -- Caso queira tratar valores não esperados
    END AS discount_quartil,
    CASE
      WHEN discount_percentage < 0.10 THEN 'baixo'
      WHEN discount_percentage BETWEEN 0.10 AND 0.20 THEN 'medio'
      WHEN discount_percentage BETWEEN 0.21 AND 0.40 THEN 'medio'
      WHEN discount_percentage > 0.40 THEN 'alto'
      ELSE NULL -- para tratar valores não esperados
    END AS discount_seg
  FROM
    `datalab-amazon-produtos.amazon_sales.amazon_completa_backup`
),
rating_quartil AS (
  -- Criação da nova variável rating_quartil na tabela amazon_completa
  SELECT
    product_id,
    CASE
      WHEN rating BETWEEN 1.0 AND 2.0 THEN 1
      WHEN rating BETWEEN 2.1 AND 3.0 THEN 2
      WHEN rating BETWEEN 3.1 AND 4.0 THEN 3
      WHEN rating > 4.0 THEN 4
      ELSE NULL -- para tratar valores não esperados
    END AS rating_quartil,
    CASE
      WHEN rating BETWEEN 1.0 AND 2.0 THEN 'baixo'
      WHEN rating BETWEEN 2.1 AND 3.0 THEN 'medio'
      WHEN rating BETWEEN 3.1 AND 4.0 THEN 'medio'
      WHEN rating > 4.0 THEN 'alto'
      ELSE NULL -- para tratar valores não esperados
    END AS rating_seg
  FROM
    `datalab-amazon-produtos.amazon_sales.amazon_completa_backup`
),
sentimento_quartil2 AS (
  -- Criação da nova variável sentimento_quartil na tabela amazon_completa
  SELECT
  product_id,
  CASE
    WHEN score_sentimento BETWEEN -0.90 AND 0.00 THEN 1
    WHEN score_sentimento BETWEEN 0.01 AND 0.25 THEN 2
    WHEN score_sentimento BETWEEN 0.26 AND 0.50 THEN 3
    WHEN score_sentimento BETWEEN 0.51 AND 1.00 THEN 4
    ELSE NULL  -- para tratar valores não esperados
  END AS sentimento_quartil
FROM
  `datalab-amazon-produtos.amazon_sales.amazon_completa_backup`

),
score_seg AS (
  -- Criando segmentação para variável score_sentimento
  SELECT
    product_id,
    CASE
      WHEN sentimento_quartil = 1 THEN 'ruim'
      WHEN sentimento_quartil IN (2, 3) THEN 'neutro'
      WHEN sentimento_quartil = 4 THEN 'positivo'
      ELSE NULL -- para tratar valores não esperados
    END AS score_seg
  FROM
    sentimento_quartil2
)

-- Selecionando e sobrescrevendo a tabela amazon_completa com as novas variáveis
SELECT
  a.*,
  d.discount_quartil,
  d.discount_seg,
  r.rating_quartil,
  r.rating_seg,
  s.sentimento_quartil,
  ss.score_seg
FROM
  `datalab-amazon-produtos.amazon_sales.amazon_completa_backup` a
LEFT JOIN discount_quartil d ON a.product_id = d.product_id
LEFT JOIN rating_quartil r ON a.product_id = r.product_id
LEFT JOIN sentimento_quartil2 s ON a.product_id = s.product_id
LEFT JOIN score_seg ss ON a.product_id = ss.product_id;

  # Consultando quantidade por categoria
  SELECT 
  score_seg,
  COUNT(product_id) AS num_products
FROM 
  `datalab-amazon-produtos.amazon_sales.amazon_completa`
GROUP BY 
  score_seg
ORDER BY 
  num_products DESC;