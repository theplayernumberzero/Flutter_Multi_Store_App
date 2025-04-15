import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BuyerListWidget extends StatelessWidget {
  const BuyerListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _buyersStream =
        FirebaseFirestore.instance.collection('buyers').snapshots();

    Widget BuyerData(Widget widget, int? flex) {
      return Expanded(
        flex: flex!,
        child: Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
          child: Padding(padding: const EdgeInsets.all(8.0), child: widget),
        ),
      );
    }

    return StreamBuilder<QuerySnapshot>(
      stream: _buyersStream,
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
            final buyer = snapshot.data!.docs[index];
            return Row(
              children: [
                BuyerData(
                  SizedBox(
                    height: 50,
                    width: 50,
                    child: Image.network("https://picsum.photos/200/300"),
                  ),
                  1,
                ),
                BuyerData(Text(buyer['fullname']), 3),
                BuyerData(
                  Text(
                    buyer['state'] == "" ||
                            buyer['locality'] == "" ||
                            buyer['city'] == ""
                        ? "Adress didnt entered correctly"
                        : buyer['state'] +
                            "/" +
                            buyer['city'] +
                            "/" +
                            buyer['locality'],
                  ),
                  2,
                ),
                BuyerData(Text(buyer['email']), 2),
              ],
            );
          },
        );
      },
    );
  }
}
