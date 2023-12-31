import 'package:animated_list_plus/animated_list_plus.dart';
import 'package:animated_list_plus/transitions.dart';
import 'package:car_wash_frontend/models/car_type.dart';
import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../models/car.dart';
import '../../../views/ask_dialog.dart';
import '../../../views/data_panel.dart';
import '../../../views/marked_list.dart';
import '../../../views/titled_panel.dart';
import 'account_menu_contract.dart';
import 'account_menu_presenter.dart';
import 'add_car_dialog.dart';

class AccountMenuPage extends StatefulWidget {
  const AccountMenuPage({Key? key}) : super(key: key);

  @override
  AccountMenuPageState createState() {
    return AccountMenuPageState();
  }
}

class AccountMenuPageState extends State<AccountMenuPage>
    implements AccountMenuContract {
  late AccountMenuPresenter _presenter;
  bool _isNameEntering = false;
  String _editingName = "";
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _presenter = AccountMenuPresenter(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.dirtyWhite,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_rounded,),
        ),
        actions: [
          IconButton(
            onPressed: _onExitButtonPressed,
            icon: const Icon(
              Icons.logout_rounded,
            ),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _userPanel(),
            Padding(
              padding: const EdgeInsets.all(3),
              child: _carsPanel(),
            ),
          ],
        ),
      ),
    );
  }

  void _onExitButtonPressed() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AskDialog(
          text: "Выйти из профиля?",
          onConfirmed: () {
            Navigator.pushNamedAndRemoveUntil(context, "/login_page", (_) => false);
          },
        );
      },
    );
  }

  Widget _userPanel() {
    return IntrinsicHeight(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(3),
            child: _userImagePanel(),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(3),
              child: _userTitledPanel(),
            ),
          ),
        ],
      ),
    );
  }

  InputBorder _inputFieldBorder(Color color) {
    return UnderlineInputBorder(
      borderSide: BorderSide(
        width: 2.0,
        color: color,
      ),
    );
  }

  Widget _nameInputField() {
    return Form(
      key: _formKey,
      child: TextFormField(
        autofocus: true,
        initialValue: _presenter.account.name,
        style: Theme.of(context).textTheme.titleMedium,
        decoration: InputDecoration(
          enabledBorder: _inputFieldBorder(AppColors.lightOrange),
          focusedBorder: _inputFieldBorder(AppColors.orange),
          errorBorder: _inputFieldBorder(AppColors.darkRed),
          errorStyle: const TextStyle(height: 0.001),
          contentPadding: const EdgeInsets.only(bottom: 18),
        ),
        validator: (String? value) {
          if (value == null || value.isEmpty) {
            return '';
          }
          _editingName = value;
          return null;
        },
        onEditingComplete: () {
          if(_formKey.currentState!.validate()) {
            _isNameEntering = false;
            _presenter.changeAccountName(_editingName);
          }
        },
      ),
    );
  }

  Widget _userTitledPanel() {
    Widget title;
    if (!_isNameEntering) {
      title = Text(
        _presenter.account.name,
        style: Theme.of(context).textTheme.titleMedium,
      );
    }
    else {
      title = _nameInputField();
    }

    return TitledPanel(
      title: title,
      child: Padding(
        padding: const EdgeInsets.only(top: 3),
        child: _userInfoPanel(),
      ),
      buttonIconData: Icons.edit_rounded,
      iconSize: 22,
      onButtonPressed: () {
        _isNameEntering = true;
        setState(() {});
      },
      buttonColor: AppColors.orange,
    );
  }

  Widget _userInfoPanel() {
    return MarkedList(
      textStyle: Theme.of(context).textTheme.titleSmall,
      iconSize: 22,
      markedTexts: [
        MarkedTextData(iconData: Icons.call_rounded, text: _presenter.account.phoneNumber),
        MarkedTextData(iconData: Icons.star_rounded, text: _presenter.account.rating.toString()),
      ],
    );
  }

  Widget _userImagePanel() {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        width: 90,
        decoration: BoxDecoration(
          color: AppColors.lightGrey,
          borderRadius: BorderRadius.circular(10),
          image: const DecorationImage(
            image:  AssetImage("assets/default_person_image.png"),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  Widget _carsPanel() {
    IconData iconData;
    Color buttonColor;
    Function() buttonFunction;
    if (_presenter.selectedCars.isEmpty) {
      iconData = Icons.add_rounded;
      buttonColor = AppColors.orange;
      buttonFunction = () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AddCarDialog(
              onAdded: (addedCar) {
                _presenter.addCar(addedCar);
              },
            );
          },
        );
      };
    }
    else {
      iconData = Icons.delete_rounded;
      buttonColor = AppColors.darkRed;
      buttonFunction = () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AskDialog(
              text: "Удалить выбранные машины?",
              onConfirmed: () {
                _presenter.deleteSelectedCars();
              },
            );
          },
        );
      };
    }

    return TitledPanel(
      title: Text(
        "Ваши машины:",
        style: Theme.of(context).textTheme.titleMedium,
      ),
      buttonIconData: iconData,
      buttonColor: buttonColor,
      onButtonPressed: buttonFunction,
      child: _carsList(),
    );
  }

  Widget _carsList() {
    return ImplicitlyAnimatedList(
      items: _presenter.account.cars,
      shrinkWrap: true,
      areItemsTheSame: (a, b) => a == b,
      itemBuilder: (context, animation, item, index) {
        return SizeFadeTransition(
          sizeFraction: 0.7,
          curve: Curves.easeInOut,
          animation: animation,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 3),
            child: _carInfoPanel(item),
          ),
        );
      },
    );
  }

  Widget _carInfoPanel(Car car) {
    bool isToggled = _presenter.selectedCars.contains(car);

    return DataButtonPanel(
      backgroundColor: AppColors.grey,
      borderColor: isToggled ? AppColors.lightOrange : null,
      onPressed: () {
        if (_presenter.selectedCars.contains(car)) {
          _presenter.selectedCars.remove(car);
        }
        else {
          _presenter.selectedCars.add(car);
        }
        setState(() {});
      },
      child: Row(
        children: [
          Icon(
            car.type.carIcon(),
            size: 40,
            color: AppColors.lightOrange,
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 5),
              child: Text(
                car.name,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
          _carNumberPanel(car.number),
        ],
      ),
    );
  }

  Widget _carNumberPanel(String carNumber) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: AppColors.lightGrey.withOpacity(0.2),
          ),
          child: RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 18),
              children: [
                TextSpan(
                  text: carNumber[0],
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                TextSpan(
                  text: carNumber.substring(1, 4),
                ),
                TextSpan(
                  text: carNumber.substring(4, 6),
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                TextSpan(
                  text: carNumber.substring(6, carNumber.length),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  void showError(String errorMessage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
      ),
    );
  }

  @override
  void update() {
    setState(() {});
  }
}