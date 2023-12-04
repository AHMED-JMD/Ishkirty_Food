import 'dart:io';
import 'package:ashkerty_food/API/Spieces.dart';
import 'package:ashkerty_food/static/drawer.dart';
import 'package:ashkerty_food/static/leadinButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:form_builder_file_picker/form_builder_file_picker.dart';

final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

class AddSpieces extends StatefulWidget {
  AddSpieces({super.key,});

  @override
  State<AddSpieces> createState() => _AddSpiecesState();
}

class _AddSpiecesState extends State<AddSpieces> {
  bool isLoading = false;
  File? file;

  //--add client
  Future addSpieces(name ,price, category, file) async {
    setState(() {
      isLoading = true;
    });
    //call the api
    final response = await APISpieces.add(name ,price, category, file);
    setState(() {
      isLoading = false;
    });

    if(response == true){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Center(child: Text('تمت اضافة الصنف بنجاح', style: TextStyle(fontSize: 19) ,)),
            backgroundColor: Colors.green,
          )
      );
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Center(child: Text('$response', style: TextStyle(fontSize: 19) )),
            backgroundColor: Colors.redAccent,
          )
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(backgroundColor: const Color(0xff20491a),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              size: 37,
              color: Colors.white,
            ),
            onPressed: (){
              Navigator.pushReplacementNamed(context, '/speices');
            },
          ),
          title: const Center(child: Text("اضافة صنف", style: TextStyle(fontSize: 25),)),
          actions: const [LeadingDrawerBtn(),],
        ),
        endDrawer: const MyDrawer(),
        body: Padding(
                padding: const EdgeInsets.only(left: 50.0, right: 50, bottom: 10, top: 10),
                child: ListView(
                  children: [
                    isLoading == true? SpinKitWave(
                      color: Colors.green,
                      size: 70.0,
                    ) : Text(''),
                    FormBuilder(
                      key: _formKey,
                      child : Column(
                          children: [
                            Container(
                              width: 500,
                              child: FormBuilderTextField(
                                name: 'name',
                                decoration: InputDecoration(labelText: 'الأسم'),
                                initialValue: null,
                                validator: FormBuilderValidators.required(errorText: 'الرجاء ادخال جميع الحقول'),
                              ),
                            ),
                            Container(
                              width: 500,
                              child: FormBuilderTextField(
                                name: 'price',
                                decoration: InputDecoration(labelText: 'السعر'),
                                initialValue: null,
                                validator: FormBuilderValidators.required(errorText: 'الرجاء ادخال جميع الحقول'),
                              ),
                            ),
                            Container(
                              width: 500,
                              child: FormBuilderDropdown(
                                name: 'category',
                                decoration: InputDecoration(labelText: 'اختر النوع'),
                                items: ['تقليدي', 'لحوم', 'اضافات', 'عصائر']
                                    .map((type) => DropdownMenuItem(
                                    value: type,
                                    child: Text('$type')
                                )).toList(),
                                validator: FormBuilderValidators.required(errorText: "الرجاء ادخال جميع الجقول"),
                              ),
                            ),
                            SizedBox(height: 20,),
                            Container(
                              height: 220,
                              width: 400,
                              child: FormBuilderFilePicker(
                                name: "file",
                                decoration: InputDecoration(labelText: "اضف الصورة"),
                                maxFiles: 1,
                                previewImages: true,
                                onChanged: (val) => print(val),
                                typeSelectors: [
                                  TypeSelector(
                                    type: FileType.image,
                                    selector: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(Icons.add_circle),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 8.0),
                                          child: Text("اختر الصورة"),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                                onFileLoading: (val) {
                                  print(val);
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0, top: 30),
                              child: Center(
                                child: SizedBox(
                                  height: 40,
                                  width: 300,
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.deepPurple,
                                      primary: Colors.white,
                                    ),
                                    child: Text('حفظ'),
                                    onPressed: (){
                                      if(_formKey.currentState!.saveAndValidate()){

                                        String name = _formKey.currentState!.value['name'];
                                        String price = _formKey.currentState!.value['price'];
                                        String category = _formKey.currentState!.value['category'];
                                        final file = _formKey.currentState!.value['file'];

                                        //server
                                        addSpieces(name ,price, category, file[0]);
                                        _formKey.currentState!.reset();
                                      }

                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

AddSpeicies_Modal (BuildContext context,) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: SimpleDialog(
          title: Center(child: Text(' إضافة الصنف')),
          children:[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: FormBuilder(
                key: _formKey,
                child: Column(
                  children: [
                    FormBuilderTextField(
                      name: 'name',
                      decoration: InputDecoration(labelText: 'الأسم'),
                      initialValue: null,
                      validator: FormBuilderValidators.required(errorText: 'الرجاء ادخال جميع الحقول'),
                    ),
                    FormBuilderTextField(
                      name: 'price',
                      decoration: InputDecoration(labelText: 'السعر'),
                      initialValue: null,
                      validator: FormBuilderValidators.required(errorText: 'الرجاء ادخال جميع الحقول'),
                    ),
                    FormBuilderTextField(
                      name: 'imageLink',
                      decoration: InputDecoration(labelText: 'الصورة'),
                      initialValue: null,
                      validator: FormBuilderValidators.required(errorText: 'الرجاء ادخال جميع الحقول'),
                    ),
                    FormBuilderTextField(
                      name: 'type',
                      decoration: InputDecoration(labelText: 'النوع'),
                      initialValue: null,
                      validator: FormBuilderValidators.required(errorText: 'الرجاء ادخال جميع الحقول'),
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
                                data['name'] = _formKey.currentState!.value['name'];
                                data['price'] = _formKey.currentState!.value['price'];
                                data['imageLink'] = _formKey.currentState!.value['imageLink'];
                                data['type'] = _formKey.currentState!.value['type'];
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

