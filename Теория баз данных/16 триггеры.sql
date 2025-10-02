-- Специальная хранимая процедура, которая автоматически выполняется
-- при возникновении события (INSERT, UPDATE, DELETE)

-- Создание простого триггера на INSERT
CREATE TRIGGER trg_AfterInsertStudent
ON Students                         -- На какую таблицу вешаем
AFTER INSERT                        -- Когда срабатывает (ПОСЛЕ операции)
AS
BEGIN
    PRINT 'Добавлен новый студент'  -- Просто сообщение
    -- Здесь может быть любая логика
END

-- Теперь при каждой вставке в Students будет выводиться сообщение
INSERT INTO Students (Name, Age) VALUES ('Анна', 20)
-- В результатах увидим: "Добавлен новый студент"

-- ==========================================

-- ВИДЫ ТРИГГЕРОВ ПО ВРЕМЕНИ СРАБАТЫВАНИЯ

-- AFTER TRIGGER (после операции)
CREATE TRIGGER trg_AfterDeleteStudent
ON Students
AFTER DELETE                        -- После удаления
AS
BEGIN
    PRINT 'Студент удален из базы'
END

-- INSTEAD OF TRIGGER (вместо операции)
CREATE TRIGGER trg_InsteadOfDelete  
ON Students
INSTEAD OF DELETE                   -- Вместо удаления
AS
BEGIN
    PRINT 'Удаление запрещено!'     -- Блокируем удаление
    ROLLBACK TRANSACTION            -- Отменяем операцию
END

-- ==========================================

-- СПЕЦИАЛЬНЫЕ ТАБЛИЦЫ inserted и deleted
-- Доступны только внутри триггера

-- Триггер для логирования добавлений
CREATE TRIGGER trg_LogInsertStudent
ON Students
AFTER INSERT
AS
BEGIN
    -- inserted содержит новые добавленные записи
    INSERT INTO StudentLog (StudentID, Action, Date)
    SELECT 
        ID,                     -- Берем ID из добавленной записи
        'INSERT',               -- Тип действия
        GETDATE()               -- Текущая дата
    FROM inserted               -- Специальная таблица с новыми данными
END

-- Триггер для логирования удалений
CREATE TRIGGER trg_LogDeleteStudent  
ON Students
AFTER DELETE
AS
BEGIN
    -- deleted содержит удаленные записи
    INSERT INTO StudentLog (StudentID, Action, Date)
    SELECT 
        ID,                     -- Берем ID из удаленной записи
        'DELETE',               -- Тип действия
        GETDATE()               -- Текущая дата
    FROM deleted                -- Специальная таблица со старыми данными
END

-- ==========================================

-- ТРИГГЕР НА UPDATE (отслеживание изменений)

CREATE TRIGGER trg_UpdateStudent
ON Students
AFTER UPDATE
AS
BEGIN
    -- inserted содержит новые значения
    -- deleted содержит старые значения
    INSERT INTO StudentHistory (StudentID, OldName, NewName, ChangeDate)
    SELECT 
        d.ID,                   -- ID из deleted (старые данные)
        d.Name,                 -- Старое имя
        i.Name,                 -- Новое имя из inserted
        GETDATE()               -- Дата изменения
    FROM deleted d
    INNER JOIN inserted i ON d.ID = i.ID  -- Связываем по ID
    WHERE d.Name <> i.Name      -- Только если имя действительно изменилось
END

-- ==========================================

-- ПРАКТИЧЕСКИЕ ПРИМЕРЫ ИСПОЛЬЗОВАНИЯ

-- Автоматическое проставление даты создания
CREATE TRIGGER trg_SetCreateDate
ON Products
AFTER INSERT
AS
BEGIN
    UPDATE Products 
    SET CreateDate = GETDATE()
    WHERE ID IN (SELECT ID FROM inserted)
    -- Для всех новых записей проставляем текущую дату
END

-- Проверка данных перед вставкой
CREATE TRIGGER trg_CheckAge
ON Students
AFTER INSERT, UPDATE
AS
BEGIN
    -- Проверяем, что возраст больше 0
    IF EXISTS (SELECT * FROM inserted WHERE Age <= 0)
    BEGIN
        PRINT 'Возраст должен быть положительным числом!'
        ROLLBACK TRANSACTION  -- Отменяем всю операцию
    END
END

-- ==========================================

-- УПРАВЛЕНИЕ ТРИГГЕРАМИ

-- Просмотр всех триггеров в базе
SELECT * FROM sys.triggers

-- Отключение триггера
DISABLE TRIGGER trg_CheckAge ON Students

-- Включение триггера  
ENABLE TRIGGER trg_CheckAge ON Students

-- Удаление триггера
DROP TRIGGER trg_CheckAge

-- ==========================================

-- КОГДА ИСПОЛЬЗОВАТЬ ТРИГГЕРЫ?

-- Для аудита и логирования изменений
-- Для автоматического заполнения полей (даты, вычисляемые значения)
-- Для каскадных операций
-- Для сложных проверок целостности данных

-- НЕ используйте для:
-- Слишком сложной бизнес-логики
-- Операций, которые могут выполняться долго
-- Логики, которую можно реализовать на уровне приложения

-- ==========================================

-- ВАЖНЫЕ МОМЕНТЫ

-- Триггеры выполняются В РАМКАХ ТРАНЗАКЦИИ
-- Если в триггере ошибка - откатывается вся операция

-- Будьте осторожны с рекурсивными триггерами
-- Триггер может вызвать сам себя бесконечно

-- Триггеры замедляют операции
-- Каждый INSERT/UPDATE/DELETE будет дополнительно нагружен

-- ==========================================

-- ПРИМЕР КОМПЛЕКСНОГО ТРИГГЕРА

CREATE TRIGGER trg_StudentFullControl
ON Students
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    -- Логируем ВСЕ операции со студентами
    IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
    BEGIN
        -- UPDATE операция
        INSERT INTO AuditLog (TableName, Action, Details, Date)
        VALUES ('Students', 'UPDATE', 'Изменены данные студентов', GETDATE())
    END
    ELSE IF EXISTS (SELECT * FROM inserted)
    BEGIN
        -- INSERT операция  
        INSERT INTO AuditLog (TableName, Action, Details, Date)
        VALUES ('Students', 'INSERT', 'Добавлены новые студенты', GETDATE())
    END
    ELSE IF EXISTS (SELECT * FROM deleted)
    BEGIN
        -- DELETE операция
        INSERT INTO AuditLog (TableName, Action, Details, Date)
        VALUES ('Students', 'DELETE', 'Удалены студенты', GETDATE())
    END
END

-- ==========================================

-- КРАТКАЯ ШПАРГАЛКА
/*
AFTER INSERT    - после добавления
AFTER UPDATE    - после изменения  
AFTER DELETE    - после удаления
INSTEAD OF      - вместо операции

inserted        - новые данные (для INSERT/UPDATE)
deleted         - старые данные (для UPDATE/DELETE)

ROLLBACK        - отмена операции
PRINT           - вывод сообщения