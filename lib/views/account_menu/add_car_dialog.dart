import 'package:car_wash_frontend/models/car.dart';
import 'package:car_wash_frontend/views/stateless_views/data_panel.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../theme/app_colors.dart';

class AddCarDialog extends StatefulWidget {
  final Function(Car) onAdded;

  const AddCarDialog({
    Key? key,
    required this.onAdded,
  }) : super(key: key);

  @override
  AddCarDialogState createState() {
    return AddCarDialogState();
  }
}

class AddCarDialogState extends State<AddCarDialog> {
  final _formKey = GlobalKey<FormState>();
  final _carNumberFormatter = MaskTextInputFormatter(
    mask: '#-***-## ***',
    filter: { "#": RegExp(r'[a-z,A-Z]'), "*": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );
  final List<CarType> _carTypes = [
    CarType.passengerCar,
    CarType.truck,
    CarType.motorbike,
  ];
  late Car _buildingCar;

  @override
  void initState() {
    _buildingCar = Car("", "", _carTypes[0]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.grey,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
      ),
      child: Container (
        width: 200,
        padding: const EdgeInsets.all(6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _carTypeCarousel(),
            _carDataForm(),
            _addCarButton(),
          ],
        ),
      ),
    );
  }

  Widget _carDataForm() {
    return Form(
      key: _formKey,
      child:  DataPanel(
        margin: 3,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(3),
              child: _carNameInputPanel(),
            ),
            Padding(
              padding: const EdgeInsets.all(3),
              child: _carNumberInputPanel(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _carNameInputPanel() {
    return TextFormField(
      decoration: _inputDecoration("Название"),
      validator: (String? value){
        if (value == null || value.isEmpty) {
          return 'Введите название машины';
        }
        _buildingCar.name = value;
        return null;
      },
    );
  }

  Widget _carNumberInputPanel() {
    return TextFormField(
      decoration: _inputDecoration("Номер"),
      validator: (String? value){
        if (value == null || value.isEmpty) {
          return 'Введите номер машины';
        }
        if (value.length < 8) {
          return 'Неверно введён номер';
        }
        _buildingCar.number = _carNumberFormatter.getUnmaskedText().toUpperCase();
        return null;
      },
      inputFormatters: [_carNumberFormatter],
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
      labelStyle: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColors.lightOrange),
      floatingLabelStyle: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColors.orange),
    );
  }

  Widget _addCarButton() {
    return Container(
      height: 45,
      margin: const EdgeInsets.all(3),
      child: DataButtonPanel(
        backgroundColor: AppColors.lightOrange,
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            widget.onAdded(_buildingCar);
            Navigator.pop(context);
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Добавить",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.dirtyWhite),
            ),
            const SizedBox(width: 10,),
            const Icon(
              Icons.done_rounded,
              color: AppColors.dirtyWhite,
              size: 30,
            ),
          ],
        ),
      ),
    );
  }

  Widget _carTypeCarousel() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CarouselSlider.builder(
          itemCount: _carTypes.length,
          options: CarouselOptions(
            height: 90,
            enlargeCenterPage: true,
            viewportFraction: 0.37,
            enlargeFactor: 0.55,
            onPageChanged: (index, reason) {
              _buildingCar.type = _carTypes[index];
              setState(() {});
            },
          ),
          itemBuilder: (context, index, a) {
            return Icon(
              _carTypes[index].carIcon(),
              size: 100,
              color: AppColors.lightOrange,
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 3),
          child: Text(
            _buildingCar.type.parseToString(),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.dirtyWhite),
          ),
        ),
      ],
    );
  }
}