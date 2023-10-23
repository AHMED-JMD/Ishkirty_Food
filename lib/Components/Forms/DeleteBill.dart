import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
//delete modal
final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
deleteBill(BuildContext context, String title){
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child:Center(
          child: FormBuilder(
            key: _formKey,
          child: Column(
            children:<Widget>[
            AlertDialog(
            title: const Center(child: Text('حذف فاتورة ')),
            content: const Text('هل انت متأكد من رغبتك في حذف هذه الفاتورة',style: TextStyle(fontSize: 18,color: Color(0xffb00505),),),
            actions: [
              TextFormField(
                 decoration: const InputDecoration(
                 labelText: 'تعليق',
  icon: Icon(Icons.comment_rounded),
  ),
  validator: FormBuilderValidators.required(errorText: 'الرجاء ادخال تعليق '),
),
              const SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Center(
                  child: SizedBox(
                    height: 50,
                    width: 100,
                    child: TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor: const Color(0xffb00505),
                            primary: Colors.white
                        ),
                        onPressed: (){if(_formKey.currentState!.saveAndValidate()){
                          Navigator.pushReplacementNamed(context, '/bills');
                        }
                        },
                        child: const Text('حذف',style: TextStyle(fontSize: 20,color: Colors.white),)
                    ),
                  ),
                ),
              ),
            ],
      ),
      ],),
      ),
        ),
      );
    },
  );
}