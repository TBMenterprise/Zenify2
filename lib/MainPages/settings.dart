import 'package:flutter/material.dart';
import 'package:mainproject/SubPages/change_username.dart';
import 'package:mainproject/SubPages/delete_account.dart';
import 'package:mainproject/SubPages/go_premium.dart';
import 'package:mainproject/SubPages/update_password.dart';
import 'package:mainproject/widgets/settings_bottom_sheet.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Settings'), 
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Color(0xFF333333),
                size: 18,
              ),
            ),
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return
          SingleChildScrollView(
            child:
          Padding(padding: EdgeInsets.all(20), child: Column(
            children: [
              profilecard(),
              SizedBox(height: 20),
              settingButtons('Update Username', ChangeUsernamePage(), context),
              SizedBox(height: 10),
              settingButtons('Go Premium', GoPremiumPage(), context),
              SizedBox(height: 10),
              settingButtons('Update Password', UpdatePasswordPage(), context),
              SizedBox(height: 10),
              // TODO: Implement Support us page
              settingButtons('Support us', Text('Support us'), context),
              SizedBox(height: 10),
              // TODO: Implement Help and support page
              settingButtons('Help and support', Text('Help and support'), context),
              SizedBox(height: 10),
              settingButtons('Delete Account', DeleteAccountPage(), context),
              SizedBox(height: 20),
              logouttext(),

              // Your settings widgets will go here
            ],
          ),
          ),
          );
        },
      ),
    );
  }

  Widget settingButtons(String title, Widget page, BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
      borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          SizedBox(width: 10),
          Text(title),
          Spacer(),
          IconButton(
            onPressed: () {
              showSettingsBottomSheet(context, page);
            },
            icon: Icon(Icons.arrow_forward_ios),
          ),
        ],
      ),
    );
  }
  Widget profilecard(){
    return Container( width: double.infinity , color: Colors.white, child: Card(// Adjusted margin
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 50), // Adjusted padding
                child: Row(
                  // Removed mainAxisSize: MainAxisSize.min to allow expansion
                  children: <Widget>[
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[300],
                      child: Text(
                        'BD',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded( // Added Expanded to the Column to fill remaining space
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // Removed mainAxisSize: MainAxisSize.min
                        children: <Widget>[
                          Text(
                            'Benjamin Djan',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Edit Profile',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blue[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
    ),
            );
  }
  Widget logouttext(){
    return TextButton(onPressed: (){}, child: Text('Logout', style: TextStyle(color: Colors.red, fontSize: 21 ),));
  }
}