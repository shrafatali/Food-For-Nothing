// ignore_for_file: use_build_context_synchronously, avoid_print, use_key_in_widget_constructors

import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:foodfornothing/components/components.dart';
import 'package:foodfornothing/components/constants.dart';
import 'package:foodfornothing/main.dart';
import 'package:foodfornothing/screens/DonerHome/drawer_screen.dart';
import 'package:foodfornothing/util/helper.dart';
import 'package:foodfornothing/util/push_notification.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

class Sale extends StatefulWidget {
  @override
  State<Sale> createState() => _UploadProductPageState();
}

class _UploadProductPageState extends State<Sale> {
  final formKey = GlobalKey<FormState>();

  final TextEditingController nameProductC = TextEditingController();
  final TextEditingController descriptionC = TextEditingController();

  final TextEditingController perItemPriceC = TextEditingController();
  final TextEditingController totalItemsC = TextEditingController();

  TextEditingController locationC = TextEditingController();
  TextEditingController dateC = TextEditingController();

  DateTime date = DateTime.now();

  final ImagePicker imagePicker = ImagePicker();
  List<XFile> imageFileList = [];
  bool image = false;

  String imagePath1;
  String imagePath2;
  String imagePath3;
  String imagePath4;

  String productCategorie = 'Select Categorie';
  var productCategorieList = [
    'Select Categorie',
    'Cooked',
    'Non Cooked',
    'Packed',
  ];

  Future abc(BuildContext context1) async {
    Components.showAlertDialog(context1);
    await Helper.getUserCurrentLocation(context1).then((value) async {
      double lat = value[0];
      double long = value[1];

      List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);

      String userCurrentLocation = placemarks.reversed.last.locality;

      CameraPosition cameraPosition = CameraPosition(
        target: LatLng(lat, long),
        zoom: 16,
      );

      final GoogleMapController controller = await googleMapcontroller.future;
      markers.clear();
      markers.add(
        Marker(
          infoWindow: InfoWindow(title: userCurrentLocation.toString()),
          markerId: MarkerId('$lat$long'),
          position: LatLng(lat, long),
        ),
      );

      setState(() {
        locationC = TextEditingController(text: userCurrentLocation.toString());
        Navigator.pop(context1);
        controller.animateCamera(
          CameraUpdate.newCameraPosition(cameraPosition),
        );
      });
    });
  }

  List<Marker> markers = [];

  final Completer<GoogleMapController> googleMapcontroller = Completer();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(
      33.6844,
      73.0479,
    ),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
        elevation: 0,
        title: Text(
          "Sale",
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
                  title: const Text('Item Price'),
                  subtitle: TextFormField(
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    controller: perItemPriceC,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Item Price is not Empty";
                      }
                      return null;
                    },
                    autocorrect: true,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(top: 13, left: 10),
                        child: Text(
                          'Rs',
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.5),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 10),
                      prefixIcon: const Icon(
                        Icons.summarize,
                      ),
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      hintText: "Enter your Best Price",
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
                const SizedBox(height: 15),
                Container(
                  height: 300,
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey),
                  ),
                  child: GoogleMap(
                    mapType: MapType.normal,
                    markers: Set<Marker>.of(markers),
                    onTap: (LatLng latLong) async {
                      Components.showAlertDialog(context);
                      List<Placemark> placemarks =
                          await placemarkFromCoordinates(
                              latLong.latitude, latLong.longitude);

                      String userCurrentLocation =
                          placemarks.reversed.last.locality;

                      CameraPosition cameraPosition = CameraPosition(
                        target: LatLng(latLong.latitude, latLong.longitude),
                        zoom: 15.4746,
                      );

                      final GoogleMapController controller =
                          await googleMapcontroller.future;
                      markers.clear();
                      markers.add(
                        Marker(
                          infoWindow:
                              InfoWindow(title: userCurrentLocation.toString()),
                          markerId: MarkerId(
                              '${latLong.latitude}${latLong.longitude}'),
                          position: LatLng(latLong.latitude, latLong.longitude),
                        ),
                      );

                      setState(() {
                        locationC = TextEditingController(
                            text: userCurrentLocation.toString());
                        Navigator.pop(context);
                        controller.animateCamera(
                          CameraUpdate.newCameraPosition(cameraPosition),
                        );
                      });
                    },
                    initialCameraPosition: _kGooglePlex,
                    onMapCreated: (GoogleMapController controller) {
                      googleMapcontroller.complete(controller);
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
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
                  ],
                ),
                const SizedBox(height: 15),
                InkWell(
                  onTap: () {
                    imageFileList.length < 4
                        ? pickImage()
                        : Components.showSnackBar(
                            context, "You cant add more then 4 Images");
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.09,
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.camera_alt),
                        SizedBox(
                          height: 4,
                        ),
                        Text("Add Item Images"),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                imageFileList.isEmpty
                    ? const SizedBox(
                        height: 0,
                        width: 0,
                      )
                    : Container(
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: GridView.builder(
                            itemCount: imageFileList.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    mainAxisSpacing: 3, crossAxisCount: 2),
                            itemBuilder: (BuildContext context, int index) {
                              return Stack(
                                children: [
                                  Container(
                                    width: (MediaQuery.of(context).size.width *
                                        0.3),
                                    margin: const EdgeInsets.all(5),
                                    padding: const EdgeInsets.all(1),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                      color: AppColor.blackColor,
                                      width: 2,
                                    )),
                                    child: Image.file(
                                      File(imageFileList[index].path),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        setState(() {
                                          imageFileList.removeAt(index);
                                        });
                                      },
                                      icon: Icon(
                                        Icons.cancel_outlined,
                                        color: AppColor.primaryColor,
                                      ))
                                ],
                              );
                            }),
                      ),
                const SizedBox(height: 30),
                ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState.validate()) {
                        if (productCategorie != 'Select Categorie') {
                          if (dateC.text.isNotEmpty) {
                            if (locationC.text.isNotEmpty) {
                              if (3 < imageFileList.length) {
                                Components.showAlertDialog(context);

                                imagePath1 =
                                    await uploadImage(imageFileList[0].path);
                                imagePath2 =
                                    await uploadImage(imageFileList[1].path);
                                imagePath3 =
                                    await uploadImage(imageFileList[2].path);
                                imagePath4 =
                                    await uploadImage(imageFileList[3].path);

                                String productID = DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString();

                                await FirebaseFirestore.instance
                                    .collection("products")
                                    .doc(productID)
                                    .set({
                                  'productType': 'paid',
                                  'productID': productID,
                                  'productImage1': imagePath1,
                                  'productImage2': imagePath2,
                                  'productImage3': imagePath3,
                                  'productImage4': imagePath4,
                                  'productCategorie':
                                      productCategorie.toString(),
                                  'productName': nameProductC.text.trim(),
                                  'productDescription':
                                      descriptionC.text.trim(),
                                  'totalOrderIDs': [],
                                  'totalItems': totalItemsC.text.trim(),
                                  'pricePerItem': perItemPriceC.text.trim(),
                                  'productAvailable': true,
                                  'userUID':
                                      FirebaseAuth.instance.currentUser.uid,
                                  'productEndDate': dateC.text.toString(),
                                  'location': locationC.text.trim().toString(),
                                  'time': FieldValue.serverTimestamp(),
                                });

                                await FirebaseFirestore.instance
                                    .collection(prefs.getString("userType"))
                                    .doc(FirebaseAuth.instance.currentUser.uid)
                                    .update({
                                  'productsIDs':
                                      FieldValue.arrayUnion([productID])
                                });

                                QuerySnapshot snap = await FirebaseFirestore
                                    .instance
                                    .collection('Donee')
                                    .where('location',
                                        isEqualTo: prefs.getString('location'))
                                    .get();
                                print(snap.toString());
                                for (var document in snap.docs) {
                                  print(document['location'].toString());

                                  PushNotification().sendPushMessage(
                                    document['fcm_token'],
                                    nameProductC.text.trim().toString(),
                                    'New Product (Sale)',
                                  );
                                }

                                Components.showSnackBar(
                                    context, "Product Uploaded Sucessfully");
                                Navigator.pop(context);
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          FlutterZoomDrawerPage(),
                                    ),
                                    (route) => false);
                              } else {
                                Components.showSnackBar(
                                    context, "Please Add 4 Item Images");
                              }
                            } else {
                              Components.showSnackBar(
                                  context, "Please Select Location");
                            }
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
                        "Upload",
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

  Future pickImage() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: const Center(child: Text("Where want you pick")),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                        onTap: (() {
                          pickMedia(0);
                          Navigator.pop(context);
                        }),
                        child: const Icon(Icons.camera_alt)),
                    const SizedBox(height: 5),
                    const Text("Carmera")
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: (() {
                        pickMedia(1);
                        Navigator.pop(context);
                      }),
                      child: const Icon(Icons.photo),
                    ),
                    const SizedBox(height: 5),
                    const Text("Gallery")
                  ],
                ),
              ],
            ));
      },
    );
  }

  void pickMedia(int value) async {
    if (value == 0) {
      try {
        XFile file = await ImagePicker().pickImage(source: ImageSource.camera);

        if (file != null) {
          setState(() {
            imageFileList.add(XFile(file.path));
          });
        }
      } catch (e) {
        print(e.toString());
      }
    } else if (value == 1) {
      try {
        final List<XFile> selectedImages = await imagePicker.pickMultiImage();
        if (selectedImages.isNotEmpty) {
          setState(() {
            imageFileList.addAll(selectedImages);
            image = true;
          });
        }
      } catch (e) {
        print(e.toString());
      }
    }
  }

  Future uploadImage(String imagePath) async {
    String postId = DateTime.now().millisecondsSinceEpoch.toString();

    Reference reference = FirebaseStorage.instance
        .ref()
        .child('productsImages')
        .child("$postId.jpg");
    await reference.putFile(File(imagePath));
    String downloadsUrlImage = await reference.getDownloadURL();
    return downloadsUrlImage;
  }
}
