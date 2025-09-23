#  Шаблоны (Template)

## Теория: Язык шаблонов Django (DTL)

    Что такое DTL?

        Это простой, но мощный язык, который позволяет вставлять динамические данные в HTML.

        Он специально ограничен в возможностях (нельзя выполнять произвольный Python-код), что делает шаблоны безопасными и чистыми.

    Основные конструкции:

        {{ переменная }} — Вывод переменной. Подставляет значение переменной из контекста. Может использовать точечную нотацию: {{ post.title }}, {{ user.first_name }}.

        {% тег %} — Выполнение логики. Теги гораздо мощнее. Они могут создавать циклы, условия, подключать другие шаблоны.

            Циклы: {% for item in list %} ... {% endfor %}

            Условия: {% if user.is_authenticated %} ... {% else %} ... {% endif %}

            Наследование: {% extends "base.html" %}, {% block content %} ... {% endblock %}

        {{ переменная | фильтр }} — Фильтры. Преобразуют значение переменной.

            {{ post.created_at | date:"d.m.Y" }} — форматирование даты.

            {{ post.content | truncatewords:30 }} — обрезает текст до 30 слов.

            {{ title | upper }} — переводит в верхний регистр.

    Наследование шаблонов — СУПЕРСИЛА Django!

        Проблема: На каждой странице сайта повторяется один и тот же код: <html>, <head>, меню, подвал, CSS/JS. Копировать это — плохая практика.

        Решение: Создаем базовый шаблон (base.html) с общей разметкой и "дырками" (блоками), которые будут заполняться в дочерних шаблонах.

        Принцип: DRY (Don't Repeat Yourself) — не повторяйся.


## Практика
В templates/base.html создаю фундамент для всех страниц сайта

```html
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>
        {% block title %}Мой Блог{% endblock %} 
        <!-- По умолчанию заголовок "Мой Блог", но дочерний шаблон может его переопределить -->
    </title>
    <!-- Можно добавить общие CSS здесь -->
</head>
<body>
    <!-- Простая навигация -->
    <header>
        <nav>
            <h1>Мой Блог</h1>
            <ul style="list-style: none; padding: 0; display: flex; gap: 20px;">
                <li><a href="{% url 'post_list' %}">Главная</a></li>
                <!-- 
                    Тег url 'post_list' генерирует абсолютный URL по имени маршрута из urls.py.
                    Это лучшая практика, чем писать href="/blog/"!
                -->
                <li><a href="/admin/">Админка (пока тут)</a></li>
                <li><a href="#">О сайте (скоро)</a></li>
            </ul>
        </nav>
        <hr>
    </header>

    <!-- Основной контент страницы -->
    <main>
        {% block content %}
        <!-- Эта "дырка" будет заполнена HTML-кодом из дочерних шаблонов -->
        <p>Содержимое страницы появится здесь.</p>
        {% endblock %}
    </main>

    <!-- Подвал сайта -->
    <footer>
        <hr>
        <p>&copy; Мой Блог, {% now "Y" %}</p>
        <!-- Тег {% now "Y" %} выводит текущий год -->
    </footer>
</body>
</html>
```

templates/blog/post_list.html
```html
{% extends 'base.html' %}
<!-- Указываем, что этот шаблон наследует от base.html -->

{% block title %}{{ title }}{% endblock %}
<!-- Переопределяем блок title. Теперь заголовок страницы будет браться из переменной context -->

{% block content %}
<!-- Начинаем заполнять блок content -->

    <h1>{{ title }}</h1>

    {% if posts %} <!-- Проверяем, есть ли посты вообще -->
        {% for post in posts %}
            <article style="margin-bottom: 2rem; padding: 1rem; border: 1px solid #ccc;">
                <h2><a href="#" style="text-decoration: none; color: inherit;">{{ post.title }}</a></h2>
                <p><strong>Автор:</strong> {{ post.author }} | <strong>Категория:</strong> {{ post.category.name }} | <strong>Опубликовано:</strong> {{ post.created_at | date:"d E Y, H:i" }}</p>
                <!-- Фильтр date форматирует дату по нашему шаблону -->
                <p>{{ post.content | truncatewords:30 }}</p>
                <a href="#">Читать далее...</a>
            </article>
        {% endfor %}
    {% else %}
        <p>К сожалению, постов еще нет.</p>
    {% endif %}

{% endblock %}
<!-- Заканчиваем блок content -->
```
blog/views.py
```python
# blog/views.py
from django.shortcuts import render
from .models import Post

def post_list(request):
    # Получаем посты, у которых указана дата публикации, и сортируем от новых к старым
    # Фильтр published_at__isnull=False означает "где published_at не пустое"
    posts = Post.objects.filter(published_at__isnull=False).order_by('-published_at')

    context = {
        'posts': posts,
        'title': 'Главная страница блога'
    }
    return render(request, 'blog/post_list.html', context)
```