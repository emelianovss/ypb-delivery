from django.db import models


class Post(models.Model):
    title = models.CharField(max_length=64)
    text = models.CharField(max_length=256)
