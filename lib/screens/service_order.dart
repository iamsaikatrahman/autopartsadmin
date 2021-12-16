import 'package:autopartsadmin/config/config.dart';
import 'package:autopartsadmin/screens/user_service_details.dart';
import 'package:autopartsadmin/widgets/loading_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class ServiceOrders extends StatefulWidget {
  @override
  _ServiceOrdersState createState() => _ServiceOrdersState();
}

class _ServiceOrdersState extends State<ServiceOrders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepOrangeAccent, Colors.orange],
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        title: Text("Control Service"),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.cancel_outlined),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("serviceOrder")
            .orderBy("orderTime", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }
          return SingleChildScrollView(
            child: Container(
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DateTime myDateTime =
                      (snapshot.data.docs[index].data()['orderTime']).toDate();
                  return Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Order ID: ",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.deepOrangeAccent,
                                  ),
                                ),
                                TextSpan(
                                  text: snapshot.data.docs[index]
                                      .data()['orderId'],
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Text(
                          //   "(" +
                          //       (snapshot.data.docs[index]
                          //                   .data()[AutoParts.productID]
                          //                   .length -
                          //               1)
                          //           .toString() +
                          //       " items)",
                          //   style: TextStyle(
                          //     color: Colors.grey,
                          //     fontSize: 16,
                          //   ),
                          // ),
                          Text(
                            "Total Price: " +
                                snapshot.data.docs[index]
                                    .data()['totalPrice']
                                    .toString() +
                                " TK.",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            DateFormat.yMMMd().add_jm().format(myDateTime),
                          ),
                          Text(timeago
                              .format(DateTime.tryParse(snapshot
                                  .data.docs[index]
                                  .data()['orderTime']
                                  .toDate()
                                  .toString()))
                              .toString()),
                          RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => UserServiceDetails(
                                    orderId: snapshot.data.docs[index]
                                        .data()['orderId'],
                                    addressId: snapshot.data.docs[index]
                                        .data()['addressID'],
                                  ),
                                ),
                              );
                            },
                            color: Colors.deepOrangeAccent[200],
                            child: Text(
                              "Order Details",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
