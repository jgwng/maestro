import 'package:client/core/maestro_resources.dart';
import 'package:client/helper/maestro_theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClientTFT extends StatefulWidget {
  final TextEditingController controller;
  final String? hintText;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final Icon? suffixIcon;
  final SuffixMode? mode;
  final bool? setPadding;
  final FocusNode focusNode;
  final Function(String)? onChanged;
  final Function(String)? onFieldSubmit;

  const ClientTFT(
      {super.key,
      this.mode,
      this.hintText,
      this.setPadding,
      this.validator,
      required this.controller,
      required this.focusNode,
      this.onFieldSubmit,
      this.onChanged,
      this.suffixIcon,
      this.keyboardType});

  @override
  _ClientTFTState createState() => _ClientTFTState();
}

class _ClientTFTState extends State<ClientTFT> {
  bool? isObscureText;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isObscureText = widget.mode == SuffixMode.obscure;
    widget.focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: MaestroThemeHelper.themeMode,
        builder: (context, mode, child) {
          bool isDark = mode == ThemeMode.dark;
          return Container(
            width: double.infinity,
            height: 60,
            margin: (widget.setPadding ?? true)
                ? const EdgeInsets.only(top: 20, left: 20, right: 20)
                : EdgeInsets.zero,
            child: TextFormField(
              obscureText: isObscureText ?? false,
              keyboardType: widget.keyboardType ?? TextInputType.text,
              controller: widget.controller,
              focusNode: widget.focusNode ?? FocusNode(),
              cursorColor: Theme.of(context).primaryColorDark,
              validator: widget.validator,
              style: Theme.of(context).textTheme.bodyMedium,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onChanged: (text) {
                setState(() {
                  if (widget.onChanged != null) {
                    widget.onChanged!;
                  }
                });
              },
              onFieldSubmitted: widget.onFieldSubmit,
              decoration: InputDecoration(
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      suffixWidget(isDark),
                      if (showSuffixIcon == true)
                        IconButton(
                          onPressed: () {
                            setState(() {
                              widget.controller.clear();
                              if (widget.onChanged != null) {
                                widget.onChanged!;
                              }
                            });
                          },
                          icon: Icon(
                            Icons.cancel,
                            color: Theme.of(context).primaryColorDark,
                          ),
                        )
                    ],
                  ),
                  hintText: widget.hintText,
                  hintStyle: Theme.of(context).textTheme.bodySmall,
                  labelStyle: AppThemes.textTheme.bodyLarge!
                      .copyWith(color: Colors.grey),
                  errorStyle: AppThemes.textTheme.bodyMedium!
                      .copyWith(color: Colors.red),
                  filled: true,
                  fillColor: Theme.of(context).secondaryHeaderColor,
                  focusedBorder: fieldBorder,
                  focusedErrorBorder: fieldBorder,
                  disabledBorder: fieldBorder,
                  enabledBorder: fieldBorder,
                  border: fieldBorder
              ),
            ),
          );
        });
  }

  OutlineInputBorder get fieldBorder {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: BorderSide(
          color: Theme.of(context).secondaryHeaderColor),
    );
  }

  bool get showSuffixIcon => (widget.focusNode.hasFocus) &&
      (widget.controller.text.isNotEmpty );
  Widget suffixWidget(bool isDark) {
    switch (widget.mode) {
      case SuffixMode.obscure:
        if(showSuffixIcon == false){
          return const SizedBox();
        }
        return IconButton(
          onPressed: () {
            setState(() {
              isObscureText = !isObscureText!;
            });
          },
          icon: Icon(isObscureText! ? Icons.visibility_off : Icons.visibility),
        );
      case SuffixMode.search:
        return InkWell(
          onTap: () {
            if (widget.controller.text.isNotEmpty) {
              String text = widget.controller.text;
              if (widget.onChanged != null) {
                widget.onFieldSubmit!(text);
              }
            }
          },
          child: Icon(
            Icons.search,
            size: 32,
            color: widget.controller.text.isNotEmpty
                ? ((isDark == true) ? Colors.white : Colors.black)
                : (isDark == true)
                    ? const Color.fromRGBO(108, 108, 108, 1.0)
                    : const Color.fromRGBO(154, 163, 180, 1.0),
          ),
        );
      default:
        return const SizedBox();
    }
  }
}

enum SuffixMode { obscure, search, none }
