import 'package:flutter/material.dart';
import 'package:ugc_notes_admin/main.dart';
import 'package:ugc_notes_admin/screens/changeSubscriptionPrices.dart';
import 'package:ugc_notes_admin/screens/premiumUsersScreen.dart';

class ScreenDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            height: 100,
            child: DrawerHeader(
              padding: EdgeInsets.only(top: 25, left: 30),
              child: Text(
                'UGC NOTES Admin',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
          ),
          ListTile(
            title: Text('Home'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => MyHomePage(),
                ),
              );
            },
          ),
          ListTile(
            title: Text('Change Subscription Plans'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangeSubscriptionPricesScreen(),
                ),
              );
            },
          ),

          Divider(),
          ListTile(
            title: Text('Premium Users'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PremiumUsersScreen(),
                ),
              );
            },
          ),
          // ListTile(
          //   title: Text('Questions Configration'),
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => AllQuestions(),
          //       ),
          //     );
          //   },
          // ),
          // Divider(),
        ],
      ),
    );
  }
}
