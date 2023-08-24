import 'package:car_wash_frontend/theme/app_colors.dart';
import 'package:car_wash_frontend/views/stateless_views/input_panel.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../stateless_views/data_panel.dart';

class SignUpPage extends StatefulWidget{
  const SignUpPage({Key? key}) : super(key: key);

  @override
  SignUpPageState createState() {
    return SignUpPageState();
  }
}

class SignUpPageState extends State<SignUpPage>{

  final _formKey = GlobalKey<FormState>();

  final _phoneInputFormatter = MaskTextInputFormatter(
    mask: '+7 (###) ###-##-##',
    filter: { "#": RegExp(r'[0-9]') },
    type: MaskAutoCompletionType.lazy,
  );

  String _userName = '';
  String _password = '';
  String _repeatedPassword = '';
  String _phoneNumber = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_rounded,),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.dirtyWhite,
      body: Align(
        alignment: Alignment.center,
        child: SizedBox(
          width: 320,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Регистрация",
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 45,
                  fontWeight: FontWeight.w800,
                ),
              ),

              DataPanel(
                backgroundColor: AppColors.black,
                borderRadius: 16,
                padding: 11,
                child: _signUpForm(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _signUpForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _identityPanel(),
          _passwordInputPanel(),
          _repeatedPasswordInputPanel(),
          _signUpButton(),
        ],
      ),
    );
  }

  Widget _identityPanel() {
    return IntrinsicHeight(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _userNameInputPanel(),
                _phoneInputPanel(),
              ],
            ),
          ),
          _userImagePanel(),
        ],
      ),
    );
  }

  Widget _userImagePanel() {
    return Container(
      margin: const EdgeInsets.all(4),
      constraints: const BoxConstraints(maxWidth: 100),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: const DecorationImage(
          image:  AssetImage("assets/goshan.jpg"),
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }

  Widget _userNameInputPanel(){
    return InputPanel(
      margin: 4,
      keyboardType: TextInputType.text,
      textColor: AppColors.dirtyWhite,
      labelText: "Имя",
      validator: (String? value){
        if (value == null || value.isEmpty) {
          return 'Введите имя';
        }
        _userName = value;
        return null;
      },
    );
  }

  Widget _phoneInputPanel(){
    return InputPanel(
      margin: 4,
      keyboardType: TextInputType.phone,
      textColor: AppColors.dirtyWhite,
      labelText: "Номер телефона",
      inputFormatters: [
        _phoneInputFormatter
      ],
      validator: (String? value){
        if (value != null && value.isEmpty) {
          return 'Введите телефон';
        }
        if (_phoneInputFormatter.getUnmaskedText().length != 10) {
          return "Неполный номер";
        }
        _phoneNumber = _phoneInputFormatter.getMaskedText();
        return null;
      },
    );
  }

  Widget _passwordInputPanel(){
    return InputPanel(
      margin: 4,
      isPasswordField: true,
      textColor: AppColors.dirtyWhite,
      labelText: "Пароль",
      validator: (String? value){
        if (value == null || value.isEmpty) {
          return 'Введите пароль';
        }
        _password = value;
        return null;
      },
    );
  }

  Widget _repeatedPasswordInputPanel(){
    return InputPanel(
      margin: 4,
      isPasswordField: true,
      textColor: AppColors.dirtyWhite,
      labelText: "Повторите пароль",
      validator: (String? value){
        if (value == null || value.isEmpty) {
          return 'Повторите пароль';
        }
        if (value != _password) {
          return 'Пароли не совпадают';
        }
        _repeatedPassword = value;
        return null;
      },
    );
  }

  Widget _signUpButton(){
    return DataButtonPanel(
      margin: 4,
      height: 45,
      splashColor: AppColors.dirtyWhite,
      backgroundColor: AppColors.orange,
      child: Align(
        alignment: Alignment.center,
        child: Text(
          'Зарегестрироваться',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.dirtyWhite),
        ),
      ),
      onPressed: () {
        if(_formKey.currentState!.validate()) {
          Navigator.pushNamedAndRemoveUntil(context, "/login_page", (_) => false);
        }
      },
    );
  }
}