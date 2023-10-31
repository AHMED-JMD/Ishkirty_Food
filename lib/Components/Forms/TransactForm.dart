
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../../static/my_icon_icons.dart';
//delete modal
final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

Transact(BuildContext context){
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: FormBuilder(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:<Widget>[
              AlertDialog(
                title: const Center(child: Text('تحويل ')),
                actions: [
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'القيمة',
                      icon: Icon(MyIcon.bankak,size: 35,color: Colors.red,),
                    ),
                    validator: FormBuilderValidators.required(errorText: 'الرجاء ادخال قيمة '),
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
                                backgroundColor: const Color(0xff850808),
                                primary: Colors.white
                            ),
                            onPressed: (){if(_formKey.currentState!.saveAndValidate()){
                              Navigator.pushReplacementNamed(context, '/home'
                                  );
                            }
                            },
                            child: const Text('تحويل',style: TextStyle(fontSize: 20,color: Colors.white),)
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],),
        ),
      );
    },
  );
}