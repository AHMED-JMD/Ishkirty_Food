import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class Add_Admin extends StatelessWidget {
  final Function(Map) addAdmin;
  Add_Admin({super.key, required this.addAdmin});

  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  AddModal(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              title: const Center(child: Text('إضافة كاشير جديد ')),
              actions: [
                FormBuilder(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0, left: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FormBuilderTextField(
                          name: 'username',
                          decoration: const InputDecoration(
                            labelText: 'الاسم',
                            icon: Icon(
                              Icons.person_pin,
                              size: 20,
                              color: Colors.teal,
                            ),
                          ),
                          validator: FormBuilderValidators.required(
                              errorText: 'الرجاء ادخال قيمة '),
                        ),
                        FormBuilderTextField(
                          name: 'phoneNum',
                          decoration: const InputDecoration(
                            labelText: 'رقم الهاتف',
                            icon: Icon(
                              Icons.phone,
                              size: 20,
                              color: Colors.teal,
                            ),
                          ),
                          validator: FormBuilderValidators.required(
                              errorText: 'الرجاء ادخال قيمة '),
                        ),
                        FormBuilderDropdown(
                          name: 'shift',
                          decoration: const InputDecoration(
                              labelText: 'اختر الوردية',
                              icon: Icon(
                                Icons.access_time,
                                size: 20,
                                color: Colors.teal,
                              )),
                          items: ['صباحية', 'مسائية']
                              .map((item) => DropdownMenuItem(
                                  value: item, child: Text(item)))
                              .toList(),
                          validator: FormBuilderValidators.required(
                              errorText: 'الرجاء ادخال قيمة '),
                        ),
                        FormBuilderTextField(
                          name: 'password',
                          decoration: const InputDecoration(
                            labelText: 'كلمة السر',
                            icon: Icon(
                              Icons.password,
                              size: 20,
                              color: Colors.teal,
                            ),
                          ),
                          obscureText: true,
                          validator: FormBuilderValidators.required(
                              errorText: 'الرجاء ادخال قيمة '),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Center(
                    child: SizedBox(
                      height: 40,
                      width: 110,
                      child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.teal,
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.saveAndValidate()) {
                              //call add client
                              addAdmin(_formKey.currentState!.value);
                              Navigator.of(context).pop();
                            }
                          },
                          child: const Text(
                            'حفظ',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          )),
                    ),
                  ),
                ),
              ],
            ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.teal, width: 2),
          borderRadius: BorderRadius.circular(10)),
      child: TextButton(
          onPressed: () {
            AddModal(context);
          },
          style: TextButton.styleFrom(
              backgroundColor: Colors.transparent,
              minimumSize: const Size(200, 50)),
          child: const Text(
            'اضافة كاشير جديد',
            style: TextStyle(color: Colors.black),
          )),
    );
  }
}
