from django.db import models

class Customer_User(models.Model):
    name = models.CharField(max_length=255)
    email = models.EmailField(unique=True)
    password = models.CharField(max_length=255)
    phone = models.CharField(max_length=15, blank=True, null=True)
    address = models.TextField(blank=True, null=True)
    wishlist_products = models.JSONField(default=list)
    cart_products = models.JSONField(default=list)

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

class Product(models.Model):
    name = models.CharField(max_length=255)
    seller = models.CharField(max_length=255)
    category = models.CharField(max_length=50, choices=[('men', 'Men'), ('women', 'Women'), ('children', 'Children')])
    description = models.TextField()
    photo = models.URLField()
    stock_quantity = models.IntegerField()
    price = models.FloatField()
    discount = models.FloatField()
    keywords = models.JSONField(default=list)
    sizes_list = models.JSONField(default=list)

    def __str__(self):
        return self.name