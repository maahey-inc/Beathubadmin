import 'dart:io';
import 'dart:ui';

import 'package:beathub/VIews/Loginview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class AddMusicview extends StatefulWidget {
  bool file;
  bool spotify;
  bool apple;
  bool soundcloud;
  String musictype;
  AddMusicview({
    this.file,
    this.apple,
    this.soundcloud,
    this.spotify,
    this.musictype,
  });

  @override
  _AddMusicviewState createState() => _AddMusicviewState();
}

class _AddMusicviewState extends State<AddMusicview> {
  File selectedfile;
  String fileurl;
  String filename = "Upload Music File";
  String image;
  String coverimageurl;
  final name = new TextEditingController();
  final link = new TextEditingController();
  final type = new TextEditingController();
  final albumname = new TextEditingController();
  final artist = new TextEditingController();
  File selectedimage;
  bool coverimageselected = false;
  Future upload() async {
    print("pickingfile");
    FilePickerResult file = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mp3', 'm4a', 'flac', 'wav'],
        allowMultiple: false);
    // String fileName = '${randomName}.pdf';
    // print(fileName);
    // print('${file.readAsBytesSync()}');
    setState(() {
      selectedfile = File(file.files.first.path);

      filename = file.paths.toString().split("/").last.split("]").first;
      print(file.paths.toString().split("/").last.split("]").first);
    });
  }

  Future saveimagemusic(File file) async {
    CoolAlert.show(
      barrierDismissible: false,
      context: context,
      type: CoolAlertType.loading,
      text: "Uploading! Please Wait.",
    );
    Reference reference = FirebaseStorage.instance.ref().child(
        'media/' + file.path.toString().split("/").last.split("]").first);
    UploadTask uploadTask = reference.putFile(file);
    uploadTask.then((res) {
      res.ref.getDownloadURL().then((url) {
        setState(() {
          fileurl = url;
          Reference reference = FirebaseStorage.instance.ref().child('media/' +
              selectedimage.path.toString().split("/").last.split("]").first);
          UploadTask uploadTask = reference.putFile(selectedimage);
          uploadTask.then((coverurlres) {
            coverurlres.ref.getDownloadURL().then((coverurl) {
              setState(() {
                coverimageurl = coverurl.toString();
                savedataoffile(url.toString());
              });
            });
          });
          //print(fileurl);
        });
      });
    });
  }

  checkcategory() {
    CoolAlert.show(
      barrierDismissible: false,
      context: context,
      type: CoolAlertType.loading,
      text: "Uploading! Please Wait.",
    );
    Reference reference = FirebaseStorage.instance.ref().child('media/' +
        selectedimage.path.toString().split("/").last.split("]").first);
    UploadTask uploadTask = reference.putFile(selectedimage);
    uploadTask.then((coverurlres) {
      coverurlres.ref.getDownloadURL().then((coverurl) {
        setState(() {
          coverimageurl = coverurl.toString();
          if (widget.file) {
            saveimagemusic(selectedfile);
          } else if (widget.apple) {
            var data = {
              "name": name.text,
              "coverimage": coverimageurl,
              "albumname": albumname.text,
              "type": type.text,
              "artist": artist.text,
              "apple": link.text,
            };
            FirebaseFirestore.instance
                .collection('AppleMusic')
                .add(data)
                .then((v) {
              Navigator.pop(context);
              CoolAlert.show(
                  barrierDismissible: false,
                  context: context,
                  type: CoolAlertType.success,
                  text: "Music Has Been Uploaded.",
                  onConfirmBtnTap: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  });
            });
          } else if (widget.spotify) {
            var data = {
              "name": name.text,
              "coverimage": coverimageurl,
              "albumname": albumname.text,
              "type": type.text,
              "artist": artist.text,
              "spotify": link.text,
            };
            FirebaseFirestore.instance
                .collection('SpotifyMusic')
                .add(data)
                .then((v) {
              Navigator.pop(context);
              CoolAlert.show(
                  barrierDismissible: false,
                  context: context,
                  type: CoolAlertType.success,
                  text: "Music Has Been Uploaded.",
                  onConfirmBtnTap: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  });
            });
          } else if (widget.soundcloud) {
            var data = {
              "name": name.text,
              "coverimage": coverimageurl,
              "albumname": albumname.text,
              "type": type.text,
              "artist": artist.text,
              "spotify": link.text,
            };
            FirebaseFirestore.instance
                .collection('SoundcloudMusic')
                .add(data)
                .then((v) {
              Navigator.pop(context);
              CoolAlert.show(
                  barrierDismissible: false,
                  context: context,
                  type: CoolAlertType.success,
                  text: "Music Has Been Uploaded.",
                  onConfirmBtnTap: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  });
            });
          }
        });
      });
    });
  }

  savedataoffile(String str) {
    var data = {
      "name": name.text,
      "coverimage": coverimageurl,
      "albumname": albumname.text,
      "type": type.text,
      "artist": artist.text,
      "songurl": str,
    };
    FirebaseFirestore.instance.collection('Music').add(data).then((v) {
      Navigator.pop(context);
      CoolAlert.show(
          barrierDismissible: false,
          context: context,
          type: CoolAlertType.success,
          text: "Music Has Been Uploaded.",
          onConfirmBtnTap: () {
            Navigator.pop(context);
            Navigator.pop(context);
          });
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => Adminhome()),
      // );
    });
  }

  @override
  void initState() {
    //setimage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("Assets/Images/dj.jpg"),
            fit: BoxFit.fill,
          ),
        ),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
            child: Container(
              color: Color(0xFF000000).withOpacity(0.4),
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 50,
                  bottom: 10,
                  right: 40,
                  left: 40,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: () {
                            //login();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width * 0.8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: Colors.white),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(
                                'Add Song',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      GestureDetector(
                        onTap: () async {
                          FilePickerResult file = await FilePicker.platform
                              .pickFiles(
                                  type: FileType.custom,
                                  allowedExtensions: ['jpg', 'png', 'jpeg'],
                                  allowMultiple: false);

                          setState(() {
                            selectedimage = File(file.files.first.path);
                            coverimageselected = true;
                            //savePdf(selectedimage, false);
                          });
                        },
                        child: Container(
                          //alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: MediaQuery.of(context).size.width * 0.4,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.white),
                          ),
                          child: coverimageselected
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image(
                                    image: FileImage(selectedimage),
                                    fit: BoxFit.fill,
                                    //height: MediaQuery.of(context).size.height / 1200,
                                    //width: 100,
                                  ),
                                )
                              : Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Icon(
                                      Icons.upload_file,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      "Upload Cover Image",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Textfield(
                        password: false,
                        hinttext: "Song Name",
                        controller: name,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Textfield(
                        password: false,
                        hinttext: "Artist",
                        controller: artist,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Textfield(
                        password: false,
                        hinttext: "Album Name",
                        controller: albumname,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Textfield(
                        password: false,
                        hinttext: "Type",
                        controller: type,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Textfield(
                        password: false,
                        hinttext: "${widget.musictype} Link",
                        controller: link,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Visibility(
                        visible: widget.file,
                        child: GestureDetector(
                          onTap: () {
                            print("tapping");
                            upload();
                          },
                          child: Container(
                            height: 45,
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  child: Text(filename)),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: () {
                            widget.file
                                ? saveimagemusic(selectedfile)
                                : checkcategory();
                            //login();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width * 0.4,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(color: Colors.white),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(
                                'Upload',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
