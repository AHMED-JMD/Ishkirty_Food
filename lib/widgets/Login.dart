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
  final String username='محمد';
  final String password='1a2b3c4d';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
          children:[
            Container(
              decoration: const BoxDecoration(
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
                        height: 470,
                        decoration: BoxDecoration(
                            color: const Color.fromRGBO(255, 255, 255, 0.8),
                            borderRadius: BorderRadius.circular(13)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(40.0),
                          child: FormBuilder(
                            key: _formKey,
                            child: Column(
                              children: [
                                const Center(
                                  child: Text(
                                    'مطعم اشكرتي  ',
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20,),

                                FormBuilderTextField(
                                  name: 'username',
                                  decoration: const InputDecoration(
                                    labelText: 'الاسم',
                                    icon: Icon(Icons.person),
                                  ),
                                  validator: FormBuilderValidators.required(errorText: "الرجاء ادخال جميع الجقول"),
                                ),
                                const SizedBox(height: 20,),
                                FormBuilderTextField(
                                  name: 'password',
                                  decoration: const InputDecoration(
                                      labelText: 'كلمة السر',
                                      icon: Icon(Icons.password),
                                      focusColor: Colors.deepPurple
                                  ),
                                  obscureText: true,
                                  validator: FormBuilderValidators.required(errorText: "الرجاء ادخال جميع الجقول"),
                                ),
                                const SizedBox(height: 50,),
                                SizedBox(
                                  height: 40,
                                  width: 180,
                                  child: ElevatedButton(
                                    onPressed: (){
                                      if(_formKey.currentState!.saveAndValidate()){
                                        
                                        Navigator.pushReplacementNamed(context, '/home');
                                        
                                        //call to server
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(

                                        backgroundColor: const Color(0xff000000),
                                    ),
                                    child: const Text('تسجيل الدخول', style: TextStyle(fontSize: 20, color: Colors.white)),
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
