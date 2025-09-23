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