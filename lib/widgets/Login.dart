import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../Components/Forms/ChangePassword.dart';


class Login extends StatefulWidget {
 late String username='محمد';
  late String password='ماعا1997';
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  bool isLoading = false;
  late String username='محمد';
  late String password='ماعا1997';
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
                        height: 490,
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
                                        color: Color(0xdb000000),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20,),

                                FormBuilderTextField(
                                  name: 'username',
                                  decoration: const InputDecoration(
                                    labelText: 'اسم المستخدم',
                                    icon: Icon(Icons.person),
                                  ),
                                   // validator:(value){
                                   //   if(value != username ){
                                   //     return'اسم مستخدم خاطئ ';
                                   //   }
                                   // }
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
                                     // validator:(value){
                                     //  if(value != password ) {
                                     //     return'كلمة سر خاطئة';
                                     //   }
                                     // }
                                ),
                                const SizedBox(height: 60,),
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
                                ),
                            SizedBox(height: 20,),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8,8,8,3),
                                child: TextButton(onPressed: (){ChangePassword(context);}, child: Text('تغيير كلمة السر? اضغط هنا',style: TextStyle(fontSize: 16,color: Color(0xff0a2060)),)),
                              ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(8,0,8,2),
                                  child: TextButton(onLongPress: (){Navigator.pushReplacementNamed(context, '/home');},onPressed: (){}, child: Text('.',style: TextStyle(fontSize: 8,color: Color(0xffffffff)),)),
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
