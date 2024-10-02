import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/product_service.dart';
import './scan_screen.dart';
import './home_screen.dart';

class ProductInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productService = Provider.of<ProductService>(context);
    final product = productService.productData;

    if (product == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Product Information'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: const Center(
          child: Text('Product not found'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Information'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Center(
              child: Image.network(
                product['image_url'] ?? '', // API provides 'image_url'
                height: 150,
                errorBuilder: (context, error, stackTrace) =>
                    Icon(Icons.image_not_supported),
              ),
            ),
            SizedBox(height: 20),

            // Product Name, Brand, and Score
            Center(
              child: Column(
                children: [
                  Text(
                    product['product_name'] ??
                        'Product Name', // 'product_name' from API
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    product['brands'] ?? 'Brand Name', // 'brands' from API
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Displaying score as "score/100"
                      Text(
                        '${product['nutriscore_score']?.toString() ?? '0'}/100', // Showing score/100
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      SizedBox(width: 10),

                      // Displaying Nutriscore grade
                      Text(
                        'Grade: ${product['nutriscore_grade']?.toUpperCase() ?? 'Unknown'}', // Showing grade with "Grade: " prefix
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: 20),

            // Negatives Section
            Text(
              'Negatives',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            // Additives
            if (product['additives_tags'] != null &&
                product['additives_tags'].isNotEmpty)
              _buildInfoTile(
                title: 'Additives',
                subtitle: 'Contains additives to avoid',
                value: product['additives_tags'].length.toString(),
                color: Colors.red,
              ),

            // Sodium
            if (product['nutriments']?['sodium'] != null)
              _buildInfoTile(
                title: 'Sodium',
                subtitle: 'Sodium content',
                value:
                    '${(product['nutriments']['sodium'] / 1000).toStringAsFixed(2)} g',
                color: Colors.red,
              ),

            // Calories
            if (product['nutriments']?['energy-kcal_100g'] != null)
              _buildInfoTile(
                title: 'Calories',
                subtitle: 'Calories per 100g',
                value:
                    '${product['nutriments']['energy-kcal_100g'].toString()} Cal',
                color: Colors.orange,
              ),

            SizedBox(height: 20),

            // Positives Section
            Text(
              'Positives',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            // Protein
            if (product['nutriments']?['proteins_100g'] != null)
              _buildInfoTile(
                title: 'Protein',
                subtitle: 'Protein per 100g',
                value: '${product['nutriments']['proteins_100g'].toString()} g',
                color: Colors.green,
              ),

            // Fiber
            if (product['nutriments']?['fiber_100g'] != null)
              _buildInfoTile(
                title: 'Fiber',
                subtitle: 'Fiber per 100g',
                value: '${product['nutriments']['fiber_100g'].toString()} g',
                color: Colors.green,
              ),

            // Sugar
            if (product['nutriments']?['sugars_100g'] != null)
              _buildInfoTile(
                title: 'Sugar',
                subtitle: 'Sugar per 100g',
                value: '${product['nutriments']['sugars_100g'].toString()} g',
                color: Colors.green,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(
      {required String title,
      required String subtitle,
      required String value,
      required Color color}) {
    return ListTile(
      leading: Icon(Icons.circle, color: color, size: 20),
      title: Text(title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
      subtitle:
          Text(subtitle, style: TextStyle(fontSize: 14, color: Colors.grey)),
      trailing: Text(value,
          style: TextStyle(
              fontSize: 16, color: color, fontWeight: FontWeight.bold)),
    );
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
