import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
          children:[
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    'assets/images/resturant2.jpg',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 600,
                        height: 460,
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(255, 255, 255, 0.8),
                            borderRadius: BorderRadius.circular(13)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(40.0),
                          child: FormBuilder(
                            key: _formKey,
                            child: Column(
                              children: [
                                Center(
                                  child: Text(
                                    'مطعم اشكرتي للمأكولات ',
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black
                                    ),
                                  ),
                                ),
                                SizedBox(height: 30,),
                                Center(
                                  child: Text('تسجيل الدخول',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black
                                    ),
                                  ),
                                ),
                                FormBuilderTextField(
                                  name: 'username',
                                  decoration: InputDecoration(
                                    labelText: 'الاسم',
                                    icon: Icon(Icons.person),
                                  ),
                                  validator: FormBuilderValidators.required(errorText: "الرجاء ادخال جميع الجقول"),
                                ),
                                SizedBox(height: 20,),
                                FormBuilderTextField(
                                  name: 'password',
                                  decoration: InputDecoration(
                                      labelText: 'كلمة السر',
                                      icon: Icon(Icons.password),
                                      focusColor: Colors.deepPurple
                                  ),
                                  obscureText: true,
                                  validator: FormBuilderValidators.required(errorText: "الرجاء ادخال جميع الجقول"),
                                ),
                                SizedBox(height: 30,),
                                SizedBox(
                                  height: 40,
                                  width: 100,
                                  child: ElevatedButton(
                                    onPressed: (){
                                      if(_formKey.currentState!.saveAndValidate()){
                                        
                                        Navigator.pushReplacementNamed(context, '/home');
                                        
                                        //call to server
                                      }
                                    },
                                    child: Text('ارسال', style: TextStyle(fontSize: 16, color: Colors.black)),
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.grey,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ]
      ),
    );
  }
}
