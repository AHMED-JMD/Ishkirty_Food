import 'package:ashkerty_food/models/Client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class AddAccount extends StatelessWidget {
  final Client data;
  final Function(Map) Modify;
  AddAccount({super.key, required this.data, required this.Modify});

  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  AddModal(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              title: Center(child: Text('تعديل حساب ${data.name}')),
              actions: [
                FormBuilder(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0, left: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FormBuilderDropdown(
                          name: 'name',
                          decoration:
                              InputDecoration(labelText: 'اسم المستخدم'),
                          initialValue: data.name.toString(),
                          items: ['${data.name}']
                              .map((type) => DropdownMenuItem(
                                  value: data.name, child: Text('$type')))
                              .toList(),
                          validator: FormBuilderValidators.required(
                              errorText: "الرجاء ادخال جميع الجقول"),
                        ),
                        FormBuilderDropdown(
                          name: 'type',
                          decoration:
                              InputDecoration(labelText: 'اختر نوع التعديل'),
                          items: ['خصم', 'اضافة']
                              .map((type) => DropdownMenuItem(
                                  value: type, child: Text('$type')))
                              .toList(),
                          validator: FormBuilderValidators.required(
                              errorText: "الرجاء ادخال جميع الجقول"),
                        ),
                        FormBuilderTextField(
                          name: 'amount',
                          decoration: InputDecoration(
                            labelText: 'المبلغ',
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
                              primary: Colors.white),
                          onPressed: () {
                            if (_formKey.currentState!.saveAndValidate()) {
                              //call add client
                              Modify(
                                _formKey.currentState!.value,
                              );
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
    return Placeholder();
  }
}
