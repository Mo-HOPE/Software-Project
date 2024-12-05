from rest_framework import serializers
from .models import Register
from . import views
from django.contrib.auth.hashers import make_password

class RegisterSerializer(serializers.ModelSerializer):
    password = serializers.CharField()
    #new_password = serializers.CharField(write_only=True, min_length=8)
    class Meta:
        model = Register
        fields = ['email',  'user_type', 'password']
        
    def create(self, validated_data):
        password = validated_data.pop('password')  
        hashed_password = make_password(password) 
        validated_data['password'] = hashed_password 
        
        return Register.objects.create(**validated_data)
    
''' def validate(self, data):
        # Check if the user exists
        try:
            self.user = Register.objects.get(email=data['email'])
        except Register.DoesNotExist:
            raise serializers.ValidationError({"email": "User with this email does not exist."})
        return data

    def save(self, **kwargs):
        # Hash the new password and update the user's password
        new_password = make_password(self.validated_data['new_password'])
        self.user.password = new_password
        self.user.save()
        return self.user'''
