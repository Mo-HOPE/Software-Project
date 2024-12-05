from django.urls import path
from . import views

urlpatterns = [
    path('register/', views.Registercreate.as_view(), name='Registercreate'),
    path('login/', views.LoginView.as_view(), name='login'), 
    #path('change-password/', views.ChangePasswordView.as_view(), name='change-password'),
]
