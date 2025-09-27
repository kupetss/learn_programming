from django.urls import path
from . import views

app_name = 'blog'

urlpatterns = [
    # Главная страница блога
    path('', views.post_list, name='post_list'),

    # Детальная страница поста (обратите внимание на post_id)
    path('post/<int:post_id>/', views.post_detail, name='post_detail'),

    # Можно добавить альтернативный путь для детальной страницы
    path('posts/<int:post_id>/', views.post_detail, name='post_detail_alt'),

    # Пример других страниц (если добавьте функции в views.py)
    # path('about/', views.about, name='about'),
    # path('contact/', views.contact, name='contact'),
]
