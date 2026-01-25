import 'dart:convert';
import 'package:ashkerty_food/API/Spieces.dart';
import 'package:ashkerty_food/API/Store.dart' as api;
import 'package:ashkerty_food/models/StockItem.dart';
import 'package:ashkerty_food/models/StoreAssociation.dart';
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
  List<StockItem> stores = [];

  List<StoreAssociation> _assocs = [];
  bool _assocsLoading = false;

  @override
  void initState() {
    super.initState();
    _loadAssocs();
    _loadStores();
  }

  Future _loadAssocs() async {
    setState(() => _assocsLoading = true);
    try {
      final res = await api.APIStore.getStoreSpice(widget.data.id.toString());
      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        List data = List.from(body);

        _assocs = data.map((e) => StoreAssociation.fromJson(e)).toList();
      }
    } catch (e) {
      // ignore for now
    }
    setState(() => _assocsLoading = false);
  }

  Future _loadStores() async {
    //call
    final res = await api.APIStore.getItems();
    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);
      List data = List.from(body);
      stores = data.map((e) => StockItem.fromJson(e)).toList();
    } else {
      // keep empty or show error
    }
  }

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
      await _loadAssocs();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Center(
            child: Text('$response', style: const TextStyle(fontSize: 19))),
        backgroundColor: Colors.redAccent,
      ));
    }
  }

  void _showForm({StoreAssociation? assoc}) {
    final storeCtrl = TextEditingController(text: assoc?.storeId ?? '');
    final spiceCtrl = TextEditingController(text: widget.data.name);

    final qtyCtrl = TextEditingController(
        text: assoc != null ? assoc.quantityNeeded.toString() : '');
    final formKey = GlobalKey<FormState>();

    showDialog(
        context: context,
        builder: (_) => StatefulBuilder(
              builder: (context, setState) => AlertDialog(
                title: Center(
                    child: Text(assoc == null
                        ? 'ربط الصنف بالمخزن'
                        : 'تعديل الربط بالمخزن')),
                content: Form(
                  key: formKey,
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            controller: spiceCtrl,
                            readOnly: true,
                            decoration:
                                const InputDecoration(labelText: 'الصنف'),
                            validator: (v) => (v == null || v.trim().isEmpty)
                                ? 'Required'
                                : null,
                          ),
                          DropdownButtonFormField<String>(
                            initialValue: assoc?.storeId,
                            decoration: InputDecoration(
                                labelText: assoc?.storeName ?? 'اختر المخزن'),
                            items: stores
                                .map((s) => DropdownMenuItem(
                                      value: s.id,
                                      child: Text(s.name),
                                    ))
                                .toList(),
                            onChanged: assoc != null
                                ? null
                                : (val) {
                                    storeCtrl.text = val ?? '';
                                  },
                            disabledHint: assoc != null
                                ? Text(assoc.storeName)
                                : const Text('اختر المخزن'),
                            validator: (v) =>
                                (v == null || v.isEmpty) ? 'Required' : null,
                          ),
                          TextFormField(
                            controller: qtyCtrl,
                            decoration: InputDecoration(
                                labelText: assoc != null && assoc.isKilo
                                    ? 'الكمية (كيلو)'
                                    : ' الكمية'),
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            validator: (v) => int.tryParse(v ?? '') == null
                                ? 'Invalid'
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'الغاء',
                        style: TextStyle(color: Colors.black),
                      )),
                  ElevatedButton(
                    onPressed: () async {
                      if (!formKey.currentState!.validate()) return;
                      final dto = {
                        'spiceId': widget.data.id,
                        'storeId': storeCtrl.text.trim(),
                        'quantityNeeded': int.parse(qtyCtrl.text.trim()),
                      };

                      Navigator.pop(context);
                      // call API
                      setState(() {
                        _assocsLoading = true;
                      });
                      try {
                        final res = await api.APIStore.addStoreSpice(dto);
                        if (res.statusCode == 200) {
                          await _loadAssocs();
                        } else {
                          // show error
                        }
                      } catch (e) {
                        // show error
                      } finally {
                        setState(() {
                          _assocsLoading = false;
                        });
                      }
                    },
                    child:
                        const Text('حفظ', style: TextStyle(color: Colors.teal)),
                  ),
                ],
              ),
            ));
  }

  void _confirmDelete(StoreAssociation it) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Center(child: Text('حذف العنصر')),
        content: Text(
          "سيتم حذف ${it.storeName} ولن يكون هناك صنف مرتبط به",
          textDirection: TextDirection.rtl,
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child:
                  const Text('الغاء', style: TextStyle(color: Colors.black))),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final res = await api.APIStore.deleteStoreSpice(
                  {'spiceId': it.spiceId, 'storeId': it.storeId});
              if (res.statusCode == 200) {
                await _loadAssocs();
              } else {
                //show error
              }
            },
            child: const Text('حذف', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left: the existing form (kept mostly unchanged)
                Expanded(
                  child: FormBuilder(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 5),
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
                            decoration:
                                const InputDecoration(labelText: 'الأسم'),
                            initialValue: widget.data.name,
                            validator: FormBuilderValidators.required(
                                errorText: 'الرجاء ادخال جميع الحقول'),
                          ),
                        ),
                        SizedBox(
                          width: 700,
                          child: FormBuilderTextField(
                            name: 'price',
                            decoration:
                                const InputDecoration(labelText: 'السعر'),
                            initialValue: '${widget.data.price}',
                            validator: FormBuilderValidators.required(
                                errorText: 'الرجاء ادخال جميع الحقول'),
                          ),
                        ),
                        SizedBox(
                          width: 700,
                          child: FormBuilderDropdown(
                            name: 'category',
                            decoration:
                                const InputDecoration(labelText: 'النوع'),
                            initialValue: widget.data.category.toString(),
                            items: ['لحوم', 'اضافات', 'عصائر']
                                .map((type) => DropdownMenuItem(
                                    value: type, child: Text(type)))
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
                                            fontSize: 19,
                                            color: Colors.redAccent),
                                      ),
                                      initialValue: false,
                                      onChanged: (val) {
                                        setState(() {
                                          cancelFav = val ?? false;
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 30),
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
                                  decoration: const InputDecoration(
                                      labelText: 'زر الكيبورد'),
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
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 20),
                                ),
                                onPressed: () {
                                  if (_formKey.currentState!
                                      .saveAndValidate()) {
                                    Map data = {};
                                    data['id'] = widget.data.id;
                                    data['name'] =
                                        _formKey.currentState!.value['name'];
                                    data['price'] =
                                        _formKey.currentState!.value['price'];
                                    data['category'] = _formKey
                                        .currentState!.value['category'];
                                    data['isFavourites'] = _formKey
                                        .currentState!.value['isFavourite'];
                                    data['favBtn'] =
                                        _formKey.currentState!.value['favBtn'];
                                    data['isControll'] = _formKey
                                        .currentState!.value['isControll'];
                                    data['cancel'] = _formKey
                                        .currentState!.value['cancelFav'];

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
                const SizedBox(width: 24),
                // Right: horizontal list of associated stores
                SizedBox(
                  width: 380,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'عناصر المخزن',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            onPressed: _showForm,
                            icon: const Icon(Icons.add),
                            tooltip: "اضافة ارتباط جديد",
                          )
                        ],
                      ),
                      const SizedBox(height: 12),
                      _assocsLoading
                          ? const Center(child: CircularProgressIndicator())
                          : _assocs.isEmpty
                              ? const Text('لا توجد مخازن مرتبطة')
                              : SizedBox(
                                  height: 700,
                                  child: ListView.separated(
                                    scrollDirection: Axis.vertical,
                                    itemCount: _assocs.length,
                                    separatorBuilder: (_, __) =>
                                        const SizedBox(width: 12),
                                    itemBuilder: (context, idx) {
                                      final a = _assocs[idx];
                                      return Card(
                                        elevation: 2,
                                        child: Container(
                                          width: 220,
                                          padding: const EdgeInsets.all(12),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(a.storeName,
                                                      style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  Row(
                                                    children: [
                                                      IconButton(
                                                          onPressed: () =>
                                                              _confirmDelete(a),
                                                          icon: const Icon(
                                                            Icons.delete,
                                                            color: Colors
                                                                .redAccent,
                                                          )),
                                                      IconButton(
                                                          onPressed: () =>
                                                              _showForm(
                                                                  assoc: a),
                                                          icon: const Icon(
                                                            Icons.edit,
                                                          )),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                  'الكمية المطلوبة: ${a.quantityNeeded}',
                                                  style: const TextStyle(
                                                      fontSize: 14)),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
