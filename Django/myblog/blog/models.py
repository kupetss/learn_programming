from django.db import models

class Category(models.Model):
    name = models.CharField(max_length=100)
    slug = models.SlugField(max_length=100, unique=True)
    
    
    def __str__(self):
        return self.name
    
    
    class Meta:
        verbose_name = 'Категория'
        verbose_name_plural = 'Категории' 
        
        
class Post(models.Model):
    title = models.CharField(max_length=200, verbose_name='Заголовок')
    content = models.TextField(verbose_name='Содержание')
    created_at = models.DateTimeField(auto_now_add=True, verbose_name='Дата создания')
    updated_at = models.DateTimeField(auto_now=True, verbose_name='Дата обновления')
    published_at = models.DateTimeField(blank=True, null=True, verbose_name='Дата публикации')
    category = models.ForeignKey(
        Category,
        on_delete=models.CASCADE,
        related_name='posts',
        verbose_name='Категория'
    )
    author = models.CharField(max_length=100, default='Аноним', verbose_name='Автор')
    
    def __str__(self):
        return self.title
    
    
    class Meta:
        verbose_name = 'Пост'
        verbose_name_plural = 'Посты'
        ordering = ['-created_at']