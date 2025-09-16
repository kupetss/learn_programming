# Модели (Model)
## Теория (кратко и по делу)
Что такое модель?

Это Python-класс, который наследуется от django.db.models.Model.

Каждый атрибут этого класса — это поле вашей будущей таблицы в базе данных (БД).

Модель — это единственный и исчерпывающий источник информации о ваших данных. Она содержит все необходимые поля и поведение для работы с данными. Вы в основном будете работать с моделями, а Django за кулисами будет генерировать и выполнять SQL-запросы.

Зачем нужны модели?

Абстракция от БД: Вы пишете на Python, а Django сам решает, как это превратить в SQL для MySQL, PostgreSQL, SQLite и т.д. Вы можете сменить БД, почти не меняя код моделей.

Безопасность: Правильно построенные модели помогают избежать уязвимостей (например, SQL-инъекций).

Удобство: Работа с данными становится объектно-ориентированной. Вместо INSERT INTO blog_post ... вы пишете new_post.save().

Что такое ORM (Object-Relational Mapper)?

Это прослойка, которая связывает мир объектов (Python) с миром реляционных таблиц (БД).

Django ORM превращает ваш Python-код в SQL-запросы, выполняет их и возвращает результаты в виде Python-объектов.

Пример: Post.objects.all() превращается в SELECT * FROM blog_post; и возвращает не сырые данные из БД, а список объектов класса Post.

Типы полей (некоторые основные):

CharField - для коротких строк (обязательный параметр max_length).

TextField - для больших текстовых блоков (без ограничения длины).

DateTimeField - для хранения даты и времени.

auto_now_add=True - автоматически проставит текущую дату/время при создании объекта.

auto_now=True - автоматически обновляет дату/время при каждом сохранении объекта.

ForeignKey - связь «многие-к-одному». Например, многие посты могут принадлежать одной категории. Первый аргумент — класс связанной модели, аргумент on_delete обязателен (что делать с постом, если удалить категорию? models.CASCADE - удалить пост, models.PROTECT - запретить удаление).

Миграции (Migrations):

Это способ применения изменений, которые вы внесли в модели, к схеме вашей реальной БД.

python manage.py makemigrations - создает миграции. Django смотрит на ваши модели, сравнивает с текущим состоянием БД и создает Python-код для приведения схемы БД к новому виду.

python manage.py migrate - применяет созданные миграции к БД.

Миграции — это система контроля версий для вашей схемы БД. Они позволяют легко применять и откатывать изменения в команде.

## Практика
Открываем blog/models.py и создаю модель Category (сначала создадим то, на что будем ссылаться):
```python
from django.db import models

class Category(models.Model):
    # Поле для названия категории
    name = models.CharField(max_length=100)
    # Поле для удобного URL-адреса (опционально, но хороший тон)
    slug = models.SlugField(max_length=100, unique=True)

    # Вспомогательный метод для читаемого представления объекта в админке и shell
    def __str__(self):
        return self.name

    # Метаданные модели (необязательно, но полезно)
    class Meta:
        verbose_name = 'Категория' # Человекочитаемое имя в единственном числе
        verbose_name_plural = 'Категории' # Человекочитаемое имя во множественном числе


class Post(models.Model):
    # Поле для заголовка поста
    title = models.CharField(max_length=200, verbose_name='Заголовок')
    
    # Поле для содержания поста. TextField подходит для длинных текстов.
    content = models.TextField(verbose_name='Содержание')
    
    # Поле автоматически проставит дату при СОЗДАНИИ объекта
    created_at = models.DateTimeField(auto_now_add=True, verbose_name='Дата создания')
    
    # Поле автоматически обновляет дату при КАЖДОМ сохранении объекта
    updated_at = models.DateTimeField(auto_now=True, verbose_name='Дата обновления')
    
    # Поле для даты публикации. Может быть пустым (blank=True) и не заданным в базе (null=True).
    published_at = models.DateTimeField(blank=True, null=True, verbose_name='Дата публикации')
    
    # Связь "многие-к-одному": у одной категории может быть много постов.
    # on_delete=models.CASCADE означает: при удалении категории, все связанные посты тоже удалятся.
    category = models.ForeignKey(
        Category, 
        on_delete=models.CASCADE,
        related_name='posts', # Это позволяет получать все посты категории через category.posts.all()
        verbose_name='Категория'
    )
    
    # Автор поста. Пока просто текстовое поле, позже свяжем с моделью User.
    author = models.CharField(max_length=100, default='Аноним', verbose_name='Автор')

    def __str__(self):
        return self.title

    class Meta:
        verbose_name = 'Пост'
        verbose_name_plural = 'Посты'
        # Сортировка постов по дате создания (сначала новые)
        ordering = ['-created_at']
```

Дальше создаю миграции:
```bash
python manage.py makemigrations
python manage.py migrate
```


### Админ панель.
Создаем суперпользователя (администратора сайта):
```bash
python manage.py createsuperuser
```
`http://127.0.0.1:8000/admin`

### Регистрирую модели в админ-панели (blog/admin.py)
Чтобы Post и Category отображались в админке, их нужно зарегистрировать.
```python
from django.contrib import admin

# Импортируем наши модели из файла models.py в текущей директории
from .models import Category, Post

# Регистрируем модель Category стандартным способом
admin.site.register(Category)

# Регистрируем модель Post с кастомизацией
@admin.register(Post) # <- Это декоратор, альтернатива admin.site.register(Post)
class PostAdmin(admin.ModelAdmin):
    # Какие поля показывать в списке объектов админки
    list_display = ('title', 'author', 'category', 'created_at', 'published_at')
    # Добавляет фильтр сбоку
    list_filter = ('category', 'created_at')
    # Добавляет поиск по полям
    search_fields = ('title', 'content')
    # Предзаполнение поля slug (если бы оно было у Post) на основе title
    # prepopulated_fields = {'slug': ('title',)}
```
