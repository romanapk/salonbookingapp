import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

class Appointment {
  final String serviceName;
  final DateTime dateTime;

  Appointment({required this.serviceName, required this.dateTime});
}

class SpecialistDetailsPage extends StatefulWidget {
  final String name;
  final String imagePath;

  const SpecialistDetailsPage({Key? key, required this.name, required this.imagePath}) : super(key: key);

  @override
  State<SpecialistDetailsPage> createState() => _SpecialistDetailsPageState();
}

class _SpecialistDetailsPageState extends State<SpecialistDetailsPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final format = DateFormat("yyyy-MM-dd HH:mm");

  List<String> selectedServices = [];
  List<Appointment> appointments = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: AssetImage(widget.imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Select Services',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Wrap(
                spacing: 8.0,
                children: buildServiceChips(),
              ),
              SizedBox(height: 20),
              DateTimeField(
                controller: _dateController,
                format: format,
                onChanged: (dateTime) {
                  // Do something with the selected date
                },
                onShowPicker: (context, currentValue) async {
                  final date = await showDatePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    initialDate: currentValue ?? DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (date != null) {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                    );
                    return DateTimeField.combine(date, time);
                  } else {
                    return currentValue;
                  }
                },
                decoration: InputDecoration(
                  labelText: 'Date & Time',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Perform booking logic here
                    saveAppointment();
                  }
                },
                child: Text('Book Appointment'),
              ),
              SizedBox(height: 20),
              Text(
                'Appointments:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              buildAppointmentsList(),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> buildServiceChips() {
    return [
      buildServiceChip('Hair Cut'),
      buildServiceChip('Hair Style'),
      buildServiceChip('Hair Color'),
      buildServiceChip('Hair Massage'),
      // Add more services as needed
    ];
  }

  Widget buildServiceChip(String serviceName) {
    final isSelected = selectedServices.contains(serviceName);
    return ActionChip(
      label: Text(serviceName),
      onPressed: () {
        setState(() {
          if (isSelected) {
            selectedServices.remove(serviceName);
          } else {
            selectedServices.add(serviceName);
          }
        });
      },
      backgroundColor: isSelected ? Colors.blue : Colors.grey,
    );
  }

  void saveAppointment() {
    final appointment = Appointment(
      serviceName: selectedServices.join(', '),
      dateTime: format.parse(_dateController.text),
    );
    setState(() {
      appointments.add(appointment);
    });
  }

  Widget buildAppointmentsList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        final appointment = appointments[index];
        return ListTile(
          title: Text(appointment.serviceName),
          subtitle: Text(format.format(appointment.dateTime)),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              setState(() {
                appointments.removeAt(index);
              });
            },
          ),
        );
      },
    );
  }
}
