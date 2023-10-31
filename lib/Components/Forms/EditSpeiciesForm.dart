import 'package:ashkerty_food/API/Spieces.dart';
import 'package:ashkerty_food/models/speicies.dart';
import 'package:ashkerty_food/static/drawer.dart';
import 'package:ashkerty_food/static/leadinButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

class EditSpieces extends StatefulWidget {
  final Spieces data;
  const EditSpieces({super.key, required this.data});

  @override
  State<EditSpieces> createState() => _EditSpiecesState();
}

class _EditSpiecesState extends State<EditSpieces> {
  bool isLoading = false;

  //--add client
  Future editSpieces(data) async {
    setState(() {
      isLoading = true;
    });
    //call the api
    final response = await APISpieces.update(data);
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
        appBar: AppBar(
          backgroundColor: const Color(0xff20491a),
          leading: IconButton(
            icon: const Icon(
              Icons.home_sharp,
              size: 37,
              color: Colors.white,
            ),
            onPressed: (){
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
          title: const Center(child: Text("تعديل الصنف", style: TextStyle(fontSize: 25),)),
          actions: const [LeadingDrawerBtn(),],
        ),
        endDrawer: MyDrawer(),
        body: Padding(
              padding: const EdgeInsets.all(70.0),
              child: FormBuilder(
                key: _formKey,
                child: Column(
                  children: [
                    CircleAvatar(
                      child: Image.network('http://localhost:3000/${widget.data.ImgLink}'),
                      radius: 70,
                      backgroundColor: Colors.grey.shade300,
                    ),
                    isLoading == true? SpinKitWave(
                      color: Colors.green,
                      size: 50.0,
                    ) : Text(''),
                    Container(
                      width: 700,
                      child: FormBuilderTextField(
                        name: 'name',
                        decoration: InputDecoration(labelText: 'الأسم'),
                        initialValue: '${widget.data.name}',
                        validator: FormBuilderValidators.required(errorText: 'الرجاء ادخال جميع الحقول'),
                      ),
                    ),
                    Container(
                      width: 700,
                      child: FormBuilderTextField(
                        name: 'price',
                        decoration: InputDecoration(labelText: 'السعر'),
                        initialValue: '${widget.data.price}',
                        validator: FormBuilderValidators.required(errorText: 'الرجاء ادخال جميع الحقول'),
                      ),
                    ),
                    Container(
                      width: 700,
                      child: FormBuilderDropdown(
                        name: 'category',
                        decoration: InputDecoration(labelText: 'النوع'),
                        initialValue: widget.data.category.toString(),
                        items: ['تقليدي', 'لحوم', 'اضافات', 'عصائر']
                            .map((type) => DropdownMenuItem(
                            value: type,
                            child: Text('$type')
                        )).toList(),
                        validator: FormBuilderValidators.required(errorText: "الرجاء ادخال جميع الجقول"),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0, top: 50),
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
      ),
    );
  }
}

