import 'package:client/core/maestro_resources.dart';
import 'package:client/helper/maestro_theme_helper.dart';
import 'package:flutter/material.dart';

class ClientButton extends StatelessWidget {
  const ClientButton(
      {super.key,
      required this.onPressed,
      required this.buttonText,
      this.vMargin,
      this.hMargin,
      this.isNetworking});

  final String buttonText;
  final VoidCallback onPressed;
  final double? vMargin;
  final double? hMargin;
  final bool? isNetworking;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: MaestroThemeHelper.themeMode,
        builder: (context, mode, child) {
          bool isDark = mode == ThemeMode.dark;
          return GestureDetector(
            onTap: onPressed,
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: double.infinity,
              height: 60,
              margin: EdgeInsets.symmetric(
                  horizontal: hMargin ?? 0, vertical: vMargin ?? 0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: isDark
                      ? const Color.fromRGBO(228, 228, 228, 1.0)
                      : const Color.fromRGBO(17, 17, 17, 1.0)),
              child: (isNetworking ?? false)
                  ? CircularProgressIndicator(
                      color: isDark ? Colors.white : Colors.black)
                  : Text(buttonText,
                      style: Theme.of(context).textTheme.labelLarge),
            ),
          );
        });
  }
}
