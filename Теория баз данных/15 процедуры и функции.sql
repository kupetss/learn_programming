-- ПРОЦЕДУРЫ
-- Выполняют действия, не возвращают значения через RETURN
-- Могут возвращать таблицы, иметь побочные эффекты

--Создание простой процедуры
CREATE PROCEDURE GetStudents
AS
BEGIN
    SELECT * FROM Students  -- Просто показывает таблицу
END

--Процедура с параметрами
CREATE PROCEDURE GetStudentByID 
    @StudentID INT         -- Входной параметр
AS
BEGIN
    SELECT * FROM Students 
    WHERE ID = @StudentID  -- Ищем по переданному ID
END

--Вызов процедур
EXEC GetStudents                    -- Без параметров
EXEC GetStudentByID @StudentID = 5  -- С параметром

-- ==========================================

--ФУНКЦИИ
-- Возвращают значение через RETURN
-- Не могут изменять данные (только читать)

--Скалярная функция (возвращает одно значение)
CREATE FUNCTION GetStudentCount()
RETURNS INT              -- Указываем тип возвращаемого значения
AS
BEGIN
    DECLARE @Count INT   -- Объявляем переменную
    SELECT @Count = COUNT(*) FROM Students  -- Считаем студентов
    RETURN @Count        -- Возвращаем результат
END

--Функция с параметрами
CREATE FUNCTION CalculateBonus(
    @Salary MONEY,       -- Первый параметр
    @Percent INT         -- Второй параметр
)
RETURNS MONEY
AS
BEGIN
    RETURN @Salary * @Percent / 100  -- Вычисляем и возвращаем
END

--Вызов функций (обязательно dbo.)
SELECT dbo.GetStudentCount() AS StudentCount
SELECT dbo.CalculateBonus(1000, 10) AS Bonus  -- 1000 * 10% = 100

-- ==========================================

--РАЗЛИЧИЯ ПРОЦЕДУР И ФУНКЦИЙ

--Процедура (для действий)
CREATE PROCEDURE UpdateStudentName
    @StudentID INT,
    @NewName NVARCHAR(50)
AS
BEGIN
    UPDATE Students 
    SET Name = @NewName          -- МЕНЯЕМ данные
    WHERE ID = @StudentID
END
-- Вызов: EXEC UpdateStudentName 1, 'Иван'

--Функция (для вычислений)
CREATE FUNCTION GetFormattedName(
    @FirstName NVARCHAR(50),
    @LastName NVARCHAR(50)
)
RETURNS NVARCHAR(100)
AS
BEGIN
    RETURN @LastName + ' ' + @FirstName  -- Только ВОЗВРАЩАЕМ значение
END
-- Вызов: SELECT dbo.GetFormattedName('Иван', 'Петров')

-- ==========================================

--ПРАКТИЧЕСКИЕ ПРИМЕРЫ

--Процедура для добавления студента
CREATE PROCEDURE AddStudent
    @Name NVARCHAR(50),
    @Age INT
AS
BEGIN
    INSERT INTO Students (Name, Age)  -- Вставляем новую запись
    VALUES (@Name, @Age)
    
    PRINT 'Студент добавлен!'  -- Выводим сообщение
END

--Функция для проверки возраста
CREATE FUNCTION CheckAge(@Age INT)
RETURNS NVARCHAR(20)
AS
BEGIN
    IF @Age >= 18
        RETURN 'Совершеннолетний'
    ELSE
        RETURN 'Несовершеннолетний'
END

-- ==========================================

--ВЫЗОВ НА ПРАКТИКЕ

-- Процедуры (действия)
EXEC AddStudent @Name = 'Мария', @Age = 20
EXEC GetStudents

-- Функции (вычисления)
SELECT 
    Name,
    Age,
    dbo.CheckAge(Age) AS AgeStatus  -- Используем в SELECT
FROM Students

-- ==========================================

--ОСНОВНЫЕ ОТЛИЧИЯ
/*
ПРОЦЕДУРЫ:
• CREATE PROCEDURE
• EXEC Name
• Могут изменять данные
• Не возвращают значение через RETURN

ФУНКЦИИ:
• CREATE FUNCTION  
• SELECT dbo.Name()
• Только читают данные
• Всегда возвращают значение (RETURN)
*/