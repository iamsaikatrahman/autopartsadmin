import 'package:autopartsadmin/services/service_status.dart';
import 'package:autopartsadmin/widgets/loading_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class UserServiceDetails extends StatefulWidget {
  final String orderId;
  final String addressId;

  const UserServiceDetails({Key key, this.orderId, this.addressId})
      : super(key: key);
  @override
  _UserServiceDetailsState createState() => _UserServiceDetailsState();
}

class _UserServiceDetailsState extends State<UserServiceDetails> {
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
        title: Text("Orders Details"),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.cancel_outlined),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("serviceOrder")
                    .where("orderId", isEqualTo: widget.orderId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return circularProgress();
                  }
                  return Container(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              leading: Image.network(
                                snapshot.data.docs[index]
                                    .data()['serviceImage'],
                                width: 80,
                                height: 80,
                              ),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    snapshot.data.docs[index]
                                        .data()['serviceName'],
                                    maxLines: 2,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    "Date: " +
                                        snapshot.data.docs[index]
                                            .data()['date'],
                                    maxLines: 2,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    "\৳" +
                                        snapshot.data.docs[index]
                                            .data()['newPrice']
                                            .toString(),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepOrangeAccent[200],
                                    ),
                                  )
                                ],
                              ),
                              trailing: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "✖",
                                      style: TextStyle(
                                        color: Colors.deepOrangeAccent[200],
                                      ),
                                    ),
                                    TextSpan(
                                      text: snapshot.data.docs[index]
                                          .data()['quantity']
                                          .toString(),
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("useraddress")
                    .where("addressId", isEqualTo: widget.addressId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 20),
                        child: Container(
                          width: double.infinity,
                          child: Table(
                            children: [
                              TableRow(
                                children: [
                                  KeyText(msg: "Customer Name"),
                                  Text(
                                    snapshot.data.docs[index]
                                        .data()['customerName'],
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  KeyText(msg: "Phone"),
                                  Text(
                                    snapshot.data.docs[index]
                                        .data()['phoneNumber'],
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  KeyText(msg: "City"),
                                  Text(
                                    snapshot.data.docs[index].data()['city'],
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  KeyText(msg: "Area"),
                                  Text(
                                    snapshot.data.docs[index].data()['area'],
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  KeyText(msg: "House NO"),
                                  Text(
                                    snapshot.data.docs[index]
                                        .data()['houseandroadno'],
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  KeyText(msg: "Area Code"),
                                  Text(
                                    snapshot.data.docs[index]
                                        .data()['areacode'],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              Card(
                elevation: 3,
                child: Container(
                  height: 50,
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      "Order Status",
                      style: TextStyle(
                        letterSpacing: 1,
                        color: Colors.deepOrangeAccent[200],
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("serviceOrder")
                      .where("orderId", isEqualTo: widget.orderId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Container();
                    }

                    return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          DateTime orderRecivedTime = (snapshot.data.docs[index]
                                  .data()['orderRecivedTime'])
                              .toDate();
                          DateTime beingPreParedTime = (snapshot
                                  .data.docs[index]
                                  .data()['beingPreParedTime'])
                              .toDate();
                          DateTime onTheWayTime =
                              (snapshot.data.docs[index].data()['onTheWayTime'])
                                  .toDate();
                          DateTime deliverdTime =
                              (snapshot.data.docs[index].data()['deliverdTime'])
                                  .toDate();
                          return Card(
                            elevation: 3,
                            child: Container(
                              height: 500,
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsets.all(14.0),
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          children: [
                                            IconDoneOrNotDone(
                                              isdone: (snapshot.data.docs[index]
                                                              .data()[
                                                          'orderRecived'] ==
                                                      'Done')
                                                  ? true
                                                  : false,
                                            ),
                                            dividerBetweenDoneIcon(
                                              (snapshot.data.docs[index].data()[
                                                          'beingPrePared'] ==
                                                      'Done')
                                                  ? true
                                                  : false,
                                              (snapshot.data.docs[index].data()[
                                                          'beingPrePared'] ==
                                                      'Done')
                                                  ? true
                                                  : false,
                                            ),
                                            IconDoneOrNotDone(
                                              isdone: (snapshot.data.docs[index]
                                                              .data()[
                                                          'beingPrePared'] ==
                                                      'Done')
                                                  ? true
                                                  : false,
                                            ),
                                            dividerBetweenDoneIcon(
                                              (snapshot.data.docs[index]
                                                          .data()['onTheWay'] ==
                                                      'Done')
                                                  ? true
                                                  : false,
                                              (snapshot.data.docs[index]
                                                          .data()['onTheWay'] ==
                                                      'Done')
                                                  ? true
                                                  : false,
                                            ),
                                            IconDoneOrNotDone(
                                              isdone: (snapshot.data.docs[index]
                                                          .data()['onTheWay'] ==
                                                      'Done')
                                                  ? true
                                                  : false,
                                            ),
                                            dividerBetweenDoneIcon(
                                              (snapshot.data.docs[index]
                                                          .data()['deliverd'] ==
                                                      'Done')
                                                  ? true
                                                  : false,
                                              (snapshot.data.docs[index]
                                                          .data()['deliverd'] ==
                                                      'Done')
                                                  ? true
                                                  : false,
                                            ),
                                            IconDoneOrNotDone(
                                              isdone: (snapshot.data.docs[index]
                                                          .data()['deliverd'] ==
                                                      'Done')
                                                  ? true
                                                  : false,
                                            ),
                                          ],
                                        ),
                                        SizedBox(width: 20),
                                        Expanded(
                                          child: Column(
                                            children: [
                                              OrderStatusCard(
                                                title: "Order Recived",
                                                isPressed: (snapshot.data
                                                                .docs[index]
                                                                .data()[
                                                            'orderRecived'] ==
                                                        "Done")
                                                    ? true
                                                    : false,
                                                onPressed: () {
                                                  ServiceOrderStatusService()
                                                      .updateOrderRecived(
                                                    snapshot.data.docs[index]
                                                        .data()['orderId'],
                                                  );
                                                  Fluttertoast.showToast(
                                                      msg: "Order Recived");
                                                },
                                                time: DateFormat.yMMMd()
                                                    .add_jm()
                                                    .format(orderRecivedTime),
                                              ),
                                              SizedBox(height: 15),
                                              OrderStatusCard(
                                                title: "Service Man PrePared",
                                                isPressed: (snapshot.data
                                                                .docs[index]
                                                                .data()[
                                                            'beingPrePared'] ==
                                                        'Done')
                                                    ? true
                                                    : false,
                                                onPressed: () {
                                                  ServiceOrderStatusService()
                                                      .updateBeingPrePared(
                                                    snapshot.data.docs[index]
                                                        .data()['orderId'],
                                                  );
                                                  Fluttertoast.showToast(
                                                      msg:
                                                          "Service Man PrePared");
                                                },
                                                time: DateFormat.yMMMd()
                                                    .add_jm()
                                                    .format(beingPreParedTime),
                                              ),
                                              SizedBox(height: 15),
                                              OrderStatusCard(
                                                title: "On the way",
                                                isPressed: (snapshot.data
                                                                .docs[index]
                                                                .data()[
                                                            'onTheWay'] ==
                                                        'Done')
                                                    ? true
                                                    : false,
                                                onPressed: () {
                                                  ServiceOrderStatusService()
                                                      .updateOnTheWay(
                                                    snapshot.data.docs[index]
                                                        .data()['orderId'],
                                                  );
                                                  Fluttertoast.showToast(
                                                      msg: "On the way");
                                                },
                                                time: DateFormat.yMMMd()
                                                    .add_jm()
                                                    .format(onTheWayTime),
                                              ),
                                              SizedBox(height: 15),
                                              OrderStatusCard(
                                                title: "Service Complete",
                                                isPressed: (snapshot.data
                                                                .docs[index]
                                                                .data()[
                                                            'deliverd'] ==
                                                        'Done')
                                                    ? true
                                                    : false,
                                                onPressed: () {
                                                  ServiceOrderStatusService()
                                                      .updateDeliverd(
                                                    snapshot.data.docs[index]
                                                        .data()['orderId'],
                                                  );
                                                  Fluttertoast.showToast(
                                                      msg: "Service Complete");
                                                },
                                                time: DateFormat.yMMMd()
                                                    .add_jm()
                                                    .format(deliverdTime),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 20),
                                    Text(
                                      (snapshot.data.docs[index]
                                                  .data()['deliverd'] ==
                                              'Done')
                                          ? "!!Congratulations!!\nThe Service has been successfully Completed."
                                          : "",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.deepOrangeAccent[200],
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Container dividerBetweenDoneIcon(bool isdone, bool isPressed) {
    return Container(
      height: (isPressed) ? 55 : 80,
      width: 2,
      color: (isdone) ? Colors.deepOrangeAccent[200] : Colors.grey,
    );
  }
}

class IconDoneOrNotDone extends StatelessWidget {
  const IconDoneOrNotDone({
    this.isdone,
    Key key,
  }) : super(key: key);
  final bool isdone;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      child: CircleAvatar(
        backgroundColor: (isdone) ? Colors.deepOrangeAccent[200] : Colors.grey,
        child: Icon(
          (isdone) ? Icons.done : null,
          color: Colors.white,
        ),
      ),
    );
  }
}

class OrderStatusCard extends StatelessWidget {
  const OrderStatusCard({
    Key key,
    @required this.title,
    @required this.onPressed,
    @required this.time,
    this.isPressed,
  }) : super(key: key);
  final String title;
  final Function onPressed;
  final String time;

  final bool isPressed;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          (isPressed)
              ? Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 10),
                    Text(
                      time,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                )
              : RaisedButton(
                  color: Colors.deepOrangeAccent[200],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  onPressed: onPressed,
                  child: Text(
                    "Done",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
          SizedBox(height: 10),
          Container(
            height: 3,
            width: double.infinity,
            color: Colors.blueGrey[50],
          ),
        ],
      ),
    );
  }
}

class KeyText extends StatelessWidget {
  final String msg;

  const KeyText({Key key, this.msg}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(
      msg,
      style: TextStyle(
        fontSize: 16,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
