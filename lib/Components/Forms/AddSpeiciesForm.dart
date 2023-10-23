import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

AddSpeicies_Modal (BuildContext context,) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: SimpleDialog(
          title: Center(child: Text(' إضافة الصنف')),
          children:[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: FormBuilder(
                key: _formKey,
                child: Column(
                  children: [
                    FormBuilderTextField(
                      name: 'name',
                      decoration: InputDecoration(labelText: 'الأسم'),
                      initialValue: null,
                      validator: FormBuilderValidators.required(errorText: 'الرجاء ادخال جميع الحقول'),
                    ),
                    FormBuilderTextField(
                      name: 'price',
                      decoration: InputDecoration(labelText: 'السعر'),
                      initialValue: null,
                      validator: FormBuilderValidators.required(errorText: 'الرجاء ادخال جميع الحقول'),
                    ),
                    FormBuilderTextField(
                      name: 'imageLink',
                      decoration: InputDecoration(labelText: 'الصورة'),
                      initialValue: null,
                      validator: FormBuilderValidators.required(errorText: 'الرجاء ادخال جميع الحقول'),
                    ),
                    FormBuilderTextField(
                      name: 'type',
                      decoration: InputDecoration(labelText: 'النوع'),
                      initialValue: null,
                      validator: FormBuilderValidators.required(errorText: 'الرجاء ادخال جميع الحقول'),
                    ),


                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0, top: 30),
                      child: Center(
                        child: SizedBox(
                          height: 30,
                          width: 70,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              primary: Colors.white,
                            ),
                            child: Text('حفظ'),
                            onPressed: (){
                              if(_formKey.currentState!.saveAndValidate()){
                                Map data = {};
                                data['name'] = _formKey.currentState!.value['name'];
                                data['price'] = _formKey.currentState!.value['price'];
                                data['imageLink'] = _formKey.currentState!.value['imageLink'];
                                data['type'] = _formKey.currentState!.value['type'];
                                //server
                                Navigator.of(context).pop();
                              }

                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

