from rest_framework import serializers
from .models import Customer, Seller

class CustomerSerializer(serializers.ModelSerializer):
    class Meta:
        model = Customer
        fields = ['id', 'name', 'email', 'password']

class SellerSerializer(serializers.ModelSerializer):
    class Meta:
        model = Seller
        fields = ['id', 'owner_name', 'owner_email', 'brand_name', 'brand_email', 'password']
