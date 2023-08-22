import 'package:car_wash_frontend/theme/app_colors.dart';
import 'package:car_wash_frontend/views/sign_up_page/sign_up_page.dart';
import 'package:car_wash_frontend/views/stateless_views/data_panel.dart';
import 'package:car_wash_frontend/views/stateless_views/input_panel.dart';
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

  String _password = '';
  String _phoneNumber = '';


  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: AppColors.dirtyWhite,
      body: Align(
        alignment: Alignment.center,
        child: SizedBox(
          width: 320,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "PomoiCar",
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
                child: _loginForm(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _loginForm(){
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _phoneInputPanel(),
          _passwordInputPanel(),
          _loginButton(),
          _signUpButton(),
        ],
      ),
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
        if (value == null || value.isEmpty) {
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

  Widget _loginButton(){
    return DataButtonPanel(
      margin: 4,
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
      margin: 4,
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
