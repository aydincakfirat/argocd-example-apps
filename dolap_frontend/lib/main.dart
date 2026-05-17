import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MaterialApp(home: HomeScreen(), debugShowCheckedModeBanner: false));

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // KRİTİK NOKTA: Aynı K8s ağında olduğumuz için servis adını kullanıyoruz!
  final String apiUrl = "http://dolap-backend-app:8000/api/products";

  Future<List<dynamic>> getProducts() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception("Veriler alınamadı");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("İkinci El Kıyafetler"), backgroundColor: Colors.teal),
      body: FutureBuilder<List<dynamic>>(
        future: getProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return Center(child: Text("Hata: ${snapshot.error}"));

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final item = snapshot.data![index];
              return ListTile(
                leading: CircleAvatar(backgroundImage: NetworkImage(item['image_url'])),
                title: Text(item['title']),
                subtitle: Text("${item['price']} TL - Beden: ${item['size']}"),
              );
            },
          );
        },
      ),
    );
  }
}
