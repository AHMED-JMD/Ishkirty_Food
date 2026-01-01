import 'package:ashkerty_food/API/Bill.dart';
import 'package:ashkerty_food/providers/Auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeleteBills extends StatefulWidget {
  final int id;
  const DeleteBills({
    super.key,
    required this.id,
  });

  @override
  State<DeleteBills> createState() => _DeleteBillsState();
}

class _DeleteBillsState extends State<DeleteBills> {
  //server side Functions ------------------
  Future DeleteBill(data) async {
    //call server
    final response = await APIBill.deleteBill(data);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Center(
            child: Text(
          "تم حذف الفاتورة بنجاح",
          style: TextStyle(fontSize: 22),
        )),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ));
      Navigator.pushReplacementNamed(context, '/del_bills');
    } else {
      return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text(
          "sorry something is wrong :(",
          style: TextStyle(fontSize: 19),
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: "close X",
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ));
    }
  }

  //bill modal
  deleteModal(context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: const Center(child: Text('حذف  الفاتورة')),
            content: const Text(
              'سيؤدي ذلك لضياع كل البيانات المتعلقة بالفاتورة',
              style: TextStyle(
                fontSize: 18,
                color: Color(0xffb00505),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Center(
                  child: SizedBox(
                    height: 50,
                    width: 100,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Color(0xffb00505),
                      ),
                      onPressed: () {
                        //call server
                        DeleteBill({'id': widget.id});
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'حذف',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
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

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, value, child) {
      return value.user['role'] != 'admin'
          ? const Text('')
          : IconButton(
              onPressed: () {
                deleteModal(context);
              },
              icon: const Icon(
                Icons.delete_forever,
                color: Colors.red,
              ),
              tooltip: 'حذف',
            );
    });
  }
}
