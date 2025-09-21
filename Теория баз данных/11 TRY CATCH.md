Внутри блока CATCH доступны специальные функции, которые расскажут всё об ошибке.

ERROR_MESSAGE() — Возвращает текст ошибки. Самый часто используемый.

ERROR_NUMBER() — Возвращает уникальный номер ошибки (например, 547 - ошибка ограничения внешнего ключа).

ERROR_SEVERITY() — Возвращает уровень серьезности ошибки (от 0 до 25). Ошибки > 19 являются критическими (обычно требуют прав sysadmin).

ERROR_STATE() — Возвращает код состояния ошибки (от 1 до 255). Иногда одна и та же ошибка NUMBER может иметь разные STATE.

ERROR_LINE() — Указывает номер строки, в которой произошла ошибка. Невероятно полезно для отладки больших процедур.

ERROR_PROCEDURE() — Возвращает имя хранимой процедуры или триггера, в котором произошла ошибка.

## База 
```
USE BankDemo;

-- Создадим таблицу для логирования ошибок (очень полезная практика!)
CREATE TABLE ErrorLog (
    ErrorLogID INT IDENTITY(1,1) PRIMARY KEY,
    ErrorTime DATETIME2 DEFAULT GETDATE(),
    UserName sysname DEFAULT SUSER_SNAME(), -- Кто вызвал ошибку
    ErrorNumber INT,
    ErrorSeverity INT,
    ErrorState INT,
    ErrorProcedure NVARCHAR(126),
    ErrorLine INT,
    ErrorMessage NVARCHAR(4000)
);
```

1
```sql
BEGIN TRY
    -- Имитируем ошибку
    PRINT 'Пытаемся сделать что-то опасное...';
    SELECT 1 / 0; -- Деление на ноль! Здесь код "упал" бы без TRY/CATCH
    PRINT 'Этот текст уже не увидеть.';
END TRY
BEGIN CATCH
    PRINT 'Ой! Произошла ошибка:';
    PRINT 'Сообщение: ' + ERROR_MESSAGE();
    PRINT 'Номер: ' + CAST(ERROR_NUMBER() AS VARCHAR);
    PRINT 'Строка: ' + CAST(ERROR_LINE() AS VARCHAR);
END CATCH

PRINT 'А этот текст увидим, ведь выполнение продолжилось после CATCH!';
```

2
```sql
-- Допустим, у нас в таблице Accounts AccountID - PRIMARY KEY
BEGIN TRY
    INSERT INTO Accounts (AccountID, Balance) VALUES (1, 500); -- Счет с ID=1 уже существует!
    PRINT 'Запись добавлена.';
END TRY
BEGIN CATCH
    PRINT 'Не удалось вставить запись. Причина: ' + ERROR_MESSAGE();
    
    -- Проверим, что это именно ошибка нарушения первичного ключа (номер 2627)
    IF ERROR_NUMBER() = 2627
        PRINT 'Это ошибка дублирования ключа. Нужно выбрать другой ID.';
    ELSE
        PRINT 'Это какая-то другая ошибка.';
END CATCH
```

3
```sql
-- Создадим процедуру для безопасного перевода денег
CREATE OR ALTER PROCEDURE pSafeTransfer
    @FromAccount INT,
    @ToAccount INT,
    @Amount MONEY
AS
BEGIN
    -- Объявляем переменные для логирования
    DECLARE @ErrorMessage NVARCHAR(4000), @ErrorSeverity INT, @ErrorState INT;

    -- Начинаем транзакцию ВНУТРИ блока TRY!
    BEGIN TRY
        BEGIN TRANSACTION; -- Стартуем транзакцию

        -- 1. Списание
        UPDATE Accounts SET Balance = Balance - @Amount WHERE AccountID = @FromAccount;
        IF @@ROWCOUNT = 0 -- Если счет не найден, имитируем ошибку
            RAISERROR('Счет отправителя %d не найден!', 16, 1, @FromAccount);

        -- 2. Зачисление
        UPDATE Accounts SET Balance = Balance + @Amount WHERE AccountID = @ToAccount;
        IF @@ROWCOUNT = 0 -- Если счет не найден, имитируем ошибку
            RAISERROR('Счет получателя %d не найден!', 16, 1, @ToAccount);

        -- 3. Если все хорошо - коммитим
        COMMIT TRANSACTION;
        PRINT 'Перевод успешно завершен.';
    END TRY
    BEGIN CATCH
        -- Если произошла ошибка, сначала откатываем транзакцию!
        IF @@TRANCOUNT > 0 -- Проверяем, открыта ли еще транзакция
            ROLLBACK TRANSACTION;

        -- Сохраняем информацию об ошибке в переменные
        SELECT
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE();

        -- Логируем ошибку в таблицу
        INSERT INTO ErrorLog (ErrorNumber, ErrorSeverity, ErrorState, ErrorProcedure, ErrorLine, ErrorMessage)
        VALUES (ERROR_NUMBER(), @ErrorSeverity, @ErrorState, ERROR_PROCEDURE(), ERROR_LINE(), @ErrorMessage);

        -- И пробрасываем ошибку обратно наверх (в приложение или среду SSMS)
        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END;

-- Тестируем процедуру
-- Успешный вызов
EXEC pSafeTransfer @FromAccount = 1, @ToAccount = 2, @Amount = 100;
-- Вызов с ошибкой (несуществующий счет)
EXEC pSafeTransfer @FromAccount = 999, @ToAccount = 2, @Amount = 100;

-- Посмотрим, что попало в лог ошибок
SELECT * FROM ErrorLog;
```

4
```sql
BEGIN TRY
    DECLARE @Balance MONEY;
    SELECT @Balance = Balance FROM Accounts WHERE AccountID = 1;

    -- Бизнес-правило: нельзя иметь больше 5000 на счете
    IF @Balance > 5000
    BEGIN
        -- RAISERROR (сообщение, уровень_серьезности, состояние)
        -- Уровень серьезности 16 - самая распространенная для пользовательских ошибок
        RAISERROR('На счете слишком много денег! Баланс: %g', 16, 1, @Balance);
    END
    ELSE
    BEGIN
        PRINT 'Все в порядке.';
    END
END TRY
BEGIN CATCH
    PRINT 'Поймали пользовательскую ошибку: ' + ERROR_MESSAGE();
END CATCH
```

5
```sql
CREATE OR ALTER PROCEDURE pSomeRiskyOperation
AS
BEGIN
    BEGIN TRY
        -- ... какой-то код, который может сломаться ...
        SELECT 1 / 0; -- Имитация ошибки
    END TRY
    BEGIN CATCH
        -- Логируем ВСЕ детали об ошибке
        INSERT INTO ErrorLog (ErrorNumber, ErrorSeverity, ErrorState, ErrorProcedure, ErrorLine, ErrorMessage)
        VALUES (
            ERROR_NUMBER(),
            ERROR_SEVERITY(),
            ERROR_STATE(),
            ISNULL(ERROR_PROCEDURE(), 'pSomeRiskyOperation'), -- если ошибка не в процедуре, подставляем имя текущей
            ERROR_LINE(),
            ERROR_MESSAGE()
        );

        -- Можно также вывести их для немедленного просмотра
        PRINT 'Произошла ошибка. Смотрите лог. ID ошибки: ' + CAST(SCOPE_IDENTITY() AS VARCHAR);
        -- SCOPE_IDENTITY() возвращает последний сгенерированный IDENTITY в этой области видимости (т.е. ID нашей вставки в ErrorLog)

        -- Не пробрасываем ошибку выше, "тихая" обработка
    END CATCH
END;

EXEC pSomeRiskyOperation;
SELECT * FROM ErrorLog; -- Увидим детальную запись об ошибке деления на ноль
```