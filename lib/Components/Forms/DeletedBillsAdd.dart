import 'package:ashkerty_food/API/Bill.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class AddToDeleted extends StatefulWidget {
  final bill;
  AddToDeleted({super.key, required this.bill});

  @override
  State<AddToDeleted> createState() => _AddToDeletedState(bill: bill);
}

class _AddToDeletedState extends State<AddToDeleted> {
  final bill;
  _AddToDeletedState({ required this.bill});
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  String? comment;
  bool isLoading = false;

  //server function to update bill to be deleted
  Future updateBill (data) async {
    setState(() {
      isLoading = true;
    });

    final response = await APIBill.deleted_update(data);

    setState(() {
      isLoading = false;
    });

    if(response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Center(child: Text("تم اضافة الفاتورة للمحذوفات بنجاح", style: TextStyle(fontSize: 22),)),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          )
      );
      Navigator.pushReplacementNamed(context, '/bills');
    }else{
      return ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("sorry something is wrong :(", style: TextStyle(fontSize: 19),),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
            action: SnackBarAction(
              label: "close X",
              onPressed: (){
                Navigator.pop(context);
              },
            ),
          )
      );
    }
  }

  //delete bill model
  deleteBill(BuildContext context,){
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child:Center(
            child: FormBuilder(
              key: _formKey,
              child: Column(
                children:<Widget>[
                  AlertDialog(
                    title: const Center(child: Text('حذف فاتورة ')),
                    content: const Text('هل انت متأكد من رغبتك في حذف هذه الفاتورة',style: TextStyle(fontSize: 18,color: Color(0xffb00505),),),
                    actions: [
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'تعليق',
                          icon: Icon(Icons.comment_rounded),
                        ),
                        onChanged: (value){
                          comment = value;
                        },
                        validator: FormBuilderValidators.required(errorText: 'الرجاء ادخال تعليق '),
                      ),
                      const SizedBox(height: 20,),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Center(
                          child: SizedBox(
                            height: 50,
                            width: 100,
                            child: TextButton(
                                style: TextButton.styleFrom(
                                    backgroundColor: const Color(0xffb00505),
                                    primary: Colors.white
                                ),
                                onPressed: (){
                                  if(_formKey.currentState!.saveAndValidate()){
                                    final data = {};
                                    data['comment'] = comment;
                                    data['id'] = bill.id;

                                    //call server
                                    updateBill(data);
                                    Navigator.pop(context);
                                  }
                                },
                                child: const Text('حذف',style: TextStyle(fontSize: 20,color: Colors.white),)
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return isLoading ?
    SpinKitChasingDots(
      color: Colors.black,
      size: 30,
    )
    : IconButton(
        onPressed: (){
          deleteBill(context);
        },
        icon: const Icon(Icons.delete_rounded,color: Color(0xff65090c),)
        ,tooltip: 'اضافة للمحذوفات'
    );
  }
}
