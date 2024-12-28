import random
from django.core.mail import send_mail
from django.conf import settings
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from .models import Customer_User, Seller, Product
from .serializers import *
from django.contrib.auth.hashers import make_password, check_password

class SendOtpView(APIView):
    def post(self, request):
        email = request.data.get('email')
        
        if not email:
            return Response({"error": "Email is required"}, status=status.HTTP_400_BAD_REQUEST)

        otp = str(random.randint(100000, 999999))

        subject = "Your Verification Code"
        message = f"Your OTP code is {otp}. It will expire in 10 minutes."
        from_email = settings.DEFAULT_FROM_EMAIL
        recipient_list = [email]

        try:
            send_mail(subject, message, from_email, recipient_list, fail_silently=False)
        except Exception as e:
            return Response({"error": f"Failed to send email: {str(e)}"}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
        
        return Response({"message": "OTP sent successfully", "otp": otp}, status=status.HTTP_200_OK)

class LoginCustomerView(APIView):
    def post(self, request):
        email = request.data.get('email')
        password = request.data.get('password')
        try:
            user = Customer_User.objects.get(email=email)
            if check_password(password, user.password):
                return Response({"message": "Login successful"}, status=status.HTTP_200_OK)
            else:
                return Response({"error": "Invalid credentials"}, status=status.HTTP_401_UNAUTHORIZED)
        except Customer_User.DoesNotExist:
            return Response({"error": "User not found"}, status=status.HTTP_404_NOT_FOUND)

class CreateCustomerView(APIView):
    def post(self, request):
        data = request.data
        data['password'] = make_password(data['password'])
        serializer = Customer_UserSerializer(data=data)
        if serializer.is_valid():
            serializer.save()
            return Response({"message": "User registered successfully"}, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class ResetCustomerPasswordView(APIView):
    def post(self, request):
        email = request.data.get('email')
        new_password = request.data.get('new_password')
        
        if not email or not new_password:
            return Response({"error": "Email and new password are required"}, status=status.HTTP_400_BAD_REQUEST) 
        try:
            user = Customer_User.objects.get(email=email)            
            user.password = make_password(new_password)
            user.save()
            return Response({"message": "Password reset successfully"}, status=status.HTTP_200_OK)
        except Customer_User.DoesNotExist:
            return Response({"error": "User not found"}, status=status.HTTP_404_NOT_FOUND)
        except Exception as e:
            return Response({"error": f"An error occurred: {str(e)}"}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)



class GetCustomerInfoView(APIView):
    def get(self, request, email):
        try:
            customer = Customer_User.objects.get(email=email)
            serializer = Customer_UserSerializer(customer)
            customer_data = serializer.data
            result = {
                "id": customer_data["id"],
                "name": customer_data["name"],
                "email": customer_data["email"],
                "wishlist_products": customer_data["wishlist_products"],
                "cart_products": customer_data["cart_products"],
            }
            return Response(result, status=status.HTTP_200_OK)
        except Customer_User.DoesNotExist:
            return Response({"error": "Customer not found"}, status=status.HTTP_404_NOT_FOUND)


class DeleteCustomerView(APIView):
    def post(self, request):
        email = request.data.get('email')
        if not email:
            return Response({"error": "Email is required"}, status=status.HTTP_400_BAD_REQUEST)
        
        try:
            customer = Customer_User.objects.get(email=email)
            customer.delete()
            return Response({"message": "Customer deleted successfully"}, status=status.HTTP_200_OK)
        except Customer_User.DoesNotExist:
            return Response({"error": "Customer not found"}, status=status.HTTP_404_NOT_FOUND)

    def delete(self, request):
        email = request.data.get('email')
        if not email:
            return Response({"error": "Email is required"}, status=status.HTTP_400_BAD_REQUEST)
        
        try:
            customer = Customer_User.objects.get(email=email)
            customer.delete()
            return Response({"message": "Customer deleted successfully"}, status=status.HTTP_200_OK)
        except Customer_User.DoesNotExist:
            return Response({"error": "Customer not found"}, status=status.HTTP_404_NOT_FOUND)

class LoginSellerView(APIView):
    def post(self, request):
        brand_email = request.data.get('brand_email')
        password = request.data.get('password')
        try:
            seller = Seller.objects.get(brand_email=brand_email)
            if check_password(password, seller.password):
                return Response({"message": "Login successful"}, status=status.HTTP_200_OK)
            else:
                return Response({"error": "Invalid credentials"}, status=status.HTTP_401_UNAUTHORIZED)
        except Seller.DoesNotExist:
            return Response({"error": "Seller not found"}, status=status.HTTP_404_NOT_FOUND)

class CreateSellerView(APIView):
    def post(self, request):
        data = request.data
        data['password'] = make_password(data['password'])
        serializer = SellerSerializer(data=data)
        if serializer.is_valid():
            serializer.save()
            return Response({"message": "Seller registered successfully"}, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class ResetSellerPasswordView(APIView):
    def post(self, request):
        brand_email = request.data.get('brand_email')
        new_password = request.data.get('new_password')
        
        if not brand_email or not new_password:
            return Response({"error": "Brand email and new password are required"}, status=status.HTTP_400_BAD_REQUEST)
        try:
            seller = Seller.objects.get(brand_email=brand_email)
            seller.password = make_password(new_password)
            seller.save()
            return Response({"message": "Password reset successfully"}, status=status.HTTP_200_OK)
        except Seller.DoesNotExist:
            return Response({"error": "Seller not found"}, status=status.HTTP_404_NOT_FOUND)
        except Exception as e:
            return Response({"error": f"An error occurred: {str(e)}"}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

class PutProductView(APIView):
    def post(self, request):
        serializer = ProductSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response({"message": "Product added successfully", "product": serializer.data}, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class GetProductsView(APIView):
    def get(self, request, category):
        if category not in ['men', 'women', 'children']:
            return Response({"error": "Invalid category"}, status=status.HTTP_400_BAD_REQUEST)

        products = Product.objects.filter(category=category)
        serialized_products = ProductSerializer(products, many=True)

        result = [{
            "id": product["id"],
            "name": product["name"],
            "seller": product["seller"],
            "category": product["category"],
            "description": product["description"],
            "photo": product["photo"],
            "stock_quantity": product["stock_quantity"],
            "price": product["price"],
            "discount": product["discount"],
            "keywords": product["keywords"],
            "sizes_list": product["sizes_list"]
        } for product in serialized_products.data]

        return Response(result, status=status.HTTP_200_OK)
    
class SearchProductKeywordsView(APIView):
    def get(self, request, keyword):
        products = Product.objects.filter(keywords__icontains=keyword)
        serialized_products = ProductSerializer(products, many=True)
        
        result = [
            {
                "id": product["id"],
                "name": product["name"],
                "seller": product["seller"],
                "category": product["category"],
                "description": product["description"],
                "photo": product["photo"],
                "stock_quantity": product["stock_quantity"],
                "price": product["price"],
                "discount": product["discount"],
                "keywords": product["keywords"],
                "sizes_list": product["sizes_list"],
            }
            for product in serialized_products.data
        ]
        
        return Response(result, status=status.HTTP_200_OK)
    

class GetProductInfoView(APIView):
    def get(self, request, product_id):
        try:
            product = Product.objects.get(id=product_id)
            serializer = ProductSerializer(product)
            product_data = serializer.data
            result = {
                "id": product_data["id"],
                "name": product_data["name"],
                "seller": product_data["seller"],
                "category": product_data["category"],
                "description": product_data["description"],
                "photo": product_data["photo"],
                "stock_quantity": product_data["stock_quantity"],
                "price": product_data["price"],
                "discount": product_data["discount"],
                "keywords": product_data["keywords"],
                "sizes_list": product_data["sizes_list"],
            }
            return Response(result, status=status.HTTP_200_OK)
        except Product.DoesNotExist:
            return Response({"error": "Product not found"}, status=status.HTTP_404_NOT_FOUND)

