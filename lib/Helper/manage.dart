import 'package:autopartsadmin/Helper/custom_manage_button.dart';
import 'package:autopartsadmin/screens/add_carousel.dart';
import 'package:autopartsadmin/screens/add_product.dart';
import 'package:autopartsadmin/screens/add_service.dart';
import 'package:autopartsadmin/screens/control_orders.dart';
import 'package:autopartsadmin/screens/services.dart';
import 'package:autopartsadmin/screens/products.dart';
import 'package:autopartsadmin/services/brand.dart';
import 'package:autopartsadmin/services/category.dart';
import 'package:autopartsadmin/widgets/error_dialog.dart';
import 'package:autopartsadmin/widgets/nointernetalertdialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Manage extends StatefulWidget {
  @override
  _ManageState createState() => _ManageState();
}

class _ManageState extends State<Manage> {
  GlobalKey<FormState> _categoryformkey = GlobalKey<FormState>();
  GlobalKey<FormState> _brandformkey = GlobalKey<FormState>();
  TextEditingController categoryTextEditingController = TextEditingController();
  TextEditingController brandTextEditingController = TextEditingController();
  BrandService _brandService = BrandService();
  CategoryService _categoryService = CategoryService();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomManageButton(
          icon: Icons.add,
          title: "Add Product / Service",
          onTap: () {
            showCupertinoModalPopup(
              context: context,
              builder: (context) {
                return CupertinoActionSheet(
                  title: Text("Select Action"),
                  message: Text("Please Choose any Action."),
                  actions: [
                    CupertinoActionSheetAction(
                      child: Text(
                        "Add Product",
                        style: TextStyle(
                          color: Colors.deepOrangeAccent,
                        ),
                      ),
                      isDefaultAction: true,
                      onPressed: () async {
                        var connectivityResult =
                            await Connectivity().checkConnectivity();
                        if (connectivityResult != ConnectivityResult.mobile &&
                            connectivityResult != ConnectivityResult.wifi) {
                          return showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return NoInternetAlertDialog();
                            },
                          );
                        }

                        Route route =
                            MaterialPageRoute(builder: (c) => AddProduct());
                        Navigator.push(context, route);
                      },
                    ),
                    CupertinoActionSheetAction(
                      child: Text(
                        "Add Service",
                        style: TextStyle(
                          color: Colors.deepOrangeAccent,
                        ),
                      ),
                      isDefaultAction: true,
                      onPressed: () async {
                        var connectivityResult =
                            await Connectivity().checkConnectivity();
                        if (connectivityResult != ConnectivityResult.mobile &&
                            connectivityResult != ConnectivityResult.wifi) {
                          return showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return NoInternetAlertDialog();
                            },
                          );
                        }

                        Route route =
                            MaterialPageRoute(builder: (c) => AddService());
                        Navigator.push(context, route);
                      },
                    ),
                  ],
                  cancelButton: CupertinoActionSheetAction(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        color: Colors.deepOrangeAccent,
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
        CustomManageButton(
          icon: Icons.category_outlined,
          title: "Add Category",
          onTap: addCategory,
        ),
        CustomManageButton(
          icon: Icons.branding_watermark_outlined,
          title: "Add Brand",
          onTap: addBrand,
        ),
        CustomManageButton(
          icon: Icons.slideshow_outlined,
          title: "Add Carousel",
          onTap: () async {
            var connectivityResult = await Connectivity().checkConnectivity();
            if (connectivityResult != ConnectivityResult.mobile &&
                connectivityResult != ConnectivityResult.wifi) {
              return showDialog(
                context: context,
                builder: (BuildContext context) {
                  return NoInternetAlertDialog();
                },
              );
            }
            Route route = MaterialPageRoute(builder: (c) => AddCarousel());
            Navigator.push(context, route);
          },
        ),
        CustomManageButton(
          icon: Icons.list_alt_outlined,
          title: "Products / Services",
          onTap: () {
            showCupertinoModalPopup(
              context: context,
              builder: (context) {
                return CupertinoActionSheet(
                  title: Text("Select Action"),
                  message: Text("Please Choose any Action."),
                  actions: [
                    CupertinoActionSheetAction(
                      child: Text(
                        "See All Products",
                        style: TextStyle(
                          color: Colors.deepOrangeAccent,
                        ),
                      ),
                      isDefaultAction: true,
                      onPressed: () async {
                        var connectivityResult =
                            await Connectivity().checkConnectivity();
                        if (connectivityResult != ConnectivityResult.mobile &&
                            connectivityResult != ConnectivityResult.wifi) {
                          return showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return NoInternetAlertDialog();
                            },
                          );
                        }

                        Route route =
                            MaterialPageRoute(builder: (c) => Products());
                        Navigator.push(context, route);
                      },
                    ),
                    CupertinoActionSheetAction(
                      child: Text(
                        "See All Services",
                        style: TextStyle(
                          color: Colors.deepOrangeAccent,
                        ),
                      ),
                      isDefaultAction: true,
                      onPressed: () async {
                        var connectivityResult =
                            await Connectivity().checkConnectivity();
                        if (connectivityResult != ConnectivityResult.mobile &&
                            connectivityResult != ConnectivityResult.wifi) {
                          return showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return NoInternetAlertDialog();
                            },
                          );
                        }

                        Route route =
                            MaterialPageRoute(builder: (c) => Services());
                        Navigator.push(context, route);
                      },
                    ),
                  ],
                  cancelButton: CupertinoActionSheetAction(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        color: Colors.deepOrangeAccent,
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
        CustomManageButton(
          icon: Icons.local_shipping_outlined,
          title: "Control Orders",
          onTap: () async {
            var connectivityResult = await Connectivity().checkConnectivity();
            if (connectivityResult != ConnectivityResult.mobile &&
                connectivityResult != ConnectivityResult.wifi) {
              return showDialog(
                context: context,
                builder: (BuildContext context) {
                  return NoInternetAlertDialog();
                },
              );
            }
            Route route = MaterialPageRoute(builder: (c) => ControlOrders());
            Navigator.push(context, route);
          },
        ),
      ],
    );
  }

  void addCategory() {
    var alert = AlertDialog(
      content: Form(
        key: _categoryformkey,
        child: TextFormField(
          controller: categoryTextEditingController,
          decoration: InputDecoration(
            hintText: "Add Category",
          ),
        ),
      ),
      actions: [
        FlatButton(
          child: Text('Add'),
          onPressed: () {
            if (categoryTextEditingController.text.isNotEmpty) {
              _categoryService
                  .createCategory(categoryTextEditingController.text);
              Fluttertoast.showToast(msg: 'Category Created');
              setState(() {
                categoryTextEditingController.text = '';
              });
              Navigator.pop(context);
            } else {
              showDialog(
                  context: context,
                  builder: (c) {
                    return ErrorAlertDialog(
                      message: "Please write category name.",
                    );
                  });
            }
          },
        ),
        FlatButton(
          child: Text('Cancle'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
    showDialog(context: context, builder: (_) => alert);
  }

  void addBrand() {
    var alert = AlertDialog(
      content: Form(
        key: _brandformkey,
        child: TextFormField(
          controller: brandTextEditingController,
          decoration: InputDecoration(
            hintText: "Add Brand",
          ),
        ),
      ),
      actions: [
        FlatButton(
          child: Text('Add'),
          onPressed: () {
            if (brandTextEditingController.text.isNotEmpty) {
              _brandService.createBrad(brandTextEditingController.text);
              Fluttertoast.showToast(msg: 'Brand Created');
              setState(() {
                brandTextEditingController.text = '';
              });
              Navigator.pop(context);
            } else {
              showDialog(
                  context: context,
                  builder: (c) {
                    return ErrorAlertDialog(
                      message: "Please write brand name.",
                    );
                  });
            }
          },
        ),
        FlatButton(
          child: Text('Cancle'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
    showDialog(context: context, builder: (_) => alert);
  }
}
