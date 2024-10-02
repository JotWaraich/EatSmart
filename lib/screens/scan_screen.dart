import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';
import '../services/product_service.dart';
import 'product_info_screen.dart';

class ScanScreen extends StatefulWidget {
  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  String _scanBarcode = '';
  bool _isLoading = false; // Variable to track loading state

  @override
  void initState() {
    super.initState();
    _startBarcodeScan(); // Automatically start scanning when the screen opens
  }

  Future<void> _startBarcodeScan() async {
    try {
      String barcode = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);

      // Ensure that the widget is still mounted before updating the state
      if (!mounted) return;

      if (barcode != '-1') {
        setState(() {
          _scanBarcode = barcode;
          _isLoading = true; // Set loading state to true
        });

        // Fetch product info after the scan
        final productService =
            Provider.of<ProductService>(context, listen: false);
        await productService.fetchProductInfo(barcode);

        try {
          await productService.storeProduct(); // Now this can throw an error
        } catch (e) {
          // Handle the error from storeProduct
          print("Error storing product: $e");
          _showAlert('Error', 'Failed to store product: $e');
          return; // Exit if there's an error
        }

        // Ensure the widget is still mounted before navigating to the product info screen
        if (mounted) {
          setState(() {
            _isLoading = false; // Set loading state to false after fetching
          });

          if (productService.productData != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProductInfoScreen()),
            );
          } else {
            _showAlert('Product not found', 'No product data available.');
          }
        }
      }
    } catch (e) {
      print("Error during barcode scan: $e");
      _showAlert('Error', 'An error occurred while scanning the barcode.');
    }
  }

  void _showAlert(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan a Product'),
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator() // Show loading indicator while fetching
            : ElevatedButton(
                onPressed: () async {
                  await _startBarcodeScan();
                },
                child: const Text('Scan again'),
              ),
      ),
    );
  }
}
