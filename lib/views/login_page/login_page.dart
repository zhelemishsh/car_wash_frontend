import 'package:car_wash_frontend/theme/app_colors.dart';
import 'package:car_wash_frontend/views/sign_up_page/sign_up_page.dart';
import 'package:car_wash_frontend/views/stateless_views/data_panel.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../main_page/main_page.dart';

class LoginPage extends StatefulWidget{
  const LoginPage({Key? key}) : super(key: key);

  @override
  LoginPageState createState(){
    return LoginPageState();
  }
}

class LoginPageState extends State<LoginPage>{
  final _formKey = GlobalKey<FormState>();

  final _phoneInputFormatter = MaskTextInputFormatter(
    mask: '+7 (###) ###-##-##',
    filter: { "#": RegExp(r'[0-9]') },
    type: MaskAutoCompletionType.lazy,
  );

  var _isPasswordObscured = true;
  String _password = '';
  String _phoneNumber = '';


  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: AppColors.dirtyWhite,
      body: Align(
        alignment: Alignment.center,
        child: SizedBox(
          width: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "PomoiCar",
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 50,
                  fontWeight: FontWeight.w800,
                ),
              ),

              DataPanel(
                backgroundColor: AppColors.black,
                borderRadius: 16,
                padding: 15,
                child: _inputPanelsWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputPanelsWidget(){
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _phoneInputPanel(),
          const SizedBox(height: 8,),
          _passwordInputPanel(),
          const SizedBox(height: 8,),
          _loginButton(),
          const SizedBox(height: 8,),
          _signUpButton(),
        ],
      ),
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

  InputDecoration _inputDecoration(String labelText) {
    return InputDecoration(
      contentPadding: const EdgeInsets.all(10),
      errorBorder: _inputFieldBorder(AppColors.darkRed),
      focusedErrorBorder: _inputFieldBorder(AppColors.orange),
      enabledBorder: _inputFieldBorder(AppColors.lightOrange),
      focusedBorder: _inputFieldBorder(AppColors.orange),
      labelText: labelText,
      labelStyle: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.lightOrange),
      floatingLabelStyle: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.orange),
    );
  }

  Widget _phoneInputPanel(){
    return TextFormField(
      keyboardType: TextInputType.phone,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.dirtyWhite),
      decoration: _inputDecoration("Номер телефона"),
      inputFormatters: [
        _phoneInputFormatter
      ],
      validator: (String? value){
        if (value != null && value.isEmpty) {
          return 'Пожалуйста введите телефон';
        }
        if (_phoneInputFormatter.getUnmaskedText().length != 10) {
          return "Неправильно введен номер";
        }
        _phoneNumber = _phoneInputFormatter.getMaskedText();
        return null;
      },
    );
  }

  Widget _passwordInputPanel(){
    return TextFormField(
      style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.dirtyWhite),
      obscureText: _isPasswordObscured,
      decoration: _inputDecoration("Пароль").copyWith(
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
      validator: (String? value){
        if (value == null || value.isEmpty) {
          return 'Пожалуйста введите пароль';
        }
        _password = value;
        return null;
      },
    );
  }

  Widget _loginButton(){
    return DataButtonPanel(
      height: 45,
      splashColor: AppColors.dirtyWhite,
      backgroundColor: AppColors.orange,
      child: Align(
        alignment: Alignment.center,
        child: Text(
          'Авторизоваться',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.dirtyWhite),
        ),
      ),
      onPressed: () {
        if(_formKey.currentState!.validate()) {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MainPage()),
          );
        }
      },
    );
  }

  Widget _signUpButton(){
    return DataButtonPanel(
      height: 45,
      splashColor: AppColors.dirtyWhite,
      backgroundColor: AppColors.grey,
      borderColor: AppColors.lightOrange,
      child: Align(
        alignment: Alignment.center,
        child: Text(
          'Зарегистрироваться',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.lightOrange),
        ),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SignUpPage()),
        );
      },
    );
  }
}
