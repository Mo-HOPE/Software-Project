from rest_framework import serializers
from .models import *

class Customer_UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = Customer_User
        fields = ['id', 'name', 'email', 'password','wishlist_products', 'cart_products']

class SellerSerializer(serializers.ModelSerializer):
    class Meta:
        model = Seller
        fields = ['id', 'owner_name', 'owner_email', 'brand_name', 'brand_email', 'password']

class ProductSerializer(serializers.ModelSerializer):
    class Meta:
        model = Product
        fields = ['id', 'name', 'seller', 'category', 'description', 'photo', 'stock_quantity', 'price', 'discount', 'keywords', 'sizes_list']