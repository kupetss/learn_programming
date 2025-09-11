# GROUP BY, HAVING
```sql
-- Создаем новую базу данных для нашего примера
CREATE DATABASE SaleReportDB;

-- Переключаем контекст на созданную базу
USE SaleReportDB;

-- Создаем таблицу "Продажи"
CREATE TABLE Sales (
    SaleID INT IDENTITY(1,1) PRIMARY KEY,      -- Уникальный ID продажи (автоинкремент)
    ProductCategory NVARCHAR(50) NOT NULL,     -- Категория товара
    ProductName NVARCHAR(100) NOT NULL,        -- Название товара
    SaleDate DATE NOT NULL,                    -- Дата продажи
    Quantity INT NOT NULL,                     -- Количество проданного товара
    UnitPrice DECIMAL(10, 2) NOT NULL,         -- Цена за единицу
    Region NVARCHAR(50) NOT NULL               -- Регион продажи
);

-- Вставляем тестовые данные о продажах
INSERT INTO Sales (ProductCategory, ProductName, SaleDate, Quantity, UnitPrice, Region) VALUES
('Ноутбуки', 'Dell XPS 13', '2024-01-15', 2, 1250.00, 'Москва'),
('Ноутбуки', 'Dell XPS 13', '2024-01-20', 1, 1250.00, 'Санкт-Петербург'),
('Ноутбуки', 'MacBook Pro 16', '2024-01-18', 1, 2399.99, 'Москва'),
('Смартфоны', 'iPhone 15', '2024-01-15', 3, 899.99, 'Новосибирск'),
('Смартфоны', 'iPhone 15', '2024-01-22', 2, 899.99, 'Москва'),
('Смартфоны', 'Samsung Galaxy S24', '2024-01-19', 2, 999.99, 'Санкт-Петербург'),
('Смартфоны', 'Samsung Galaxy S24', '2024-01-25', 1, 999.99, 'Москва'),
('Ноутбуки', 'MacBook Pro 16', '2024-02-05', 2, 2399.99, 'Новосибирск'),
('Планшеты', 'iPad Air', '2024-02-10', 3, 749.99, 'Москва'),
('Планшеты', 'iPad Air', '2024-02-15', 1, 749.99, 'Санкт-Петербург'),
('Ноутбуки', 'Dell XPS 13', '2024-02-20', 1, 1199.99, 'Новосибирск');  -- Обратите внимание: цена изменилась


-- 1. Общее количество проданных товаров ПО КАТЕГОРИЯМ
SELECT 
    ProductCategory,
    SUM(Quantity) AS TotalUnitsSold
FROM Sales
GROUP BY ProductCategory;

-- 2. Общая выручка по каждой категории товаров
-- Выручка = Quantity * UnitPrice для каждой продажи, затем суммируем
SELECT 
    ProductCategory,
    SUM(Quantity * UnitPrice) AS TotalRevenue
FROM Sales
GROUP BY ProductCategory;

-- 3. Количество продаж по каждому региону
SELECT 
    Region,
    COUNT(*) AS SalesCount
FROM Sales
GROUP BY Region;

-- 4. Средний чек (средняя сумма продажи) по категориям
SELECT 
    ProductCategory,
    AVG(Quantity * UnitPrice) AS AvgSaleAmount
FROM Sales
GROUP BY ProductCategory;

-- 5. Группировка по нескольким полям: Категория + Регион
SELECT 
    ProductCategory,
    Region,
    COUNT(*) AS SalesCount,
    SUM(Quantity * UnitPrice) AS TotalRevenue
FROM Sales
GROUP BY ProductCategory, Region
ORDER BY ProductCategory, TotalRevenue DESC;
```

# HAVING
WHERE фильтрует строки ДО группировки, HAVING фильтрует результаты ПОСЛЕ группировки.
```sql
-- 1. Показать только те категории, у которых общая выручка больше 5000
SELECT 
    ProductCategory,
    SUM(Quantity * UnitPrice) AS TotalRevenue
FROM Sales
GROUP BY ProductCategory
HAVING SUM(Quantity * UnitPrice) > 5000;

-- 2. Регионы, в которых было более 2 продаж
SELECT 
    Region,
    COUNT(*) AS SalesCount
FROM Sales
GROUP BY Region
HAVING COUNT(*) > 2;

-- 3. Категории, где средний чек превышает 1000
SELECT 
    ProductCategory,
    AVG(Quantity * UnitPrice) AS AvgSaleAmount
FROM Sales
GROUP BY ProductCategory
HAVING AVG(Quantity * UnitPrice) > 1000;

-- 4. Комбинация WHERE и HAVING
-- Сначала отфильтруем продажи за Февраль 2024 (WHERE), 
-- затем сгруппируем и отфильтруем по выручке (HAVING)
SELECT 
    ProductCategory,
    SUM(Quantity * UnitPrice) AS TotalRevenue
FROM Sales
WHERE SaleDate >= '2024-02-01' AND SaleDate < '2024-03-01'  -- Фильтр ДО группировки
GROUP BY ProductCategory
HAVING SUM(Quantity * UnitPrice) > 1000;                    -- Фильтр ПОСЛЕ группировки
```
