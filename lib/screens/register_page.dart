import 'package:flutter/material.dart';
import 'package:app/db/db_helper.dart';
import '../models/user.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passController = TextEditingController();

  final DatabaseHelper db = DatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: passController,
              obscureText: true,
              decoration: InputDecoration(labelText: "Password"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                User user = User(
                  email: emailController.text.trim(),
                  password: passController.text.trim(),
                );

                // await db.registerUser(user);
                await db.insertUser({
                  'email': user.email,
                  'password': user.password,
                });


                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Registered Successfully")),
                );

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Text("Register"),
            ),
          ],
        ),
      ),
    );
  }
}










// import 'package:flutter/material.dart';
// // import '../db/db_helper.dart';
// import '../models/user.dart';
// import 'login_page.dart';
// import 'package:app/db/db_helper.dart';
// // import 'package:my_finance_app/db/db_helper.dart';



// class RegisterPage extends StatefulWidget {
//   @override
//   _RegisterPageState createState() => _RegisterPageState();
// }

// class _RegisterPageState extends State<RegisterPage> {
//   final emailController = TextEditingController();
//   final passController = TextEditingController();

//   final DBHelper db = DBHelper();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Register")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: emailController,
//               decoration: InputDecoration(labelText: "Email"),
//             ),
//             TextField(
//               controller: passController,
//               obscureText: true,
//               decoration: InputDecoration(labelText: "Password"),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () async {
//                 User user = User(
//                   email: emailController.text.trim(),
//                   password: passController.text.trim(),
//                 );

//                 await db.registerUser(user);

//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text("Registered Successfully")),
//                 );

//                 Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => LoginPage()));
//               },
//               child: Text("Register"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
