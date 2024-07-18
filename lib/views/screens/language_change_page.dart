import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LanguageChangePage extends StatefulWidget {
  final Function() mainSetState;
  LanguageChangePage(this.mainSetState);

  @override
  _LanguageChangePageState createState() => _LanguageChangePageState();
}

class _LanguageChangePageState extends State<LanguageChangePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('change_language').tr(),
      ),
      body: Center(
        child: DropdownButton<Locale>(
          value: context.locale,
          items: [
            DropdownMenuItem(
              value: Locale('en'),
              child: Text('English'),
            ),
            DropdownMenuItem(
              value: Locale('uz'),
              child: Text('O\'zbekcha'),
            ),
          ],
          onChanged: (Locale? newLocale) async {
            if (newLocale != null) {
              await context.setLocale(newLocale);
              widget.mainSetState();
              setState(() {}); // Refresh the UI
            }
          },
        ),
      ),
    );
  }
}
