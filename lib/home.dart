import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String apiKey = '18QBwoiRpbFgeYBSl3PxFHi2aoJjrt7lIindJfng';
  String imageUrl = '';
  String selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  bool isLoading = false;

  Future<void> getImage(String date) async {
    setState(() {
      isLoading = true;
    });
    final url =
        'https://api.nasa.gov/planetary/apod?date=$date&api_key=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data.containsKey('url')) {
        setState(() {
          imageUrl = data['url'];
        });
      } else {
        print('No image found for the selected date.');
        setState(() {
          imageUrl = '';
        });
      }
    } else {
      print('Failed');
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1995),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        selectedDate = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Caretutors Task')),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: isLoading
                    ? const CircularProgressIndicator()
                    : imageUrl.isNotEmpty
                        ? Image.network(imageUrl, fit: BoxFit.cover)
                        : const Text('No image available'),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () => selectDate(context),
                  child: const Text('Select Date', style: TextStyle(color: Colors.white),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // Rounded corners
                    ),

                  ),
                ),
                ElevatedButton(
                  onPressed: () => getImage(selectedDate),
                  child: const Text('Submit'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
