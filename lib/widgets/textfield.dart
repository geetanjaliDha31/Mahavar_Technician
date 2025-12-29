// ignore_for_file: must_be_immutable, prefer_if_null_operators

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mahavar_technician/constants.dart';

class TextBox extends StatefulWidget {
  final TextEditingController? controller;
  final String? hinttext;
  final String? Function(String?)? validator;
  bool obscureText;
  final String? label;
  final double width;
  final bool? enabled;
  final double height;
  FocusNode? node;
  final IconData? icon;
  final TextStyle? style;
  final double? labelSize;
  final bool isPassword;
  final bool isNumber;
  final bool readOnly;
  final TextInputType? textInputType;
  final bool inputType;
  final VoidCallback? onTap;
  final int maxLines;
  TextBox(
      {Key? key,
      this.controller,
      this.enabled,
      this.hinttext,
      this.labelSize,
      this.validator,
      this.textInputType,
      this.inputType = false,
      this.style,
      this.obscureText = false,
      this.label,
      this.node,
      this.width = 0,
      this.height = 55,
      this.icon,
      this.isPassword = false,
      this.isNumber = false,
      this.readOnly = false,
      this.onTap,
      this.maxLines = 1})
      : super(key: key);

  @override
  State<TextBox> createState() => _TextBoxState();
}

class _TextBoxState extends State<TextBox> {
  late bool focused;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    focused = false;
    _focusNode = widget.node ?? FocusNode();
    _focusNode.addListener(() {
      setState(() {
        focused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != "")
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 2),
            child: Text(
              widget.label!,
              style: GoogleFonts.montserrat(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        SizedBox(
          width: widget.width == 0 ? double.infinity : widget.width,
          height: widget.height == 55 ? 55 : widget.height,
          child: TextFormField(
            controller: widget.controller,
            focusNode: _focusNode,
            readOnly: widget.readOnly,
            maxLines: widget.maxLines,
            style: widget.style == null
                ? GoogleFonts.montserrat(color: Colors.black, fontSize: 13)
                : widget.style,
            enabled: widget.enabled,
            onTap: widget.onTap,
            keyboardType: widget.inputType
                ? widget.textInputType
                : widget.isNumber
                    ? TextInputType.number
                    : TextInputType.text,
            maxLength: widget.isNumber ? 10 : null,
            decoration: InputDecoration(
              hintText: widget.hinttext,
              counter: const SizedBox.shrink(),
              hintStyle: TextStyle(
                  color: focused ? color2 : color3, fontSize: widget.labelSize),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: color3, width: 1),
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              // error: SizedBox.shrink(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: color2, width: 1),
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
              ),

              errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 1),
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              focusedErrorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 1),
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              suffixIcon: widget.isPassword
                  ? InkWell(
                      onTap: () {
                        setState(() {
                          widget.obscureText = !widget.obscureText;
                        });
                      },
                      child: Icon(
                        widget.obscureText
                            ? Icons.visibility_off_rounded
                            : Icons.visibility_rounded,
                        color: focused || !widget.obscureText ? color2 : color3,
                      ),
                    )
                  : Icon(
                      widget.icon,
                      color: focused ? color2 : color3,
                    ),
              labelStyle: TextStyle(color: focused ? color2 : color3),
            ),
            obscureText: widget.obscureText,
            // validator: widget.validator,
          ),
        ),
      ],
    );
  }
}
