--DECLARE @MyInt INT; -- DECLARE: Объявление переменной; @MyInt: Имя переменной; INT: Тип данных целое число
--DECLARE @MyString NVARCHAR(50); -- @MyString: Имя переменной; NVARCHAR(50): Тип данных строка Unicode длиной до 50 символов
--DECLARE @MyDate DATE, @Price DECIMAL(10,2); -- @MyDate: Имя переменной; DATE: Тип данных дата; @Price: Имя переменной; DECIMAL(10,2): Тип данных десятичное число (10 цифр всего, 2 после запятой)

--SET @MyInt = 42; -- SET: Присвоение значения; = 42: Присваивание числового значения
--SET @MyString = N'Привет!'; -- N: Префикс для строки Unicode; 'Привет!': Строковое значение
--SET @MyDate = GETDATE(); -- GETDATE(): Функция получения текущей даты и времени

--DECLARE @Test INT = 13; -- Объявление переменной с одновременной инициализацией значением 13
--PRINT @MyDate; -- PRINT: Вывод значения в сообщения
--SELECT @MyString AS MYstr; -- SELECT: Выборка данных; AS: Псевдоним для столбца; MYstr: Имя столбца в результате

--DECLARE @Age INT = 70; -- @Age: Имя переменной для возраста; = 70: Начальное значение
--DECLARE @Money DECIMAL(6,0) -- @Money: Имя переменной для денежной суммы; DECIMAL(6,0): Тип данных (6 цифр, 0 после запятой)

--IF @Age < 18 -- IF: Условный оператор; <: Оператор сравнения "меньше"; 18: Числовое значение
--	PRINT 'НЕСОВЕРШЕННОЛЕТНИЙ' -- Вывод текстового сообщения
--IF @Age >= 60 -- >=: Оператор сравнения "больше или равно"
--BEGIN -- BEGIN: Начало блока кода
--	SET @Money = 1500; -- Присваивание значения переменной
--	PRINT @Money -- Вывод значения переменной
--	PRINT 'СКИДКА ДЛЯ ПЕНСИОНЕРОВ' -- Вывод текстового сообщения
--END -- END: Конец блока кода

--IF @Age BETWEEN 18 AND 25 -- BETWEEN: Оператор диапазона; AND: Логическое "И"
--	SET @Money = 5; -- Присваивание значения 5
--ELSE IF @Age BETWEEN 26 AND 35 -- ELSE: Иначе; IF: Вложенное условие
--	SET @Money = 15; -- Присваивание значения 15
--ELSE -- ELSE: Во всех остальных случаях
--	SET @Money = 30 -- Присваивание значения 30
--PRINT 'РАЗМЕР СКИДКИ: ' + CAST(@Money AS NVARCHAR(50)) + '%'; -- +: Конкатенация строк; CAST: Преобразование типа данных; AS: Указание целевого типа; '%': Символ процента

--CREATE TABLE Customers
--(
--	Id INT IDENTITY PRIMARY KEY,
--	FirstName NVARCHAR(50) NOT NULL,
--	LastName NVARCHAR(50) NOT NULL,
--	Email NVARCHAR(50) NOT NULL,
--	Data DATE NOT NULL,
--	RegistrationDate DATE DEFAULT GETDATE(),
--	Discount DECIMAL(5,2) DEFAULT 0.00
--);

--INSERT INTO Customers(FirstName, LastName, Email, Data)
--VALUES
--('Ваня','Иванов','ivan@mail.ru','2002-09-01'),
--('Пеня','Петров','pety@mail.ru','2007-07-07'),
--('Матвей','Матвеев','matvay@mail.ru','1999-03-06'),
--('Ира','Сидорова','irka@mail.ru','2005-08-31');

--DECLARE @Id INT;
--DECLARE @FirstName NVARCHAR(50);
--DECLARE @LastName NVARCHAR(50);
--DECLARE @Data DATE;
--DECLARE @Age INT;
--DECLARE @Discount DECIMAL(5,2);
--DECLARE @Message NVARCHAR(100);

--DECLARE customers_cursor CURSOR LOCAL FOR -- DECLARE: Объявление; customers_cursor: Имя курсора; CURSOR: Тип переменной (курсор); LOCAL: Область видимости (локальная); FOR: Для
--    SELECT Id, FirstName, LastName, Data -- SELECT: Выборка; Id, FirstName, LastName, Data: Столбцы для выборки
--    FROM Customers; -- FROM: Из таблицы; Customers: Имя таблицы

--OPEN customers_cursor -- OPEN: Открытие курсора для работы с данными
--FETCH NEXT FROM customers_cursor INTO @Id, @FirstName, @LastName, @Data; -- FETCH: Извлечение; NEXT: Следующая запись; FROM: Из; INTO: В переменные; @Id, @FirstName, @LastName, @Data: Переменные для сохранения данных
--WHILE @@FETCH_STATUS = 0 -- WHILE: Цикл "пока"; @@FETCH_STATUS: Системная переменная статуса извлечения; = 0: Успешное извлечение (0 = успех)
--BEGIN -- BEGIN: Начало блока кода цикла
--    SET @Age = DATEDIFF(YEAR,@Data, GETDATE()); -- SET: Присвоение; DATEDIFF: Функция разницы дат; YEAR: Год; @Data: Дата рождения; GETDATE(): Текущая дата
--    IF DATEADD(YEAR,@Age, @Data) > GETDATE() -- IF: Условие; DATEADD: Функция добавления интервала; >: Больше чем
--        SET @Age = @Age - 1 -- Уменьшение возраста на 1 если день рождения еще не наступил в этом году
        
--    IF @Age < 18 -- Если возраст меньше 18
--    BEGIN -- Начало блока условия
--        SET @Discount = 0.0 -- Установка скидки 0%
--        SET @Message = 'Несовершеннолетний'; -- Установка сообщения
--    END -- Конец блока условия
--    ELSE -- ELSE: Иначе (если возраст 18 и больше)
--    BEGIN -- Начало блока else
--        SET @Discount = 10.0 -- Установка скидки 10%
--        SET @Message = 'Совершеннолетний'; -- Установка сообщения
--    END -- Конец блока else
    
--    UPDATE Customers -- UPDATE: Обновление данных; Customers: Целевая таблица
--    SET Discount = @Discount -- SET: Установка значения; Discount: Столбец для обновления
--    WHERE Id = @Id; -- WHERE: Условие фильтрации; Id = @Id: Обновление только текущей записи
    
--    PRINT @FirstName + ' ' + @LastName + ': ' + @Message + ', скидка: ' + CAST(@Discount AS NVARCHAR(10)) + '%'; -- PRINT: Вывод; +: Конкатенация строк; CAST: Преобразование типа; AS: В тип; NVARCHAR(10): Строковый тип
    
--    FETCH NEXT FROM customers_cursor INTO @Id, @FirstName, @LastName, @Data; -- Извлечение следующей записи
--END -- Конец цикла WHILE

--IF CURSOR_STATUS('local', 'customers_cursor') >= 0 -- IF: Условие; CURSOR_STATUS: Функция проверки статуса курсора; 'local': Область видимости; 'customers_cursor': Имя курсора; >= 0: Курсор открыт (-1 = закрыт, -2 = не существует, -3 = не объявлен)
--BEGIN -- Начало блока условия
--    CLOSE customers_cursor; -- CLOSE: Закрытие курсора (освобождение ресурсов)
--    DEALLOCATE customers_cursor; -- DEALLOCATE: Освобождение памяти курсора
--END -- Конец блока условия


--IF EXISTS(SELECT Email FROM CUSTOMERS WHERE EMAIL = 'irka@mail.ru') -- IF EXISTS: Проверка существования записей; SELECT: Выборка; Email: Столбец; FROM: Из; WHERE: Условие; =: Равно
--    PRINT 'GOOD' -- Вывод если запись существует
--ELSE -- ELSE: Иначе
--    PRINT'NO GOOD' -- Вывод если запись не существует

--DECLARE @COUNT INT; -- DECLARE: Объявление переменной; @COUNT: Имя переменной; INT: Тип целое число
--SELECT @COUNT = COUNT(*) FROM CUSTOMERS; -- SELECT: Выборка; @COUNT =: Присвоение переменной; COUNT(*): Функция подсчета всех записей; FROM: Из таблицы
--IF @COUNT > 3 -- IF: Условие; >: Больше чем; 3: Числовое значение
--    PRINT 'GOOD' -- Вывод если количество больше 3
--ELSE -- ELSE: Иначе
--    PRINT 'NO GOOOOOOD' -- Вывод если количество 3 или меньше