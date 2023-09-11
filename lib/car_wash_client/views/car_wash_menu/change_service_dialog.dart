import 'package:car_wash_frontend/car_wash_client/models/car_wash_account.dart';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';

import '../../../theme/app_colors.dart';
import '../../../views/data_panel.dart';
import '../../../views/input_panel.dart';

class ChangeServiceDialog extends StatefulWidget {
  final Function(ServiceData?) onChanged;
  final ServiceData? startData;

  const ChangeServiceDialog({
    Key? key,
    required this.startData,
    required this.onChanged,
  }) : super(key: key);

  @override
  ChangeServiceDialogState createState() {
    return ChangeServiceDialogState();
  }
}

class ChangeServiceDialogState extends State<ChangeServiceDialog> {
  final _formKey = GlobalKey<FormState>();
  double? _price;
  int? _duration;

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
            _serviceDataForm(),
          ],
        ),
      ),
    );
  }

  Widget _serviceDataForm() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(3),
            child: _servicePrice(),
          ),
          Padding(
            padding: const EdgeInsets.all(3),
            child: _serviceDuration(),
          ),
          Row(
            children: [
              Expanded(
                flex: widget.startData != null ? 1 : 0,
                child: widget.startData != null ? _deleteServiceButton() : Container(),
              ),
              Expanded(
                flex: 1,
                child: _changeDataButton(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _changeDataButton() {
    return DataButtonPanel(
      margin: 3,
      height: 45,
      splashColor: AppColors.dirtyWhite,
      backgroundColor: AppColors.orange,
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          widget.onChanged(ServiceData(Duration(minutes: _duration!), _price!));
          Navigator.pop(context);
        }
      },
      child: Align(
        alignment: Alignment.center,
        child: Text(
          widget.startData != null ? "Изменить" : "Добавить услугу",
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }

  Widget _deleteServiceButton() {
    return DataButtonPanel(
      margin: 3,
      height: 45,
      splashColor: AppColors.darkRed,
      borderColor: AppColors.darkRed,
      backgroundColor: AppColors.grey,
      onPressed: () {
        widget.onChanged(null);
        Navigator.pop(context);
      },
      child: Align(
        alignment: Alignment.center,
        child: Text(
          "Удалить",
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }

  Widget _servicePrice() {
    return Row(
      children: [
        Expanded(
          child: InputPanel(
            textColor: AppColors.dirtyWhite,
            hintText: widget.startData == null
                ? "Цена услуги"
                : "${widget.startData!.price} ₽",
            keyboardType: TextInputType.number,
            validator: (String? value){
              if (value == null || value.isEmpty) {
                return 'Введите цену';
              }
              _price = double.parse(value);
              return null;
            },
          ),
        ),
        const SizedBox(width: 8,),
        const Icon(
          Icons.currency_ruble_rounded,
          size: 30,
          color: AppColors.lightOrange,
        ),
      ],
    );
  }

  Widget _serviceDuration() {
    return Row(
      children: [
        Expanded(
          child: InputPanel(
            textColor: AppColors.dirtyWhite,
            hintText: widget.startData == null
                ? "Время в минутах"
                : "${widget.startData!.duration.inMinutes} мин.",
            keyboardType: TextInputType.number,
            validator: (String? value){
              if (value == null || value.isEmpty) {
                return 'Введите время';
              }
              _duration = int.parse(value);
              return null;
            },
          ),
        ),
        const SizedBox(width: 8,),
        const Icon(
          Icons.schedule_rounded,
          size: 30,
          color: AppColors.lightOrange,
        ),
      ],
    );
  }
}