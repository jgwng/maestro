import 'package:client/core/maestro_resources.dart';
import 'package:client/helper/maestro_theme_helper.dart';
import 'package:flutter/material.dart';

class ClientTFT extends StatefulWidget {
  final TextEditingController controller;
  final String? hintText;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final Icon? suffixIcon;
  final SuffixMode? mode;
  final bool? setPadding;
  final FocusNode? focusNode;
  final Function(String)? onChanged;
  final Function(String)? onFieldSubmit;

  const ClientTFT(
      {super.key,
      this.mode,
      this.hintText,
      this.setPadding,
      this.validator,
      required this.controller,
      this.focusNode,
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
              cursorColor: (isDark)
                  ? const Color.fromRGBO(239, 241, 243, 1.0)
                  : const Color(0xff222222),
              validator: widget.validator,
              style: TextStyle(
                color: (isDark)
                    ? const Color.fromRGBO(239, 241, 243, 1.0)
                    : const Color(0xff222222),
                fontFamily: AppFonts.medium,
                fontSize: 16,
              ),
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
                      if ((widget.focusNode?.hasFocus ?? false) &&
                          (widget.controller.text.isNotEmpty ?? false))
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
                            color: (isDark)
                                ? const Color.fromRGBO(239, 241, 243, 1.0)
                                : const Color(0xff222222),
                          ),
                        )
                    ],
                  ),
                  hintText: widget.hintText,
                  hintStyle: TextStyle(
                    color: (isDark == true)
                        ? const Color.fromRGBO(108, 108, 108, 1.0)
                        : const Color.fromRGBO(108, 108, 108, 1.0),
                    fontFamily: AppFonts.medium,
                    fontSize: 16,
                  ),
                  labelStyle: AppThemes.textTheme.bodyLarge!
                      .copyWith(color: Colors.grey),
                  errorStyle: AppThemes.textTheme.bodyMedium!
                      .copyWith(color: Colors.red),
                  filled: true,
                  fillColor: (isDark == true)
                      ? const Color.fromRGBO(40, 40, 40, 1.0)
                      : const Color.fromRGBO(234, 235, 237, 1.0),
                  focusedBorder: fieldBorder(isDark),
                  focusedErrorBorder: fieldBorder(isDark),
                  disabledBorder: fieldBorder(isDark),
                  enabledBorder: fieldBorder(isDark),
                  border: fieldBorder(isDark)),
            ),
          );
        });
  }

  OutlineInputBorder fieldBorder(bool isDark) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: BorderSide(
          color: (isDark == true)
              ? const Color.fromRGBO(40, 40, 40, 1.0)
              : const Color.fromRGBO(237, 239, 246, 1.0)),
    );
  }

  Widget suffixWidget(bool isDark) {
    switch (widget.mode) {
      case SuffixMode.obscure:
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
