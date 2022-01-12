import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class CommonScaffold extends StatelessWidget {
  final Widget child;

  const CommonScaffold({ this.child}) ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      // backgroundColor: MyColors.white,
      body: DoubleBackToCloseApp(
        snackBar:  const SnackBar(
            content: Text('Please click Back again to Exit..')),
        child:   Container(
          height: Get.height,
          child:  child,
        ), ),
    );
  }
}
class Dialogs {
  static Future<void> showLoadingDialog(text) async {
    Get.dialog(
      SimpleDialog(
          backgroundColor: Colors.white,
          children: <Widget>[
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical:10.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: 20,),
                      CircularProgressIndicator(),
                      SizedBox(width: 20,),
                      Flexible(
                          child: Text(text!=null?"$text":"Please wait.....",
                            textAlign:TextAlign.center,
                            style: TextStyle(color: Colors.black),))
                    ]),
              ),
            )
          ]),
      barrierDismissible: false,
    );
  }
}

showSnackbar(title, message) {
  Get.snackbar(title, message, backgroundColor: Colors.black, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM,
    margin: EdgeInsets.all(10),);
}
