import 'package:autopartsadmin/Helper/custom_card.dart';
import 'package:autopartsadmin/screens/main_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore _db = FirebaseFirestore.instance;
    // int totalRevenue = 0;
    // int totalServiceRevenue = 0;
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            SizedBox(height: 10),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //     Column(
            //       children: [
            //         Text(
            //           "Total Revenue \nFrom Order",
            //           textAlign: TextAlign.center,
            //           style: TextStyle(
            //             fontSize: 16,
            //             fontWeight: FontWeight.w600,
            //           ),
            //         ),
            //         SizedBox(height: 10),
            //         StreamBuilder<QuerySnapshot>(
            //             stream: _db
            //                 .collection("orders")
            //                 .where("deliverd", isEqualTo: "Done")
            //                 .snapshots(),
            //             builder: (context, snapshot) {
            //               if (snapshot.data == null) return Text('');
            //               for (int i = 0; i < snapshot.data.docs.length; i++) {
            //                 totalRevenue = totalRevenue +
            //                     snapshot.data.docs[i].data()['totalPrice'];
            //               }
            //               return Text(
            //                 "\৳" + totalRevenue.toString(),
            //                 style: TextStyle(
            //                   fontSize: 22,
            //                   color: Colors.deepOrangeAccent[200],
            //                   fontWeight: FontWeight.bold,
            //                 ),
            //               );
            //             }),
            //       ],
            //     ),
            //     Column(
            //       children: [
            //         Text(
            //           "Total Revenue \nFrom Service",
            //           textAlign: TextAlign.center,
            //           style: TextStyle(
            //             fontSize: 16,
            //             fontWeight: FontWeight.w600,
            //           ),
            //         ),
            //         SizedBox(height: 10),
            //         StreamBuilder<QuerySnapshot>(
            //             stream: _db
            //                 .collection("serviceOrder")
            //                 .where("deliverd", isEqualTo: "Done")
            //                 .snapshots(),
            //             builder: (context, snapshot) {
            //               if (snapshot.data == null) return Text('');
            //               for (int i = 0; i < snapshot.data.docs.length; i++) {
            //                 totalServiceRevenue = totalServiceRevenue +
            //                     snapshot.data.docs[i].data()['totalPrice'];
            //               }
            //               return Text(
            //                 "\৳" + totalServiceRevenue.toString(),
            //                 style: TextStyle(
            //                   fontSize: 22,
            //                   color: Colors.deepOrangeAccent[200],
            //                   fontWeight: FontWeight.bold,
            //                 ),
            //               );
            //             }),
            //       ],
            //     ),
            //   ],
            // ),

            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              padding: EdgeInsets.zero,
              physics: NeverScrollableScrollPhysics(),
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream: _db.collection("users").snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.data == null) return Text('');
                    return CustomCard(
                      titleicon: Icons.people_alt_outlined,
                      titletext: "Users",
                      counttext: snapshot.data.docs.length.toString(),
                    );
                  },
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: _db.collection("categories").snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.data == null) return Text('');
                    return CustomCard(
                      titleicon: Icons.category_outlined,
                      titletext: "Categories",
                      counttext: snapshot.data.docs.length.toString(),
                    );
                  },
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: _db.collection("products").snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.data == null) return Text('');
                    return CustomCard(
                      titleicon: Icons.list_alt_outlined,
                      titletext: "Products",
                      counttext: snapshot.data.docs.length.toString(),
                    );
                  },
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: _db.collection("brands").snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.data == null) return Text('');
                    return CustomCard(
                      titleicon: Icons.branding_watermark_outlined,
                      titletext: "Brands",
                      counttext: snapshot.data.docs.length.toString(),
                    );
                  },
                ),
                StreamBuilder<QuerySnapshot>(
                    stream: _db.collection("service").snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.data == null) return Text('');
                      return CustomCard(
                        titleicon: Icons.calendar_today_outlined,
                        titletext: "Service",
                        counttext: snapshot.data.docs.length.toString(),
                      );
                    }),
                StreamBuilder<QuerySnapshot>(
                    stream: _db.collection("orders").snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.data == null) return Text('');
                      return CustomCard(
                        titleicon: Icons.local_shipping_outlined,
                        titletext: "Orders",
                        counttext: snapshot.data.docs.length.toString(),
                      );
                    }),
                StreamBuilder<QuerySnapshot>(
                    stream: _db.collection("serviceOrder").snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.data == null) return Text('');
                      return CustomCard(
                        titleicon: Icons.date_range_outlined,
                        titletext: "Service\n Orders",
                        counttext: snapshot.data.docs.length.toString(),
                      );
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
