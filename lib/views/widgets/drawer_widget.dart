import 'package:easy_localization/easy_localization.dart';
import 'package:events_app/controller/user_controller.dart';
import 'package:events_app/views/screens/language_change_page.dart';
import 'package:events_app/views/screens/my_events_page.dart';
import 'package:events_app/views/screens/theme_switcher_screen%20.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final userControeller = context.read<UserController>();
    final user = userControeller.user!;
    return Drawer(
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  child: userControeller.user!.imageUrl == null
                      ? Image.asset('assets/images/profile.png')
                      : FadeInImage(
                          placeholder: const AssetImage('assets/images/profile.png'),
                          image: NetworkImage(userControeller.user!.imageUrl!),
                        ),
                ),
                title: Row(
                  children: [
                    Text(
                      user.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(10),
                    Text(
                      user.surName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                subtitle: Text(user.email),
              ),
              const Divider(
                thickness: 3,
              ),
              ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyEventsPage(),
                    ),
                  );
                },
                leading: const Icon(
                  Icons.discount,
                ),
                title: Text(
                  "mening_tadbirlarim".tr(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: const Icon(Icons.arrow_forward_ios_sharp),
              ),
              ListTile(
                onTap: () {},
                leading: const Icon(
                  Icons.person,
                ),
                title: Text(
                  "profil_malumotlari".tr(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: const Icon(Icons.arrow_forward_ios_sharp),
              ),
              ListTile(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    'language',
                  );
                },
                leading: const Icon(
                  Icons.translate,
                ),
                title: Text(
                  "tillarni_ozgartirish".tr(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: const Icon(Icons.arrow_forward_ios_sharp),
              ),
              ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ThemeSwitcherScreen(),
                      ));
                },
                leading: const Icon(
                  Icons.light_mode_outlined,
                ),
                title: Text(
                  "tungi_kunduzgi_holat".tr(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: const Icon(Icons.arrow_forward_ios_sharp),
              )
            ],
          ),
        ),
        bottomNavigationBar: ListTile(
          onTap: () async {
            await FirebaseAuth.instance.signOut();
          },
          leading: const Icon(Icons.logout),
          title: const Text(
            "Chiqish",
            style: TextStyle(
              color: Colors.red,
            ),
          ),
        ),
      ),
    );
  }
}
