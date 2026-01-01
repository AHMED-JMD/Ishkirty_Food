import 'package:ashkerty_food/models/Client.dart';
import 'package:flutter/material.dart';

class DeleteAccount extends StatelessWidget {
  final Client data;
  final Function(Map) Delete;
  const DeleteAccount({super.key, required this.data, required this.Delete});

  Modal(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              title: Center(child: Text('حذف حساب ${data.name}')),
              actions: [
                const Center(
                    child: Text(
                  'سيؤدي ذلك لضياع كل بيانات الحساب',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.red,
                      fontWeight: FontWeight.bold),
                )),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Center(
                    child: SizedBox(
                      height: 40,
                      width: 100,
                      child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                          ),
                          onPressed: () {
                            //call add client
                            Map datas = {};
                            datas['id'] = data.id;
                            Delete(datas);
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            'حفظ',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          )),
                    ),
                  ),
                ),
              ],
            ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
