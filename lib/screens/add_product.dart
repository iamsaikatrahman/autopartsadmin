import 'dart:io';
import 'package:autopartsadmin/model/product_model.dart';
import 'package:autopartsadmin/widgets/customsimpledialogoption.dart';
import 'package:autopartsadmin/widgets/error_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class AddProduct extends StatefulWidget {
  final ProductModel productModel;

  const AddProduct({Key key, this.productModel}) : super(key: key);
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  File file;
  var seletedCategory, seletedBrand, selectedStatusType;
  TextEditingController descriptionController = TextEditingController();
  TextEditingController orginalPriceController = TextEditingController();
  TextEditingController newPriceController = TextEditingController();
  TextEditingController offerPercentController = TextEditingController();
  TextEditingController productNameController = TextEditingController();
  TextEditingController shortInfoController = TextEditingController();
  List<String> status = <String>['Available', 'Unavailable'];
  String productId = DateTime.now().microsecondsSinceEpoch.toString();

  @override
  Widget build(BuildContext context) {
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

    pickPhotoFromGallery() async {
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
        title: Text("Add Product"),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.cancel_outlined),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          FlatButton(
            padding: EdgeInsets.zero,
            child: Icon(
              Icons.add_circle_outline,
              size: 30,
              color: Colors.white,
            ),
            onPressed: () async {
              var connectivityResult = await Connectivity().checkConnectivity();
              if (connectivityResult != ConnectivityResult.mobile &&
                  connectivityResult != ConnectivityResult.wifi) {
                Fluttertoast.showToast(msg: 'No internet connectivity');
                return;
              }
              if (shortInfoController.text.isNotEmpty &&
                  productNameController.text.isNotEmpty &&
                  descriptionController.text.isNotEmpty &&
                  orginalPriceController.text.isNotEmpty &&
                  newPriceController.text.isNotEmpty &&
                  offerPercentController.text.isNotEmpty &&
                  file != null &&
                  seletedCategory != null &&
                  seletedBrand != null &&
                  selectedStatusType != null) {
                uploadImageAndSaveItemInfo();
                Fluttertoast.showToast(msg: 'Product Addedd Successfully');
                Navigator.pop(context);
              } else {
                showDialog(
                  context: context,
                  builder: (c) {
                    return ErrorAlertDialog(
                      message: "Please fill up all information.",
                    );
                  },
                );
              }
            },
          ),
        ],
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
                        : AssetImage(
                            "assets/authenticaiton/take_image.png",
                          ),
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
                    controller: shortInfoController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      hintText: "Short Info",
                      labelText: "Short Info",
                      labelStyle: TextStyle(color: Colors.deepOrangeAccent),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: productNameController,
                    decoration: InputDecoration(
                      hintText: "Enter Product Name",
                      labelText: "Product Name",
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
                  TextFormField(
                    controller: descriptionController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: "Description",
                      labelText: "Description",
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
                    controller: newPriceController,
                    readOnly: true,
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

  uploadImageAndSaveItemInfo() async {
    String imageDownloadUrl = await uploadItemImage(file);
    saveItemInfo(imageDownloadUrl);
  }

  Future<String> uploadItemImage(mFileImage) async {
    final Reference reference =
        FirebaseStorage.instance.ref().child("Products");
    UploadTask uploadTask =
        reference.child("Product_$productId.jpg").putFile(mFileImage);
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  saveItemInfo(downloadUrl) {
    final itemsRef = FirebaseFirestore.instance.collection("products");
    itemsRef.doc(productId).set({
      "productId": productId,
      "shortInfo": shortInfoController.text.trim(),
      "productName": productNameController.text.trim(),
      "description": descriptionController.text.trim(),
      "orginalprice": int.parse(orginalPriceController.text),
      "newprice": int.parse(newPriceController.text),
      "offer": int.parse(offerPercentController.text),
      "publishedDate": DateTime.now(),
      "status": selectedStatusType,
      "categoryName": seletedCategory,
      "brandName": seletedBrand,
      "productImgUrl": downloadUrl,
    });
  }
}
