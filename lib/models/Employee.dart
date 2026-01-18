class Employee {
  Employee({
    required this.id,
    required this.name,
    required this.jobTitle,
    required this.shift,
    required this.fixedSalary,
    required this.salary,
    this.createdAt,
    this.updatedAt,
  });

  late final int id;
  late final String name;
  late final String jobTitle;
  late final String shift;
  late final double fixedSalary;
  late final double salary;
  late final String? createdAt;
  late final String? updatedAt;

  Employee.fromJson(Map<String, dynamic> json) {
    id = json['id'] is int ? json['id'] : int.parse(json['id'].toString());
    name = json['name'] ?? '';
    jobTitle = json['jobTitle'] ?? '';
    shift = json['shift'] ?? '';
    fixedSalary = json['fixed_salary'] is num
        ? (json['fixed_salary'] as num).toDouble()
        : double.tryParse(json['fixed_salary'].toString()) ?? 0.0;
    salary = json['salary'] is num
        ? (json['salary'] as num).toDouble()
        : double.tryParse(json['salary'].toString()) ?? 0.0;
    createdAt = json['createdAt']?.toString();
    updatedAt = json['updatedAt']?.toString();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['jobTitle'] = jobTitle;
    _data['shift'] = shift;
    _data['fixed_salary'] = fixedSalary;
    _data['salary'] = salary;
    if (createdAt != null) _data['createdAt'] = createdAt;
    if (updatedAt != null) _data['updatedAt'] = updatedAt;
    return _data;
  }
}
