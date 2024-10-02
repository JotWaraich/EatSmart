import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/db_service.dart'; // Replace with your actual path

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dbService = Provider.of<DBService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan History'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: dbService.getScanHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading scan history'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No products scanned yet!'));
          }

          final scanHistory = snapshot.data!;

          return ListView.builder(
            itemCount: scanHistory.length,
            itemBuilder: (context, index) {
              final scan = scanHistory[index];
              return Card(
                elevation: 4,
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  leading: Image.network(
                    scan['image_url'] ?? '',
                    width: 50,
                    height: 50,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.image_not_supported),
                  ),
                  title: Text(scan['product_name'] ?? 'Unknown Product'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          'Nutrient Score: ${scan['nutrient_score'] ?? 'N/A'}'),
                      Text(
                          'Nutriscore Grade: ${scan['nutriscore_grade'] ?? 'Unknown'}'),
                      Text('Scanned on: ${scan['scan_date']}'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
