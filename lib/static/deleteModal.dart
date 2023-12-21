import 'package:flutter/material.dart';
//delete modal
 deleteModal(BuildContext context, Function delete, String title){
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: Text('حذف $title'),
          content: Text('هل انت متأكد برغبتك في حذف $title'),
          actions: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Center(
                child: SizedBox(
                  height: 30,
                  child: TextButton(
                      child: Text('حذف'),
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          primary: Colors.white
                      ),
                      onPressed: (){
                        delete();
                        Navigator.of(context).pop();
                      }
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}