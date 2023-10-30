import 'package:ashkerty_food/API/Client.dart';
import 'package:ashkerty_food/Components/Forms/AddClientForm.dart';
import 'package:ashkerty_food/static/leadinButton.dart';
import 'package:flutter/material.dart';
import '../Components/tables/ClientTable.dart';
import '../static/drawer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Clients extends StatefulWidget {
  const Clients({super.key});

  @override
  State<Clients> createState() => _ClientsState();
}

class _ClientsState extends State<Clients> {
  List data = [];
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getClients();
  }

  //future server functions
  Future getClients () async {
    setState(() {
      isLoading = true;
      data = [];
    });
    //call api
    final response = await APIClient.Get();

    setState(() {
      isLoading = false;
    });

    if(response != false){
      setState(() {
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

    if(response == true){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Center(child: Text('تمت اضافة العميل بنجاح', style: TextStyle(fontSize: 19) ,)),
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

    //set state
    getClients();

  }


  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(backgroundColor: const Color(0xff20491a),
//custom button in static folder
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

        title: const Center(child: Text("العملاء", style: TextStyle(fontSize: 25),)),
        actions: const [LeadingDrawerBtn(),],
    ),
        //custom my drawer in static folder
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
                  const SizedBox(height: 50,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8,8,650,20),
                        child: Container(height:50,width:250,
                            decoration:BoxDecoration(
                              color: const Color(0xffffffff),
                              border: Border.all(
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(0),
                            ),
                            child: TextField(decoration: InputDecoration(
                                suffixIcon: IconButton(onPressed: () {  }, icon: Icon(Icons.person_search_sharp,size: 24,color: Color(0xff090c2d),),)
                            ),
                            )

                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8,0,8,10),
                        child: ElevatedButton.icon(
                          onPressed: (){
                            AddClient_Modal(addClient: addClient,).AddModal(context);
                          },
                          icon: Icon(Icons.add_box_sharp,color: Color(0xff090c2d),size: 25,),
                          label: Text('اضافة عميل'),
                        ),
                      ),
                    ],
                  ),
                  data.length != 0 && isLoading == false ?
                  Container(
                      color: Colors.grey[100],
                      child: ClientTable(data: data)
                  ): Padding(
                    padding: const EdgeInsets.only(top: 190.0),
                    child: SpinKitWave(
                        color: Colors.green,
                        size: 70.0,
                      ),
                  ),
                ],
              ),
            ]
        ),
      ),
    );
  }
}
