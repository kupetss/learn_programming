from django.shortcuts import render, get_object_or_404
from .models import Post

# blog/views.py
def post_list(request):
    posts = Post.objects.all().order_by('-created_at')
    context = {
        'posts': posts,
        'title': 'Главная страница блога'
    }
    return render(request, 'blog/post_list.html', context)

def post_detail(request, post_id):
    post = get_object_or_404(Post, id=post_id)
    context = {
        'post': post
    }
    return render(request, 'blog/post_detail.html', context)