import 'package:car_wash_frontend/car_wash_client/models/car_wash_account.dart';
import 'package:car_wash_frontend/car_wash_client/views/car_wash_menu/change_service_dialog.dart';
import 'package:car_wash_frontend/models/car_type.dart';
import 'package:car_wash_frontend/models/wash_service.dart';
import 'package:car_wash_frontend/views/data_panel.dart';
import 'package:car_wash_frontend/views/marked_text.dart';
import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../views/dropdown_list.dart';

class CarWashMenuPage extends StatefulWidget {
  const CarWashMenuPage({Key? key}) : super(key: key);

  @override
  CarWashMenuPageState createState() {
    return CarWashMenuPageState();
  }
}

class CarWashMenuPageState extends State<CarWashMenuPage> {
  final _account = CarWashAccount();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.dirtyWhite,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_rounded,),
        ),
        actions: [
          IconButton(
            onPressed: () {},
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
            _mainInfoPanel(),
            Padding(
              padding: const EdgeInsets.all(3),
              child: _servicesPanel(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _mainInfoPanel() {
    return IntrinsicHeight(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(3),
            child: _carWashImagePanel(),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(3),
              child: _carWashTitlePanel(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _carWashImagePanel() {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        width: 90,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: const DecorationImage(
            image:  AssetImage("assets/goshan.jpg"),
            fit: BoxFit.fitHeight,
          ),
        ),
      ),
    );
  }

  Widget _carWashTitlePanel() {
    return DataPanel(
      backgroundColor: AppColors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Помойка",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Text(
            "ул. Пушкина 25 64",
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 6,),
          MarkedText(
            text: "89278756682",
            iconData: Icons.call_rounded,
            textStyle: Theme.of(context).textTheme.titleSmall,
          ),
        ],
      ),
    );
  }

  Widget _servicesPanel() {
    return DataPanel(
      backgroundColor: AppColors.black,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(
              "Ваши услуги:",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Container(
            constraints: const BoxConstraints(maxHeight: 550),
            child: SingleChildScrollView(
              child: _servicesList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _servicesList() {
    List<Widget> washServices = [];

    for (final serviceCarsData in _account.servicesData.entries) {
      washServices.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: DropdownList(
            title: _serviceTitlePanel(serviceCarsData.key),
            child: _serviceCarsList(serviceCarsData.key, serviceCarsData.value),
          ),
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: washServices,
    );
  }

  Widget _serviceCarsList(WashService service, Map<CarType, ServiceData?> serviceCarsData) {
    List<Widget> carServicesInfo = [];

    for (final carTypeData in serviceCarsData.entries) {
      carServicesInfo.add(
        _serviceInfoPanel(service, carTypeData.key, carTypeData.value),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: carServicesInfo,
    );
  }

  Widget _serviceInfoPanel(WashService service, CarType carType, ServiceData? serviceData) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 3, right: 6),
          child: Icon(
            carType.carIcon(),
            size: 30,
          ),
        ),
        Expanded(
          child: Text(
            carType.parseToString(),
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        _durationPriceButton(service, carType, serviceData),
      ],
    );
  }

  Widget _durationPriceButtonInside(ServiceData? serviceData) {
    if (serviceData == null) {
      return Text(
        "Добавить",
        style: Theme.of(context).textTheme.titleSmall,
      );
    }
    else {
      return Row(
        children: [
          Text(
            "${serviceData.duration.inMinutes} мин.",
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const VerticalDivider(color: AppColors.grey,),
          Text(
            "${serviceData.price} ₽",
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ],
      );
    }
  }

  Widget _durationPriceButton(WashService service, CarType carType, ServiceData? serviceData) {
    return DataButtonPanel(
      margin: 3,
      backgroundColor: AppColors.lightGrey.withOpacity(0.2),
      height: 35,
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return ChangeServiceDialog(
              startData: serviceData,
              onChanged: (serviceData) {
                if (serviceData == null) {
                  _account.servicesData[service]![carType] = null;
                }
                else {
                  _account.servicesData[service]![carType] = serviceData;
                }
                setState(() {});
              },
            );
          },
        );
      },
      child: _durationPriceButtonInside(serviceData),
    );
  }

  Widget _serviceTitlePanel(WashService service) {
    return Row(
      children: [
        Icon(
          service.getIconData(),
          color: AppColors.lightOrange,
          size: 35,
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(left: 5),
            child: Text(
              service.parseToString(),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ),
      ],
    );
  }
}