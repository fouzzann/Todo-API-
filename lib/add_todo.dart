import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddToDoPage extends StatefulWidget {
  const AddToDoPage({Key? key}) : super(key: key);

  @override
  State<AddToDoPage> createState() => _AddToDoPageState();
}

class _AddToDoPageState extends State<AddToDoPage> {
  final _formKey = GlobalKey<FormState>(); // Add a GlobalKey for the Form

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.teal[200],
        ),
        backgroundColor: const Color.fromARGB(255, 56, 55, 55),
        title: Text(
          'Add Todo',
          style: TextStyle(
            color: Colors.teal[200],
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: Form(
        // Wrap your ListView with a Form widget
        key: _formKey, // Assign the GlobalKey to the Form
        child: ListView(
          padding: EdgeInsets.all(20),
          children: [
            TextFormField(
              // Use TextFormField instead of TextField for validation
              style: TextStyle(color: Colors.teal[100]),
              controller: titleController,
              decoration: InputDecoration(
                hintText: "Title",
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal),
                ),
              ),
              keyboardType: TextInputType.multiline,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            TextFormField(
              // Use TextFormField instead of TextField for validation
              style: TextStyle(color: Colors.teal[100]),
              controller: descriptionController,
              decoration: InputDecoration(
                hintText: "Description",
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal),
                ),
              ),
              keyboardType: TextInputType.multiline,
              minLines: 5,
              maxLines: 8,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Validate the form
                  Submit();
                }
              },
              child: Text(
                'Submit',
                style: TextStyle(color: Colors.black),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal[200],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> Submit() async {
    final title = titleController.text;
    final description = descriptionController.text;

    if (title.isEmpty) {
      showFailedMessage("Please enter a title");
      return;
    }

    if (description.isEmpty) {
      showFailedMessage("Please enter a description");
      return;
    }

    final body = jsonEncode({
      "title": title,
      "description": description,
      "is_completed": false
    });

    final url = 'https://api.nstack.in/v1/todos';
    final uri = Uri.parse(url);
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': "application/json",
      },
      body: body,
    );

    print(response.body);
    if (response.statusCode == 201) {
      showSuccessMessage("You have created the new List !");
      Navigator.pop(context);
    } else {
      showFailedMessage("Sorry the List was not added");
    }
    print(response.statusCode);
  }

  void showSuccessMessage(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showFailedMessage(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
