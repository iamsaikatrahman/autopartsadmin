import 'package:autopartsadmin/model/carousel_model.dart';
import 'package:autopartsadmin/services/carousel_service.dart';
import 'package:autopartsadmin/widgets/loading_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AllCarousel extends StatefulWidget {
  @override
  _AllCarouselState createState() => _AllCarouselState();
}

class _AllCarouselState extends State<AllCarousel> {
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
        title: Text("All Carousels"),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("Carousels")
              .orderBy("publishedDate", descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return circularProgress();
            }
            return (snapshot.data.docs.length == 0)
                ? Center(
                    child: Text(
                      "No Carousel Image.\nPlease added Carousel Image!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                  )
                : SingleChildScrollView(
                    child: Container(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          CarouselModel carouselModel = CarouselModel.fromJson(
                              snapshot.data.docs[index].data());
                          return Stack(
                            children: [
                              Card(
                                margin: EdgeInsets.all(5),
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Container(
                                  height: 230.0,
                                  width: double.infinity,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      carouselModel.carouselImgUrl,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 5,
                                right: 5,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.blueGrey,
                                        offset: Offset(2, 3),
                                        blurRadius: 6,
                                        spreadRadius: -3,
                                      )
                                    ],
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                    ),
                                  ),
                                  child: IconButton(
                                    padding: EdgeInsets.zero,
                                    icon: Icon(
                                      Icons.clear,
                                      color: Colors.deepOrangeAccent,
                                    ),
                                    onPressed: () {
                                      CarouselService()
                                          .deleteItem(carouselModel.carouselId);
                                      Fluttertoast.showToast(
                                          msg: 'Carousel delete Successfully');
                                    },
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  );
          }),
    );
  }
}
