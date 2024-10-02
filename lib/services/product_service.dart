import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'db_service.dart'; // Import the DBService

class ProductService extends ChangeNotifier {
  Map<String, dynamic>? productData;
  final DBService dbService; // Declare DBService

  ProductService(this.dbService); // Pass DBService through the constructor

  Future<void> fetchProductInfo(String barcode) async {
    final url = 'https://world.openfoodfacts.org/api/v0/product/$barcode.json';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 1) {
        productData = data['product'];
      } else {
        productData = null;
      }
    } else {
      throw Exception('Failed to load product');
    }

    notifyListeners();
  }

  Future<void> storeProduct() async {
    if (productData != null) {
      try {
        await dbService.insertScan({
          'barcode': productData!['code'],
          'product_name': productData!['product_name'],
          'nutriscore_score':
              productData!['nutriscore_score']?.toString() ?? 'N/A',
          'nutriscore_grade':
              productData!['nutriscore_grade']?.toUpperCase() ?? 'Unknown',
          'image_url': productData!['image_url'] ?? '',
          'scan_date': DateTime.now().toIso8601String(),
        });
        print('Product stored successfully!'); // Confirmation message
      } catch (e) {
        print('Error storing product: $e'); // Print the error
        throw Exception('Failed to store product. $e'); // Rethrow the error
      }
    } else {
      print('No product data to store.');
      throw Exception(
          'No product data to store.'); // Rethrow for handling in the calling function
    }
  }
}
