import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_app/src/core/data/data_saver.dart';

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
        final data = json.decode(response.body);
        if (data['status'] == 1 && data['product'] != null) {
          final product = data['product'];
          final nutriments = product['nutriments'];
          final newProduct = {
            'name': product['product_name'],
            'barcode': barcode,
            'energy_kcal_100g': nutriments['energy-kcal_100g'],
            'nutriments': nutriments,
          };
          await _saveProduct(newProduct);
        }
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
      final dataSaver = DataSaver();
      final selectedDate = DateTime.now();
      final formattedDate =
          "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";

      final dailyData = await dataSaver.readDailyData(formattedDate) ??
          {
            'date': formattedDate,
            'waterGlasses': 0,
            'burnedActivities': <String, double>{},
            'mealCalories': <String, double>{},
          };

      final mealCalories = (dailyData['mealCalories'] as Map).cast<String, double>();
      final productName = product['name'] as String;
      final calories = (product['nutriments']['energy-kcal_serving'] ??
          product['energy_kcal_100g']) as num;

      mealCalories[productName] = calories.toDouble();
      dailyData['mealCalories'] = mealCalories;

      await dataSaver.saveDailyData(formattedDate, dailyData);

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
                final energy = product['energy_kcal_100g'];
                return ListTile(
                  title: Text(product['name'] ?? 'No name'),
                  subtitle: Text('Barcode: ${product['barcode'] ?? ''} - ${energy ?? 'N/A'} kcal'),
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