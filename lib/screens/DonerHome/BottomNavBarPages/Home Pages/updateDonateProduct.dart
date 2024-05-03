// ignore_for_file: use_build_context_synchronously, avoid_print, must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodfornothing/screens/DonerHome/drawer_screen.dart';
import 'package:foodfornothing/components/components.dart';
import 'package:foodfornothing/components/constants.dart';
import 'package:foodfornothing/util/helper.dart';

class UpdateDonateProductPage extends StatefulWidget {
  Map<String, dynamic> productData;

  UpdateDonateProductPage({Key key, @required this.productData})
      : super(key: key);
  @override
  State<UpdateDonateProductPage> createState() =>
      _UpdateDonateProductPageState();
}

class _UpdateDonateProductPageState extends State<UpdateDonateProductPage> {
  final formKey = GlobalKey<FormState>();

  TextEditingController nameProductC;
  TextEditingController descriptionC;
  TextEditingController totalItemsC;
  TextEditingController locationC;
  TextEditingController dateC;

  String productCategorie = 'Select Categorie';
  var productCategorieList = [
    'Select Categorie',
    'Cooked',
    'Non Cooked',
    'Packed',
  ];

  DateTime date = DateTime.now();

  @override
  void initState() {
    nameProductC = TextEditingController(
        text: widget.productData['productName'].toString());
    descriptionC = TextEditingController(
        text: widget.productData['productDescription'].toString());
    dateC = TextEditingController(
        text: widget.productData['productEndDate'].toString());
    totalItemsC = TextEditingController(
        text: widget.productData['totalItems'].toString());
    locationC =
        TextEditingController(text: widget.productData['location'].toString());
    productCategorie = widget.productData['productCategorie'].toString();
    super.initState();
  }

  Future abc(BuildContext context1) async {
    Components.showAlertDialog(context1);
    await Helper.getUserCurrentLocation(context1).then((value) {
      setState(() {
        locationC = TextEditingController(text: value.toString());
        Navigator.pop(context1);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
        elevation: 0,
        title: Text(
          "Donate",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColor.whiteColor,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(13.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  title: const Text('Name'),
                  subtitle: TextFormField(
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    controller: nameProductC,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Item Name is not Empty";
                      }
                      return null;
                    },
                    autocorrect: true,
                    autofocus: false,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      prefixIcon: Icon(
                        Icons.person,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      hintText: "Enter Item Name",
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  title: const Text('Description'),
                  subtitle: TextFormField(
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    maxLines: 3,
                    minLines: 1,
                    controller: descriptionC,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Description is not Empty";
                      }
                      return null;
                    },
                    autocorrect: true,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      prefixIcon: Icon(
                        Icons.notes_rounded,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      hintText: "Enter Item Description",
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  title: const Text('Categorie'),
                  subtitle: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    height: 45,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        border:
                            Border.all(width: 1, color: AppColor.blackColor),
                        borderRadius: BorderRadius.circular(8)),
                    child: DropdownButton(
                      value: productCategorie,
                      underline: Container(),
                      isExpanded: true,
                      iconSize: 30,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: productCategorieList.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }).toList(),
                      onChanged: (String newValue) {
                        setState(() {
                          productCategorie = newValue;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  title: const Text('Total Items'),
                  subtitle: TextFormField(
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    controller: totalItemsC,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Total Items is not Empty";
                      }
                      return null;
                    },
                    autocorrect: true,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      prefixIcon: Icon(
                        Icons.summarize,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      hintText: "Enter Total Number of Items",
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  title: const Text('Select Ending Date'),
                  onTap: () async {
                    DateTime dateNow = await showDatePicker(
                      context: context,
                      initialDate: date,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2050),
                    );

                    if (dateNow == null) {
                      return;
                    }

                    setState(() {
                      date = dateNow;
                      setDate(date.day.toString(), date.month.toString(),
                          date.year.toString());
                    });
                  },
                  subtitle: TextFormField(
                    controller: dateC,
                    readOnly: true,
                    enabled: false,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      prefixIcon: Icon(
                        Icons.date_range_rounded,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      hintText: "Ending Date",
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  title: const Text('Location'),
                  subtitle: TextFormField(
                    controller: locationC,
                    readOnly: true,
                    enabled: false,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.location_on),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      hintText: 'City',
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextButton.icon(
                      style: TextButton.styleFrom(
                          foregroundColor: AppColor.primaryColor),
                      icon: const Icon(
                        Icons.location_on,
                      ),
                      label: const Text('Current Location'),
                      onPressed: () {
                        abc(context);
                      },
                    ),
                    TextButton.icon(
                      style: TextButton.styleFrom(
                          foregroundColor: AppColor.primaryColor),
                      icon: const Icon(
                        Icons.map,
                      ),
                      label: const Text('Select on Map'),
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState.validate()) {
                        if (productCategorie != 'Select Categorie') {
                          if (dateC.text.isNotEmpty) {
                            Components.showAlertDialog(context);

                            await FirebaseFirestore.instance
                                .collection("products")
                                .doc(widget.productData['productID'].toString())
                                .update({
                              'productCategorie': productCategorie.toString(),
                              'productName':
                                  nameProductC.text.trim().toString(),
                              'productDescription':
                                  descriptionC.text.trim().toString(),
                              'totalItems': totalItemsC.text.trim().toString(),
                              'productEndDate': dateC.text.toString(),
                              'location': locationC.text.trim().toString(),
                              'time': FieldValue.serverTimestamp(),
                            });

                            Components.showSnackBar(
                                context, "Product Update Sucessfully");
                            Navigator.pop(context);
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FlutterZoomDrawerPage(),
                                ),
                                (route) => false);
                          } else {
                            Components.showSnackBar(
                                context, "Please Select Ending Date");
                          }
                        } else {
                          Components.showSnackBar(
                              context, "Please Select Item Categorie");
                        }
                      }
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: AppColor.primaryColor,
                      minimumSize: const Size(150, 40),
                    ),
                    child: Center(
                      child: Text(
                        "Update",
                        style: TextStyle(color: AppColor.whiteColor),
                      ),
                    )),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  setDate(String date, String month, String year) {
    dateC = TextEditingController(
        text:
            '$year-${int.parse(month) < 10 ? '0$month' : month}-${int.parse(date) < 10 ? '0$date' : date}');
  }
}
