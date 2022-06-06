import 'package:flutter/material.dart';
import 'package:contactus/contactus.dart';
import 'package:gdsc_solution/theme/custom_color.dart';
import 'package:typicons_flutter/typicons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class Contact extends StatefulWidget {
  const Contact({Key? key}) : super(key: key);

  @override
  State<Contact> createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(top: 50.0),
        child: Center(
          child: Column(
            children: [
              CircleAvatar(
                child: Image.asset('assets/logo.png'),
                radius: 70,
                backgroundColor: Colors.white,
              ),
              SizedBox(height: 30),
              Text("Contact Us", style: TextStyle(color: CustomColor.primary, fontSize: 30, fontWeight: FontWeight.bold),),
              SizedBox(height: 10),
              //to website
              Card(
                clipBehavior: Clip.antiAlias,
                margin: EdgeInsets.symmetric(
                  vertical: 15.0,
                  horizontal: 25.0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
                color: CustomColor.primary,
                child: ListTile(
                  leading: Icon(Typicons.link, color: Colors.white, size: 30),
                  title: Text(
                    'Website',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  onTap: () => launch('https://github.com/simata98/GDSC-Solution-Challenge-Green-Plogging-'),
                ),
              ),
              //to email
              Card(
                clipBehavior: Clip.antiAlias,
                margin: EdgeInsets.symmetric(
                  vertical: 15.0,
                  horizontal: 25.0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
                color: CustomColor.primary,
                child: ListTile(
                  leading: Icon(Typicons.mail, color: Colors.white, size: 30),
                  title: Text(
                    'Email ID',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  onTap: () => launch('mailto:cnckddn0146@gmail.com'),
                ),
              ),
              //to github
              Card(
                clipBehavior: Clip.antiAlias,
                margin: EdgeInsets.symmetric(
                  vertical: 15.0,
                  horizontal: 25.0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
                color: CustomColor.primary,
                child: ListTile(
                  leading: Icon(Typicons.social_github, color: Colors.white, size: 30),
                  title: Text(
                    'GitHub',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  onTap: () => launch('https://github.com/hanuuuuU'),
                ),
              ),
              //instagram
              Card(
                clipBehavior: Clip.antiAlias,
                margin: EdgeInsets.symmetric(
                  vertical: 15.0,
                  horizontal: 25.0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
                color: CustomColor.primary,
                child: ListTile(
                  leading: Icon(Typicons.social_instagram, color: Colors.white, size: 30),
                  title: Text(
                    'Instagram',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Card(
                clipBehavior: Clip.antiAlias,
                margin: EdgeInsets.symmetric(
                  vertical: 15.0,
                  horizontal: 25.0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
                color: CustomColor.primary,
                child: ListTile(
                  leading: Icon(Typicons.social_twitter, color: Colors.white, size: 30),
                  title: Text(
                    'Twitter',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  //onTap: () => launch(''),
                ),
              )
            ]
          ),
        )
      ),
    );
  }
}
