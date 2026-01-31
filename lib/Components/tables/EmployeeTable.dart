import 'package:flutter/material.dart';
import 'package:ashkerty_food/models/Employee.dart';
import 'package:ashkerty_food/static/formatter.dart';

class EmployeeTable extends StatefulWidget {
  final bool isAdmin;
  final List<Employee> employees;
  final void Function(Employee) onEdit;
  final void Function(Employee) onDelete;
  final void Function(Employee) onView;

  const EmployeeTable({
    required this.isAdmin,
    required this.employees,
    required this.onEdit,
    required this.onDelete,
    required this.onView,
    Key? key,
  }) : super(key: key);

  @override
  State<EmployeeTable> createState() => _EmployeeTableState();
}

class _EmployeeTableState extends State<EmployeeTable> {
  List<Employee> filtered = [];
  final TextEditingController _searchCtrl = TextEditingController();
  int _rowsPerPage = 5;

  @override
  void initState() {
    super.initState();
    filtered = List.from(widget.employees);
  }

  @override
  void didUpdateWidget(covariant EmployeeTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.employees != widget.employees) {
      filtered = List.from(widget.employees);
      if (_searchCtrl.text.trim().isNotEmpty) _applyFilter();
      setState(() {});
    }
  }

  void _applyFilter() {
    final q = _searchCtrl.text.toLowerCase().trim();
    if (q.isEmpty) {
      filtered = List.from(widget.employees);
    } else {
      filtered = widget.employees
          .where((emp) => emp.name.toLowerCase().contains(q))
          .toList();
    }
    // if (filtered.isNotEmpty && _rowsPerPage > filtered.length) {
    //   _rowsPerPage = filtered.length;
    // }
    setState(() {});
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                child: TextField(
                  controller: _searchCtrl,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'ايجاد موظف بالاسم .....'),
                  onChanged: (v) => _applyFilter(),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: PaginatedDataTable(
            columns: const [
              DataColumn(
                  label: Text('الاسم',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal))),
              DataColumn(
                  label: Text(' الوظيفة',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal))),
              DataColumn(
                  label: Text('الوردية',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal))),
              DataColumn(
                  label: Text('الراتب (جنيه)',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal))),
              DataColumn(
                  label: Text('الإجراءات',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal))),
            ],
            source: EmployeeDataSource(
              isAdmin: widget.isAdmin,
              filtered,
              onEdit: widget.onEdit,
              onDelete: widget.onDelete,
              onView: widget.onView,
            ),
            rowsPerPage: _rowsPerPage,
            availableRowsPerPage: const [5, 10, 25],
            onRowsPerPageChanged: (r) {
              setState(() {
                _rowsPerPage = r ?? _rowsPerPage;
              });
            },
            columnSpacing: 12.0,
            showCheckboxColumn: false,
            showEmptyRows: false,
          ),
        ),
      ],
    );
  }
}

class EmployeeDataSource extends DataTableSource {
  final bool isAdmin;
  final List<Employee> _data;
  final void Function(Employee) onEdit;
  final void Function(Employee) onDelete;
  final void Function(Employee) onView;

  EmployeeDataSource(this._data,
      {required this.isAdmin,
      required this.onEdit,
      required this.onDelete,
      required this.onView});

  @override
  DataRow? getRow(int index) {
    if (index >= _data.length) return null;
    final emp = _data[index];

    Widget cell(String text) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(text, style: const TextStyle(fontSize: 17)),
        );
    return DataRow.byIndex(
      index: index,
      color: WidgetStateProperty.resolveWith<Color?>((states) {
        return index.isEven ? Colors.grey.withOpacity(0.03) : null;
      }),
      cells: [
        DataCell(cell(emp.name)),
        DataCell(cell(emp.jobTitle)),
        DataCell(cell(emp.shift)),
        DataCell(cell("${numberFormatter(emp.salary)} (جنيه)")),
        DataCell(Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              if (isAdmin)
                Row(
                  children: [
                    IconButton(
                        icon: const Icon(Icons.edit, size: 18),
                        color: Colors.blueGrey,
                        onPressed: () => onEdit(emp)),
                    IconButton(
                        icon: const Icon(Icons.delete, size: 18),
                        color: Colors.redAccent,
                        onPressed: () => onDelete(emp)),
                  ],
                ),
              IconButton(
                  icon: const Icon(Icons.remove_red_eye, size: 18),
                  color: Colors.teal,
                  onPressed: () => onView(emp)),
            ],
          ),
        )),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _data.length;

  @override
  int get selectedRowCount => 0;
}
