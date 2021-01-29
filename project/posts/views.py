from django.shortcuts import render
from posts.models import Post
from django.conf import settings

def view(request):
    posts = Post.objects.all()
    return render(request, template_name='index.html', context={
        'posts': posts,
        'debug': settings.DEBUG
    })

