import 'package:ashkerty_food/models/manager.dart';
import 'package:flutter/material.dart';


class DeleteManager extends StatelessWidget {
  final Managers data;
  final Function(Map) Delete;
  DeleteManager({super.key, required this.data, required this.Delete});

  Modal(BuildContext context){
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              title: Center(child: Text('حذف حساب ${data.username}')),
              actions: [
                Center(
                    child: Text('لن يتمكن ${data.username} من تسجيل الدخول مجددا',
                      style: TextStyle(fontSize: 18, color: Colors.red, fontWeight: FontWeight.bold),
                    )
                ),
                const SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Center(
                    child: SizedBox(
                      height: 40,
                      width: 100,
                      child: TextButton(
                          style: TextButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              primary: Colors.white
                          ),
                          onPressed: (){
                            //call add client
                            Map datas = {};
                            datas['username'] = data.username;
                            Delete(datas);
                            Navigator.of(context).pop();
                          },
                          child: const Text('حذف',style: TextStyle(fontSize: 20,color: Colors.white),)
                      ),
                    ),
                  ),
                ),
              ],
            )
        );

      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: (){
          Modal(context);
        },
        icon: Icon(Icons.delete_rounded,color: Color(0xff060d48)),
        tooltip: 'حذف'
    );

  }
}

