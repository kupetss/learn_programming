-- 1. БАЗОВЫЙ СИНТАКСИС CASE
--DECLARE @Grade INT = 85; -- DECLARE: Объявление переменной; @Grade: Имя переменной; INT: Тип данных; = 85: Значение

--SELECT 
--    @Grade AS Оценка, -- SELECT: Выборка; AS: Псевдоним столбца
--    CASE @Grade -- CASE: Начало оператора; @Grade: Выражение для сравнения
--        WHEN 100 THEN 'Идеально' -- WHEN: Условие; 100: Значение для сравнения; THEN: Результат при совпадении
--        WHEN 90 THEN 'Отлично' 
--        WHEN 80 THEN 'Хорошо'
--        WHEN 70 THEN 'Удовлетворительно'
--        WHEN 60 THEN 'Неудовлетворительно'
--        ELSE 'Провал' -- ELSE: Результат если ни одно условие не совпало
--    END AS Результат -- END: Конец оператора CASE; AS: Псевдоним для столбца результата

-- 2. SEARCHED CASE (С ПОИСКОМ УСЛОВИЙ)
--DECLARE @Score INT = 92; -- @Score: Переменная для оценки
--DECLARE @Attendance INT = 85; -- @Attendance: Переменная для посещаемости

--SELECT 
--    @Score AS Баллы,
--    @Attendance AS Посещаемость,
--    CASE -- CASE без выражения (searched case)
--        WHEN @Score >= 90 AND @Attendance >= 90 THEN 'Отлично' -- WHEN: Условие с логическими операторами
--        WHEN @Score >= 75 AND @Attendance >= 80 THEN 'Хорошо' -- AND: Логическое "И"
--        WHEN @Score >= 60 AND @Attendance >= 70 THEN 'Удовлетворительно'
--        WHEN @Score < 60 OR @Attendance < 70 THEN 'Неудовлетворительно' -- OR: Логическое "ИЛИ"
--        ELSE 'Не определено' -- На случай если все условия ложны
--    END AS ИтоговаяОценка

-- 3. CASE В SELECT ЗАПРОСАХ С ТАБЛИЦАМИ
-- Создание тестовой таблицы
--CREATE TABLE #Students ( -- #Students: Временная таблица
--    StudentID INT IDENTITY PRIMARY KEY, -- StudentID: Первичный ключ с автоинкрементом
--    FirstName NVARCHAR(50) NOT NULL, -- FirstName: Имя студента
--    LastName NVARCHAR(50) NOT NULL, -- LastName: Фамилия студента
--    Score INT NOT NULL, -- Score: Набранные баллы
--    Attendance INT NOT NULL -- Attendance: Процент посещаемости
--);

-- Заполнение таблицы данными
--INSERT INTO #Students (FirstName, LastName, Score, Attendance) VALUES
--('Иван', 'Иванов', 95, 92),
--('Мария', 'Петрова', 82, 88),
--('Алексей', 'Сидоров', 65, 75),
--('Елена', 'Кузнецова', 45, 68),
--('Дмитрий', 'Смирнов', 78, 95);

-- Использование CASE в SELECT с вычисляемыми столбцами
--SELECT 
--    FirstName AS Имя,
--    LastName AS Фамилия,
--    Score AS Баллы,
--    Attendance AS Посещаемость,
--    CASE 
--        WHEN Score >= 90 THEN 'A' -- THEN: Возвращает буквенную оценку
--        WHEN Score >= 80 THEN 'B'
--        WHEN Score >= 70 THEN 'C'
--        WHEN Score >= 60 THEN 'D'
--        ELSE 'F' -- ELSE: Оценка F для всех остальных случаев
--    END AS БуквеннаяОценка, -- AS: Псевдоним для столбца с оценкой
    
--    CASE 
--        WHEN Score >= 90 AND Attendance >= 90 THEN 'Стипендия +' -- Комбинированные условия
--        WHEN Score >= 80 AND Attendance >= 85 THEN 'Стипендия'
--        ELSE 'Без стипендии'
--    END AS Стипендия
    
--FROM #Students; -- FROM: Указание таблицы для выборки

-- 4. CASE В UPDATE ЗАПРОСАХ
-- Обновление данных на основе условий CASE
--UPDATE #Students -- UPDATE: Обновление данных в таблице
--SET Score = 
--    CASE 
--        WHEN Attendance > 95 THEN Score + 5 -- Бонус за высокую посещаемость
--        WHEN Attendance BETWEEN 90 AND 95 THEN Score + 3 -- BETWEEN: Диапазон значений
--        WHEN Attendance < 70 THEN Score - 5 -- Штраф за низкую посещаемость
--        ELSE Score -- Если условия не подходят - оставить без изменений
--    END
--WHERE Score IS NOT NULL; -- WHERE: Условие применения обновления

-- Проверка результатов обновления
--SELECT * FROM #Students;

-- 5. CASE В ORDER BY (СОРТИРОВКА ПО УСЛОВИЮ)
--SELECT 
--    FirstName,
--    LastName,
--    Score,
--    CASE 
--        WHEN Score >= 90 THEN 1 -- Высший приоритет сортировки
--        WHEN Score >= 80 THEN 2
--        WHEN Score >= 70 THEN 3
--        ELSE 4 -- Низший приоритет
--    END AS SortOrder -- Вспомогательный столбец для сортировки
--FROM #Students
--ORDER BY 
--    CASE 
--        WHEN Score >= 90 THEN 1 -- Сортировка по приоритету оценок
--        WHEN Score >= 80 THEN 2
--        WHEN Score >= 70 THEN 3
--        ELSE 4
--    END,
--    LastName; -- ORDER BY: Сортировка по нескольким столбцам

-- 6. CASE В WHERE И HAVING
-- Фильтрация с использованием CASE
--SELECT 
--    FirstName,
--    LastName,
--    Score,
--    Attendance
--FROM #Students
--WHERE 
--    CASE 
--        WHEN Score >= 80 THEN 1 -- WHERE с CASE возвращает 1 или 0 для фильтрации
--        ELSE 0
--    END = 1; -- Фильтрация только строк где CASE вернул 1

-- CASE в HAVING для группировки
--SELECT 
--    CASE 
--        WHEN Score >= 90 THEN 'Отлично' -- Группировка по категориям оценок
--        WHEN Score >= 80 THEN 'Хорошо'
--        WHEN Score >= 70 THEN 'Удовлетворительно'
--        ELSE 'Неудовлетворительно'
--    END AS Категория,
--    COUNT(*) AS КоличествоСтудентов -- COUNT: Подсчет количества
--FROM #Students
--GROUP BY -- GROUP BY: Группировка по категориям
--    CASE 
--        WHEN Score >= 90 THEN 'Отлично'
--        WHEN Score >= 80 THEN 'Хорошо'
--        WHEN Score >= 70 THEN 'Удовлетворительно'
--        ELSE 'Неудовлетворительно'
--    END
--HAVING COUNT(*) > 1; -- HAVING: Фильтрация после группировки

-- 7. ВЛОЖЕННЫЕ CASE ВЫРАЖЕНИЯ
--SELECT 
--    FirstName,
--    LastName,
--    Score,
--    Attendance,
--    CASE 
--        WHEN Score >= 90 THEN 
--            CASE -- Вложенный CASE
--                WHEN Attendance >= 95 THEN 'Отлично с отличием' -- THEN: Возврат строкового значения
--                ELSE 'Отлично'
--            END
--        WHEN Score >= 80 THEN 'Хорошо'
--        ELSE 'Требует улучшения'
--    END AS ДетальнаяОценка
--FROM #Students;

-- 8. CASE С АГРЕГАТНЫМИ ФУНКЦИЯМИ
--SELECT 
--    COUNT(*) AS ВсегоСтудентов, -- COUNT: Общее количество
--    SUM(CASE WHEN Score >= 90 THEN 1 ELSE 0 END) AS Отличники, -- SUM: Сумма с условием
--    SUM(CASE WHEN Score BETWEEN 80 AND 89 THEN 1 ELSE 0 END) AS Хорошисты, -- BETWEEN: Диапазон
--    SUM(CASE WHEN Score < 60 THEN 1 ELSE 0 END) AS Неуспевающие, -- Условие с сравнением
--    AVG(CASE WHEN Attendance > 70 THEN Score END) AS СреднийБаллПосещающих -- AVG: Среднее значение с условием
--FROM #Students;

-- 9. CASE В INSERT ЗАПРОСАХ
--DECLARE @NewScore INT = 88; -- @NewScore: Новые баллы для вставки
--DECLARE @NewAttendance INT = 91; -- @NewAttendance: Новая посещаемость

--INSERT INTO #Students (FirstName, LastName, Score, Attendance)
--VALUES (
--    'Ольга', 
--    'Новикова', 
--    CASE 
--        WHEN @NewScore > 100 THEN 100 -- Ограничение максимального значения
--        WHEN @NewScore < 0 THEN 0 -- Ограничение минимального значения
--        ELSE @NewScore -- Использование исходного значения
--    END,
--    CASE 
--        WHEN @NewAttendance > 100 THEN 100
--        WHEN @NewAttendance < 0 THEN 0
--        ELSE @NewAttendance
--    END
--);

-- 10. PRACTICAL EXAMPLE: CATEGORIZATION
--SELECT 
--    FirstName,
--    LastName,
--    Score,
--    Attendance,
--    CASE 
--        WHEN Score >= 90 AND Attendance >= 90 THEN 'Высокий уровень'
--        WHEN Score >= 75 AND Attendance >= 80 THEN 'Средний уровень'
--        WHEN Score >= 60 AND Attendance >= 70 THEN 'Базовый уровень'
--        WHEN Score < 60 OR Attendance < 70 THEN 'Требует внимания'
--        ELSE 'Не определено'
--    END AS УровеньПодготовки,
    
--    CASE 
--        WHEN Score - Attendance > 20 THEN 'Низкая посещаемость влияет на результаты'
--        WHEN Attendance - Score > 15 THEN 'Высокая посещаемость, но низкие результаты'
--        ELSE 'Сбалансированные показатели'
--    END AS Рекомендация
    
--FROM #Students
--ORDER BY Score DESC; -- DESC: Сортировка по убыванию

-- 11. CASE WITH DATE FUNCTIONS
--SELECT 
--    FirstName,
--    LastName,
--    Score,
--    CASE 
--        WHEN DATEPART(MONTH, GETDATE()) BETWEEN 9 AND 12 THEN -- DATEPART: Извлечение части даты
--            CASE 
--                WHEN Score >= 85 THEN 'Осенний отличник'
--                ELSE 'Осенний студент'
--            END
--        WHEN DATEPART(MONTH, GETDATE()) BETWEEN 1 AND 5 THEN
--            CASE 
--                WHEN Score >= 85 THEN 'Весенний отличник'
--                ELSE 'Весенний студент'
--            END
--        ELSE 'Летний/Зимний студент'
--    END AS СезоннаяКатегория
--FROM #Students;

-- ОЧИСТКА ВРЕМЕННЫХ ДАННЫХ
--DROP TABLE #Students; -- DROP TABLE: Удаление временной таблицы

-- ВАЖНЫЕ ЗАМЕЧАНИЯ ПО ИСПОЛЬЗОВАНИЮ CASE
--1. ПОРЯДОК ВЫПОЛНЕНИЯ: CASE выполняет условия последовательно и возвращает 
--   результат первого совпавшего условия. Порядок WHEN важен!

--2. ELSE ОПЦИОНАЛЕН: Если ELSE не указан и ни одно условие не совпало, 
--   возвращается NULL.

--3. ТИПЫ ДАННЫХ: Все THEN в одном CASE должны возвращать данные совместимых типов.

--4. PERFORMANCE: CASE обычно эффективнее вложенных IF statements.

--5. ЧИТАЕМОСТЬ: Используйте отступы для сложных CASE выражений для улучшения читаемости.

--6. ALTERNATIVES: Для простых условий考虑使用 IIF() или CHOOSE() функции.

--7. NULL HANDLING: CASE не обрабатывает NULL автоматически. Используйте IS NULL проверки.
