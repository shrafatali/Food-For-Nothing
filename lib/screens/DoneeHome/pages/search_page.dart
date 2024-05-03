// ignore_for_file: avoid_print

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:foodfornothing/components/components.dart';
import 'package:foodfornothing/components/constants.dart';
import 'package:foodfornothing/components/product_details_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController searchProductName = TextEditingController();

  bool isLoading = false;

  var documentList;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Form(
        key: formKey,
        child: Scaffold(
          appBar: AppBar(
            titleSpacing: 0,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColor.blackColor,
              ),
            ),
            toolbarHeight: 60,
            backgroundColor: Colors.grey.shade50,
            title: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: searchProductName,
                      autofocus: true,
                      cursorColor: Colors.grey.shade700,
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(
                              borderSide: BorderSide.none),
                          hintText: 'Enter product name',
                          hintStyle: TextStyle(color: Colors.grey.shade700)),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 15),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (searchProductName.text.isNotEmpty) {
                        setState(() {
                          isLoading = true;
                        });
                      } else {
                        Components.showSnackBar(
                            context, 'Please Enter Product Name');
                      }
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColor.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      FontAwesome.search,
                      size: 22,
                      color: AppColor.whiteColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: isLoading == false
              ? Center(
                  child: Text(
                    'No search !',
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 20),
                  ),
                )
              : Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('products')
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasData && snapshot.data != null) {
                          if (snapshot.data.docs.isNotEmpty) {
                            print(snapshot.data.docs.length);
                            return ListView.builder(
                              itemBuilder: (context, index) {
                                Map<String, dynamic> documentData =
                                    snapshot.data.docs[index].data();

                                String mainString = documentData['productName']
                                    .toString()
                                    .toLowerCase()
                                    .trim();
                                String substring = searchProductName.text
                                    .toString()
                                    .toLowerCase()
                                    .trim();

                                if (mainString.contains(substring)) {
                                  return Card(
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (_) => ItemDetailsSreen(
                                              productData: documentData,
                                              userData: null,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5.0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Expanded(
                                              flex: 2,
                                              child: Container(
                                                height: 80,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: CachedNetworkImage(
                                                  fit: BoxFit.fill,
                                                  imageUrl: documentData[
                                                          'productImage1']
                                                      .toString(),
                                                  placeholder: (context, url) =>
                                                      const Center(
                                                          child:
                                                              CircularProgressIndicator()),
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      const Icon(Icons.error),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        5.0, 0.0, 0.0, 0.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      documentData[
                                                              'productName']
                                                          .toString(),
                                                      maxLines: 1,
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.black,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                    const Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 2.0)),
                                                    Text(
                                                      documentData[
                                                              'productDescription']
                                                          .toString(),
                                                      maxLines: 2,
                                                      style: const TextStyle(
                                                        color: Colors.grey,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                    const Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 1.0)),
                                                    Text(
                                                      'Location : ${documentData['location'].toString()}',
                                                      maxLines: 1,
                                                      style: const TextStyle(
                                                        color: Colors.grey,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  return const SizedBox(
                                    height: 0,
                                    width: 0,
                                  );
                                }
                              },
                              itemCount: snapshot.data.docs.length,
                            );
                          } else {
                            return const Center(
                              child: Text("No Product Data Is Available"),
                            );
                          }
                        } else {
                          return Center(
                            child: CircularProgressIndicator(
                              color: AppColor.primaryColor,
                            ),
                          );
                        }
                      }),
                ),
        ),
      ),
    );
  }
}
