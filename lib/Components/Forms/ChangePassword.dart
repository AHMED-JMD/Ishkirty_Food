import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

late String password;
late String newpassword;
final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

ChangePassword (BuildContext context) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: SimpleDialog(
          title: Center(child: Text('تغيير كلمة السر')),
          children:[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: FormBuilder(
                key: _formKey,
                child: Column(
                  children: [
                    FormBuilderTextField(
                      name: 'oldpassword',
                      decoration: InputDecoration(labelText: 'كلمة السر القديمة'),
                      validator: (value){
                        if(value!= password){
                          return'كلمة سر خاطئة';
                        }
                        }

                    ),
                    FormBuilderTextField(
                      name: 'newpassword',
                      decoration: InputDecoration(labelText: 'كلمة السر الجديدة'),

                      validator: (value){
                        if(value!=null)
                          {
                            newpassword=value;
                          }

                      },
                    ),
                    FormBuilderTextField(
                      name: 'price',
                      decoration: InputDecoration(labelText: 'تكرار كلمة السر'),

                      validator: (value){
                        if(value!=null)
                        {
                          newpassword=value;
                        }

                      },
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

                                password=newpassword;
                                Navigator.pushReplacementNamed(context, '/');

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


