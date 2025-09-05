# Конспект: Операторы IN, BETWEEN и условия 
## 1. Оператор IN
### Назначение
Оператор IN позволяет указать несколько значений в условии WHERE, заменяя несколько операторов OR.

```
SELECT column1, column2, ...
FROM table_name
WHERE column_name IN (value1, value2, ...);
```

### Примеры
```
-- Выбрать всех клиентов из Германии, Франции или Великобритании
SELECT * FROM Customers
WHERE Country IN ('Germany', 'France', 'UK');

-- Выбрать всех клиентов НЕ из Германии, Франции или Великобритании
SELECT * FROM Customers
WHERE Country NOT IN ('Germany', 'France', 'UK');

-- С подзапросом
SELECT * FROM Products
WHERE CategoryID IN (SELECT CategoryID FROM Categories WHERE CategoryName IN ('Beverages', 'Dairy Products'));
```
Работает с NOT для отрицания

## 2. Оператор BETWEEN
### Назначение
Оператор BETWEEN выбирает значения в заданном диапазоне (включительно).

```
SELECT column1, column2, ...
FROM table_name
WHERE column_name BETWEEN value1 AND value2;
```

### Примеры
```
-- Выбрать продукты с ценой от 10 до 20
SELECT * FROM Products
WHERE Price BETWEEN 10 AND 20;

-- Выбрать продукты с ценой НЕ от 10 до 20
SELECT * FROM Products
WHERE Price NOT BETWEEN 10 AND 20;

-- С датами
SELECT * FROM Orders
WHERE OrderDate BETWEEN '2023-01-01' AND '2023-12-31';

-- С текстовыми значениями
SELECT * FROM Products
WHERE ProductName BETWEEN 'C' AND 'M';
```

Работает с числами, датами и текстом

Может использоваться с NOT

## 3. Логические операторы (AND, OR, NOT)
### Оператор AND
```
SELECT * FROM Customers
WHERE Country = 'Germany' AND City = 'Berlin';
```

### Оператор OR
```
SELECT * FROM Customers
WHERE City = 'Berlin' OR City = 'München';
```
### Комбинация AND/OR
```
SELECT * FROM Customers
WHERE Country = 'Germany' AND (City = 'Berlin' OR City = 'München');
```

### Оператор NOT
```
SELECT * FROM Customers
WHERE NOT Country = 'Germany';
```