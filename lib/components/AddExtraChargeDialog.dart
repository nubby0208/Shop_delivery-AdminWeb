import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:local_delivery_admin/main.dart';
import 'package:local_delivery_admin/models/CityListModel.dart';
import 'package:local_delivery_admin/models/ExtraChragesListModel.dart';
import 'package:local_delivery_admin/network/RestApis.dart';
import 'package:local_delivery_admin/utils/Colors.dart';
import 'package:local_delivery_admin/utils/Common.dart';
import 'package:local_delivery_admin/utils/Constants.dart';
import 'package:local_delivery_admin/utils/Extensions/app_common.dart';
import 'package:local_delivery_admin/utils/Extensions/app_textfield.dart';

import '../utils/CommonApiCall.dart';

class AddExtraChargeDialog extends StatefulWidget {
  static String tag = '/AddExtraChargeDialog';
  final ExtraChargesData? extraChargesData;
  final Function()? onUpdate;

  AddExtraChargeDialog({this.extraChargesData, this.onUpdate});

  @override
  AddExtraChargeDialogState createState() => AddExtraChargeDialogState();
}

class AddExtraChargeDialogState extends State<AddExtraChargeDialog> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController titleController = TextEditingController();
  TextEditingController chargeController = TextEditingController();

  List<CityData> cityList = [];

  int? selectedCountryId;
  int? selectedCityId;
  String? chargeTypeValue;

  bool isUpdate = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    afterBuildCreated(() {
      appStore.setLoading(true);
    });
    await getAllCountryApiCall();
    await getCityListApiCall();
    isUpdate = widget.extraChargesData != null;
    if (isUpdate) {
      titleController.text = widget.extraChargesData!.title!;
      chargeController.text = widget.extraChargesData!.charges!.toString();
      appStore.countryList.forEach((element) {
        if(element.id == widget.extraChargesData!.countryId!){
          selectedCountryId = widget.extraChargesData!.countryId!;
        }
      });
      cityList.forEach((element) {
        if(element.id == widget.extraChargesData!.cityId!){
          selectedCityId = widget.extraChargesData!.cityId!;
        }
      });
      chargeTypeValue = widget.extraChargesData!.chargesType!;
    }
    appStore.setLoading(false);
    //setState(() { });
  }

  getCityListApiCall() async {
    appStore.setLoading(true);
    await getCityList(countryId: selectedCountryId).then((value) {
      appStore.setLoading(false);
      cityList.clear();
      cityList.addAll(value.data!);
      setState(() {});
    }).catchError((error) {
      appStore.setLoading(false);
      toast(error.toString());
    });
  }

  AddExtraChargeApiCall() async {
    if (_formKey.currentState!.validate()) {
      if (chargeTypeValue == null) return toast(language.please_select_charge_type);
      Navigator.pop(context);
      Map req = {
        "id": isUpdate ? widget.extraChargesData!.id : "",
        "title": titleController.text,
        "charges_type": chargeTypeValue,
        "charges": chargeController.text,
        "country_id": selectedCountryId,
        "city_id": selectedCityId,
      };
      appStore.setLoading(true);
      await addExtraCharge(req).then((value) {
        appStore.setLoading(false);
        toast(value.message.toString());
        widget.onUpdate!.call();
      }).catchError((error) {
        appStore.setLoading(false);
        toast(error.toString());
      });
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsPadding: EdgeInsets.only(right: 16, bottom: 16),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(isUpdate ? language.update_extra_charge : language.add_extra_charge, style: boldTextStyle(color: primaryColor, size: 20)),
          IconButton(
            icon: Icon(Icons.close),
            padding: EdgeInsets.zero,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      content: Observer(builder: (context) {
        return SingleChildScrollView(
          child: Stack(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(language.country, style: primaryTextStyle()),
                              SizedBox(height: 8),
                              DropdownButtonFormField<int>(
                                value: selectedCountryId,
                                dropdownColor: Theme.of(context).cardColor,
                                decoration: commonInputDecoration(),
                                items: appStore.countryList.map<DropdownMenuItem<int>>((item) {
                                  return DropdownMenuItem(
                                    value: item.id,
                                    child: Text(item.name!, style: primaryTextStyle()),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  selectedCountryId = value;
                                  getCityListApiCall();
                                  selectedCityId = null;
                                },
                                validator: (s) {
                                  if (selectedCountryId == null) return language.field_required_msg;
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(language.city, style: primaryTextStyle()),
                              SizedBox(height: 8),
                              DropdownButtonFormField<int>(
                                value: selectedCityId,
                                dropdownColor: Theme.of(context).cardColor,
                                decoration: commonInputDecoration(),
                                items: cityList.map<DropdownMenuItem<int>>((item) {
                                  return DropdownMenuItem(
                                    value: item.id,
                                    child: Text(item.name!, style: primaryTextStyle()),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  selectedCityId = value;
                                  setState(() {});
                                },
                                validator: (s) {
                                  if (selectedCityId == null) return language.field_required_msg;
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(language.title, style: primaryTextStyle()),
                              SizedBox(height: 8),
                              AppTextField(
                                controller: titleController,
                                textFieldType: TextFieldType.OTHER,
                                decoration: commonInputDecoration(),
                                textInputAction: TextInputAction.next,
                                validator: (s) {
                                  if (s!.trim().isEmpty) return language.field_required_msg;
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(language.charge, style: primaryTextStyle()),
                              SizedBox(height: 8),
                              AppTextField(
                                controller: chargeController,
                                textFieldType: TextFieldType.OTHER,
                                decoration: commonInputDecoration(),
                                textInputAction: TextInputAction.next,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp('[0-9 .]')),
                                ],
                                validator: (s) {
                                  if (s!.trim().isEmpty) return language.field_required_msg;
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text(language.charge_type, style: primaryTextStyle()),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        SizedBox(
                          width: 150,
                          child: RadioListTile<String>(
                            value: CHARGE_TYPE_FIXED,
                            title: Text(CHARGE_TYPE_FIXED, style: primaryTextStyle()),
                            groupValue: chargeTypeValue,
                            onChanged: (value) {
                              chargeTypeValue = value;
                              setState(() {});
                            },
                          ),
                        ),
                        SizedBox(width: 16),
                        SizedBox(
                          width: 200,
                          child: RadioListTile<String>(
                            value: CHARGE_TYPE_PERCENTAGE,
                            title: Text(CHARGE_TYPE_PERCENTAGE, style: primaryTextStyle()),
                            groupValue: chargeTypeValue,
                            onChanged: (value) {
                              chargeTypeValue = value;
                              setState(() {});
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Visibility(visible: appStore.isLoading, child: loaderWidget()),
            ],
          ),
        );
      }),
      actions: <Widget>[
        dialogSecondaryButton(language.cancel, () {
          Navigator.pop(context);
        }),
        SizedBox(width: 4),
        dialogPrimaryButton(isUpdate ? language.update : language.add, () {
          if (shared_pref.getString(USER_TYPE) == DEMO_ADMIN) {
            toast(language.demo_admin_msg);
          } else {
            AddExtraChargeApiCall();
          }
        }),
      ],
    );
  }
}
