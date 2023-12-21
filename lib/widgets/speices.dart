import 'package:ashkerty_food/API/Spieces.dart';
import 'package:ashkerty_food/Components/Forms/AddSpeiciesForm.dart';
import 'package:ashkerty_food/static/drawer.dart';
import 'package:ashkerty_food/static/leadinButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';


import '../Components/tables/SpieciesTable.dart';

class Speices extends StatefulWidget {
  const Speices({super.key});

  @override
  State<Speices> createState() => _SpeicesState();
}

class _SpeicesState extends State<Speices> {
  List data = [];
  List<String> spieces_names = [];
  String? name;
  bool isLoading = false;

  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSpieces();
  }

  //future server functions
  Future getSpieces () async {
    setState(() {
      isLoading = true;
      data = [];
    });
    //call api
    final response = await APISpieces.Get();

    setState(() {
      isLoading = false;
    });

    if(response != false){
      setState(() {
        data = response;
      });
    }
  }
  //--find client
  Future _OnSubmit(name) async {
    setState(() {
      isLoading = true;
      data = [];
    });

    //call the api
    final response = await APISpieces.findOne(name);

    if(response != false){
      setState(() {
        isLoading = false;
        data = response;
      });
    }

  }

  //function to extract clients names
  Future extractName (List Clients) async {
    List<String> names = [];
    //iterate
    Clients.map((map) => map['name']).forEach((value) {
      names.add(value);
    });

    setState(() {
      spieces_names = names;
    });
  }

  @override
  Widget build(BuildContext context) {
    //extract names from clients
    extractName(data);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          leading: IconButton(
            icon: const Icon(
              Icons.home_work,
              size: 37,
              color: Colors.white,
            ),
            onPressed: (){
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
          title: const Center(child: Text("الاصناف", style: TextStyle(fontSize: 25),)),
          actions: const [LeadingDrawerBtn(),],
          toolbarHeight: 45,
        ),
          endDrawer: const MyDrawer(),
        body: ListView(
            children:[
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey[100]
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FormBuilder(
                        key: _formKey,
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8,8,40,20),
                              child: Container(
                                  height:50,
                                  width:300,
                                  decoration:BoxDecoration(
                                    color: const Color(0xffffffff),
                                    border: Border.all(
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: TypeAheadField(
                                    textFieldConfiguration: TextFieldConfiguration(
                                      autofocus: false,
                                      decoration: InputDecoration(
                                        label: Text('ابحث عن الاسم'),
                                      ),
                                    ),
                                    suggestionsCallback: (pattern) async {
                                      return spieces_names.where((option) => option.toLowerCase().contains(pattern.toLowerCase()));
                                    },
                                    itemBuilder: (context, suggestion) {
                                      return ListTile(
                                        title: Text(suggestion),
                                      );
                                    },
                                    onSuggestionSelected: (suggestion) {
                                      name = suggestion;
                                    },
                                  )
                              ),
                            ),
                            SizedBox(width: 25,),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: TextButton.icon(
                                  onPressed: (){
                                    if(_formKey.currentState!.saveAndValidate()){
                                      //send to server
                                      Map datas = {};
                                      datas['name'] = name;
                                      _OnSubmit(datas);
                                      setState(() {
                                        data = [];
                                      });
                                    }
                                  },
                                  icon: Icon(Icons.person_search),
                                  style: TextButton.styleFrom(
                                      backgroundColor: Colors.grey,
                                      primary: Colors.black,
                                      minimumSize: Size(100, 50)
                                  ),
                                  label: Text('ابحث')
                              ),
                            ),
                            SizedBox(width: 20,),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: TextButton.icon(
                                onPressed: () {
                                  getSpieces();
                                  setState(() {
                                    data = [];
                                  });
                                },
                                style: TextButton.styleFrom(
                                    backgroundColor: Colors.grey[300],
                                    minimumSize: Size(70, 50)
                                ),
                                label: Text('الكل', style: TextStyle(color: Colors.black, fontSize: 17),),
                                icon: const Icon(Icons.person_search_outlined, size: 30, color: Colors.red,),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8,0,8,10),
                        child: ElevatedButton.icon(
                            onPressed: (){
                              Navigator.push(context,
                              MaterialPageRoute(
                                  builder: (context) => AddSpieces()));
                          },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.teal
                            ),
                            label: Text('صنف جديد'),
                            icon: Icon(Icons.add_box_sharp,color: Color(0xff090c2d),size: 25,)
                        ),
                      ),
                    ],
                  ),
                  data.length != 0 || isLoading == false ?
                  Container(
                      color: Colors.grey[100],
                      child: SpeiciesTable(data: data)
                  ): Padding(
                    padding: const EdgeInsets.only(top: 190.0),
                    child: SpinKitPouringHourGlassRefined(
                      color: Colors.teal,
                      size: 70.0,
                    ),
                  ),
                ],
              ),
            ]
        ),
        bottomNavigationBar: BottomAppBar(
          child:Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  width:200,
                  height:70,
                  child: Text('عدد الاصناف=${data.length}',style: const TextStyle(fontSize: 24),)
              ),
            ],
          ),
        ),
      ),

    );
  }
}
