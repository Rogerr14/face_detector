import 'package:flutter/material.dart';
// import 'package:mi_arcsa/env/theme/app_theme.dart';

// import '../helpers/global_helper.dart';
// import '../widget/alerts_template.dart';

class FunctionalProvider extends ChangeNotifier {
  //bool _isLoading = false;

  //bool get isLoading => _isLoading;
  // IconBottomNavigationBarItem iconBottomNavigationBarItem = IconBottomNavigationBarItem.iconButtonNavigatorDashboard;

  // void setLoading(bool loading) {
  //   _isLoading = loading;
  //   notifyListeners();
  // }
  List<Widget> alerts = [];
  List<Widget> alertLoading = [];

  // IconBottomNavigationBarItem iconBottomNavigationBarItem = IconBottomNavigationBarItem.iconBottonNavBarEstablishment;


  // showAlert({required GlobalKey key, required Widget content, bool closeAlert = false, bool animation = true, double padding = 20}) {
  //   final newAlert = Container(
  //     key: key,
  //     color: AppTheme.transparent,
  //     child: AlertTemplate(content: content, keyToClose: key, dismissAlert: closeAlert, animation: animation, padding: padding));
  //   alerts.add(newAlert);
  //   //GlobalHelper.logger.t('total de alerts: ${alerts.length.toString()}');
  //   //GlobalHelper.logger.t('key alert: ${key.toString()}');
  //   notifyListeners();
  // }
  // showAlertLoading({required GlobalKey key, required Widget content, bool closeAlert = false, bool animation = true}) {
  //   final newAlert = Container(
  //   key: key,
  //   color: Colors.transparent,
  //   child: AlertTemplate(content: content, keyToClose: key, dismissAlert: closeAlert, animation: animation));
  //   alertLoading.add(newAlert);
  //   alerts.add(newAlert);
  //   notifyListeners();
  // }

  

  addPage({required GlobalKey key, required Widget content}) {
    alerts.add(content);
    //lobalHelper.logger.t('total de pages: ${alerts.length.toString()}');
    //GlobalHelper.logger.t('key page: ${key.toString()}');
    notifyListeners();
  }


  dismissAlert({required GlobalKey key}) {
    //GlobalHelper.logger.t('MANDAR A BORRAR alert de: $key');
    alerts.removeWhere((alert) => key == alert.key);
    notifyListeners();
  }
  dismissAlertLoading({required GlobalKey key}) {
    alertLoading.removeWhere((alert) => key == alert.key);
    alerts.removeWhere((alert) => key == alert.key);
    notifyListeners();
  }
  clearAllAlert() {
    //GlobalHelper.logger.t('se cerraron todos los alerts');
    alerts = [];
    notifyListeners();
  }
  // selectIconBottomNavigationBarItem(){
  //   return iconBottomNavigationBarItem;
  // }

  // setIconBottomNavigationBarItem(IconBottomNavigationBarItem value){
  //   iconBottomNavigationBarItem = value;
  //   notifyListeners();
  // }

  changeTitle(int page) {
    // switch (page) {
    //   case 0:
    //     titleCitizenComplaint = 'DETALLE DE LA DENUNCIA';
    //     break;
    //   case 1:
    //     titleCitizenComplaint = 'DETALLE DEL PRODUCTO';
    //     break;
    //    case 2:
    //     titleCitizenComplaint = 'DETALLE DEL ESTABLECIMIENTO';
    //     break;
    //    case 3:
    //     titleCitizenComplaint = 'DATOS DEL CONTACTO';
    //     break;
    //   default:
    //     titleCitizenComplaint = 'DETALLE DE LA DENUNCIA';
    //     break;
    // }
    notifyListeners();
  }
}
