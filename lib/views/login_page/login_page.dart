import 'package:car_wash_frontend/theme/app_colors.dart';
import 'package:car_wash_frontend/views/sign_up_page/sign_up_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

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
      body: _loginPanelWidget(),
    );
  }


  Widget _loginPanelWidget(){
    return Container(
      color: AppColors.dirtyWhite,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "PomoiCar",
            style: TextStyle(
                color: AppColors.darkGrey,
                fontSize: 50,
                fontWeight: FontWeight.w800
            ),
          ),

          Container(
            constraints: const BoxConstraints(maxWidth: 300.0, maxHeight: 450.0),
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: AppColors.darkGrey,
              borderRadius: BorderRadius.circular(15),
            ),
            child: _inputPanelsWidget(),
          ),
        ],
      ),
    );
  }

  Widget _inputPanelsWidget(){
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Номер телефона:',
              style: TextStyle(
                  fontSize: 15.0,
                  color: AppColors.orange
              ),
            ),
          ),

          _phoneInputPanel(),

          const SizedBox(height: 20.0),

          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Пароль:',
              style: TextStyle(
                  fontSize: 15.0,
                  color: AppColors.orange
              ),
            ),
          ),

          _passwordInputPanel(),

          const SizedBox(height: 20.0),

          _loginButton(),

          const SizedBox(height: 20.0),

          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Ещё не зарегистрированы?',
              style: TextStyle(
                  fontSize: 15.0,
                  color: AppColors.lightOrange
              ),
            ),
          ),

          const SizedBox(height: 5.0),

          _signUpButton()
        ],
      ),
    );
  }

  Widget _phoneInputPanel(){
    return TextFormField(
      keyboardType: TextInputType.phone,
      style: const TextStyle(
          color: AppColors.dirtyWhite
      ),
      decoration: const InputDecoration(
        hintText: "+7 (000) 000-00-00",
        hintStyle: TextStyle(
          color: Color.fromRGBO(230, 230, 230, 0.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 2.0,
            color: AppColors.lightOrange,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 2.0,
            color: AppColors.orange,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 2.0,
            color: AppColors.errorRed,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 2.0,
            color: AppColors.orange,
          ),
        ),
      ),
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
      style: const TextStyle(
          color: AppColors.dirtyWhite
      ),
      obscureText: _isPasswordObscured,
      decoration: InputDecoration(
        hintText: "Введите пароль",
        hintStyle: const TextStyle(
          color: Color.fromRGBO(230, 230, 230, 0.5),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            width: 2.0,
            color: AppColors.lightOrange,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            width: 2.0,
            color: AppColors.orange,
          ),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            width: 2.0,
            color: AppColors.errorRed,
          ),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            width: 2.0,
            color: AppColors.orange,
          ),
        ),
        suffixIcon: IconButton(
          color: AppColors.lightOrange,
          onPressed: () {
            setState(() {
              _isPasswordObscured = !_isPasswordObscured;
            });
          },
          icon: _isPasswordObscured ?
          const Icon(Icons.visibility) :
          const Icon(Icons.visibility_off),
        ),
      ),
      validator: (String? value){
        if (value != null && value.isEmpty) {
          return 'Пожалуйста введите пароль';
        }
        _password = value!;
        return null;
      },
    );
  }

  Widget _loginButton(){
    return ElevatedButton(
      onPressed: (){
        if(_formKey.currentState!.validate()) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                "Phone: " + _phoneNumber + "  Password: " + _password
            ),
            backgroundColor: AppColors.lightOrange,));
        }
      },
      child: const Text(
        'Авторизоваться',
        style: TextStyle(
            color: AppColors.dirtyWhite
        ),
      ),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(50),
        backgroundColor: AppColors.orange,
      ),
    );
  }

  Widget _signUpButton(){
    return ElevatedButton(
      onPressed: (){
        Navigator.push(
          context,
          CupertinoPageRoute(builder: (context) => const SignUpPage()),
        );
      },
      child: const Text(
        'Зарегистрироваться',
        style: TextStyle(
          color: AppColors.lightOrange
        ),
      ),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(50),
        backgroundColor: AppColors.grey,
        side: const BorderSide(
          color: AppColors.lightOrange,
          width: 2.0,
        )
      ),
    );
  }

}
