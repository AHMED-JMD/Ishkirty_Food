import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class AddClient_Modal extends StatelessWidget {
  final Function(Map) addClient;
  AddClient_Modal({super.key, required this.addClient});

  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  AddModal(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              title: const Center(child: Text('إضافة عميل ')),
              actions: [
                FormBuilder(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0, left: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FormBuilderTextField(
                          name: 'name',
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
                        FormBuilderTextField(
                          name: 'account',
                          initialValue: '0',
                          decoration: const InputDecoration(
                            labelText: 'الحساب الحالي',
                            icon: Icon(
                              Icons.account_balance_wallet,
                              size: 20,
                              color: Colors.teal,
                            ),
                          ),
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
                      height: 50,
                      width: 100,
                      child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: const Color(0xff000000),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.saveAndValidate()) {
                              //call add client
                              addClient(_formKey.currentState!.value);
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
    return const Placeholder();
  }
}
