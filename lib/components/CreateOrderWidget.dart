import 'package:country_code_picker/country_code_picker.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:local_delivery_admin/models/AutoCompletePlacesListModel.dart';
import 'package:local_delivery_admin/models/CountryListModel.dart';
import 'package:local_delivery_admin/utils/Constants.dart';
import 'package:local_delivery_admin/utils/Extensions/StringExtensions.dart';
import '../main.dart';
import '../models/CityListModel.dart';
import '../models/ExtraChargeRequestModel.dart';
import '../models/ParcelTypeListModel.dart';
import '../models/PlaceIdDetailModel.dart';
import '../network/RestApis.dart';
import '../utils/Colors.dart';
import '../utils/Common.dart';
import '../utils/Extensions/app_common.dart';
import '../utils/Extensions/app_textfield.dart';
import 'CreateOrderConfirmationDialog.dart';

class CreateOrderWidget extends StatefulWidget {
  @override
  CreateOrderWidgetState createState() => CreateOrderWidgetState();
}

class CreateOrderWidgetState extends State<CreateOrderWidget> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isDeliverNow = true;
  String paymentCollectFrom = PAYMENT_ON_PICKUP;

  List<ParcelTypeData> parcelTypeList = [];

  TextEditingController parcelTypeCont = TextEditingController();
  TextEditingController weightController = TextEditingController(text: '1');
  TextEditingController totalParcelController = TextEditingController(text: '1');

  TextEditingController pickAddressCont = TextEditingController();
  TextEditingController pickPhoneCont = TextEditingController();
  TextEditingController pickDesCont = TextEditingController();
  TextEditingController pickDateController = TextEditingController();
  TextEditingController pickFromTimeController = TextEditingController();
  TextEditingController pickToTimeController = TextEditingController();

  TextEditingController deliverAddressCont = TextEditingController();
  TextEditingController deliverPhoneCont = TextEditingController();
  TextEditingController deliverDesCont = TextEditingController();
  TextEditingController deliverDateController = TextEditingController();
  TextEditingController deliverFromTimeController = TextEditingController();
  TextEditingController deliverToTimeController = TextEditingController();

  String deliverCountryCode = '+91';
  String pickupCountryCode = '+91';

  DateTime? pickFromDateTime, pickToDateTime, deliverFromDateTime, deliverToDateTime;
  DateTime? pickDate, deliverDate;
  TimeOfDay? pickFromTime, pickToTime, deliverFromTime, deliverToTime;

  String? pickLat, pickLong, deliverLat, deliverLong;

  num totalDistance = 0;
  num totalAmount = 0;

  num weightCharge = 0;
  num distanceCharge = 0;
  num totalExtraCharge = 0;

  List<ExtraChargeRequestModel> extraChargeList = [];

  int? selectedCountry;
  int? selectedCity;

  CityData? cityData;

  List<CountryData> countryList = [];
  List<CityData> cityList = [];

  List<Predictions> pickPredictionList = [];
  List<Predictions> deliverPredictionList = [];

  String? pickMsg, deliverMsg;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    await getParcelTypeListApiCall();
    await getCountryApiCall();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  getParcelTypeListApiCall() async {
    appStore.setLoading(true);
    await getParcelTypeList().then((value) {
      appStore.setLoading(false);
      parcelTypeList.clear();
      parcelTypeList.addAll(value.data!);
      setState(() {});
    }).catchError((error) {
      appStore.setLoading(false);
      toast(error.toString());
    });
  }

  getCountryApiCall() async {
    appStore.setLoading(true);
    await getCountryList().then((value) {
      appStore.setLoading(false);
      countryList = value.data!;
      selectedCountry = countryList[0].id!;
      getCityApiCall();
      setState(() {});
    }).catchError((error) {
      appStore.setLoading(false);
      log(error);
    });
  }

  getCityApiCall({String? name}) async {
    appStore.setLoading(true);
    await getCityList(countryId: selectedCountry!).then((value) {
      appStore.setLoading(false);
      cityList.clear();
      cityList.addAll(value.data!);
      setState(() {});
    }).catchError((error) {
      appStore.setLoading(false);
      log(error);
    });
  }

  getCityDetailApiCall() async {
    await getCityDetail(selectedCity ?? 0).then((value) async {
      cityData = value;
      setState(() {});
    }).catchError((error) {});
  }

  String getCountryCode() {
    String countryCode = countryList[0].code!;
    countryList.forEach((element) {
      if (element.id == selectedCountry) {
        countryCode = element.code!;
      }
    });
    return countryCode;
  }

  getTotalAmount() {
    totalDistance = calculateDistance(double.tryParse(pickLat!), double.tryParse(pickLong!), double.tryParse(deliverLat!), double.tryParse(deliverLong!));
    totalAmount = 0;
    weightCharge = 0;
    distanceCharge = 0;
    totalExtraCharge = 0;

    /// calculate weight Charge
    if (double.tryParse(weightController.text)! > cityData!.minWeight!) {
      weightCharge = double.parse(((double.tryParse(weightController.text)! - cityData!.minWeight!) * cityData!.perWeightCharges!).toStringAsFixed(2));
    }

    /// calculate distance Charge
    if (totalDistance > cityData!.minDistance!) {
      distanceCharge = double.parse(((totalDistance - cityData!.minDistance!) * cityData!.perDistanceCharges!).toStringAsFixed(2));
    }

    /// total amount
    totalAmount = cityData!.fixedCharges! + weightCharge + distanceCharge;

    /// calculate extra charges
    cityData!.extraCharges!.forEach((element) {
      totalExtraCharge += countExtraCharge(totalAmount: totalAmount, charges: element.charges!, chargesType: element.chargesType!);
    });

    /// All Charges
    totalAmount = double.parse((totalAmount + totalExtraCharge).toStringAsFixed(2));
  }

  extraChargesList() {
    extraChargeList.clear();
    extraChargeList.add(ExtraChargeRequestModel(key: FIXED_CHARGES, value: cityData!.fixedCharges, valueType: ""));
    extraChargeList.add(ExtraChargeRequestModel(key: MIN_DISTANCE, value: cityData!.minDistance, valueType: ""));
    extraChargeList.add(ExtraChargeRequestModel(key: MIN_WEIGHT, value: cityData!.minWeight, valueType: ""));
    extraChargeList.add(ExtraChargeRequestModel(key: PER_DISTANCE_CHARGE, value: cityData!.perDistanceCharges, valueType: ""));
    extraChargeList.add(ExtraChargeRequestModel(key: PER_WEIGHT_CHARGE, value: cityData!.perWeightCharges, valueType: ""));
    cityData!.extraCharges!.forEach((element) {
      extraChargeList.add(ExtraChargeRequestModel(key: element.title!.toLowerCase().replaceAll(' ', "_"), value: element.charges, valueType: element.chargesType));
    });
  }

  createOrderApiCall(String orderStatus) async {
    Map req = {
      "id": "",
      "client_id": shared_pref.getInt(USER_ID).toString(),
      "date": DateTime.now().toString(),
      "country_id": selectedCountry.toString(),
      "city_id": selectedCity.toString(),
      "pickup_point": {
        "start_time": !isDeliverNow ? pickFromDateTime.toString() : DateTime.now().toString(),
        "end_time": !isDeliverNow ? pickToDateTime.toString() : null,
        "address": pickAddressCont.text,
        "latitude": pickLat,
        "longitude": pickLong,
        "description": pickDesCont.text,
        "contact_number": '$pickupCountryCode ${pickPhoneCont.text.trim()}'
      },
      "delivery_point": {
        "start_time": !isDeliverNow ? deliverFromDateTime.toString() : null,
        "end_time": !isDeliverNow ? deliverToDateTime.toString() : null,
        "address": deliverAddressCont.text,
        "latitude": deliverLat,
        "longitude": deliverLong,
        "description": deliverDesCont.text,
        "contact_number": '$deliverCountryCode ${deliverPhoneCont.text.trim()}',
      },
      "extra_charges": extraChargeList,
      "parcel_type": parcelTypeCont.text,
      "total_weight": double.tryParse(weightController.text),
      "total_distance": totalDistance.toStringAsFixed(2),
      "payment_collect_from": paymentCollectFrom,
      "status": orderStatus,
      "payment_type": PAYMENT_TYPE_CASH,
      "payment_status": "",
      "fixed_charges": cityData!.fixedCharges.toString(),
      "parent_order_id": "",
      "total_amount": totalAmount,
      "weight_charge": weightCharge,
      "distance_charge": distanceCharge,
      "total_parcel": int.tryParse(totalParcelController.text),
    };
    appStore.setLoading(true);
    await createOrder(req).then((value) {
      appStore.setLoading(false);
      toast(value.message);
      appStore.setSelectedMenuIndex(ORDER_INDEX);
    }).catchError((error) {
      appStore.setLoading(false);
      toast(error.toString());
    });
  }

  Future<List<Predictions>> getPlaceAutoCompleteApiCall(String text) async {
    List<Predictions> list = [];
    await placeAutoCompleteApi(searchText: text, language: appStore.selectedLanguage, countryCode: getCountryCode()).then((value) {
      list = value.predictions ?? [];
    }).catchError((e) {
      throw e.toString();
    });
    return list;
  }

  Future<PlaceIdDetailModel?> getPlaceIdDetailApiCall({required String placeId}) async {
    PlaceIdDetailModel? detailModel;
    await getPlaceDetail(placeId: placeId).then((value) {
      detailModel = value;
    }).catchError((e) {
      throw e.toString();
    });
    return detailModel;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          padding: EdgeInsets.only(left: 16, top: 16, right: 16, bottom: 100),
          controller: ScrollController(),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(language.crete_order, style: boldTextStyle(size: 20, color: primaryColor)),
                    GestureDetector(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(defaultRadius)),
                        child: Text(language.save, style: boldTextStyle(color: Colors.white)),
                      ),
                      onTap: () async {
                        pickMsg = '';
                        deliverMsg = '';
                        setState(() {});
                        if (_formKey.currentState!.validate()) {
                          Duration difference = Duration();
                          Duration differenceCurrentTime = Duration();
                          if (!isDeliverNow) {
                            pickFromDateTime = pickDate!.add(Duration(hours: pickFromTime!.hour, minutes: pickFromTime!.minute));
                            pickToDateTime = pickDate!.add(Duration(hours: pickToTime!.hour, minutes: pickToTime!.minute));
                            deliverFromDateTime = deliverDate!.add(Duration(hours: deliverFromTime!.hour, minutes: deliverFromTime!.minute));
                            deliverToDateTime = deliverDate!.add(Duration(hours: deliverToTime!.hour, minutes: deliverToTime!.minute));
                            difference = pickFromDateTime!.difference(deliverFromDateTime!);
                            differenceCurrentTime = DateTime.now().difference(pickFromDateTime!);
                          }
                          if (differenceCurrentTime.inMinutes > 0) return toast(language.pickup_current_validation_msg);
                          if (difference.inMinutes > 0) return toast(language.pickup_deliver_validation_msg);
                          extraChargesList();
                          getTotalAmount();
                          showDialog(
                              context: context,
                              builder: (context) => CreateOrderConfirmationDialog(
                                  extraChargesList: extraChargeList,
                                  totalDistance: totalDistance,
                                  totalWeight: double.parse(weightController.text),
                                  distanceCharge: distanceCharge,
                                  weightCharge: weightCharge,
                                  totalAmount: totalAmount,
                                  onAccept: () async {
                                    await createOrderApiCall(ORDER_CREATE);
                                  }));
                        }
                      },
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    scheduleOptionWidget(
                        context: context,
                        isSelected: isDeliverNow,
                        imagePath: 'assets/icons/ic_clock.png',
                        title: language.deliver_now,
                        onTap: () {
                          isDeliverNow = true;
                          setState(() {});
                        }),
                    SizedBox(width: 16),
                    scheduleOptionWidget(
                        context: context,
                        isSelected: !isDeliverNow,
                        imagePath: 'assets/icons/ic_schedule.png',
                        title: language.schedule,
                        onTap: () {
                          isDeliverNow = false;
                          setState(() {});
                        }),
                  ],
                ),
                if (!isDeliverNow)
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(language.pick_time, style: boldTextStyle()),
                              SizedBox(height: 16),
                              Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Theme.of(context).dividerColor),
                                  borderRadius: BorderRadius.circular(defaultRadius),
                                ),
                                child: Column(
                                  children: [
                                    DateTimePicker(
                                      controller: pickDateController,
                                      type: DateTimePickerType.date,
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime(2050),
                                      onChanged: (value) {
                                        pickDate = DateTime.parse(value);
                                        deliverDate = null;
                                        deliverDateController.clear();
                                        setState(() {});
                                      },
                                      validator: (value) {
                                        if (value!.isEmpty) return errorThisFieldRequired;
                                        return null;
                                      },
                                      decoration: commonInputDecoration(suffixIcon: Icons.calendar_today, hintText: "Date"),
                                    ),
                                    SizedBox(height: 16),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: DateTimePicker(
                                            controller: pickFromTimeController,
                                            type: DateTimePickerType.time,
                                            onChanged: (value) {
                                              pickFromTime = TimeOfDay.fromDateTime(DateFormat('hh:mm').parse(value));
                                              setState(() {});
                                            },
                                            validator: (value) {
                                              if (value!.isEmpty) return errorThisFieldRequired;
                                              return null;
                                            },
                                            decoration: commonInputDecoration(suffixIcon: Icons.access_time, hintText: language.from),
                                          ),
                                        ),
                                        SizedBox(width: 16),
                                        Expanded(
                                          child: DateTimePicker(
                                            controller: pickToTimeController,
                                            type: DateTimePickerType.time,
                                            onChanged: (value) {
                                              pickToTime = TimeOfDay.fromDateTime(DateFormat('hh:mm').parse(value));
                                              setState(() {});
                                            },
                                            validator: (value) {
                                              if (value!.isEmpty) return errorThisFieldRequired;
                                              double fromTimeInHour = pickFromTime!.hour + pickFromTime!.minute / 60;
                                              double toTimeInHour = pickToTime!.hour + pickToTime!.minute / 60;
                                              double difference = toTimeInHour - fromTimeInHour;
                                              if (difference <= 0) {
                                                return language.end_start_time_validation_msg;
                                              }
                                              return null;
                                            },
                                            decoration: commonInputDecoration(suffixIcon: Icons.access_time, hintText: language.to),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(language.deliver_time, style: boldTextStyle()),
                              SizedBox(height: 16),
                              Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Theme.of(context).dividerColor),
                                  borderRadius: BorderRadius.circular(defaultRadius),
                                ),
                                child: Column(
                                  children: [
                                    DateTimePicker(
                                      controller: deliverDateController,
                                      type: DateTimePickerType.date,
                                      initialDate: pickDate ?? DateTime.now(),
                                      firstDate: pickDate ?? DateTime.now(),
                                      lastDate: DateTime(2050),
                                      onChanged: (value) {
                                        deliverDate = DateTime.parse(value);
                                        setState(() {});
                                      },
                                      validator: (value) {
                                        if (value!.isEmpty) return errorThisFieldRequired;
                                        return null;
                                      },
                                      decoration: commonInputDecoration(suffixIcon: Icons.calendar_today, hintText: language.date),
                                    ),
                                    SizedBox(height: 16),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: DateTimePicker(
                                            controller: deliverFromTimeController,
                                            type: DateTimePickerType.time,
                                            onChanged: (value) {
                                              deliverFromTime = TimeOfDay.fromDateTime(DateFormat('hh:mm').parse(value));
                                              setState(() {});
                                            },
                                            validator: (value) {
                                              if (value!.isEmpty) return errorThisFieldRequired;
                                              return null;
                                            },
                                            decoration: commonInputDecoration(suffixIcon: Icons.access_time, hintText: language.from),
                                          ),
                                        ),
                                        SizedBox(width: 16),
                                        Expanded(
                                          child: DateTimePicker(
                                            controller: deliverToTimeController,
                                            type: DateTimePickerType.time,
                                            onChanged: (value) {
                                              deliverToTime = TimeOfDay.fromDateTime(DateFormat('hh:mm').parse(value));
                                              setState(() {});
                                            },
                                            validator: (value) {
                                              if (value!.isEmpty) return errorThisFieldRequired;
                                              double fromTimeInHour = deliverFromTime!.hour + deliverFromTime!.minute / 60;
                                              double toTimeInHour = deliverToTime!.hour + deliverToTime!.minute / 60;
                                              double difference = toTimeInHour - fromTimeInHour;
                                              if (difference < 0) {
                                                return language.end_start_time_validation_msg;
                                              }
                                              return null;
                                            },
                                            decoration: commonInputDecoration(suffixIcon: Icons.access_time, hintText: language.to),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.30,
                      decoration: BoxDecoration(border: Border.all(color: Theme.of(context).dividerColor), borderRadius: BorderRadius.circular(defaultRadius)),
                      child: IntrinsicHeight(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Text(language.weight, style: primaryTextStyle()),
                              ),
                            ),
                            VerticalDivider(thickness: 1),
                            GestureDetector(
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Icon(Icons.remove, color: appStore.isDarkMode ? Colors.white : Colors.grey),
                              ),
                              onTap: () {
                                if (double.parse(weightController.text) > 1) {
                                  weightController.text = (double.parse(weightController.text) - 1).toString();
                                }
                              },
                            ),
                            VerticalDivider(thickness: 1),
                            Container(
                              width: 50,
                              child: AppTextField(
                                controller: weightController,
                                textAlign: TextAlign.center,
                                maxLength: 5,
                                textFieldType: TextFieldType.PHONE,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp('[0-9 .]')),
                                ],
                                decoration: InputDecoration(
                                  counterText: '',
                                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: primaryColor)),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            VerticalDivider(thickness: 1),
                            GestureDetector(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Icon(Icons.add, color: appStore.isDarkMode ? Colors.white : Colors.grey),
                              ),
                              onTap: () {
                                weightController.text = (double.parse(weightController.text) + 1).toString();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.30,
                      decoration: BoxDecoration(border: Border.all(color: Theme.of(context).dividerColor), borderRadius: BorderRadius.circular(defaultRadius)),
                      child: IntrinsicHeight(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Text(language.number_of_parcels, style: primaryTextStyle()),
                              ),
                            ),
                            VerticalDivider(thickness: 1),
                            GestureDetector(
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Icon(Icons.remove, color: appStore.isDarkMode ? Colors.white : Colors.grey),
                              ),
                              onTap: () {
                                if (int.parse(totalParcelController.text) > 1) {
                                  totalParcelController.text = (int.parse(totalParcelController.text) - 1).toString();
                                }
                              },
                            ),
                            VerticalDivider(thickness: 1),
                            Container(
                              width: 50,
                              child: AppTextField(
                                controller: totalParcelController,
                                textAlign: TextAlign.center,
                                maxLength: 2,
                                textFieldType: TextFieldType.PHONE,
                                decoration: InputDecoration(
                                  counterText: '',
                                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: primaryColor)),
                                  border: InputBorder.none,
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                              ),
                            ),
                            VerticalDivider(thickness: 1),
                            GestureDetector(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Icon(Icons.add, color: appStore.isDarkMode ? Colors.white : Colors.grey),
                              ),
                              onTap: () {
                                totalParcelController.text = (int.parse(totalParcelController.text) + 1).toString();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Text(language.parcel_type, style: boldTextStyle()),
                SizedBox(height: 8),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.40,
                  child: AppTextField(
                    controller: parcelTypeCont,
                    textFieldType: TextFieldType.OTHER,
                    decoration: commonInputDecoration(),
                    validator: (value) {
                      if (value!.isEmpty) return errorThisFieldRequired;
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 0,
                  children: parcelTypeList.map((item) {
                    return GestureDetector(
                      child: Chip(
                        backgroundColor: Theme.of(context).cardColor,
                        label: Text(item.label!),
                        elevation: 0,
                        labelStyle: primaryTextStyle(color: Colors.grey),
                        padding: EdgeInsets.zero,
                        labelPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(defaultRadius),
                          side: BorderSide(color: Theme.of(context).dividerColor),
                        ),
                      ),
                      onTap: () {
                        parcelTypeCont.text = item.label!;
                        setState(() {});
                      },
                    );
                  }).toList(),
                ),
                SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(language.country, style: boldTextStyle()),
                          SizedBox(height: 8),
                          DropdownButtonFormField<int>(
                            value: selectedCountry,
                            decoration: commonInputDecoration(),
                            dropdownColor: Theme.of(context).cardColor,
                            style: primaryTextStyle(),
                            items: countryList.map<DropdownMenuItem<int>>((item) {
                              return DropdownMenuItem(
                                value: item.id,
                                child: Text(item.name ?? ''),
                              );
                            }).toList(),
                            onChanged: (value) {
                              selectedCountry = value!;
                              selectedCity = null;
                              cityData = null;
                              pickAddressCont.clear();
                              pickLat = null;
                              pickLong = null;
                              deliverAddressCont.clear();
                              deliverLat = null;
                              deliverLong = null;
                              pickPredictionList = [];
                              deliverPredictionList = [];
                              getCityApiCall();
                              setState(() {});
                            },
                            validator: (value) {
                              if (selectedCountry == null) return errorThisFieldRequired;
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
                        Text(language.city, style: boldTextStyle()),
                        SizedBox(height: 8),
                        DropdownButtonFormField<int>(
                          value: selectedCity,
                          decoration: commonInputDecoration(),
                          dropdownColor: Theme.of(context).cardColor,
                          style: primaryTextStyle(),
                          items: cityList.map<DropdownMenuItem<int>>((item) {
                            return DropdownMenuItem(
                              value: item.id,
                              child: Text(item.name ?? ''),
                            );
                          }).toList(),
                          onChanged: (value) {
                            selectedCity = value!;
                            getCityDetailApiCall();
                            setState(() {});
                          },
                          validator: (value) {
                            if (selectedCity == null) return errorThisFieldRequired;
                            return null;
                          },
                        ),
                      ],
                    )),
                    SizedBox(width: 16),
                    Spacer(),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(language.pickup_info, style: boldTextStyle()),
                          SizedBox(height: 8),
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Theme.of(context).dividerColor),
                              borderRadius: BorderRadius.circular(defaultRadius),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(language.pickup_location, style: primaryTextStyle()),
                                SizedBox(height: 8),
                                AppTextField(
                                  controller: pickAddressCont,
                                  textInputAction: TextInputAction.next,
                                  textFieldType: TextFieldType.ADDRESS,
                                  decoration: commonInputDecoration(suffixIcon: Icons.location_on_outlined),
                                  validator: (value) {
                                    if (value!.isEmpty) return errorThisFieldRequired;
                                    if (pickLat == null || pickLong == null) return language.pleaseSelectValidAddress;
                                    return null;
                                  },
                                  onChanged: (val) async {
                                    pickMsg = '';
                                    pickLat = null;
                                    pickLong = null;
                                    if (val.isNotEmpty) {
                                      if (val.length < 3) {
                                        pickMsg = language.selectedAddressValidation;
                                        pickPredictionList.clear();
                                        setState(() {});
                                      } else {
                                        pickPredictionList = await getPlaceAutoCompleteApiCall(val);
                                        setState(() {});
                                      }
                                    } else {
                                      pickPredictionList.clear();
                                      setState(() {});
                                    }
                                  },
                                ),
                                if (!pickMsg.isEmptyOrNull)
                                  Padding(
                                      padding: EdgeInsets.only(top: 8, left: 8),
                                      child: Text(
                                        pickMsg.validate(),
                                        style: secondaryTextStyle(color: Colors.red),
                                      )),
                                if (pickPredictionList.isNotEmpty)
                                  ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      controller: ScrollController(),
                                      padding: EdgeInsets.only(top: 16, bottom: 16),
                                      shrinkWrap: true,
                                      itemCount: pickPredictionList.length,
                                      itemBuilder: (context, index) {
                                        Predictions mData = pickPredictionList[index];
                                        return ListTile(
                                          leading: Icon(Icons.location_pin, color: primaryColor),
                                          title: Text(mData.description ?? ""),
                                          onTap: () async {
                                            PlaceIdDetailModel? response = await getPlaceIdDetailApiCall(placeId: mData.placeId!);
                                            if (response != null) {
                                              pickAddressCont.text = mData.description ?? "";
                                              pickLat = response.result!.geometry!.location!.lat.toString();
                                              pickLong = response.result!.geometry!.location!.lng.toString();
                                              pickPredictionList.clear();
                                              setState(() {});
                                            }
                                          },
                                        );
                                      }),
                                SizedBox(height: 16),
                                Text(language.pickup_contact_number, style: primaryTextStyle()),
                                SizedBox(height: 8),
                                AppTextField(
                                  controller: pickPhoneCont,
                                  textInputAction: TextInputAction.next,
                                  textFieldType: TextFieldType.PHONE,
                                  decoration: commonInputDecoration(
                                      suffixIcon: Icons.phone,
                                      prefixIcon: IntrinsicHeight(
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            CountryCodePicker(
                                              initialSelection: pickupCountryCode,
                                              showCountryOnly: false,
                                              showFlag: true,
                                              showFlagDialog: true,
                                              showOnlyCountryWhenClosed: false,
                                              alignLeft: false,
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
                                              onInit: (c) {
                                                pickupCountryCode = c!.dialCode!;
                                              },
                                              onChanged: (c) {
                                                pickupCountryCode = c.dialCode!;
                                              },
                                            ),
                                            VerticalDivider(color: Colors.grey.withOpacity(0.5)),
                                          ],
                                        ),
                                      )),
                                  validator: (value) {
                                    if (value!.trim().isEmpty) return errorThisFieldRequired;
                                    if (value.trim().length < 10 || value.trim().length > 14) return language.contact_length_validation;
                                    return null;
                                  },
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                ),
                                SizedBox(height: 16),
                                Text(language.pickup_description, style: primaryTextStyle()),
                                SizedBox(height: 8),
                                TextField(
                                  controller: pickDesCont,
                                  decoration: commonInputDecoration(suffixIcon: Icons.notes),
                                  textInputAction: TextInputAction.newline,
                                  maxLines: 3,
                                  minLines: 3,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(language.delivery_information, style: boldTextStyle()),
                          SizedBox(height: 8),
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Theme.of(context).dividerColor),
                              borderRadius: BorderRadius.circular(defaultRadius),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(language.delivery_location, style: primaryTextStyle()),
                                SizedBox(height: 8),
                                AppTextField(
                                  controller: deliverAddressCont,
                                  textInputAction: TextInputAction.next,
                                  textFieldType: TextFieldType.ADDRESS,
                                  decoration: commonInputDecoration(suffixIcon: Icons.location_on_outlined),
                                  validator: (value) {
                                    if (value!.isEmpty) return errorThisFieldRequired;
                                    if (deliverLat == null || deliverLong == null) return language.pleaseSelectValidAddress;
                                    return null;
                                  },
                                  onChanged: (val) async {
                                    deliverMsg = '';
                                    deliverLat = null;
                                    deliverLong = null;
                                    if (val.isNotEmpty) {
                                      if (val.length < 3) {
                                        deliverMsg = language.selectedAddressValidation;
                                        deliverPredictionList.clear();
                                        setState(() {});
                                      } else {
                                        deliverPredictionList = await getPlaceAutoCompleteApiCall(val);
                                        setState(() {});
                                      }
                                    } else {
                                      deliverPredictionList.clear();
                                      setState(() {});
                                    }
                                  },
                                ),
                                if (!deliverMsg.isEmptyOrNull)
                                  Padding(
                                      padding: EdgeInsets.only(top: 8, left: 8),
                                      child: Text(
                                        deliverMsg.validate(),
                                        style: secondaryTextStyle(color: Colors.red),
                                      )),
                                if (deliverPredictionList.isNotEmpty)
                                  ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    controller: ScrollController(),
                                    padding: EdgeInsets.only(top: 16, bottom: 16),
                                    shrinkWrap: true,
                                    itemCount: deliverPredictionList.length,
                                    itemBuilder: (context, index) {
                                      Predictions mData = deliverPredictionList[index];
                                      return ListTile(
                                        leading: Icon(Icons.location_pin, color: primaryColor),
                                        title: Text(mData.description ?? ""),
                                        onTap: () async {
                                          PlaceIdDetailModel? response = await getPlaceIdDetailApiCall(placeId: mData.placeId!);
                                          if (response != null) {
                                            deliverAddressCont.text = mData.description ?? "";
                                            deliverLat = response.result!.geometry!.location!.lat.toString();
                                            deliverLong = response.result!.geometry!.location!.lng.toString();
                                            deliverPredictionList.clear();
                                            setState(() {});
                                          }
                                        },
                                      );
                                    },
                                  ),
                                SizedBox(height: 16),
                                Text(language.delivery_contact_number, style: primaryTextStyle()),
                                SizedBox(height: 8),
                                AppTextField(
                                  controller: deliverPhoneCont,
                                  textInputAction: TextInputAction.next,
                                  textFieldType: TextFieldType.PHONE,
                                  decoration: commonInputDecoration(
                                    suffixIcon: Icons.phone,
                                    prefixIcon: IntrinsicHeight(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CountryCodePicker(
                                            initialSelection: deliverCountryCode,
                                            showCountryOnly: false,
                                            showFlag: true,
                                            showFlagDialog: true,
                                            showOnlyCountryWhenClosed: false,
                                            alignLeft: false,
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
                                            onInit: (c) {
                                              deliverCountryCode = c!.dialCode!;
                                            },
                                            onChanged: (c) {
                                              deliverCountryCode = c.dialCode!;
                                            },
                                          ),
                                          VerticalDivider(color: Colors.grey.withOpacity(0.5)),
                                        ],
                                      ),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value!.trim().isEmpty) return errorThisFieldRequired;
                                    if (value.trim().length < 10 || value.trim().length > 14) return language.contact_length_validation;
                                    return null;
                                  },
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                ),
                                SizedBox(height: 16),
                                Text(language.delivery_description, style: primaryTextStyle()),
                                SizedBox(height: 8),
                                TextField(
                                  controller: deliverDesCont,
                                  decoration: commonInputDecoration(suffixIcon: Icons.notes),
                                  textInputAction: TextInputAction.newline,
                                  maxLines: 3,
                                  minLines: 3,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Text(language.payment_collect_form, style: boldTextStyle()),
                SizedBox(height: 8),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: DropdownButtonFormField<String>(
                    isExpanded: true,
                    value: paymentCollectFrom,
                    dropdownColor: Theme.of(context).cardColor,
                    style: primaryTextStyle(),
                    decoration: commonInputDecoration(),
                    items: [
                      DropdownMenuItem(value: PAYMENT_ON_PICKUP, child: Text(language.pickup_location, style: primaryTextStyle(), maxLines: 1)),
                      DropdownMenuItem(value: PAYMENT_ON_DELIVERY, child: Text(language.delivery_location, style: primaryTextStyle(), maxLines: 1)),
                    ],
                    onChanged: (value) {
                      paymentCollectFrom = value!;
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        Observer(builder: (context) {
          return Visibility(visible: appStore.isLoading, child: Positioned.fill(child: loaderWidget()));
        }),
      ],
    );
  }
}
