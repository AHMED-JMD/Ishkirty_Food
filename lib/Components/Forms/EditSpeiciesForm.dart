import 'package:ashkerty_food/API/Spieces.dart';
import 'package:ashkerty_food/models/kebordKeys.dart';
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
  bool isFavourites = false;
  bool cancelFav = false;
  bool isControl = false;

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

    if (response == true) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Center(
            child: Text(
          'تمت تعديل الصنف بنجاح',
          style: TextStyle(fontSize: 19),
        )),
        backgroundColor: Colors.green,
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Center(
            child: Text('$response', style: const TextStyle(fontSize: 19))),
        backgroundColor: Colors.redAccent,
      ));
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
              Icons.arrow_back,
              size: 37,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/speices');
            },
          ),
          title: const Center(
              child: Text(
            "تعديل الصنف",
            style: TextStyle(fontSize: 25),
          )),
          actions: const [
            LeadingDrawerBtn(),
          ],
        ),
        endDrawer: const MyDrawer(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: FormBuilder(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  Image.network(
                    'http://localhost:3000/${widget.data.ImgLink}',
                    width: 200.0,
                    height: 150.0,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(
                    width: 700,
                    child: FormBuilderTextField(
                      name: 'name',
                      decoration: const InputDecoration(labelText: 'الأسم'),
                      initialValue: widget.data.name,
                      validator: FormBuilderValidators.required(
                          errorText: 'الرجاء ادخال جميع الحقول'),
                    ),
                  ),
                  SizedBox(
                    width: 700,
                    child: FormBuilderTextField(
                      name: 'price',
                      decoration: const InputDecoration(labelText: 'السعر'),
                      initialValue: '${widget.data.price}',
                      validator: FormBuilderValidators.required(
                          errorText: 'الرجاء ادخال جميع الحقول'),
                    ),
                  ),
                  SizedBox(
                    width: 700,
                    child: FormBuilderDropdown(
                      name: 'category',
                      decoration: const InputDecoration(labelText: 'النوع'),
                      initialValue: widget.data.category.toString(),
                      items: ['تقليدي', 'لحوم', 'اضافات', 'عصائر']
                          .map((type) =>
                              DropdownMenuItem(value: type, child: Text(type)))
                          .toList(),
                      validator: FormBuilderValidators.required(
                          errorText: "الرجاء ادخال جميع الجقول"),
                    ),
                  ),
                  widget.data.isFavourites
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 350,
                              child: FormBuilderCheckbox(
                                name: 'cancelFav',
                                title: const Text(
                                  'الغاء من المفضلة؟',
                                  style: TextStyle(
                                      fontSize: 19, color: Colors.redAccent),
                                ),
                                initialValue: false,
                                onChanged: (val) {
                                  setState(() {
                                    cancelFav = val ?? false;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 30,
                            ),
                            SizedBox(
                              width: 350,
                              child: FormBuilderCheckbox(
                                name: 'isFavourite',
                                title: const Text(
                                  'تغيير الزر؟',
                                  style: TextStyle(fontSize: 19),
                                ),
                                initialValue: false,
                                onChanged: (val) {
                                  setState(() {
                                    cancelFav = false;
                                    isFavourites = val ?? false;
                                  });
                                },
                              ),
                            ),
                          ],
                        )
                      : SizedBox(
                          width: 700,
                          child: FormBuilderCheckbox(
                            name: 'isFavourite',
                            title: const Text('اضافة للمفضلة',
                                style: TextStyle(fontSize: 19)),
                            initialValue: false,
                            onChanged: (val) {
                              setState(() {
                                isFavourites = val ?? false;
                              });
                            },
                          ),
                        ),
                  if (isFavourites)
                    SizedBox(
                      width: 700,
                      child: Column(
                        children: [
                          FormBuilderDropdown(
                            name: 'favBtn',
                            initialValue: '',
                            decoration:
                                const InputDecoration(labelText: 'زر الكيبورد'),
                            items: keyBoardList
                                .map((key) => DropdownMenuItem(
                                    value: key, child: Text('$key')))
                                .toList(),
                          ),
                          FormBuilderCheckbox(
                            name: 'isControll',
                            title: const Text('اضافة زر ctrl'),
                            initialValue: false,
                            onChanged: (val) {
                              setState(() {
                                isControl = val ?? false;
                              });
                            },
                          )
                        ],
                      ),
                    ),
                  isLoading == true
                      ? Container(
                          padding: const EdgeInsets.all(8),
                          color: Colors.grey[200],
                          width: 400,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'جاري المعالجة',
                                style: TextStyle(fontSize: 18),
                              ),
                              SpinKitThreeInOut(
                                color: Colors.black,
                                size: 30.0,
                              ),
                            ],
                          ),
                        )
                      : const Text(''),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0, top: 50),
                    child: Center(
                      child: SizedBox(
                        height: 40,
                        width: 300,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                          ),
                          child: const Text(
                            'حفظ',
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.saveAndValidate()) {
                              Map data = {};
                              data['id'] = widget.data.id;
                              data['name'] =
                                  _formKey.currentState!.value['name'];
                              data['price'] =
                                  _formKey.currentState!.value['price'];
                              data['category'] =
                                  _formKey.currentState!.value['category'];
                              data['isFavourites'] =
                                  _formKey.currentState!.value['isFavourite'];
                              data['favBtn'] =
                                  _formKey.currentState!.value['favBtn'];
                              data['isControll'] =
                                  _formKey.currentState!.value['isControll'];
                              data['cancel'] =
                                  _formKey.currentState!.value['cancelFav'];

                              //server
                              editSpieces(data);
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
      ),
    );
  }
}
