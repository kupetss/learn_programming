from django.contrib import admin
from .models import Category, Post

admin.site.register(Category)

@admin.register(Post)
class PostAdmin(admin.ModelAdmin):
    list_display = ('title', 'author', 'category', 'created_at','published_at')
    list_filter = ('category', 'created_at')
    search_fields = ('title', 'content')
    