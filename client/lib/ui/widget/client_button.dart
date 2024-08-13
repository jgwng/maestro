import 'package:client/core/maestro_resources.dart';
import 'package:client/helper/maestro_theme_helper.dart';
import 'package:flutter/material.dart';

class ClientButton extends StatelessWidget{
  ClientButton({
    required this.onPressed,
    required this.buttonText,this.vMargin,this.hMargin,
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
        builder: (context,mode,child){
          return GestureDetector(
            onTap: onPressed,
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: double.infinity,
              height: 60,
              margin: EdgeInsets.symmetric(horizontal: hMargin ?? 0,vertical: vMargin ?? 0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: AppThemes.pointColor
              ),
              child: (isNetworking ?? false) ? const CircularProgressIndicator(
                  color : Colors.white
              ) : Text(buttonText,
                style: const TextStyle(
                    fontFamily: AppFonts.medium,
                    fontSize: 18,
                    height: 24/18,
                    letterSpacing: -0.6,
                    color : Colors.white),),
            ),
          );
        });
  }

}