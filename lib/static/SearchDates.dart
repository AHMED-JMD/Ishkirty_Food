import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class SearchInDates extends StatefulWidget {
  final Function(Map) searchDates;
  const SearchInDates({super.key, required this.searchDates});

  @override
  State<SearchInDates> createState() => _SearchInDatesState();
}

class _SearchInDatesState extends State<SearchInDates> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  DateTime? start_date = DateTime.now();
  DateTime? end_date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      if (constraints.maxWidth > 700) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 38.0),
              child: FormBuilder(
                key: _formKey,
                child: Row(
                  children: [
                    const Text(
                      'من : ',
                      style: TextStyle(fontSize: 17),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 200,
                      child: FormBuilderDateTimePicker(
                        name: "start_date",
                        onChanged: (value) {
                          setState(() {
                            start_date = value;
                          });
                        },
                        decoration: const InputDecoration(
                            labelText: "البداية",
                            suffixIcon: Icon(
                              Icons.calendar_month,
                              color: Colors.blueAccent,
                            )),
                        validator: FormBuilderValidators.required(
                            errorText: "الرجاء اختيار تاريخ محدد"),
                        initialDate: DateTime.now(),
                        inputType: InputType.date,
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    const Text(
                      'الى : ',
                      style: TextStyle(fontSize: 17),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 200,
                      child: FormBuilderDateTimePicker(
                        name: "end_date",
                        onChanged: (value) {
                          setState(() {
                            end_date = value;
                          });
                        },
                        decoration: const InputDecoration(
                            labelText: "النهاية",
                            suffixIcon: Icon(
                              Icons.calendar_month,
                              color: Colors.blueAccent,
                            )),
                        validator: FormBuilderValidators.required(
                            errorText: "الرجاء اختيار تاريخ محدد"),
                        initialDate: DateTime.now(),
                        inputType: InputType.date,
                      ),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    // Add a submit button
                    SizedBox(
                      height: 40,
                      child: TextButton.icon(
                        label: const Text(
                          'بحث',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.teal,
                              fontWeight: FontWeight.bold),
                        ),
                        icon: const Icon(
                          Icons.search,
                          color: Colors.teal,
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.saveAndValidate()) {
                            //call to backend
                            Map datas = {};
                            datas['start_date'] = start_date!.toIso8601String();
                            datas['end_date'] = end_date!.toIso8601String();

                            // function
                            widget.searchDates(datas);
                            _formKey.currentState!.reset();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      } else {
        if (constraints.maxWidth > 500) {
          return Row(
            children: [
              const Text(
                'من : ',
                style: TextStyle(fontSize: 17),
              ),
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                width: 130,
                child: FormBuilderDateTimePicker(
                  name: "start_date",
                  onChanged: (value) {
                    setState(() {
                      start_date = value;
                    });
                  },
                  decoration: const InputDecoration(
                      labelText: "البداية",
                      suffixIcon: Icon(
                        Icons.calendar_month,
                        color: Colors.blueAccent,
                      )),
                  validator: FormBuilderValidators.required(
                      errorText: "الرجاء اختيار تاريخ محدد"),
                  initialDate: DateTime.now(),
                  inputType: InputType.date,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              const Text(
                'الى : ',
                style: TextStyle(fontSize: 17),
              ),
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                width: 130,
                child: FormBuilderDateTimePicker(
                  name: "end_date",
                  onChanged: (value) {
                    setState(() {
                      end_date = value;
                    });
                  },
                  decoration: const InputDecoration(
                      labelText: "النهاية",
                      suffixIcon: Icon(
                        Icons.calendar_month,
                        color: Colors.blueAccent,
                      )),
                  validator: FormBuilderValidators.required(
                      errorText: "الرجاء اختيار تاريخ محدد"),
                  initialDate: DateTime.now(),
                  inputType: InputType.date,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              // Add a submit button
              SizedBox(
                width: 80,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 18)),
                  onPressed: () {
                    if (_formKey.currentState!.saveAndValidate()) {
                      //call to backend
                      Map datas = {};
                      datas['start_date'] = start_date!.toIso8601String();
                      datas['end_date'] = end_date!.toIso8601String();

                      // function
                      widget.searchDates(datas);
                      _formKey.currentState!.reset();
                    }
                  },
                  child: const Text('ارسال'),
                ),
              ),
            ],
          );
        } else {
          return Column(
            children: [
              const Text(
                'من : ',
                style: TextStyle(fontSize: 17),
              ),
              SizedBox(
                width: 200,
                child: FormBuilderDateTimePicker(
                  name: "start_date",
                  onChanged: (value) {
                    setState(() {
                      start_date = value;
                    });
                  },
                  decoration: const InputDecoration(
                      labelText: "البداية",
                      suffixIcon: Icon(
                        Icons.calendar_month,
                        color: Colors.blueAccent,
                      )),
                  validator: FormBuilderValidators.required(
                      errorText: "الرجاء اختيار تاريخ محدد"),
                  initialDate: DateTime.now(),
                  inputType: InputType.date,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'الى : ',
                style: TextStyle(fontSize: 17),
              ),
              SizedBox(
                width: 200,
                child: FormBuilderDateTimePicker(
                  name: "end_date",
                  onChanged: (value) {
                    setState(() {
                      end_date = value;
                    });
                  },
                  decoration: const InputDecoration(
                      labelText: "النهاية",
                      suffixIcon: Icon(
                        Icons.calendar_month,
                        color: Colors.blueAccent,
                      )),
                  validator: FormBuilderValidators.required(
                      errorText: "الرجاء اختيار تاريخ محدد"),
                  initialDate: DateTime.now(),
                  inputType: InputType.date,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              // Add a submit button
              SizedBox(
                width: 80,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 18)),
                  onPressed: () {
                    if (_formKey.currentState!.saveAndValidate()) {
                      //call to backend
                      Map datas = {};
                      datas['start_date'] = start_date!.toIso8601String();
                      datas['end_date'] = end_date!.toIso8601String();

                      // function
                      widget.searchDates(datas);
                      _formKey.currentState!.reset();
                    }
                  },
                  child: const Text('ارسال'),
                ),
              ),
            ],
          );
        }
      }
    });
  }
}
