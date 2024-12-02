import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'database_helper.dart';

class CreateRequestPage extends StatefulWidget {
  @override
  _CreateRequestPageState createState() => _CreateRequestPageState();
}

class _CreateRequestPageState extends State<CreateRequestPage> {
  final TextEditingController carModelController = TextEditingController();
  final TextEditingController issueDescriptionController = TextEditingController();
  final TextEditingController ownerNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      locale: const Locale('ru', ''), // Устанавливаем русский язык
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  Future<void> _saveRequest() async {
    if (selectedDate == null || selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Пожалуйста, выберите дату и время')),
      );
      return;
    }

    String formattedDate = DateFormat('dd.MM.yyyy').format(selectedDate!);
    String formattedTime = selectedTime!.format(context);

    Map<String, dynamic> repairRequest = {
      'ownerName': ownerNameController.text,
      'phoneNumber': phoneNumberController.text,
      'carModel': carModelController.text,
      'issueDescription': issueDescriptionController.text,
      'date': formattedDate,
      'time': formattedTime,
    };

    await DatabaseHelper().insertRepairRequest(repairRequest);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Заявка успешно сохранена')),
    );

    ownerNameController.clear();
    phoneNumberController.clear();
    carModelController.clear();
    issueDescriptionController.clear();
    setState(() {
      selectedDate = null;
      selectedTime = null;
    });

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = selectedDate != null
        ? DateFormat('dd.MM.yyyy').format(selectedDate!)
        : 'Выберите дату';
    String formattedTime = selectedTime != null
        ? selectedTime!.format(context)
        : 'Выберите время';

    return Scaffold(
      appBar: AppBar(
        title: Text('Создание заявки на ремонт'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: ownerNameController,
                decoration: InputDecoration(
                  labelText: 'Имя владельца',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: phoneNumberController,
                decoration: InputDecoration(
                  labelText: 'Номер телефона',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 16),
              TextField(
                controller: carModelController,
                decoration: InputDecoration(
                  labelText: 'Модель автомобиля',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: issueDescriptionController,
                decoration: InputDecoration(
                  labelText: 'Описание проблемы',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _selectDate(context),
                      child: Text(formattedDate),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _selectTime(context),
                      child: Text(formattedTime),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: _saveRequest,
                  child: Text('Отправить заявку'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
