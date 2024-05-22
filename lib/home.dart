import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:to_do_/add_todo.dart';

class MyUi extends StatefulWidget {
  const MyUi({Key? key}) : super(key: key);

  @override
  State<MyUi> createState() => _MyUiState();
}

class _MyUiState extends State<MyUi> {
  List<Map<String, dynamic>> items = [];

  @override
  void initState() {
    super.initState();
    fetchTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 56, 55, 55),
        title: Text(
          'Todo List',
          style: TextStyle(
            color: Colors.teal[200],
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: fetchTodo,
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
        
            return ListTile(
              leading: CircleAvatar(radius: 25 ,
                backgroundColor: Colors.teal[200],
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(
                item['title'],
                style: TextStyle(
                  color: Colors.teal[200],
                  fontSize: 19,
                  fontWeight: FontWeight.w500
                 ),
              ),
              subtitle: Text(
                item['description'],
                style: TextStyle(
                  color: Colors.teal[200],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: navigateToAddPage,
        label: Text(
          "Add Todo",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.teal[200],
      ),
    );
  }

  void navigateToAddPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddToDoPage()),
    );
    if (result == true) {
      fetchTodo();
    }
  }

  Future<void> fetchTodo() async {
    final url = 'https://api.nstack.in/v1/todos';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final result = json['items'] as List<dynamic>;
      final List<Map<String, dynamic>> typedItems =
          result.cast<Map<String, dynamic>>();
      setState(() {
        items = typedItems;
      });
    } else {
      print('Failed to load');
    }
    print(response.statusCode);
    print(response.body);
  }
}
