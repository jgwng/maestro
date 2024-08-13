import 'package:client/core/maestro_resources.dart';
import 'package:client/helper/maestro_theme_helper.dart';
import 'package:flutter/material.dart';
class ClientTFT extends StatefulWidget {

  final TextEditingController? controller;
  final String labelText;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final Icon? suffixIcon;
  final bool obscureText;
  final FocusNode? focusNode;
  final Function(String)? onChanged;
  final Function(String)? onFieldSubmit;

  const ClientTFT({super.key, required this.labelText, this.validator,this.controller,this.focusNode,this.onFieldSubmit,
    this.onChanged, this.suffixIcon, this.obscureText = false, this.keyboardType});

  @override
  _ClientTFTState createState() => _ClientTFTState();
}

class _ClientTFTState extends State<ClientTFT>{
  bool? isObscureText;
  bool? isPw;
  List<String> obscureLabel = ['비밀번호',''];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.labelText);
    print(widget.labelText == '');
    isObscureText = widget.obscureText;
    isPw = obscureLabel.contains(widget.labelText);
  }


  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: MaestroThemeHelper.themeMode,
        builder: (context,mode,child){
          return Container(
            width: double.infinity,
            height: 60,
            margin: const EdgeInsets.only(top:20,left:20,right:20),
            child: TextFormField(
              obscureText: isPw! ? isObscureText! : widget.obscureText,
              keyboardType: widget.keyboardType ?? TextInputType.text,
              controller: widget.controller ?? TextEditingController(),
              focusNode: widget.focusNode ?? FocusNode(),
              cursorColor: Colors.black,
              validator: widget.validator,
              style: const TextStyle(
                  color: AppThemes.textColor,
                  fontFamily: AppFonts.medium,
                  fontSize: 16
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onChanged: (text){
                setState(() {
                  if(widget.onChanged != null){
                    widget.onChanged!;
                  }
                });
              },
              onFieldSubmitted: widget.onFieldSubmit,
              decoration: InputDecoration(
                  labelText: widget.labelText,
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if(isPw ?? false)
                        IconButton(
                          onPressed: (){
                            setState(() {
                              isObscureText = !isObscureText!;
                            });
                          },
                          icon: Icon(isObscureText! ? Icons.visibility_off : Icons.visibility),
                        ),
                      if((widget.focusNode?.hasFocus ?? false) && (widget.controller?.text.isNotEmpty ?? false))
                        IconButton(
                          onPressed: (){
                            setState(() {
                              widget.controller!.clear();
                              if(widget.onChanged != null){
                                widget.onChanged!;
                              }
                            });
                          },
                          icon: const Icon(Icons.cancel),
                        )
                    ],
                  ),
                  labelStyle: AppThemes.textTheme.bodyLarge!.copyWith(color: Colors.grey),
                  errorStyle: AppThemes.textTheme.bodyMedium!.copyWith(color: Colors.red),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: const BorderSide(
                        color: AppThemes.pointColor),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: const BorderSide(color: Colors.black),
                  )),
            ),
          );
        });
  }
}