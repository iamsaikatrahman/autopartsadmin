import 'package:autopartsadmin/model/product_model.dart';
import 'package:autopartsadmin/screens/edit_product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ProductSearch extends StatefulWidget {
  @override
  _ProductSearchState createState() => _ProductSearchState();
}

class _ProductSearchState extends State<ProductSearch> {
  final searchProductController = TextEditingController();

  List _allProductResults = [];
  List _productResultList = [];
  Future productResultsLoaded;
  @override
  void initState() {
    searchProductController.addListener(_onProductSearchChanged);
    super.initState();
  }

  @override
  void dispose() {
    searchProductController.removeListener(_onProductSearchChanged);
    searchProductController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    productResultsLoaded = getAllSearchProductsData();
  }

  _onProductSearchChanged() {
    searchProductsResultsList();
  }

  searchProductsResultsList() {
    var showResult = [];
    if (searchProductController.text != "") {
      for (var productfromjson in _allProductResults) {
        var productName =
            ProductModel.fromSnaphot(productfromjson).productName.toLowerCase();
        if (productName.contains(searchProductController.text.toLowerCase())) {
          showResult.add(productfromjson);
        }
      }
    } else {
      showResult = List.from(_allProductResults);
    }
    _productResultList = showResult;
  }

  getAllSearchProductsData() async {
    var data = await FirebaseFirestore.instance
        .collection('products')
        .orderBy("publishedDate", descending: true)
        .get();
    setState(() {
      _allProductResults = data.docs;
    });
    searchProductsResultsList();
    return "Complete";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: TextField(
          onChanged: (searchProductController) {
            setState(() {
              searchProductController;
            });
          },
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          controller: searchProductController,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
              vertical: 15.0,
              horizontal: 0,
            ),
            hintText: 'Search products...',
            hintStyle: TextStyle(
              color: Colors.blueGrey,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            border: InputBorder.none,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
            // Route route = MaterialPageRoute(builder: (_) => Products());
            // Navigator.pushReplacement(context, route);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.clear,
              color: Colors.black,
            ),
            onPressed: () {
              searchProductController.text = "";
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Padding(
            //   padding: EdgeInsets.symmetric(
            //     horizontal: 8.0,
            //     vertical: 10.0,
            //   ),
            //   child: Form(
            //     key: _formKey,
            //     child: TextFormField(
            //       autofocus: true,
            //       controller: searchProductController,
            //       decoration: InputDecoration(
            //         filled: true,
            //         fillColor: Color(0xFFF6F8F9),
            //         contentPadding: EdgeInsets.symmetric(vertical: 15.0),
            //         hintText: 'Search in thousands of products',
            //         border: OutlineInputBorder(
            //             borderRadius: BorderRadius.circular(10.0)),
            //         prefixIcon: IconButton(
            //           icon: Icon(Icons.search),
            //           onPressed: () {},
            //         ),
            //       ),
            //     ),
            //   ),
            // ),

            Container(
              width: double.infinity,
              child: StaggeredGridView.countBuilder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                crossAxisCount: 4,
                staggeredTileBuilder: (int index) => new StaggeredTile.fit(2),
                mainAxisSpacing: 5.0,
                crossAxisSpacing: 5.0,
                itemCount: _productResultList.length,
                itemBuilder: (BuildContext context, int index) {
                  ProductModel productData =
                      ProductModel.fromSnaphot(_productResultList[index]);
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (c) => EditProduct(
                            productModel: productData,
                          ),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 5),
                          Image.network(
                            productData.productImgUrl,
                            width: double.infinity,
                            height: 120,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  productData.productName,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.category_outlined,
                                      size: 20,
                                    ),
                                    SizedBox(width: 5),
                                    Flexible(
                                      child: Text(
                                        productData.categoryName,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.branding_watermark_outlined,
                                      size: 20,
                                    ),
                                    SizedBox(width: 5),
                                    Flexible(
                                      child: Text(
                                        productData.brandName,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),
                                (productData.offervalue.toInt() < 1)
                                    ? Text(
                                        "\৳${productData.orginalprice}",
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      )
                                    : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '\৳${productData.newprice}',
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                '\৳${productData.orginalprice}',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  decoration: TextDecoration
                                                      .lineThrough,
                                                ),
                                              ),
                                              SizedBox(width: 5),
                                              Text(
                                                  '- ${productData.offervalue}%')
                                            ],
                                          ),
                                        ],
                                      ),
                                Text(
                                  productData.status,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
