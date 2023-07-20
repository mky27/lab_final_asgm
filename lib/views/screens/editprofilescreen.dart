import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:barterit/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:barterit/myconfig.dart';

class EditProfileScreen extends StatefulWidget {
  final User user;

  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late double screenHeight, screenWidth, cardwitdh;
  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _phoneEditingController = TextEditingController();
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passEditingController = TextEditingController();
  final TextEditingController _pass2EditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameEditingController.text = widget.user.name.toString();
    _phoneEditingController.text = widget.user.phone.toString();
    _emailEditingController.text = widget.user.email.toString();
    _passEditingController.text = widget.user.password.toString();
    _pass2EditingController.text = widget.user.password.toString();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Profile"),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.secondary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          SizedBox(
              height: screenHeight * 0.35,
              width: screenWidth,
              child: Image.asset(
                "assets/images/editProfile.png",
                fit: BoxFit.contain,
              )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 8,
              child: Container(
                margin: const EdgeInsets.all(16),
                child: Column(children: [
                  Form(
                    key: _formKey,
                    child: Column(children: [
                      TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: _nameEditingController,
                          validator: (val) => val!.isEmpty || (val.length < 5)
                              ? "name must be longer than 5"
                              : null,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                              labelText: 'Name',
                              labelStyle: TextStyle(),
                              icon: Icon(Icons.person),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 2.0),
                              ))),
                      TextFormField(
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.phone,
                          validator: (val) => val!.isEmpty || (val.length < 10)
                              ? "phone must be longer or equal than 10"
                              : null,
                          controller: _phoneEditingController,
                          decoration: const InputDecoration(
                              labelText: 'Phone',
                              labelStyle: TextStyle(),
                              icon: Icon(Icons.phone),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 2.0),
                              ))),
                      TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: _emailEditingController,
                          validator: (val) => val!.isEmpty ||
                                  !val.contains("@") ||
                                  !val.contains(".")
                              ? "enter a valid email"
                              : null,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                              labelText: 'Email',
                              labelStyle: TextStyle(),
                              icon: Icon(Icons.email),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 2.0),
                              ))),
                      TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: _passEditingController,
                          validator: (val) => val!.isEmpty || (val.length < 5)
                              ? "password must be longer than 5"
                              : null,
                          obscureText: true,
                          decoration: const InputDecoration(
                              labelText: 'Password',
                              labelStyle: TextStyle(),
                              icon: Icon(Icons.lock),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 2.0),
                              ))),
                      TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: _pass2EditingController,
                          validator: (val) => val!.isEmpty || (val.length < 5)
                              ? "password must be longer than 5"
                              : null,
                          obscureText: true,
                          decoration: const InputDecoration(
                              labelText: 'Re-enter password',
                              labelStyle: TextStyle(),
                              icon: Icon(Icons.lock),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 2.0),
                              ))),
                      const SizedBox(
                        height: 16,
                      ),
                      SizedBox(
                        width: screenWidth / 1.2,
                        height: 50,
                        child: ElevatedButton(
                            onPressed: () {
                              udpateDialog();
                            },
                            child: const Text("Update")),
                      )
                    ]),
                  )
                ]),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  void udpateDialog() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Check your input")));
      return;
    }
    String passa = _passEditingController.text;
    String passb = _pass2EditingController.text;
    if (passa != passb) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Check your password")));
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text(
            "Update your Profile?",
            style: TextStyle(),
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                updateProfile();
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void updateProfile() {
    String name = _nameEditingController.text;
    String email = _emailEditingController.text;
    String phone = _phoneEditingController.text;
    String passa = _passEditingController.text;

    http.post(Uri.parse("${MyConfig().SERVER}/barterit/php/update_profile.php"),
        body: {
          "id": widget.user.id,
          "name": name,
          "email": email,
          "phone": phone,
          "password": passa
        }).then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Update Success")));
          Navigator.pop(context);
          setState(() {});
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Update Failed")));
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Update Failed")));
        Navigator.pop(context);
      }
    });
  }
}
