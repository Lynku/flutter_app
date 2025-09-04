import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:path_provider/path_provider.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  List<Map<String, dynamic>> _scannedProducts = [];
  bool _isScanning = true;

  @override
  void initState() {
    super.initState();
    _loadScannedProducts();
  }

  Future<File> get _scannedProductsFile async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/scanned_products.json');
  }

  Future<void> _loadScannedProducts() async {
    try {
      final file = await _scannedProductsFile;
      if (await file.exists()) {
        final content = await file.readAsString();
        if (content.isNotEmpty) {
          setState(() {
            _scannedProducts =
                List<Map<String, dynamic>>.from(json.decode(content));
          });
        }
      }
    } catch (e) {
      // Handle errors
    }
  }

  Future<void> _saveProduct(Map<String, dynamic> product) async {
    _scannedProducts.add(product);
    final file = await _scannedProductsFile;
    await file.writeAsString(json.encode(_scannedProducts));
    _loadScannedProducts();
  }

  Future<void> _handleBarcode(String barcode) async {
    if (!_isScanning) return;
    setState(() {
      _isScanning = false;
    });

    try {
      //     .get(Uri.parse('http://localhost:8080/products/$barcode'));
      final response = await http
             .get(Uri.parse('https://world.openfoodfacts.org/api/v0/product/$barcode.json'));
      if (response.statusCode == 200) {
        final product = json.decode(response.body);
        await _saveProduct(product);
      }
    } catch (e) {
      // Handle errors
    } finally {
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _isScanning = true;
          });
        }
      });
    }
  }

  Future<void> _addToMeal(Map<String, dynamic> product) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final mealsFile = File('${directory.path}/meals.json');
      List<Map<String, dynamic>> meals = [];
      if (await mealsFile.exists()) {
        final content = await mealsFile.readAsString();
        if (content.isNotEmpty) {
          meals = List<Map<String, dynamic>>.from(json.decode(content));
        }
      }
      meals.add(product);
      await mealsFile.writeAsString(json.encode(meals));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${product['name']} added to today\'s meals'),
        ),
      );
    } catch (e) {
      // Handle errors
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scanner'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 200,
            child: MobileScanner(
              onDetect: (capture) {
                final List<Barcode> barcodes = capture.barcodes;
                for (final barcode in barcodes) {
                  if (barcode.rawValue != null) {
                    _handleBarcode(barcode.rawValue!);
                    break;
                  }
                }
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _scannedProducts.length,
              itemBuilder: (context, index) {
                final product = _scannedProducts[index];
                return ListTile(
                  title: Text(product['name'] ?? 'No name'),
                  subtitle: Text(product['barcode'] ?? ''),
                  trailing: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => _addToMeal(product),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}