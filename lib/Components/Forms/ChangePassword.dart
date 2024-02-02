import 'package:ashkerty_food/API/Auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class ChangePassword extends StatefulWidget {
  final String admin_id;
  const ChangePassword({super.key, required this.admin_id});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  String? new_password;
  String? re_password;
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  //server function to update password
  Future updatePassword (data) async{
    //call server
    final response = await APIAuth.UpdatPassword(data);

    if(response == true){
      return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Center(
              child: Text('تم تغيير كلمة السر بنجاح', style: TextStyle(fontSize: 20),),
            ),
          backgroundColor: Colors.green,
        )
      );
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

  change_password (BuildContext context) {
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
                          name: 'password',
                          decoration: InputDecoration(labelText: 'كلمة السر القديمة'),
                        validator: FormBuilderValidators.required(errorText: 'الرجاء ادخال جميع الحقول'),
                      ),
                      FormBuilderTextField(
                        name: 'new_password',
                        onChanged: (val){
                          setState(() {
                            new_password = val;
                          });
                        },
                        obscureText: true,
                        decoration: InputDecoration(labelText: 'كلمة السر الجديدة'),
                        validator: FormBuilderValidators.required(errorText: 'الرجاء ادخال جميع الحقول'),
                      ),
                      FormBuilderTextField(
                        name: 're_password',
                        onChanged: (val){
                          setState(() {
                            re_password = val;
                          });
                        },
                        obscureText: true,
                        decoration: InputDecoration(labelText: 'تكرار كلمة السر'),
                        validator: (value){
                          if(value != new_password){
                            return 'كلمة السر لا تتطابق';
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
                                  Map data = {};
                                  data['admin_id'] = widget.admin_id;
                                  data['password'] = _formKey.currentState!.value['password'];
                                  data['newPassword'] = _formKey.currentState!.value['new_password'];

                                  //call Func
                                  updatePassword(data);
                                  Navigator.pop(context);
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

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: (){
          change_password(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal,
          minimumSize: Size(200, 50)
        ),
        child: Text('تغيير كلمة السر?', style: TextStyle(fontSize: 17),));
  }
}



