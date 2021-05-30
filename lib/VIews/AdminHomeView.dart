import 'dart:io';
import 'dart:ui';

import 'package:beathub/VIews/AddMusicView.dart';
import 'package:beathub/VIews/Loginview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';

class AdminHomeView extends StatefulWidget {
  @override
  _AdminHomeViewState createState() => _AdminHomeViewState();
}

class _AdminHomeViewState extends State<AdminHomeView> {
  List<Widget> widgetlist = [
    NewMusic(),
    Column(
      children: [
        Container(
          height: 45,
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(10)),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: TextField(
                //obscureText: true,
                textAlign: TextAlign.start,
                decoration: InputDecoration(
                  hintText: "Search",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Column(
          children: [
            User(
              followers: "1000",
              name: "Haris Abdullah",
              following: "1000",
              premium: true,
              image:
                  "https://instagram.fisb6-1.fna.fbcdn.net/v/t51.2885-19/s150x150/192922463_164663999000802_3049741104662236605_n.jpg?tp=1&_nc_ht=instagram.fisb6-1.fna.fbcdn.net&_nc_ohc=LzoC7l2j1O4AX-xrOML&edm=ABfd0MgBAAAA&ccb=7-4&oh=2f50bf979f513974a97662d54321c815&oe=60B782D7&_nc_sid=7bff83",
            ),
            User(
              followers: "100",
              name: "Atif Riaz",
              following: "100",
              premium: false,
              image:
                  "https://instagram.fisb6-1.fna.fbcdn.net/v/t51.2885-19/s150x150/156482140_258422865742153_2119754574542240214_n.jpg?tp=1&_nc_ht=instagram.fisb6-1.fna.fbcdn.net&_nc_ohc=Gds8dHrxqFoAX_7xE4Z&edm=ABfd0MgBAAAA&ccb=7-4&oh=8157c3531f84841a2d169d649226c6be&oe=60B82F89&_nc_sid=7bff83",
            ),
          ],
        ),
      ],
    ),
  ];
  

  int _selectedItemPosition = 0;
  final BorderRadius _borderRadius = const BorderRadius.only(
    topLeft: Radius.circular(25),
    topRight: Radius.circular(25),
  );

  ShapeBorder bottomBarShape = const RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(25),
      topRight: Radius.circular(25),
    ),
  );
  SnakeBarBehaviour snakeBarStyle = SnakeBarBehaviour.floating;
  EdgeInsets padding = const EdgeInsets.all(0);

  //int _selectedItemPosition = 2;
  SnakeShape snakeShape = SnakeShape.circle;

  bool showSelectedLabels = false;
  bool showUnselectedLabels = false;

  Color selectedColor = Colors.black;
  Gradient selectedGradient =
      const LinearGradient(colors: [Colors.red, Colors.amber]);

  Color unselectedColor = Colors.blueGrey;
  Gradient unselectedGradient =
      const LinearGradient(colors: [Colors.red, Colors.blueGrey]);
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        exit(0);
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        bottomNavigationBar: BottomAppBar(
          color: Colors.transparent,
          child: SnakeNavigationBar.color(
            //shadowColor: Colors.transparent,
            // height: 80,
            behaviour: snakeBarStyle,
            snakeShape: snakeShape,
            shape: bottomBarShape,
            //padding: padding,

            ///configuration for SnakeNavigationBar.color
            snakeViewColor: selectedColor,
            selectedItemColor:
                snakeShape == SnakeShape.indicator ? selectedColor : null,
            unselectedItemColor: Colors.blueGrey,

            showUnselectedLabels: showUnselectedLabels,
            showSelectedLabels: showSelectedLabels,

            currentIndex: _selectedItemPosition,
            onTap: (index) => setState(() => _selectedItemPosition = index),
            items: [
              const BottomNavigationBarItem(
                icon: Icon(Icons.music_note),
                label: 'tickets',
              ),
              const BottomNavigationBarItem(
                  icon: Icon(
                    Icons.person,
                  ),
                  label: 'calendar'),
            ],
            selectedLabelStyle: const TextStyle(fontSize: 14),
            unselectedLabelStyle: const TextStyle(fontSize: 10),
          ),
        ),
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
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 8,
                                      child: Text(
                                        _selectedItemPosition == 0
                                            ? 'Add New Music'
                                            : "All Users",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          FirebaseAuth.instance
                                              .signOut()
                                              .then((value) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      LoginView()),
                                            );
                                          });
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          width: 30,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            border:
                                                Border.all(color: Colors.white),
                                          ),
                                          child: Icon(
                                            Icons.logout,
                                            size: 20,
                                            color: Colors.white,
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
                        SizedBox(
                          height: 40,
                        ),
                        widgetlist[_selectedItemPosition],
                      ],
                    ),
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

class NewMusic extends StatelessWidget {
  const NewMusic({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 15,
      runSpacing: 15,
      alignment: WrapAlignment.center,
      direction: Axis.horizontal,
      children: [
        Options(
          ontap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddMusicview(
                  musictype: "Itunes",
                  file: false,
                  apple: true,
                  spotify: false,
                  soundcloud: false,
                ),
              ),
            );
          },
          image: 'Assets/Images/itunes.png',
          text: "Add Song with Itunes",
        ),
        Options(
          ontap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddMusicview(
                  musictype: "Spotify",
                  file: false,
                  apple: false,
                  spotify: true,
                  soundcloud: false,
                ),
              ),
            );
          },
          image: 'Assets/Images/spotify.png',
          text: "Add Song with Spotify",
        ),
        Options(
          ontap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddMusicview(
                  musictype: "Soundcloud",
                  file: false,
                  apple: false,
                  spotify: false,
                  soundcloud: true,
                ),
              ),
            );
          },
          image: 'Assets/Images/soundcloud.png',
          text: "Add Song with Soundcloud",
        ),
        Options(
          ontap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddMusicview(
                  musictype: "file",
                  file: true,
                  apple: false,
                  spotify: false,
                  soundcloud: false,
                ),
              ),
            );
          },
          image: 'Assets/Images/music.png',
          text: "Add Song from File",
        ),
      ],
    );
  }
}

class Options extends StatelessWidget {
  Function ontap;
  String text;
  String image;

  Options({
    this.ontap,
    this.image,
    this.text,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        alignment: Alignment.center,
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.white),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Image.asset(
                image,
                height: 80,
              ),
              Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class User extends StatefulWidget {
  String image;
  String name;
  String followers;
  String following;
  bool premium;
  User({
    this.followers,
    this.following,
    this.image,
    this.name,
    this.premium,
  });
  @override
  _UserState createState() => _UserState();
}

class _UserState extends State<User> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 15,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.white),
        ),
        padding: EdgeInsets.all(
          15,
        ),
        child: Column(
          children: [
            Stack(
              overflow: Overflow.visible,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(widget.image),
                ),
                Visibility(
                  visible: widget.premium,
                  child: Positioned(
                      top: -4,
                      left: -4,
                      child: Icon(
                        Icons.star,
                        color: Colors.yellow,
                      )),
                ),
              ],
            ),
            Divider(
              color: Colors.white,
            ),
            Text(
              widget.name,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "Followers",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Following",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  widget.followers,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  widget.following,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class Users {
  String name;
  String image;
  String followers;
  String following;
  bool premium;

  Users({
    this.followers,
    this.following,
    this.image,
    this.name,
    this.premium,
  });
}
