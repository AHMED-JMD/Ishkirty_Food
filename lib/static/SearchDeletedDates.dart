import 'package:ashkerty_food/widgets/DeletedBills.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class SearchInDeletedDates extends StatefulWidget {
  const SearchInDeletedDates({super.key});

  @override
  State<SearchInDeletedDates> createState() => _SearchInDeletedDatesState();
}

class _SearchInDeletedDatesState extends State<SearchInDeletedDates> {

  GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  DateTime? start_date = DateTime.now();
  DateTime? end_date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints){
          if(constraints.maxWidth > 700){
            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 483,),
                Text('من : ', style: TextStyle(fontSize: 17),),
                SizedBox(width: 10,),
                Container(
                  width: 200,
                  child: FormBuilderDateTimePicker(
                    name: "start_date",
                    onChanged: (value){
                      setState(() {
                        start_date = value;
                      });
                    },
                    decoration: InputDecoration(
                        labelText: "البداية",
                        // border: OutlineInputBorder(
                        //   borderSide: BorderSide(
                        //     color: Colors.black,
                        //     width: 5,
                        //   ),
                        //   borderRadius: BorderRadius.circular(5.0),
                        // ),
                        suffixIcon: Icon(Icons.calendar_month, color: Colors.blueAccent,)
                    ),
                    validator: FormBuilderValidators.required(errorText: "الرجاء اختيار تاريخ محدد"),
                    initialDate: DateTime.now(),
                    inputType: InputType.date,
                  ),
                ),
                SizedBox(width: 20,),
                Text('الى : ', style: TextStyle(fontSize: 17),),
                SizedBox(width: 10,),
                Container(
                  width: 200,
                  child: FormBuilderDateTimePicker(
                    name: "end_date",
                    onChanged: (value){
                      setState(() {
                        end_date = value;
                      });
                    },
                    decoration: InputDecoration(
                        labelText: "النهاية",
                        // border: OutlineInputBorder(
                        //   borderSide: BorderSide(
                        //     color: Colors.black,
                        //     width: 5,
                        //   ),
                        //   borderRadius: BorderRadius.circular(5.0),
                        // ),
                        suffixIcon: Icon(Icons.calendar_month, color: Colors.blueAccent,)
                    ),
                    validator: FormBuilderValidators.required(errorText: "الرجاء اختيار تاريخ محدد"),
                    initialDate: DateTime.now(),
                    inputType: InputType.date,
                  ),
                ),
                SizedBox(width: 30,),
                // Add a submit button
                SizedBox(
                  width: 70,
                  height: 30,
                  child: ElevatedButton(
                    child: const Text('بحث',style: TextStyle(fontSize: 20,color: Colors.white),),
                    style: ElevatedButton.styleFrom(
                        primary: Color(0xff194867),
                        textStyle: TextStyle(fontSize: 18)
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.saveAndValidate()) {
                        //call to backend
                        Map datas = {};
                        datas['start_date'] = start_date!.toIso8601String();
                        datas['end_date'] = end_date!.toIso8601String();

                        // function
                        // GetDaily(datas);
                      }
                    },
                  ),
                ),
              ],

            );
          } else {
            if(constraints.maxWidth> 500){
              return Row(
                children: [
                  Text('من : ', style: TextStyle(fontSize: 17),),
                  SizedBox(width: 10,),
                  Container(
                    width: 130,
                    child: FormBuilderDateTimePicker(
                      name: "start_date",
                      onChanged: (value){
                        setState(() {
                          start_date = value;
                        });
                      },
                      decoration: InputDecoration(
                          labelText: "البداية",
                          // border: OutlineInputBorder(
                          //   borderSide: BorderSide(
                          //     color: Colors.black,
                          //     width: 5,
                          //   ),
                          //   borderRadius: BorderRadius.circular(5.0),
                          // ),
                          suffixIcon: Icon(Icons.calendar_month, color: Colors.blueAccent,)
                      ),
                      validator: FormBuilderValidators.required(errorText: "الرجاء اختيار تاريخ محدد"),
                      initialDate: DateTime.now(),
                      inputType: InputType.date,
                    ),
                  ),
                  SizedBox(width: 10,),
                  Text('الى : ', style: TextStyle(fontSize: 17),),
                  SizedBox(width: 10,),
                  Container(
                    width: 130,
                    child: FormBuilderDateTimePicker(
                      name: "end_date",
                      onChanged: (value){
                        setState(() {
                          end_date = value;
                        });
                      },
                      decoration: InputDecoration(
                          labelText: "النهاية",
                          // border: OutlineInputBorder(
                          //   borderSide: BorderSide(
                          //     color: Colors.black,
                          //     width: 5,
                          //   ),
                          //   borderRadius: BorderRadius.circular(5.0),
                          // ),
                          suffixIcon: Icon(Icons.calendar_month, color: Colors.blueAccent,)
                      ),
                      validator: FormBuilderValidators.required(errorText: "الرجاء اختيار تاريخ محدد"),
                      initialDate: DateTime.now(),
                      inputType: InputType.date,
                    ),
                  ),
                  SizedBox(width: 10,),
                  // Add a submit button
                  SizedBox(
                    width: 80,
                    height: 50,
                    child: ElevatedButton(
                      child: Text('ارسال'),
                      style: ElevatedButton.styleFrom(
                          primary: Colors.blueGrey,
                          textStyle: TextStyle(fontSize: 18)
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.saveAndValidate()) {
                          //call to backend
                          Map datas = {};
                          datas['start_date'] = start_date!.toIso8601String();
                          datas['end_date'] = end_date!.toIso8601String();

                          // function
                          // GetDaily(datas);
                        }
                      },
                    ),
                  ),
                ],
              );
            }else{
              return Column(
                children: [
                  Text('من : ', style: TextStyle(fontSize: 17),),
                  Container(
                    width: 200,
                    child: FormBuilderDateTimePicker(
                      name: "start_date",
                      onChanged: (value){
                        setState(() {
                          start_date = value;
                        });
                      },
                      decoration: InputDecoration(
                          labelText: "البداية",
                          // border: OutlineInputBorder(
                          //   borderSide: BorderSide(
                          //     color: Colors.black,
                          //     width: 5,
                          //   ),
                          //   borderRadius: BorderRadius.circular(5.0),
                          // ),
                          suffixIcon: Icon(Icons.calendar_month, color: Colors.blueAccent,)
                      ),
                      validator: FormBuilderValidators.required(errorText: "الرجاء اختيار تاريخ محدد"),
                      initialDate: DateTime.now(),
                      inputType: InputType.date,
                    ),
                  ),
                  SizedBox(height: 10,),
                  Text('الى : ', style: TextStyle(fontSize: 17),),
                  Container(
                    width: 200,
                    child: FormBuilderDateTimePicker(
                      name: "end_date",
                      onChanged: (value){
                        setState(() {
                          end_date = value;
                        });
                      },
                      decoration: InputDecoration(
                          labelText: "النهاية",
                          // border: OutlineInputBorder(
                          //   borderSide: BorderSide(
                          //     color: Colors.black,
                          //     width: 5,
                          //   ),
                          //   borderRadius: BorderRadius.circular(5.0),
                          // ),
                          suffixIcon: Icon(Icons.calendar_month, color: Colors.blueAccent,)
                      ),
                      validator: FormBuilderValidators.required(errorText: "الرجاء اختيار تاريخ محدد"),
                      initialDate: DateTime.now(),
                      inputType: InputType.date,
                    ),
                  ),
                  SizedBox(height: 10,),
                  // Add a submit button
                  SizedBox(
                    width: 80,
                    height: 50,
                    child: ElevatedButton(
                      child: Text('ارسال'),
                      style: ElevatedButton.styleFrom(
                          primary: Colors.blueGrey,
                          textStyle: TextStyle(fontSize: 18)
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.saveAndValidate()) {
                          //call to backend
                          Map datas = {};
                          datas['start_date'] = start_date!.toIso8601String();
                          datas['end_date'] = end_date!.toIso8601String();

                          // function
                          // GetDaily(datas);
                        }
                      },
                    ),
                  ),
                ],
              );
            }
          }
        }
    );
  }
}
