import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
//delete modal
final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

ReductAccount(BuildContext context, String title){
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child:Center(
          child: FormBuilder(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:<Widget>[
                AlertDialog(
                  title: const Center(child: Text('خصم ')),
                  actions: [
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'القيمة',
                        icon: Icon(Icons.attach_money_rounded),
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
                                  backgroundColor: const Color(0xff000000),
                                  primary: Colors.white
                              ),
                              onPressed: (){if(_formKey.currentState!.saveAndValidate()){
                                Navigator.pushReplacementNamed(context, '/clients');
                              }
                              },
                              child: const Text('حفظ',style: TextStyle(fontSize: 20,color: Colors.white),)
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