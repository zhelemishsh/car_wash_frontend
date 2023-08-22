import 'package:car_wash_frontend/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

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

  var _isPasswordObscured = true;
  String _userName = '';
  String _password = '';
  String _phoneNumber = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.dirtyWhite,
        elevation: 0.0,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            size: 40,
          ),
          color: AppColors.orange,
          alignment: Alignment.centerLeft,
        ),
      ),
      body: _signUpPanelWidget(),
    );
  }

  Widget _signUpPanelWidget(){
    return Container(
      color: AppColors.dirtyWhite,
      alignment: Alignment.center,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Регистация",
              style: TextStyle(
                  color: AppColors.darkGrey,
                  fontSize: 50,
                  fontWeight: FontWeight.w800
              ),
            ),

            Container(
              constraints: const BoxConstraints(maxWidth: 300.0, maxHeight: 550.0),
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: AppColors.darkGrey,
                borderRadius: BorderRadius.circular(15),
              ),
              child: _inputPanelsWidget(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputPanelsWidget(){
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _avatarPanel(),

          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Имя:',
              style: TextStyle(
                  fontSize: 15.0,
                  color: AppColors.orange
              ),
            ),
          ),

          _userNameInputPanel(),

          const SizedBox(height: 20.0),

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

          _signUpButton(),
        ],
      ),
    );
  }

  Widget _avatarPanel(){
    return Stack(
      children: [
        const CircleAvatar(
          foregroundImage: AssetImage("assets/goshan.jpg"),
          radius: 40.0,
        ),

        Positioned(
          bottom: -10,
          right: -10,
          child: IconButton(
            color: AppColors.lightOrange,
            onPressed: (){},
            icon: const Icon(
                Icons.photo_camera
            ),
          ),
        )
      ],
    );
  }

  Widget _userNameInputPanel(){
    return TextFormField(
      keyboardType: TextInputType.text,
      style: const TextStyle(
          color: AppColors.dirtyWhite
      ),
      decoration: const InputDecoration(
        hintText: "Введите имя",
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
      validator: (String? value){
        if (value != null && value.isEmpty) {
          return 'Пожалуйста введите имя';
        }
        _userName = value!;
        return null;
      },
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

  Widget _signUpButton(){
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
        'Зарегестрироваться',
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
}