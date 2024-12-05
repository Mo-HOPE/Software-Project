from django.shortcuts import render
from rest_framework import generics
from .models import Register
from .serializers import  RegisterSerializer
from rest_framework.response import Response
from rest_framework import status
from rest_framework.views import APIView
from rest_framework.exceptions import AuthenticationFailed
from django.contrib.auth.hashers import make_password

import  jwt, datetime

class Registercreate(generics.ListCreateAPIView):
    queryset=Register.objects.all()
    serializer_class=RegisterSerializer
    
    def post(self, request, *args, **kwargs):
        
        serializer = self.get_serializer(data=request.data)

        if serializer.is_valid():
            
            user = serializer.save()

            return Response({
                "message": "User registered successfully!",
                "user": serializer.data  
            }, status=status.HTTP_201_CREATED)
        else:
            return Response({
                "error": "Invalid data",
                "details": serializer.errors 
            }, status=status.HTTP_400_BAD_REQUEST)
            
#***********************************************************************
class LoginView(APIView):
    def post(self,request):
        email= request.data['email']
        password= request.data['password']
        
        user= Register.objects.filter(email=email).first()
        
        if user is None:
            raise AuthenticationFailed('User not found!')

        if not user.check_password(password):
            raise AuthenticationFailed('Incorrect password!')
        
        
        payload={
            'id':user.id,
            'expiration':datetime.utcnow()+datetime.timedelta(minutes="60"),
            'iat': datetime.datetime.utcnow()
        }
        token=jwt.encode(payload,'secret',algorithm='HS256').decode('utf-8')                                                                                                                                                                                                                  
        
        
        response = Response()

        response.set_cookie(key='jwt', value=token, httponly=True)
        response.data = {
            'jwt': token
        }
        return response
    
    
    
class UserView(APIView):

    def get(self, request):
        token = request.COOKIES.get('jwt')

        if not token:
            raise AuthenticationFailed('Unauthenticated!')

        try:
            payload = jwt.decode(token, 'secret', algorithm=['HS256'])
        except jwt.ExpiredSignatureError:
            raise AuthenticationFailed('Unauthenticated!')

        user = Register.objects.filter(id=payload['id']).first()
        serializer = RegisterSerializer(user)
        return Response(serializer.data)

'''class ChangePasswordView(APIView):
    def post(self, request, *args, **kwargs):
        serializer =  RegisterSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response({"message": "Password updated successfully."}, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)'''
    
            
