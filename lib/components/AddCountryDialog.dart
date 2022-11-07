import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:local_delivery_admin/models/CountryListModel.dart';
import 'package:local_delivery_admin/network/RestApis.dart';
import 'package:local_delivery_admin/utils/Colors.dart';
import 'package:local_delivery_admin/utils/Common.dart';
import 'package:local_delivery_admin/utils/Constants.dart';
import 'package:local_delivery_admin/utils/Extensions/app_common.dart';
import 'package:local_delivery_admin/utils/country_list.dart';

import '../main.dart';

class AddCountryDialog extends StatefulWidget {
  static String tag = '/AddCountryDialog';
  final CountryData? countryData;
  final Function()? onUpdate;

  AddCountryDialog({this.countryData, this.onUpdate});

  @override
  AddCountryDialogState createState() => AddCountryDialogState();
}

class AddCountryDialogState extends State<AddCountryDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<String> distanceTypeList = ['km', 'miles'];
  List<String> weightTypeList = ['kg', 'pound'];
  String? selectedDistanceType;
  String? selectedWeightType;
  bool isUpdate = false;

  CountryCode? countryCode = CountryCode.fromJson(country_list.first);

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    isUpdate = widget.countryData != null;
    if (isUpdate) {
      country_list.forEach((element) {
        if (CountryCode.fromJson(element).code == widget.countryData!.code) {
          countryCode = CountryCode.fromJson(element);
        }
      });
      if (distanceTypeList.contains(widget.countryData!.distanceType)) {
        selectedDistanceType = widget.countryData!.distanceType;
      }
      if (weightTypeList.contains(widget.countryData!.weightType)) {
        selectedWeightType = widget.countryData!.weightType;
      }
    }
  }

  AddCountryApiCall() async {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context);
      Map req = {
        "id": isUpdate ? widget.countryData!.id : "",
        "name": countryCode!.name,
        "distance_type": selectedDistanceType ?? "",
        "weight_type": selectedWeightType ?? "",
        "code": countryCode!.code,
      };
      appStore.setLoading(true);
      await addCountry(req).then((value) {
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
          Text(isUpdate ? language.update_country : language.add_country, style: boldTextStyle(color: primaryColor, size: 20)),
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
        return Stack(
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(language.country_name, style: primaryTextStyle()),
                  SizedBox(height: 8),
                  Container(
                    alignment: Alignment.topLeft,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(defaultRadius),
                    ),
                    child: CountryCodePicker(
                      initialSelection: countryCode!.code,
                      showCountryOnly: true,
                      showFlag: true,
                      showFlagDialog: true,
                      showOnlyCountryWhenClosed: true,
                      countryList: country_list,
                      showDropDownButton: true,
                      alignLeft: false,
                      backgroundColor: Colors.grey.withOpacity(0.15),
                      textStyle: primaryTextStyle(),
                      dialogBackgroundColor: Theme.of(context).cardColor,
                      barrierColor: Colors.black12,
                      dialogTextStyle: primaryTextStyle(),
                      searchDecoration: InputDecoration(
                        iconColor: Theme.of(context).dividerColor,
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).dividerColor)),
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: primaryColor)),
                      ),
                      searchStyle: primaryTextStyle(),
                      onChanged: (c) {
                        countryCode = c;
                      },
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(language.distance_type, style: primaryTextStyle()),
                            SizedBox(height: 8),
                            DropdownButtonFormField<String>(
                              dropdownColor: Theme.of(context).cardColor,
                              value: selectedDistanceType,
                              decoration: commonInputDecoration(),
                              items: distanceTypeList.map<DropdownMenuItem<String>>((item) {
                                return DropdownMenuItem(
                                  value: item,
                                  child: Text(item, style: primaryTextStyle()),
                                );
                              }).toList(),
                              onChanged: (value) {
                                selectedDistanceType = value;
                                setState(() {});
                              },
                              validator: (s) {
                                if (selectedDistanceType == null) return language.field_required_msg;
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
                            Text(language.weight_type, style: primaryTextStyle()),
                            SizedBox(height: 8),
                            DropdownButtonFormField<String>(
                              dropdownColor: Theme.of(context).cardColor,
                              value: selectedWeightType,
                              decoration: commonInputDecoration(),
                              items: weightTypeList.map<DropdownMenuItem<String>>((item) {
                                return DropdownMenuItem(
                                  value: item,
                                  child: Text(item, style: primaryTextStyle()),
                                );
                              }).toList(),
                              onChanged: (value) {
                                selectedWeightType = value;
                                setState(() {});
                              },
                              validator: (s) {
                                if (selectedWeightType == null) return language.field_required_msg;
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Visibility(visible: appStore.isLoading, child: Positioned.fill(child: loaderWidget())),
          ],
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
            AddCountryApiCall();
          }
        }),
      ],
    );
  }
}
