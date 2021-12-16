import 'dart:io';

import 'package:autopartsadmin/model/service_model.dart';
import 'package:autopartsadmin/screens/services.dart';
import 'package:autopartsadmin/screens/products.dart';
import 'package:autopartsadmin/widgets/customsimpledialogoption.dart';
import 'package:autopartsadmin/widgets/error_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class EditService extends StatefulWidget {
  final ServiceModel serviceModel;

  const EditService({Key key, this.serviceModel}) : super(key: key);

  @override
  _EditServiceState createState() => _EditServiceState();
}

class _EditServiceState extends State<EditService> {
  File file;
  var seletedCategory, seletedBrand, selectedStatusType;
  TextEditingController expectationController = TextEditingController();
  TextEditingController orginalPriceController = TextEditingController();
  TextEditingController newPriceController = TextEditingController();
  TextEditingController offerPercentController = TextEditingController();
  TextEditingController serviceNameController = TextEditingController();
  TextEditingController aboutInfoController = TextEditingController();
  List<String> status = <String>['Available', 'Unavailable'];
  String productId = DateTime.now().microsecondsSinceEpoch.toString();

  @override
  void initState() {
    aboutInfoController.text = widget.serviceModel.aboutInfo;
    serviceNameController.text = widget.serviceModel.serviceName;
    expectationController.text = widget.serviceModel.expectation;
    orginalPriceController.text = widget.serviceModel.orginalprice.toString();
    newPriceController.text = widget.serviceModel.newprice.toString();
    offerPercentController.text = widget.serviceModel.offervalue.toString();
    selectedStatusType = widget.serviceModel.status;
    seletedBrand = widget.serviceModel.brandName;
    seletedCategory = widget.serviceModel.categoryName;
    super.initState();
  }

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
        title: Text("Edit Service"),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.cancel_outlined),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                takeImage(context);
              },
              child: Container(
                height: 230.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: (file != null)
                        ? FileImage(file)
                        : NetworkImage(widget.serviceModel.serviceImgUrl),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: aboutInfoController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      hintText: "Write about the service...",
                      labelText: "About Service",
                      labelStyle: TextStyle(color: Colors.deepOrangeAccent),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: serviceNameController,
                    decoration: InputDecoration(
                      hintText: "Enter Service Name",
                      labelText: "Service Name",
                      labelStyle: TextStyle(color: Colors.deepOrangeAccent),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("categories")
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            Text('Loading');
                          }
                          if (snapshot.data == null)
                            return CircularProgressIndicator();

                          List<DropdownMenuItem> categoriesItem = [];
                          for (int i = 0; i < snapshot.data.docs.length; i++) {
                            DocumentSnapshot snap = snapshot.data.docs[i];
                            categoriesItem.add(
                              DropdownMenuItem(
                                child: Text(
                                  "${snap.data()['categoryName']}",
                                  style: TextStyle(color: Colors.black),
                                ),
                                value: "${snap.data()['categoryName']}",
                              ),
                            );
                          }
                          return Container(
                            width: MediaQuery.of(context).size.width / 2.5,
                            child: DropdownButton(
                              items: categoriesItem,
                              onChanged: (categoryValue) {
                                setState(() {
                                  seletedCategory = categoryValue;
                                });
                              },
                              value: seletedCategory,
                              isExpanded: true,
                              hint: Text(
                                'Select Category',
                                style: TextStyle(
                                  color: Colors.deepOrangeAccent,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("brands")
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            Text('Loading');
                          }
                          if (snapshot.data == null)
                            return CircularProgressIndicator();

                          List<DropdownMenuItem> brandsItem = [];
                          for (int i = 0; i < snapshot.data.docs.length; i++) {
                            DocumentSnapshot snap = snapshot.data.docs[i];
                            brandsItem.add(
                              DropdownMenuItem(
                                child: Text(
                                  "${snap.data()['brandName']}",
                                  style: TextStyle(color: Colors.black),
                                ),
                                value: "${snap.data()['brandName']}",
                              ),
                            );
                          }
                          return Container(
                            width: MediaQuery.of(context).size.width / 2.5,
                            child: DropdownButton(
                              items: brandsItem,
                              onChanged: (brandValue) {
                                setState(() {
                                  seletedBrand = brandValue;
                                });
                              },
                              value: seletedBrand,
                              isExpanded: true,
                              hint: Text(
                                'Select Brand',
                                style: TextStyle(
                                  color: Colors.deepOrangeAccent,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  TextFormField(
                    maxLines: 3,
                    controller: expectationController,
                    decoration: InputDecoration(
                      hintText: "Write some What to Expect...",
                      labelText: "Expectation",
                      labelStyle: TextStyle(color: Colors.deepOrangeAccent),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 4,
                        child: TextFormField(
                          controller: orginalPriceController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: "Enter Original Price",
                            labelText: "Original Price",
                            labelStyle:
                                TextStyle(color: Colors.deepOrangeAccent),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 4,
                        child: TextFormField(
                          controller: offerPercentController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: "Enter Offer percent",
                            labelText: "Offer Percent",
                            labelStyle:
                                TextStyle(color: Colors.deepOrangeAccent),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 4,
                        child: RaisedButton(
                          child: Text('='),
                          onPressed: () {
                            offerpercentageCalculation();
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    readOnly: true,
                    controller: newPriceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "Show New Price",
                      labelText: "New Price",
                      labelStyle: TextStyle(color: Colors.deepOrangeAccent),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: DropdownButton(
                      items: status
                          .map(
                            (value) => DropdownMenuItem(
                              child: Text(value),
                              value: value,
                            ),
                          )
                          .toList(),
                      onChanged: (selectedStatus) {
                        setState(() {
                          selectedStatusType = selectedStatus;
                        });
                      },
                      value: selectedStatusType,
                      isExpanded: true,
                      hint: Text(
                        'Select Status',
                        style: TextStyle(
                          color: Colors.deepOrangeAccent,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  RaisedButton(
                    child: Text('Update Product'),
                    onPressed: () {
                      if (aboutInfoController.text.isNotEmpty &&
                          serviceNameController.text.isNotEmpty &&
                          expectationController.text.isNotEmpty &&
                          orginalPriceController.text.isNotEmpty &&
                          newPriceController.text.isNotEmpty &&
                          offerPercentController.text.isNotEmpty &&
                          seletedCategory != null &&
                          seletedBrand != null &&
                          selectedStatusType != null) {
                        uploadImageAndSaveItemInfo();
                        Fluttertoast.showToast(
                            msg: 'Service Update Successfully');
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (_) => Services()));
                      } else {
                        showDialog(
                            context: context,
                            builder: (c) {
                              return ErrorAlertDialog(
                                message: "Please fill up all information.",
                              );
                            });
                      }
                    },
                  ),
                  RaisedButton(
                    color: Colors.redAccent,
                    child: Text(
                      'Delete Product',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      deleteItem();
                      Fluttertoast.showToast(
                          msg: 'Product Delete Successfully');
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (_) => Products()));
                    },
                  ),
                  SizedBox(height: 50),
                ],
              ),
            ),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  offerpercentageCalculation() {
    int orginalpricevalue = int.parse(orginalPriceController.text);
    int offervalue = int.parse(offerPercentController.text);
    double offerpercent = offervalue / 100;
    double mofferwithorginal = orginalpricevalue * offerpercent;
    double newpricevalue = orginalpricevalue - mofferwithorginal;
    setState(() {
      newPriceController.text = newpricevalue.toStringAsFixed(0);
    });
  }

  takeImage(mContext) {
    return showDialog(
        context: mContext,
        builder: (con) {
          return SimpleDialog(
            title: Text(
              "Product Image",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.deepOrangeAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
            children: [
              SimpleDialogOption(
                child: CustomSimpleDialogOption(
                  icon: Icons.photo_camera_outlined,
                  title: "Capture with Camera",
                ),
                onPressed: capturePhotoWithCamera,
              ),
              SimpleDialogOption(
                child: CustomSimpleDialogOption(
                  icon: Icons.photo_outlined,
                  title: "Select from Gallery",
                ),
                onPressed: pickPhotoFromGallery,
              ),
              SimpleDialogOption(
                child: Text(
                  "Cancle",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  capturePhotoWithCamera() async {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(
      source: ImageSource.camera,
      maxHeight: 680,
      maxWidth: 970,
    );
    setState(() {
      file = imageFile;
    });
  }

  void pickPhotoFromGallery() async {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 680,
      maxWidth: 970,
    );
    setState(() {
      file = imageFile;
    });
  }

  uploadImageAndSaveItemInfo() async {
    if (file != null) {
      String imageDownloadUrl = await uploadItemImage(file);
      updateItemInfo(imageDownloadUrl);
    } else {
      String imageDownloadUrl = widget.serviceModel.serviceImgUrl;
      updateItemInfo(imageDownloadUrl);
    }
  }

  Future<String> uploadItemImage(mFileImage) async {
    final Reference reference =
        FirebaseStorage.instance.ref().child("Services");
    UploadTask uploadTask = reference
        .child("Service_${widget.serviceModel.serviceId}.jpg")
        .putFile(mFileImage);
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  updateItemInfo(downloadUrl) {
    final itemsRef = FirebaseFirestore.instance.collection("service");
    itemsRef.doc(widget.serviceModel.serviceId).update({
      "aboutInfo": aboutInfoController.text.trim(),
      "serviceName": serviceNameController.text.trim(),
      "expectation": expectationController.text.trim(),
      "orginalprice": int.parse(orginalPriceController.text),
      "newprice": int.parse(newPriceController.text),
      "offer": int.parse(offerPercentController.text),
      "publishedDate": DateTime.now(),
      "status": selectedStatusType,
      "categoryName": seletedCategory,
      "brandName": seletedBrand,
      "serviceImgUrl": downloadUrl,
    });
  }

  deleteItem() {
    final itemsRef = FirebaseFirestore.instance.collection("service");
    itemsRef.doc(widget.serviceModel.serviceId).delete();
  }
}
