import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Response? getResponse;
  String error = "";
  bool isLoading = false;
  var getUrlController = TextEditingController();
  var getFormKey = GlobalKey<FormState>();
  Dio dio = Dio();

  @override
  void initState() {
    super.initState();
  }

  Future<void> getRequest() async {
    if (!getFormKey.currentState!.validate()) return;
    setState(() {
      isLoading = true;
      error = "";
      getResponse = null;
    });
    try {
      Response response = await dio.get(getUrlController.text);
      setState(() {
        getResponse = response;
        isLoading = false;
      });
    } catch (e) {
      String er = e.toString();
      if (e is DioException) {
        er = e.message ?? e.toString();
      }
      setState(() {
        error = er;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Flutter Web Api Test')),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: getFormKey,
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) return "Please Enter Url";
                    return null;
                  },
                  controller: getUrlController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter Url',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: getRequest,
              child: const Text("Get"),
            ),
            const Divider(),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Error: $error",
                                style: const TextStyle(color: Colors.red)),
                            const Divider(),
                            Text("Status Code: ${getResponse?.statusCode}"),
                            const Divider(),
                            Text("Headers: ${getResponse?.headers}"),
                            const Divider(),
                            Text("Result: ${getResponse?.data}",
                                style: const TextStyle(color: Colors.green)),
                          ],
                        ),
                      ),
                    ),
                  ),
          ],
        ));
  }
}
