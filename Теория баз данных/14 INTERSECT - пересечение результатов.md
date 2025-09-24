### **Что такое INTERSECT?**

**INTERSECT** - это оператор SQL, который возвращает **только те строки, которые есть в РЕЗУЛЬТАТАХ ВСЕХ запросов**.

**Математическая аналогия:** Пересечение двух множеств - это элементы, которые принадлежат и первому, и второму множеству.

**Простая аналогия:** Какие студенты посещают и математику, и физику? Только те, кто есть в обоих списках.

---

### **Базовый синтаксис**

```sql

SELECT столбец1, столбец2 FROM таблица1
INTERSECT
SELECT столбец1, столбец2 FROM таблица2
```

---

### **Пример 1: Общие товары в ассортименте**

**Создадим тестовые таблицы:**
```sql
-- Текущий ассортимент
CREATE TABLE Current_Products (
    ProductID INT,
    ProductName VARCHAR(50),
    Price MONEY
);

-- Новый ассортимент (частично пересекается)
CREATE TABLE New_Products (
    ProductID INT, 
    ProductName VARCHAR(50),
    Price MONEY
);

-- Заполняем данными
INSERT INTO Current_Products VALUES 
(1, 'Телевизор', 30000),
(2, 'Холодильник', 25000),
(3, 'Стиральная машина', 20000),
(4, 'Микроволновка', 8000);

INSERT INTO New_Products VALUES 
(3, 'Стиральная машина', 22000),  -- Есть в обоих (пересечение)
(4, 'Микроволновка', 7500),       -- Есть в обоих (пересечение)  
(5, 'Кофемашина', 15000),         -- Только в новых
(6, 'Пылесос', 12000);            -- Только в новых
```

**Выполним INTERSECT:**

```sql

SELECT ProductName FROM Current_Products
INTERSECT
SELECT ProductName FROM New_Products;
```

**Что происходит построчно:**

1. **`SELECT ProductName FROM Current_Products`** - получаем все товары из текущего ассортимента
    - Результат:      
```text
    
    Телевизор
    Холодильник
    Стиральная машина
    Микроволновка
```
    
2. **`INTERSECT`** - ключевое слово, которое говорит SQL Server: "Теперь найди общие элементы со следующим запросом"
   
3. **`SELECT ProductName FROM New_Products`** - получаем все товары из нового ассортимента
    
    - Результат:
```text
    Стиральная машина
    Микроволновка  
    Кофемашина
    Пылесос
```
    
4. **SQL Server находит пересечение:**
    
    - Берет первую таблицу: {Телевизор, Холодильник, Стиральная машина, Микроволновка}
    - Берет вторую таблицу: {Стиральная машина, Микроволновка, Кофемашина, Пылесос}
    - **Возвращает только то, что есть в обоих:** {Стиральная машина, Микроволновка}

**Итоговый результат:**

```text

Стиральная машина
Микроволновка
```

---

### **Важные правила INTERSECT**

#### **Правило 1: Совместимость столбцов (как в UNION)**

```sql
-- ПРАВИЛЬНО - одинаковое количество и типы столбцов
SELECT Name, Age FROM Table1
INTERSECT
SELECT Name, Age FROM Table2

-- НЕПРАВИЛЬНО - разное количество столбцов
SELECT Name, Age FROM Table1
INTERSECT
SELECT Name FROM Table2  -- ОШИБКА!

-- НЕПРАВИЛЬНО - несовместимые типы данных  
SELECT Name, Age FROM Table1  -- текст, число
INTERSECT
SELECT Name, City FROM Table2 -- текст, текст (City vs Age) - ОШИБКА!

```
#### **Правило 2: INTERSECT учитывает ВСЕ столбцы**

```sql

SELECT ProductName, Price FROM Current_Products
INTERSECT
SELECT ProductName, Price FROM New_Products;
```

Этот запрос вернет **только те строки, где совпадает И название, И цена!**

Для наших данных:

- 'Стиральная машина' - цена разная (20000 vs 22000) - **НЕ войдет в результат**  
- 'Микроволновка' - цена разная (8000 vs 7500) - **НЕ войдет в результат**

**Результат будет ПУСТЫМ**, потому что нет полного совпадения по всем столбцам.

---

### **Пример 2: Сотрудники в двух отделах**

**Создадим таблицы:**

```sql

-- Сотрудники IT-отдела
CREATE TABLE IT_Department (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(50),
    Position VARCHAR(50)
);

-- Сотрудники отдела поддержки
CREATE TABLE Support_Department (
    EmployeeID INT PRIMARY KEY, 
    Name VARCHAR(50),
    Position VARCHAR(50)
);

-- Заполняем данными
INSERT INTO IT_Department VALUES
(101, 'Анна Петрова', 'Разработчик'),
(102, 'Иван Сидоров', 'Системный администратор'),
(103, 'Мария Козлова', 'Тестировщик'),
(104, 'Алексей Волков', 'Аналитик');

INSERT INTO Support_Department VALUES
(103, 'Мария Козлова', 'Старший специалист'),  -- Работает в обоих отделах!
(104, 'Алексей Волков', 'Менеджер'),           -- Работает в обоих отделах!
(105, 'Дмитрий Орлов', 'Специалист'),
(106, 'Елена Новикова', 'Консультант');
```

**Найдем сотрудников, работающих в обоих отделах:**

```sql
SELECT EmployeeID FROM IT_Department
INTERSECT
SELECT EmployeeID FROM Support_Department;
```

**Результат:**

```text
103
104
```

**Можно получить больше информации:**

```sql
SELECT e.EmployeeID, e.Name, e.Position 
FROM IT_Department e
WHERE e.EmployeeID IN (
    SELECT EmployeeID FROM IT_Department
    INTERSECT
    SELECT EmployeeID FROM Support_Department
);
```

**Результат:**

```text
103  Мария Козлова   Тестировщик
104  Алексей Волков  Аналитик
```

---

### **Пример 3: INTERSECT с несколькими столбцами**

**Найдем клиентов с одинаковыми именами и городами:**

```sql
-- Клиенты из основной базы
SELECT Name, City FROM Primary_Customers
INTERSECT
SELECT Name, City FROM Secondary_Customers
```

Это вернет только тех клиентов, у которых совпадает **и имя, и город**.

---

### **Пример 4: INTERSECT vs IN**

**INTERSECT с одним столбцом можно заменить на IN:**

```sql
-- Эти два запроса эквивалентны:
SELECT ProductName FROM Current_Products
INTERSECT
SELECT ProductName FROM New_Products;

SELECT ProductName FROM Current_Products
WHERE ProductName IN (SELECT ProductName FROM New_Products);
```

**НО! INTERSECT с несколькими столбцами сложнее заменить:**

```sql
-- Просто с INTERSECT:
SELECT Name, City FROM Table1
INTERSECT
SELECT Name, City FROM Table2;

-- Эквивалент с EXISTS (более сложный синтаксис):
SELECT Name, City FROM Table1 t1
WHERE EXISTS (
    SELECT 1 FROM Table2 t2 
    WHERE t2.Name = t1.Name AND t2.City = t1.City
);
```

---

### **Пример 5: INTERSECT трех таблиц**

```sql
-- Какие товары есть во всех трех магазинах?
SELECT ProductName FROM Shop1_Products
INTERSECT
SELECT ProductName FROM Shop2_Products  
INTERSECT
SELECT ProductName FROM Shop3_Products;
```

Это вернет товары, которые присутствуют **в Shop1, и в Shop2, и в Shop3**.

---

### **INTERSECT и NULL значения**

**Важно:** INTERSECT считает NULL = NULL для целей сравнения.

```sql
CREATE TABLE Table1 (Name VARCHAR(50), City VARCHAR(50));
CREATE TABLE Table2 (Name VARCHAR(50), City VARCHAR(50));

INSERT INTO Table1 VALUES ('Иван', NULL), ('Петр', 'Москва');
INSERT INTO Table2 VALUES ('Иван', NULL), ('Мария', 'СПб');

SELECT Name, City FROM Table1
INTERSECT
SELECT Name, City FROM Table2;
```

**Результат:**

```text
Иван   NULL
```

---

### **Сортировка результатов INTERSECT**

**ORDER BY ставится в конце:**

```sql
SELECT ProductName FROM Current_Products
INTERSECT  
SELECT ProductName FROM New_Products
ORDER BY ProductName;  -- Отсортируем по алфавиту
```
