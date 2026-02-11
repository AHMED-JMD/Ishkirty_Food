import 'package:ashkerty_food/API/Auth.dart';
import 'package:ashkerty_food/API/BusinessLocation.dart';
import 'package:ashkerty_food/API/Store.dart' as api;
import 'package:ashkerty_food/models/BusinessLocation.dart';
import 'package:ashkerty_food/providers/Auth_provider.dart';
import 'package:ashkerty_food/utils/businessLocation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

class Login extends StatefulWidget {
  const Login({super.key});
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  List<BusinessLocation> businessLocations = [];
  bool isLoading = false;
  bool hidePassword = true;

  @override
  void initState() {
    super.initState();
    fetchBusinessLocations();
  }

  //get business locations from server and set to state
  Future<void> fetchBusinessLocations() async {
    final response = await APIBusinessLocation.getAll();
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        businessLocations =
            data.map((json) => BusinessLocation.fromJson(json)).toList();
      });
    }
  }

  //future login
  Future Login(data, provider) async {
    setState(() {
      isLoading = true;
    });
    //
    final response = await APIAuth.Login(data);
    setState(() {
      isLoading = false;
    });

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      //persist business location from login form
      AuthContext.businessLocation = data['business_location']?.toString();

      //global state Provider (this also persists token)
      provider.Login(data['user'], data['token']);

      //check that there is a purchase today,
      //if not go to store acquisition page,
      // else go to home page
      String targetRoute = '/home';
      final res = await api.APIStore.getPurchasesByDate({
        'startDate': DateTime.now().toIso8601String(),
        'endDate': DateTime.now().toIso8601String(),
        'type': 'بيع',
        'admin_id': data['user']['id'],
      });
      if (res.statusCode == 200) {
        final purchases = jsonDecode(res.body);
        if (purchases is List && purchases.isEmpty) {
          targetRoute = '/store_sell';
        }
      }

      Navigator.pushReplacementNamed(context, targetRoute);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Center(
            child: Text(
          '${response.body}',
          style: const TextStyle(fontSize: 19),
        )),
        backgroundColor: Colors.redAccent,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, value, child) {
      return Scaffold(
        body: Stack(children: [
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
                      height: 500,
                      decoration: BoxDecoration(
                          color: const Color.fromRGBO(255, 255, 255, 0.8),
                          borderRadius: BorderRadius.circular(13)),
                      child: Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: FormBuilder(
                          key: _formKey,
                          child: Column(
                            children: [
                              isLoading == true
                                  ? const SpinKitFadingCircle(
                                      color: Colors.teal,
                                      size: 50.0,
                                    )
                                  : const Text(''),
                              const Center(
                                child: Text(
                                  'مطعم عبدو كفتة  ',
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xdb000000),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              FormBuilderTextField(
                                name: 'username',
                                initialValue: value.user['username'] != null
                                    ? '${value.user['username']}'
                                    : '',
                                decoration: const InputDecoration(
                                  labelText: 'اسم المستخدم',
                                  icon: Icon(Icons.person),
                                ),
                                validator: FormBuilderValidators.required(
                                    errorText: "الرجاء ادخال جميع الحقول"),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              FormBuilderTextField(
                                name: 'password',
                                decoration: InputDecoration(
                                    labelText: 'كلمة السر',
                                    icon: const Icon(Icons.password),
                                    suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            hidePassword = !hidePassword;
                                          });
                                        },
                                        icon: Icon(hidePassword
                                            ? Icons.visibility
                                            : Icons.visibility_off)),
                                    focusColor: Colors.deepPurple),
                                obscureText: hidePassword,
                                validator: FormBuilderValidators.required(
                                    errorText: "الرجاء ادخال جميع الحقول"),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                width: 200,
                                child: FormBuilderDropdown<String>(
                                  name: 'business_location',
                                  decoration: const InputDecoration(
                                    labelText: 'موقع العمل',
                                    icon: Icon(Icons.location_on),
                                  ),
                                  items: businessLocations
                                      .map((location) =>
                                          DropdownMenuItem<String>(
                                            value: location.name,
                                            child: Text(location.name),
                                          ))
                                      .toList(),
                                  validator: FormBuilderValidators.required(
                                      errorText: "الرجاء ادخال جميع الحقول"),
                                ),
                              ),
                              const SizedBox(
                                height: 60,
                              ),
                              SizedBox(
                                height: 40,
                                width: 180,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!
                                        .saveAndValidate()) {
                                      var data = {};
                                      data['username'] = _formKey
                                          .currentState!.value['username'];
                                      data['password'] = _formKey
                                          .currentState!.value['password'];
                                      data['business_location'] = _formKey
                                          .currentState!
                                          .value['business_location'];
                                      //call to server
                                      final authProvider =
                                          context.read<AuthProvider>();
                                      Login(data, authProvider);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.teal,
                                  ),
                                  child: const Text('تسجيل الدخول',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white)),
                                ),
                              ),
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
        ]),
      );
    });
  }
}
