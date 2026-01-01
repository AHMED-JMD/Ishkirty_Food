import 'package:ashkerty_food/API/Client.dart';
import 'package:ashkerty_food/Components/Forms/AddClientForm.dart';
import 'package:ashkerty_food/providers/Auth_provider.dart';
import 'package:ashkerty_food/static/leadinButton.dart';
import 'package:flutter/material.dart';
import '../Components/tables/ClientTable.dart';
import '../static/drawer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

class Clients extends StatefulWidget {
  const Clients({super.key});

  @override
  State<Clients> createState() => _ClientsState();
}

class _ClientsState extends State<Clients> {
  List data = [];
  List<String> clientsNames = [];
  String? name;
  bool isLoading = false;

  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();
    getClients();
  }

  //future server functions
  Future getClients() async {
    setState(() {
      isLoading = true;
      data = [];
    });
    //call api
    final response = await APIClient.Get();

    if (response != false) {
      setState(() {
        isLoading = false;
        data = response;
      });
    }
  }

  //--add client
  Future addClient(data) async {
    setState(() {
      isLoading = true;
    });
    //call the api
    final response = await APIClient.add(data);
    setState(() {
      isLoading = false;
    });

    if (response == true) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Center(
            child: Text(
          'تمت اضافة العميل بنجاح',
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

    //set state
    getClients();
  }

  //--find client
  Future onSubmit(name) async {
    setState(() {
      isLoading = true;
      data = [];
    });

    //call the api
    final response = await APIClient.FindOne(name);

    if (response != false) {
      setState(() {
        isLoading = false;
        data = response;
      });
    }
  }

  //function to extract clients names
  Future extractName(List clients) async {
    List<String> names = [];
    //iterate
    clients.map((map) => map['name']).forEach((value) {
      names.add(value);
    });

    setState(() {
      clientsNames = names;
    });
  }

  @override
  Widget build(BuildContext context) {
    //extract names from clients
    extractName(data);

    return Consumer<AuthProvider>(builder: (context, value, child) {
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
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/home');
              },
            ),
            title: const Center(
                child: Text(
              "العملاء",
              style: TextStyle(fontSize: 25),
            )),
            actions: const [
              LeadingDrawerBtn(),
            ],
          ),
          //custom my drawer in static folder
          endDrawer: const MyDrawer(),
          body: ListView(children: [
            Container(
              decoration: BoxDecoration(color: Colors.grey[100]),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FormBuilder(
                      key: _formKey,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 8, 40, 20),
                            child: Container(
                                height: 50,
                                width: 300,
                                decoration: BoxDecoration(
                                  color: const Color(0xffffffff),
                                  border: Border.all(
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: TypeAheadField(
                                  textFieldConfiguration:
                                      const TextFieldConfiguration(
                                    autofocus: false,
                                    decoration: InputDecoration(
                                      label: Text('ابحث عن الاسم'),
                                    ),
                                  ),
                                  suggestionsCallback: (pattern) async {
                                    return clientsNames.where((option) => option
                                        .toLowerCase()
                                        .contains(pattern.toLowerCase()));
                                  },
                                  itemBuilder: (context, suggestion) {
                                    return ListTile(
                                      title: Text(suggestion),
                                    );
                                  },
                                  onSuggestionSelected: (suggestion) {
                                    name = suggestion;
                                  },
                                )),
                          ),
                          const SizedBox(
                            width: 25,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: TextButton.icon(
                                onPressed: () {
                                  if (_formKey.currentState!
                                      .saveAndValidate()) {
                                    //send to server
                                    Map datas = {};
                                    datas['name'] = name;
                                    onSubmit(datas);
                                    setState(() {
                                      data = [];
                                    });
                                  }
                                },
                                icon: const Icon(Icons.person_search,
                                    color: Colors.black),
                                style: TextButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(
                                        255, 189, 187, 187),
                                    minimumSize: const Size(100, 50)),
                                label: const Text(
                                  'ابحث',
                                  style: TextStyle(color: Colors.black),
                                )),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: TextButton.icon(
                              onPressed: () {
                                getClients();
                                setState(() {
                                  data = [];
                                });
                              },
                              style: TextButton.styleFrom(
                                  backgroundColor: Colors.grey[300],
                                  minimumSize: const Size(70, 50)),
                              label: const Text(
                                'الكل',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 17),
                              ),
                              icon: const Icon(
                                Icons.person_search_outlined,
                                size: 30,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 10),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          AddClient_Modal(
                            addClient: addClient,
                          ).AddModal(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                        ),
                        icon: const Icon(
                          Icons.add_box_sharp,
                          color: Color(0xff090c2d),
                          size: 25,
                        ),
                        label: const Text(
                          'اضافة عميل',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                data.isNotEmpty || isLoading == false
                    ? Container(
                        color: Colors.grey[100], child: ClientTable(data: data))
                    : const Padding(
                        padding: EdgeInsets.only(top: 190.0),
                        child: SpinKitPouringHourGlassRefined(
                          color: Colors.teal,
                          size: 70.0,
                        ),
                      ),
              ],
            ),
          ]),
        ),
      );
    });
  }
}
