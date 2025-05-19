import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PriceHistoryScreen extends StatelessWidget {
  static const String id = "/priceHistory";
  const PriceHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('products').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Bir hata oluştu'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Product Price History',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Card(
                  elevation: 4,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16),
                    child: DataTable(
                      columnSpacing: 20,
                      columns: [
                        DataColumn(label: Text('Product Picture')),
                        DataColumn(label: Text('Product Name')),
                        DataColumn(label: Text('Category')),
                        DataColumn(label: Text('Vendor')),
                        DataColumn(label: Text('Product Price History')),
                      ],
                      rows:
                          snapshot.data!.docs.map((doc) {
                            Map<String, dynamic> data =
                                doc.data() as Map<String, dynamic>;
                            List<dynamic> priceHistory =
                                data['productPrices'] ?? [];

                            return DataRow(
                              cells: [
                                DataCell(
                                  Container(
                                    width: 50,
                                    height: 50,
                                    child: Image.network(
                                      data['productImage'][0],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                DataCell(Text(data['productName'] ?? '')),
                                DataCell(Text(data['category'] ?? '')),
                                DataCell(Text(data['storeName'] ?? '')),

                                DataCell(
                                  IconButton(
                                    icon: Icon(Icons.history),
                                    onPressed: () {
                                      // Fiyat geçmişini kopyalayıp sıralama yapıyorum burada
                                      List<dynamic> sortedPriceHistory =
                                          List.from(priceHistory);

                                      //azalan sırada sıralama
                                      sortedPriceHistory.sort((a, b) {
                                        Timestamp timeA = a['time'];
                                        Timestamp timeB = b['time'];
                                        return timeB.compareTo(timeA);
                                      });

                                      showDialog(
                                        context: context,
                                        builder:
                                            (context) => Dialog(
                                              child: Container(
                                                padding: EdgeInsets.all(16),
                                                width: 400,
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      'Price History',
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    SizedBox(height: 16),
                                                    ...sortedPriceHistory.map((
                                                      price,
                                                    ) {
                                                      // priceHistory yerine sortedPriceHistory kullanıyorum, çünkü sıralanmış yapı kullanacağım
                                                      Timestamp timestamp =
                                                          price['time'];
                                                      String formattedDate =
                                                          DateFormat(
                                                            'dd/MM/yyyy HH:mm',
                                                          ).format(
                                                            timestamp.toDate(),
                                                          );
                                                      return ListTile(
                                                        title: Text(
                                                          '\$${price['price']}',
                                                        ),
                                                        subtitle: Text(
                                                          formattedDate,
                                                        ),
                                                      );
                                                    }).toList(),
                                                    TextButton(
                                                      onPressed:
                                                          () => Navigator.pop(
                                                            context,
                                                          ),
                                                      child: Text('Close'),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
