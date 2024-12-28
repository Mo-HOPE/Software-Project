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
    path('put-product/', PutProductView.as_view(), name='put_product'),
    path('get-products/<str:category>/', GetProductsView.as_view(), name='get_products_by_category'),
    path('search-products/<str:keyword>/', SearchProductKeywordsView.as_view(), name='search_product_keywords'),
    path('get-customer-info/<str:email>/', GetCustomerInfoView.as_view(), name='get_customer_info'),
    path('get-product-info/<int:product_id>/', GetProductInfoView.as_view(), name='get_product_info'),


]

