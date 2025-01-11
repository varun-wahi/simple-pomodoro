import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../config/theme/text_styles.dart';
import '../../../../core/util/constants/color_grid.dart';
import '../../../../core/util/constants/sizes.dart';
import '../../../../core/util/widgets/d_elevated_button.dart';
import '../../../../core/util/widgets/d_gap.dart';
import 'edit_profile_screen.dart';

class MoreOptionsPage extends StatelessWidget {
  const MoreOptionsPage({super.key});


  void _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        // backgroundColor: tWhite,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Settings',
          // style: TextStyle(color: tBlack),
        ),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Log Out action
            },
            icon: const FaIcon(FontAwesomeIcons.arrowRightFromBracket, size: 20),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // _buildUserProfileSection(context),
            // const DGap(gap: dGap * 2),

            // Settings Section
            // const Text('Theme', style: TextStyle(color: tBlack, fontWeight: FontWeight.bold)),
            ListTile(
              leading: const Icon(Icons.color_lens),
              title: const Text('Theme'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // Navigate to Theme settings
              },
            ),
            ListTile(
              leading: const Icon(Icons.dark_mode),
              title: const Text('Dark Mode'),
              trailing: Switch(
                value: isDarkMode,
                onChanged: (value) {
                  // Toggle theme functionality
                },
              ),
            ),
          
            const DGap(gap: dGap * 2),

            // More Information Section
            const Text('More Information', style: TextStyle(color: tBlack, fontWeight: FontWeight.bold)),
            ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: const Text('Privacy Policy'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                // Navigate to Privacy Policy
               _launchURL('https://www.freeprivacypolicy.com/live/a967bcbb-19eb-4828-8d37-6c4f0d0772e2');
              },
            ),
            ListTile(
              leading: const Icon(Icons.article),
              title: const Text('Terms of Use'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // Navigate to Terms of Use
              },
            ),
            ListTile(
              leading: const Icon(Icons.star),
              title: const Text('Rate the App'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // Navigate to Rate the App
              },
            ),
            ListTile(
              leading: const Icon(Icons.feedback),
              title: const Text('Send Feedback'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // Navigate to Send Feedback
              },
            ),
            ListTile(
              leading: const Icon(FontAwesomeIcons.userCircle),
              title: const Text('Follow Creator'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // Navigate to Follow Creator link or page
              },
            ),
            const DGap(gap: dGap * 2),
          ],
        ),
      ),
    );
  }

  Widget _buildUserProfileSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 60.0,
            backgroundImage: AssetImage('assets/images/user_dp.jpeg'),
          ),
          const SizedBox(height: dGap),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Varun",
                style: headline(),
              ),
              const DGap(),
              DElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditProfileScreen(),
                    ),
                  );
                },
                buttonColor: tBlack,
                child: Text(
                  'Edit Profile',
                  style: body(color: tWhite),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}