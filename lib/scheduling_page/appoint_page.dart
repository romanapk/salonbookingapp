import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import '../colors/app_colors.dart';

class HiveDashboardScreen extends StatefulWidget {
  const HiveDashboardScreen({Key? key}) : super(key: key);

  @override
  State<HiveDashboardScreen> createState() => _HiveDashboardScreenState();
}

class _HiveDashboardScreenState extends State<HiveDashboardScreen> {
  List<Map<String, dynamic>> record = [];
  late Box<Map<String, dynamic>> patRecord;
  late TextEditingController patientnameController;
  late TextEditingController problemnameController;
  late TextEditingController dateController;
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    openHiveBox();
    patientnameController = TextEditingController();
    problemnameController = TextEditingController();
    dateController = TextEditingController();
  }

  Future<void> openHiveBox() async {
    patRecord = await Hive.openBox('Patients_Record');
    refreshItem();
  }

  void refreshItem() {
    if (!patRecord.isOpen) {
      return;
    }

    final data = patRecord.keys.map((key) {
      final item = patRecord.get(key);
      return {
        "key": key,
        "name": item!["name"],
        "problem": item["problem"],
        "date": item["date"]
      };
    }).toList();

    setState(() {
      record = data.reversed.toList();
      print(record.length);
    });
  }

  void showForm(BuildContext context, int? itemKey) async {
    if (itemKey != null) {
      final existingItem =
          record.firstWhere((element) => element['key'] == itemKey);
      patientnameController.text = existingItem['name'];
      problemnameController.text = existingItem['problem'];
      dateController.text = existingItem['date'];
    }

    showModalBottomSheet(
      context: context,
      elevation: 5,
      isScrollControlled: true,
      builder: (_) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 15,
          left: 15,
          right: 15,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              controller: patientnameController,
              decoration: const InputDecoration(
                hintText: "Customer Name",
                labelText: "Name",
                labelStyle: TextStyle(color: AppColors.baseColor),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: problemnameController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                hintText: "Services",
                labelText: "Services ",
                labelStyle: TextStyle(color: AppColors.baseColor),
              ),
            ),
            const SizedBox(height: 10),
            DateTimeField(
              controller: dateController,
              format: DateFormat(
                "yyyy-MM-dd HH:mm",
              ),
              onShowPicker: (context, currentValue) async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: currentValue ?? DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );

                if (date != null) {
                  final time = await showTimePicker(
                    context: context,
                    initialTime:
                        TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                    initialEntryMode: TimePickerEntryMode.dial,
                  );

                  if (time != null) {
                    selectedDate = DateTime(
                      date.year,
                      date.month,
                      date.day,
                      time.hour,
                      time.minute,
                    );

                    return selectedDate;
                  }
                }

                return currentValue;
              },
              decoration: const InputDecoration(
                hintText: "Select Date & Time",
                labelText: "Date & Time",
                labelStyle: TextStyle(color: AppColors.baseColor),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                if (itemKey == null) {
                  _createItem({
                    "name": patientnameController.text,
                    "problem": problemnameController.text,
                    "date": DateFormat("yyyy-MM-dd HH:mm").format(selectedDate),
                  });
                }
                if (itemKey != null) {
                  _updateItem(itemKey, {
                    'name': patientnameController.text.trim(),
                    'problem': problemnameController.text.trim(),
                    'date': DateFormat("yyyy-MM-dd HH:mm").format(selectedDate),
                  });
                }

                patientnameController.text = '';
                problemnameController.text = '';
                dateController.text = '';
                Navigator.of(context).pop();
              },
              child: const Text("Add Appointments"),
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  Future<void> _createItem(Map<String, dynamic> newRecord) async {
    await patRecord.add(newRecord);
    refreshItem();
  }

  Future<void> _updateItem(int itemKey, Map<String, dynamic> item) async {
    await patRecord.put(itemKey, item);
    refreshItem();
  }

  Future<void> _deleteItem(int itemKey) async {
    await patRecord.delete(itemKey);
    refreshItem();

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text(
        'Appointment has been deleted',
        style: TextStyle(
          color: AppColors.textColor,
        ),
      ),
      backgroundColor: AppColors.lighterColor,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: ListView.builder(
        itemCount: record.length,
        itemBuilder: (_, index) {
          final currentItem = record[index];
          return Card(
            color: AppColors.lighterColor,
            margin: const EdgeInsets.all(10),
            elevation: 3,
            child: ListTile(
              title: Text(
                currentItem['name'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textColor,
                ),
              ),
              subtitle: Text(
                " Customer Service: ${currentItem['problem']}   date: ${currentItem['date']}",
                style: const TextStyle(
                  color: AppColors.textColor,
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.edit,
                      color: AppColors.textColor,
                    ),
                    onPressed: () =>
                        showForm(context, currentItem['key'] as int?),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: AppColors.textColor,
                    ),
                    onPressed: () => _deleteItem(currentItem['key'] as int),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showForm(context, null),
        backgroundColor: AppColors.darkerColor,
        child: const Icon(
          Icons.add,
          color: AppColors.textColor,
        ),
      ),
    );
  }
}
