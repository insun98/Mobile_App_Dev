import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:location/location.dart';
import '../src/ItemCard.dart';
import '../src/friendProfile.dart';
import '../Provider/AuthProvider.dart';
import '../Provider/ProfileProvider.dart';
import '../Provider/PostProvider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

//String locateApiKey = 'AIzaSyC1s4E9It3tVo6o8tqN3Z1OkVRkpuZ2LZY';

class addPostPage extends StatefulWidget {
  final File? image;
  final List<String> prediction;
  const addPostPage({required this.image, required this.prediction});
  @override
  _addPostPageState createState() => _addPostPageState();
}

class _addPostPageState extends State<addPostPage> {
  @override
  final _formKey = GlobalKey<FormState>(debugLabel: '_addItemPageState');
  final _amountController = TextEditingController();
  final _durationController = TextEditingController();
  final _ingredientsController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _titleController = TextEditingController();
  final _blogController = TextEditingController();
  final _introController = TextEditingController();
  DateTime _dateTime = DateTime.now();
  bool order = true;

  double lat = 0;
  double lng = 0;
  Location location = new Location();
  bool _serviceEnabled = true;
  late PermissionStatus _permissionGranted;
  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dateTime, // Refer step 1
      firstDate: DateTime(2022),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != _dateTime)
      setState(() {
        _dateTime = picked;
      });
  }

  _locateMe() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    // Track user Movements
    location.onLocationChanged.listen((res) {
      setState(() {
        lat = res.latitude!;
        lng = res.longitude!;
      });
    });
    getPlaceAddress(lat, lng);
  }

  Future<void> getPlaceAddress(double lat, double lng) async {
    final apiEndpoint =
        'https://maps.gooleapis.com/maps/api/geocode/json?latlng=$lat, $lng&key=AIzaSyDTt1M9Qxc7sGeOAzbuYuUMr3B29XO8Is0';
    final Uri url = Uri.parse(apiEndpoint);
    final response = await http.post(url);
    print(jsonDecode(response.body)['results'][0]['formatted_address']);
    //  return jsonDecode(response.body)['results'][0]['formatted_address'];
  }

  String dropdownValue = '한식';
  @override
  Widget build(BuildContext context) {
    late ScrollController _scrollController;
    void initState() {
      super.initState();
      _scrollController = ScrollController();
    }

    PostProvider postProvider = Provider.of<PostProvider>(context);
    ProfileProvider profileProvider = Provider.of<ProfileProvider>(context);
    bool dateCheck = false;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        bottomOpacity: 0.0,
        elevation: 0.0,
        title: const Text(
          '업로드',
          style: TextStyle(color: Colors.black),
        ),
        leading: TextButton(
          child: const Text(
            'cancel',
            style: TextStyle(fontSize: 12),
          ),
          onPressed: () async {
            Navigator.pop(context);
          },
          style: TextButton.styleFrom(primary: Colors.black),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Save'),
            onPressed: () async {
              String URL;
              URL = await postProvider.UploadFile(widget.image!);

              if (_formKey.currentState!.validate()) {
                await postProvider.addPost(
                    URL,
                    dropdownValue,
                    _titleController.text,
                    int.parse(_durationController.text),
                    int.parse(_amountController.text),
                    _ingredientsController.text,
                    _introController.text,
                    _descriptionController.text,
                    _blogController.text,
                    _dateTime,
                    lat,
                    lng,
                    profileProvider.myProfile.id,
                    profileProvider.myProfile.photo);
                _titleController.clear();
                _durationController.clear();
                _amountController.clear();
                _ingredientsController.clear();
                _introController.clear();
                _descriptionController.clear();
                _blogController.clear();
              }
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(primary: Colors.black),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.file(File(widget.image!.path),
                  height: 200, width: 500, fit: BoxFit.fill),
              SizedBox(
                height: 50,
                child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: widget.prediction.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return TextButton(
                      onPressed: () async {
                        _titleController.text = widget.prediction[index];
                      },
                      child: Text(
                        widget.prediction[index],
                        style: const TextStyle(color: Colors.black),
                      ),
                    );
                  },
                ),
              ),
              Container(
                  margin: EdgeInsets.all(10),
                  child: Row(children: [
                    Icon(Icons.web_asset_outlined, color: Color(0xFF961D36)),
                    const SizedBox(width: 20.0),
                    Text('반찬 나눔 종료일:'),
                    Expanded(
                      child: TextButton(
                        child: Text(
                            "${_dateTime.year.toString()}-${_dateTime.month.toString()}-${_dateTime.day.toString()} ",
                            style: TextStyle(
                              fontSize: 15,
                            )),
                        onPressed: () async {
                          _selectDate(context);
                          int difference = int.parse(_dateTime
                              .difference(DateTime.now())
                              .inDays
                              .toString());
                          print("differenc ${difference}");
                          setState(() {});
                        },
                        style: TextButton.styleFrom(primary: Colors.black),
                      ),
                    ),
                    const SizedBox(width: 80.0),
                  ])),
              Container(
                margin: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          hintText: '음식이름(상단에 추천된 이름 선택 가능)',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter your Price to continue';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 40.0),
                    DropdownButton<String>(
                      value: dropdownValue,
                      icon: const Icon(Icons.arrow_drop_down_outlined),
                      elevation: 0,
                      style: const TextStyle(color: Colors.black),
                      items: dropdownItems,
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownValue = newValue!;
                        });
                      },
                    ),
                    const SizedBox(width: 20.0),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(10),
                child: TextFormField(
                  controller: _introController,
                  decoration: const InputDecoration(
                    hintText: '한줄 소개',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter your Price to continue';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Icon(Icons.access_alarm, color: const Color(0xFF961D36)),
                    const SizedBox(width: 20.0),
                    Expanded(
                      child: TextFormField(
                        controller: _durationController,
                        decoration: const InputDecoration(
                          hintText: '조리시간',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter your Price to continue';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 20.0),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Icon(Icons.group, color: const Color(0xFF961D36)),
                    const SizedBox(width: 20.0),
                    Expanded(
                      child: TextFormField(
                        controller: _amountController,
                        decoration: const InputDecoration(
                          hintText: '몇 인분',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter your Price to continue';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 20.0),
                  ],
                ),
              ),
              const SizedBox(width: 20.0),
              const SizedBox(height: 12.0),
              Container(
                margin: EdgeInsets.all(10),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _ingredientsController,
                      decoration: const InputDecoration(
                        hintText: '재료 예) 양배추(500g), 배추(200g)',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter your Price to continue';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 40.0),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        hintText: '설명',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter your Description to continue';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 40.0),
                    TextFormField(
                      controller: _blogController,
                      decoration: const InputDecoration(
                        hintText: '사용한 블로그',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter your Description to continue';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40.0),
              Container(
                child: Center(
                  child: Text("Lat: $lat, Lng: $lng"),
                ),
              ),
              Container(
                width: double.infinity,
                child: RaisedButton(
                  child: Text("Locate Me"),
                  onPressed: () => _locateMe(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("한식"), value: "한식"),
      DropdownMenuItem(child: Text("양식"), value: "양식"),
      DropdownMenuItem(child: Text("중식"), value: "중식"),
      DropdownMenuItem(child: Text("일식"), value: "일식"),
    ];
    return menuItems;
  }
}
