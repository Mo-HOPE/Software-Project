from django.db import models

class Register(models.Model):


    email = models.EmailField(unique=True)
    user_type = models.CharField(max_length=10)
    password = models.CharField(max_length=128)
    
    def __str__(self):
        return self.email
      
    