import 'package:flutter/material.dart';
import 'package:hide_talk/widgets/custom_bottom_nav_bar.dart';

import 'components/profile_body.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProfileBody(),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}
