import 'package:local_delivery_admin/network/RestApis.dart';

import '../main.dart';
import 'Extensions/app_common.dart';

getAllCountryApiCall() async{
  await getCountryList().then((value) {
    appStore.countryList.clear();
    appStore.countryList.addAll(value.data!);
  }).catchError((error) {
    toast(error.toString());
  });
}
