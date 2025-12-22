import 'package:ashkerty_food/API/Transfer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import '../../static/my_icon_icons.dart';

class TransferFormModal extends StatefulWidget {
  final String admin_id;
  const TransferFormModal({super.key, required this.admin_id});

  @override
  State<TransferFormModal> createState() => _TransferFormModalState();
}

class _TransferFormModalState extends State<TransferFormModal> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  DateTime date = DateTime.now();

  //server function to update password
  Future add (data) async{
    //call server
    final response = await API_Transfer.add(data);

    if(response == true){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Center(
              child: Text('تم اضافة التحويلة بنجاح', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            ),
            backgroundColor: Colors.green,
          )
      );
      Navigator.pushReplacementNamed(context, '/profile');
    }else{
      return ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Center(
              child: Text('$response', style: TextStyle(fontSize: 20),),
            ),
            backgroundColor: Colors.redAccent,
          )
      );
    }
  }


  //modal
  Transfer(BuildContext context){
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: const Center(child: Text('تحويل ')),
            actions: [
              FormBuilder(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FormBuilderTextField(
                          name: 'amount',
                          decoration: const InputDecoration(
                            labelText: 'القيمة',
                            icon: Icon(MyIcon.bankak,size: 30,color: Colors.red,),
                          ),
                          validator: FormBuilderValidators.required(errorText: 'الرجاء ادخال قيمة '),
                        ),
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
                                    backgroundColor: const Color(0xff850808),
                                    primary: Colors.white
                                ),
                                onPressed: (){
                                  if(_formKey.currentState!.saveAndValidate()){
                                    Map data = {};
                                    data['date'] = date.toIso8601String();
                                    data['amount'] = _formKey.currentState!.value['amount'];
                                    data['AdminAdminId'] = widget.admin_id;
                                    //call api
                                    add(data);
                                    Navigator.of(context).pop();
                                  }
                                },
                                child: const Text('تحويل',style: TextStyle(fontSize: 20,color: Colors.white),)
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
              )
          ],
        )
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: (){
          Transfer(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red[300],
          minimumSize: Size(110, 50)
        ),
        child: Text('تحويل')
    );
  }
}
