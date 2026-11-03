from django.db import models


class Person(models.Model):
    # Alan isimleri JSON şemasıyla aynı (fullName, photoUrl ...) -> ekstra dönüşüm kodu gerekmiyor
    fullName = models.CharField(max_length=100)
    department = models.CharField(max_length=100)
    photoUrl = models.CharField(max_length=300, blank=True)
    birthPlace = models.CharField(max_length=100)
    birthDate = models.DateField()
    email = models.CharField(max_length=100)
    phone = models.CharField(max_length=30)
