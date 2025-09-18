from django.shortcuts import render
from django.http import HttpResponse
from .models import Post

def post_list(request):
    posts = Post.objects.order_by('-created_at')
    context = {
        'posts': posts,
        'title': 'Главная страница'
    }
    return render(request, 'blog/post_list.html', context)
