import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

 Order_Modal (BuildContext context, data) {
  return showDialog(
     context: context,
     builder: (BuildContext context) {
       return Directionality(
         textDirection: TextDirection.rtl,
         child: SimpleDialog(
           title: Text('طلب فاتورة'),
           children:[
             Padding(
               padding: const EdgeInsets.all(20.0),
               child: FormBuilder(
                 key: _formKey,
                 child: Column(
                   children: [
                     FormBuilderTextField(
                       name: 'name',
                       decoration: InputDecoration(labelText: 'الصنف'),
                       initialValue: '${data.name}',
                       validator: FormBuilderValidators.required(errorText: 'الرجاء ادخال جميع الحقول'),
                     ),
                     FormBuilderTextField(
                       name: 'price',
                       decoration: InputDecoration(labelText: 'السعر'),
                       initialValue: '${data.price}',
                       validator: FormBuilderValidators.required(errorText: 'الرجاء ادخال جميع الحقول'),
                     ),
                     FormBuilderTextField(
                       name: 'amount',
                       decoration: InputDecoration(labelText: 'الكمية'),
                       initialValue: '0',
                       validator: FormBuilderValidators.required(errorText: 'الرجاء ادخال جميع الحقول'),
                     ),
                     FormBuilderDateTimePicker(
                       name: 'date',
                       decoration: InputDecoration(
                           labelText: 'التاريخ',
                           suffixIcon: Icon(Icons.calendar_month, color: Colors.blueAccent,)
                       ),
                       validator: FormBuilderValidators.required(errorText: "الرجاء ادخال جميع الجقول"),
                       initialDate: DateTime.now(),
                       inputType: InputType.date,
                     ),

                     Padding(
                       padding: const EdgeInsets.only(bottom: 8.0, top: 30),
                       child: Center(
                         child: SizedBox(
                           height: 30,
                           width: 70,
                           child: TextButton(
                             style: TextButton.styleFrom(
                               backgroundColor: Colors.blueAccent,
                               primary: Colors.white,
                             ),
                             child: Text('حفظ'),
                             onPressed: (){
                               if(_formKey.currentState!.saveAndValidate()){
                                 Map data = {};
                                 data['emp_id'] = _formKey.currentState!.value['emp_id'];
                                 data['edit_type'] = _formKey.currentState!.value['edit_type'];
                                 data['amount'] = _formKey.currentState!.value['amount'];
                                 data['date'] = _formKey.currentState!.value['date'].toIso8601String();
                                 data['comment'] = _formKey.currentState!.value['comment'];

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
