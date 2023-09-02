import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../../theme/app_colors.dart';
import '../../models/car.dart';
import '../../../views/data_panel.dart';
import '../../../views/input_panel.dart';

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
      backgroundColor: AppColors.black,
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
    return InputPanel(
      textColor: AppColors.dirtyWhite,
      labelText: "Название",
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
    return InputPanel(
      textColor: AppColors.dirtyWhite,
      labelText: "Номер",
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

  Widget _addCarButton() {
    return Container(
      height: 45,
      margin: const EdgeInsets.all(3),
      child: DataButtonPanel(
        backgroundColor: AppColors.orange,
        splashColor: AppColors.dirtyWhite,
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