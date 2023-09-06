import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../theme/app_colors.dart';

class InputPanel extends StatefulWidget {
  final String? labelText;
  final String? hintText;
  final double margin;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final Color? textColor;
  final TextInputType? keyboardType;
  final bool isPasswordField;

  const InputPanel({
    Key? key,
    this.labelText,
    this.hintText,
    this.margin = 0,
    this.inputFormatters,
    this.validator,
    this.textColor,
    this.keyboardType,
    this.isPasswordField = false,
  }) : super(key: key);

  @override
  InputPanelState createState() {
    return InputPanelState();
  }
}

class InputPanelState extends State<InputPanel> {
  bool _isPasswordObscured = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(widget.margin),
      child: TextFormField(
        obscureText: widget.isPasswordField ? _isPasswordObscured : false,
        keyboardType: widget.keyboardType,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(color: widget.textColor),
        decoration: !widget.isPasswordField
            ? _inputDecoration(widget.labelText, context)
            : _inputDecoration(widget.labelText, context).copyWith(
          suffixIcon: IconButton(
            color: AppColors.lightOrange,
            onPressed: () {
              setState(() {
                _isPasswordObscured = !_isPasswordObscured;
              });
            },
            icon: _isPasswordObscured
                ? const Icon(Icons.visibility)
                : const Icon(Icons.visibility_off),
          ),
        ),
        inputFormatters: widget.inputFormatters,
        validator: widget.validator,
      ),
    );
  }

  InputDecoration _inputDecoration(String? labelText, BuildContext context) {
    return InputDecoration(
      hintText: widget.hintText,
      contentPadding: const EdgeInsets.all(10),
      errorStyle: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.darkRed),
      errorBorder: _inputFieldBorder(AppColors.darkRed),
      focusedErrorBorder: _inputFieldBorder(AppColors.orange),
      enabledBorder: _inputFieldBorder(AppColors.lightOrange),
      focusedBorder: _inputFieldBorder(AppColors.orange),
      labelText: labelText,
      labelStyle: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.lightOrange),
      floatingLabelStyle: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.orange),
    );
  }

  InputBorder _inputFieldBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(
        width: 2.0,
        color: color,
      ),
    );
  }
}
