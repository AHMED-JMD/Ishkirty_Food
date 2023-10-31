import 'package:ashkerty_food/models/speicies.dart';
import 'package:flutter/material.dart';
//delete modal

class DeleteSpices extends StatelessWidget {
  final Function(Map) delete;
  final Spieces data;
  const DeleteSpices({super.key, required this.delete, required this.data});

  deletespeices(BuildContext context){
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: Center(child: Text('حذف صنف ${data.name} ')),
            content: Text('سيؤدي ذلك لضياع كل البيانات المتعلقة بالصنف',style: TextStyle(fontSize: 18,color: Color(0xffb00505),),),
            actions: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Center(
                  child: SizedBox(
                    height: 50,
                    width: 100,
                    child: TextButton(
                        child: Text('حذف',style: TextStyle(fontSize: 20,color: Colors.white),),
                        style: TextButton.styleFrom(
                            backgroundColor: Color(0xffb00505),
                            primary: Colors.white
                        ),
                        onPressed: (){
                          //call server
                          delete({'id': data.id});
                          Navigator.of(context).pop();
                        }
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
