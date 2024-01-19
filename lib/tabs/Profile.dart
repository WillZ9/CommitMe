import 'package:flutter/material.dart';
import 'package:commit_me/themes.dart';
import '/db/DatabaseHelperCommit.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Profile',
          style: normalTextStyle)
      ),
      body: Column(children: [
        Row(
          children: [
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello, ${CurrentUser().getUsername ?? 'No Username'}',
                          style: headingStyle,
                        ),
                        Text(
                          'Unique ID: ${CurrentUser().getUid}',
                          style: const TextStyle(color: Colors.white, 
                          fontSize: 13),
                        ),
                        const SizedBox(height: 30),
                        Text(
                          'Email: ${CurrentUser().getEmail}',
                          style: subTitleStyle,
                        ),
                        Text(
                          'Password: ${CurrentUser().getpassword}',
                          style: subTitleStyle,
                        ),
                    
                      ]),
                ),
              ],
            ),
          ],
        )
      ]),
    );
  }
}
