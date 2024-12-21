import unittest
from api import API

class TestProducts(unittest.TestCase):

    def test_get_product(self):
        api = API()
        result = api.get_products("men")
        self.assertEqual(result, "valid")

        result = api.get_products("women")
        self.assertEqual(result, "valid")

        result = api.get_products("children")
        self.assertEqual(result, "valid")

        result = api.get_products("empty")  
        self.assertEqual(result, "invalid")

    def test_put_product(self):
        api = API()

        valid_data = {
            "name": "Kids' Swim Trunks",
            "seller": "OutfitOn",
            "category": "children",
            "description": "Comfortable and quick-drying swim trunks for kids, perfect for summer pools and beach days.",
            "photo": "https://images-cdn.ubuy.co.in/665c95393c6fc846bb487e88-eulla-boys-swim-trunks-quick-dry-beach.jpg",
            "stock_quantity": 120,
            "price": 19.99,
            "discount": 15.0,
            "keywords": ["swim trunks", "kids", "summer", "children", "beach"],
            "sizes_list": ["XS", "S", "M", "L"]
        }

        result = api.put_product(valid_data)
        self.assertEqual(result, "valid")

        invalid_data = "should invalid"
        result = api.put_product(invalid_data)
        self.assertEqual(result, "invalid")

if __name__ == '__main__':
    unittest.main()
