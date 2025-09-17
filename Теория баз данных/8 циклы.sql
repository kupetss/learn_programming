-- 1. ОСНОВНАЯ СТРУКТУРА WHILE ЦИКЛА
--DECLARE @counter INT = 1; -- DECLARE: Объявление переменной-счетчика; @counter: Имя переменной; INT: Тип данных целое число; = 1: Инициализация начальным значением

--WHILE @counter <= 5 -- WHILE: Начало цикла "пока"; @counter <= 5: Условие продолжения цикла (пока истинно)
--BEGIN -- BEGIN: Начало блока кода, который будет выполняться в цикле
--    PRINT 'Итерация: ' + CAST(@counter AS VARCHAR(10)); -- PRINT: Вывод сообщения; +: Конкатенация строк; CAST: Преобразование типа; AS VARCHAR(10): В строку длиной 10 символов
--    SET @counter = @counter + 1; -- SET: Присвоение нового значения; @counter + 1: Увеличение счетчика на 1
--END -- END: Конец блока кода цикла

-- 2. ЦИКЛ С ПРЕРЫВАНИЕМ BREAK
--DECLARE @i INT = 1; -- @i: Имя переменной-счетчика

--WHILE @i <= 10 -- Цикл выполняется пока i <= 10
--BEGIN
--    PRINT 'Текущее значение: ' + CAST(@i AS VARCHAR(10)); -- Вывод текущего значения счетчика
    
--    IF @i = 5 -- IF: Условный оператор; @i = 5: Проверка равенства
--    BEGIN
--        PRINT 'Прерывание цикла на 5-й итерации'; -- Сообщение о прерывании
--        BREAK; -- BREAK: Принудительный выход из цикла
--    END
    
--    SET @i = @i + 1; -- Увеличение счетчика
--END

-- 3. ЦИКЛ С ПРОПУСКОМ ИТЕРАЦИИ CONTINUE
--DECLARE @j INT = 0; -- @j: Имя переменной-счетчика

--WHILE @j < 10 -- Цикл выполняется пока j < 10
--BEGIN
--    SET @j = @j + 1; -- Увеличение счетчика в начале итерации
    
--    IF @j % 2 = 0 -- IF: Условие; @j % 2 = 0: Проверка на четность (% - оператор остатка от деления)
--    BEGIN
--        PRINT 'Пропускаем четное число: ' + CAST(@j AS VARCHAR(10)); -- Сообщение о пропуске
--        CONTINUE; -- CONTINUE: Переход к следующей итерации цикла (пропуск оставшегося кода)
--    END
    
--    PRINT 'Обрабатываем нечетное число: ' + CAST(@j AS VARCHAR(10)); -- Вывод для нечетных чисел
--END

-- 4. БЕСКОНЕЧНЫЙ ЦИКЛ С ВЫХОДОМ ПО УСЛОВИЮ
--DECLARE @k INT = 1; -- @k: Счетчик цикла

--WHILE 1 = 1 -- WHILE: Бесконечный цикл (условие всегда истинно)
--BEGIN
--    PRINT 'Итерация бесконечного цикла: ' + CAST(@k AS VARCHAR(10)); -- Вывод номера итерации
    
--    IF @k >= 7 -- Условие выхода из цикла
--    BEGIN
--        PRINT 'Достигнут предел в 7 итераций - выход из цикла'; -- Сообщение о выходе
--        BREAK; -- Выход из бесконечного цикла
--    END
    
--    SET @k = @k + 1; -- Увеличение счетчика
    
--    WAITFOR DELAY '00:00:01'; -- WAITFOR: Пауза; DELAY: Задержка; '00:00:01': 1 секунда
--END

-- 5. ЦИКЛ С ОБРАБОТКОЙ ДАННЫХ ИЗ ТАБЛИЦЫ
-- Создание временной таблицы для демонстрации
--CREATE TABLE #TempProducts ( -- #TempProducts: Временная таблица (существует только в текущей сессии)
--    ProductID INT IDENTITY PRIMARY KEY, -- ProductID: Первичный ключ; IDENTITY: Автоинкремент
--    ProductName NVARCHAR(50) NOT NULL, -- ProductName: Название продукта; NOT NULL: Обязательное поле
--    Price DECIMAL(10,2) NOT NULL, -- Price: Цена; DECIMAL(10,2): Число с 2 знаками после запятой
--    Discounted BIT DEFAULT 0 -- Discounted: Флаг скидки; BIT: Булев тип (0/1); DEFAULT 0: Значение по умолчанию
--);

-- Заполнение таблицы тестовыми данными
--INSERT INTO #TempProducts (ProductName, Price) VALUES -- INSERT INTO: Вставка данных
--('Товар 1', 100.00),
--('Товар 2', 200.00),
--('Товар 3', 300.00),
--('Товар 4', 400.00),
--('Товар 5', 500.00);

-- Объявление переменных для цикла
--DECLARE @ProductID INT; -- @ProductID: Для хранения ID продукта
--DECLARE @ProductName NVARCHAR(50); -- @ProductName: Для хранения названия
--DECLARE @Price DECIMAL(10,2); -- @Price: Для хранения цены
--DECLARE @Counter2 INT = 1; -- @Counter2: Счетчик итераций
--DECLARE @TotalRows INT; -- @TotalRows: Общее количество строк

-- Получение общего количества записей
--SELECT @TotalRows = COUNT(*) FROM #TempProducts; -- SELECT: Выборка; COUNT(*): Подсчет всех строк

--WHILE @Counter2 <= @TotalRows -- Цикл по всем строкам таблицы
--BEGIN
--     Выборка данных текущей строки
--    SELECT 
--        @ProductID = ProductID, -- Присвоение значений переменным
--        @ProductName = ProductName,
--        @Price = Price
--    FROM #TempProducts 
--    WHERE ProductID = @Counter2; -- WHERE: Фильтрация по ID
    
--     Применение скидки 10% для товаров дороже 250
--    IF @Price > 250.00 -- Условие применения скидки
--    BEGIN
--        UPDATE #TempProducts -- UPDATE: Обновление данных
--        SET 
--            Price = Price * 0.9, -- SET: Установка новой цены (скидка 10%)
--            Discounted = 1 -- Установка флага скидки
--        WHERE ProductID = @ProductID; -- WHERE: Условие обновления конкретной строки
        
--        PRINT 'Применена скидка к товару: ' + @ProductName; -- Сообщение о применении скидки
--    END
    
--    SET @Counter2 = @Counter2 + 1; -- Увеличение счетчика
--END

-- Вывод результатов обработки
--SELECT * FROM #TempProducts; -- SELECT: Выборка всех данных из временной таблицы

-- Удаление временной таблицы
--DROP TABLE #TempProducts; -- DROP TABLE: Удаление таблицы

-- 6. ВЛОЖЕННЫЕ ЦИКЛЫ
--DECLARE @outer INT = 1; -- @outer: Счетчик внешнего цикла
--DECLARE @inner INT; -- @inner: Счетчик внутреннего цикла

--WHILE @outer <= 3 -- Внешний цикл (3 итерации)
--BEGIN
--    PRINT 'Внешний цикл, итерация: ' + CAST(@outer AS VARCHAR(10));
    
--    SET @inner = 1; -- Сброс счетчика внутреннего цикла
--    WHILE @inner <= 2 -- Внутренний цикл (2 итерации)
--    BEGIN
--        PRINT '  Внутренний цикл, итерация: ' + CAST(@inner AS VARCHAR(10));
--        SET @inner = @inner + 1; -- Увеличение внутреннего счетчика
--    END
    
--    SET @outer = @outer + 1; -- Увеличение внешнего счетчика
--END

-- 7. ЦИКЛ С ОБРАБОТКОЙ ОШИБОК
--DECLARE @attempt INT = 1; -- @attempt: Счетчик попыток
--DECLARE @success BIT = 0; -- @success: Флаг успешного выполнения

--WHILE @attempt <= 3 AND @success = 0 -- Цикл до 3 попыток или успеха
--BEGIN
--    BEGIN TRY -- BEGIN TRY: Начало блока обработки ошибок
--        PRINT 'Попытка №' + CAST(@attempt AS VARCHAR(10));
        
--         Имитация операции, которая может вызвать ошибку
--        IF @attempt = 2 -- На второй попытке имитируем ошибку
--            RAISERROR('Искусственная ошибка', 16, 1); -- RAISERROR: Генерация ошибки
        
--        SET @success = 1; -- Успешное выполнение
--        PRINT 'Операция выполнена успешно!';
--    END TRY
--    BEGIN CATCH -- BEGIN CATCH: Обработка ошибок
--        PRINT 'Ошибка: ' + ERROR_MESSAGE(); -- ERROR_MESSAGE(): Функция получения текста ошибки
--        SET @attempt = @attempt + 1; -- Увеличение счетчика попыток
        
--        IF @attempt > 3 -- Если попытки исчерпаны
--            PRINT 'Все попытки завершились ошибкой!';
--    END CATCH
--END

-- 8. ПРАКТИЧЕСКИЙ ПРИМЕР: ГЕНЕРАЦИЯ ДАТ
--DECLARE @startDate DATE = '2024-01-01'; -- @startDate: Начальная дата
--DECLARE @endDate DATE = '2024-01-10'; -- @endDate: Конечная дата
--DECLARE @currentDate DATE = @startDate; -- @currentDate: Текущая дата в цикле

-- Создание таблицы для результатов
--CREATE TABLE #DateTable (
--    DateID INT IDENTITY PRIMARY KEY,
--    DateValue DATE NOT NULL,
--    DayOfWeek NVARCHAR(20) NOT NULL
--);

--WHILE @currentDate <= @endDate -- Цикл по диапазону дат
--BEGIN
--     Вставка данных в таблицу
--    INSERT INTO #DateTable (DateValue, DayOfWeek)
--    VALUES (
--        @currentDate,
--        DATENAME(WEEKDAY, @currentDate) -- DATENAME: Получение названия дня недели
--    );
    
--    SET @currentDate = DATEADD(DAY, 1, @currentDate); -- DATEADD: Добавление 1 дня
--END

-- Вывод результатов
--SELECT * FROM #DateTable;

-- Очистка
--DROP TABLE #DateTable;

-- ВАЖНЫЕ ЗАМЕЧАНИЯ ПО ИСПОЛЬЗОВАНИЮ ЦИКЛОВ
--1. ЦИКЛЫ В SQL - ЭТО КРАЙНЯЯ МЕРА. В большинстве случаев операции с наборами данных
--   эффективнее выполнять с помощью операторов SELECT, UPDATE, DELETE с условиями WHERE.

--2. КУРСОРЫ VS ЦИКЛЫ. Для обработки строк таблиц часто лучше использовать курсоры,
--   но они также могут быть медленными. Всегда оценивайте производительность.

--3. БЕСКОНЕЧНЫЕ ЦИКЛЫ. Всегда предусматривайте условие выхода из цикла, чтобы
--   избежать бесконечного выполнения.

--4. ПРОИЗВОДИТЕЛЬНОСТЬ. Циклы в SQL обычно медленнее, чем операции с наборами.
--   Используйте их только когда действительно необходимо обрабатывать данные построчно.

--5. ТРАНЗАКЦИИ. При работе с циклами, изменяющими данные,考虑使用 транзакций
--   для обеспечения целостности данных.
