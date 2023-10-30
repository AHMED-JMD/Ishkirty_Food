import 'package:ashkerty_food/API/Spieces.dart';
import 'package:ashkerty_food/Components/Forms/AddSpeiciesForm.dart';
import 'package:ashkerty_food/static/drawer.dart';
import 'package:ashkerty_food/static/leadinButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


import '../Components/tables/SpieciesTable.dart';
import '../models/speicies.dart';

class Speices extends StatefulWidget {
  const Speices({super.key});

  @override
  State<Speices> createState() => _SpeicesState();
}

class _SpeicesState extends State<Speices> {
  List data = [];
  bool isLoading = false;

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
          title: const Center(child: Text("الاصناف", style: TextStyle(fontSize: 25),)),
        actions: const [LeadingDrawerBtn(),],
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
                                suffixIcon: IconButton(onPressed: () {  }, icon: Icon(Icons.search_sharp,size: 24,color: Color(0xff090c2d),),)
                            ),
                            )

                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8,0,8,10),
                        child: ElevatedButton.icon(
                            onPressed: (){
                          Navigator.push(context,
                              MaterialPageRoute(
                                  builder: (context) => AddSpieces())
                          );
                          },
                            label: Text('صنف جديد'),
                            icon: Icon(Icons.add_box_sharp,color: Color(0xff090c2d),size: 25,)),
                      ),
                    ],
                  ),
                  data.length != 0 && isLoading == false ?
                  Container(
                      color: Colors.grey[100],
                      child: SpeiciesTable(data: data)
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
        bottomNavigationBar: BottomAppBar(
          child:Row(
            mainAxisAlignment: MainAxisAlignment.center,
            // children: [SizedBox(width:200,height:70,child: Text('عدد الاصناف=$number_of_spiecies',style: const TextStyle(fontSize: 24),)),],
          ),
        ),
      ),

    );
  }
}
