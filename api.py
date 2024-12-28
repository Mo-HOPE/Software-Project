import requests

class API:
    BASE_URL = "https://outfitonv2-hqdnefb7hfdtg2gm.canadacentral-01.azurewebsites.net/api/"

    def __init__(self):
        pass

    def login_customer(self, email, password):
        url = f"{self.BASE_URL}/login-customer/"
        data = {"email": email, "password": password}
        response = requests.post(url, json=data)
        return "valid" if str(response.status_code).startswith("2") else "invalid"

    def send_otp(self, email):
        url = f"{self.BASE_URL}/send-otp/"
        data = {"email": email}
        response = requests.post(url, json=data)
        return "valid" if str(response.status_code).startswith("2") else "invalid"

    def reset_password(self, email, new_password):
        url = f"{self.BASE_URL}/reset-customer-password/"
        data = {"email": email, "new_password": new_password}
        response = requests.post(url, json=data)
        return "valid" if str(response.status_code).startswith("2") else "invalid"


    def get_products(self, category):
        url = f"{self.BASE_URL}/get-products/{category}/"  # Verify this matches your actual API endpoint
        response = requests.get(url)
        return "valid" if str(response.status_code).startswith("2") else "invalid"

    def put_product(self, product_data):
        url = f"{self.BASE_URL}/put-product/"
        response = requests.post(url, json=product_data)
        return "valid" if str(response.status_code).startswith("2") else "invalid"
