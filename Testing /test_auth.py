import unittest
from api import API

class TestCustomer(unittest.TestCase):

    def test_login(self):
        result = API().login_customer(email="moelkhshab@gmail.com", password="ilovenu@")
        self.assertEqual(result, "valid")

        result = API().login_customer(email="moelkhshab@gmail.com", password="ilove")
        self.assertEqual(result, "invalid")
    
    def test_reset_password(self):
        result = API().reset_password(email="moelkhshab@gmail.com", new_password="ilovenu@")
        self.assertEqual(result, "valid")

        result = API().reset_password(email="moeab@gmail.com", new_password="ilovenu@")
        self.assertEqual(result, "invalid")
    
    def test_send_otp(self):
        result = API().send_otp(email="moelkhshab@gmail.com")
        self.assertEqual(result, "valid")

        result = API().send_otp(email="moelkhshab")
        self.assertEqual(result, "invalid")
    

if __name__ == '__main__':
    unittest.main()
