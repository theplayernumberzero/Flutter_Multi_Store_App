import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class VendorListWidget extends StatelessWidget {
  const VendorListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _vendorsStream =
        FirebaseFirestore.instance.collection('vendors').snapshots();

    Widget VendorData(Widget widget, int? flex) {
      return Expanded(
        flex: flex!,
        child: Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
          child: Padding(padding: const EdgeInsets.all(8.0), child: widget),
        ),
      );
    }

    return StreamBuilder<QuerySnapshot>(
      stream: _vendorsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        //ShrinkWrap vermezsem hata verir
        return ListView.builder(
          shrinkWrap: true,
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final vendor = snapshot.data!.docs[index];
            return Row(
              children: [
                VendorData(
                  SizedBox(
                    height: 50,
                    width: 50,
                    child: Image.network("https://picsum.photos/200/300"),
                  ),
                  1,
                ),
                VendorData(Text(vendor['fullname']), 3),
                VendorData(
                  Text(
                    vendor['state'] == "" ||
                            vendor['locality'] == "" ||
                            vendor['city'] == ""
                        ? "Adress didnt entered correctly"
                        : vendor['state'] +
                            "/" +
                            vendor['city'] +
                            "/" +
                            vendor['locality'],
                  ),
                  2,
                ),
                VendorData(Text(vendor['email']), 2),
              ],
            );
          },
        );
      },
    );
  }
}
