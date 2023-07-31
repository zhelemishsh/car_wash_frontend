import 'package:flutter/material.dart';

class AccountMenuPage extends StatefulWidget {
  const AccountMenuPage({Key? key}) : super(key: key);

  @override
  AccountMenuPageState createState() {
    return AccountMenuPageState();
  }
}

class AccountMenuPageState extends State<AccountMenuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundImage: AssetImage("assets/goshan.jpg"),
                  radius: 40,
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Goshan"),
                      Text("4.01"),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}