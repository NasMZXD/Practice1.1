import 'package:flutter/material.dart';
import 'database_helper.dart';

class EditRequestPage extends StatefulWidget {
  final Map<String, dynamic> request;

  EditRequestPage({required this.request});

  @override
  _EditRequestPageState createState() => _EditRequestPageState();
}

class _EditRequestPageState extends State<EditRequestPage> {
  late TextEditingController ownerNameController;
  late TextEditingController phoneNumberController;
  late TextEditingController carModelController;
  late TextEditingController issueDescriptionController;

  @override
  void initState() {
    super.initState();
    ownerNameController =
        TextEditingController(text: widget.request['ownerName']);
    phoneNumberController =
        TextEditingController(text: widget.request['phoneNumber']);
    carModelController = TextEditingController(text: widget.request['carModel']);
    issueDescriptionController =
        TextEditingController(text: widget.request['issueDescription']);
  }

  Future<void> _saveChanges() async {
    Map<String, dynamic> updatedRequest = {
      'ownerName': ownerNameController.text,
      'phoneNumber': phoneNumberController.text,
      'carModel': carModelController.text,
      'issueDescription': issueDescriptionController.text,
    };

    await DatabaseHelper().updateRequest(widget.request['id'], updatedRequest);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Заявка успешно обновлена')),
    );

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Редактирование заявки'),
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
              SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: _saveChanges,
                  child: Text('Сохранить изменения'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
