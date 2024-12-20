from django.db import models

class Customer(models.Model):
    name = models.CharField(max_length=255)
    email = models.EmailField(unique=True)
    password = models.CharField(max_length=255)

    def __str__(self):
        return self.name

class Seller(models.Model):
    owner_name = models.CharField(max_length=255)
    owner_email = models.EmailField(unique=True)
    brand_name = models.CharField(max_length=255)
    brand_email = models.EmailField(unique=True)
    password = models.CharField(max_length=255)

    def __str__(self):
        return self.brand_name