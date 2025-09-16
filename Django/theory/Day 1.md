# Создание проекта
Виртуальное окружение нужно, чтобы изолировать зависимости вашего проекта от других проектов на компьютере.

Создание ВO и установка Django:
```bash
python -m venv venv
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
venv\Scripts\activate
pip install django
```

Создание проекта:
```bash
django-admin startproject myblog.
```

**`.`** - создает в тек. папке

Запустить сервер:
```bash
python manage.py runserver
```
http://127.0.0.1:8000/

Создать приложение в проекте:
```bash
python manage.py startapp blog
```

Cодержимое папки `blog`: 
- `migrations/` — папка для миграций базы данных.
- `admin.py` — файл для регистрации моделей в админ-панели.
- `apps.py` — файл с конфигурацией приложения.
- `models.py` — файл для определения ваших моделей (базы данных).
- `tests.py` — файл для написания тестов.
- `views.py` — файл для написания ваших представлений (логики).

Каждое новое приложение нужно записывать в `myblog/settings.py` в  `INSTALLED_APPS`. Это список всех приложений, которые активны в вашем проекте. Добавить `'blog.apps.BlogConfig'` в конец этого списка.