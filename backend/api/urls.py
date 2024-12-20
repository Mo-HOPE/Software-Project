from django.urls import path
from .views import *

urlpatterns = [
    path('login-customer/', LoginCustomerView.as_view(), name='login_customer'),
    path('create-customer/', CreateCustomerView.as_view(), name='create_customer'),
    path('reset-customer-password/', ResetCustomerPasswordView.as_view(), name='reset_customer_password'),
    path('delete-customer/', DeleteCustomerView.as_view(), name='delete_customer'),
    path('login-seller/', LoginSellerView.as_view(), name='login_seller'),
    path('create-seller/', CreateSellerView.as_view(), name='create_seller'),
    path('reset-seller-password/', ResetSellerPasswordView.as_view(), name='reset_seller_password'),
    path('send-otp/', SendOtpView.as_view(), name='send_otp'),

]
