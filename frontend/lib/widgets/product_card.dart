import 'package:flutter/material.dart';
import 'package:frontend/models/product_model.dart';
import 'package:frontend/views/product_info_view.dart';
import 'package:frontend/widgets/DiscountBanner.dart';
import 'package:frontend/widgets/sizes_box.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  const ProductCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) {
            return ProductInfoView(product: product);
          },
        ));
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 4.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                children: [
                  // Product Image
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(10.0),
                    ),
                    child: Image.network(
                      product.photo,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.network(
                          'https://thumbs.dreamstime.com/b/top-view-fashion-trendy-look-kids-clothes-103930087.jpg', // Path to your temporary fallback image
                          fit: BoxFit.fill,
                          width: double.infinity,
                        );
                      },
                      fit: BoxFit.fill,
                      width: double.infinity,
                    ),
                  ),
                  // Discount Banner
                  if (product.discount > 0)
                    Positioned(
                      top: 10,
                      left: 10,
                      child: DiscountBanner(discount: product.discount.toInt()),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: GoogleFonts.raleway(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              product.priceAfterDiscount.toString(),
                              style: const TextStyle(
                                color: Colors.purple,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizesBox(sizes: product.sizesList),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
