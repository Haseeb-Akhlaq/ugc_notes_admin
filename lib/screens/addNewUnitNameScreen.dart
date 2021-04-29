import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ugc_notes_admin/providers/addNewCourseProvider.dart';
import 'package:ugc_notes_admin/screens/topicsScreen.dart';

class AddNewUnitNameScreen extends StatefulWidget {
  @override
  _AddNewUnitNameScreenState createState() => _AddNewUnitNameScreenState();
}

class _AddNewUnitNameScreenState extends State<AddNewUnitNameScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String unitName;

  saveData() {
    bool isValid = _formKey.currentState.validate();

    if (!isValid) {
      return;
    }

    _formKey.currentState.save();

    Provider.of<AddNewCourseProvider>(context, listen: false)
        .setNewUnitName(unitName);

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => TopicsScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add new unit'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Enter the Unit Name'),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, right: 10, top: 5, bottom: 5),
                          child: TextFormField(
                            textAlign: TextAlign.left,
                            decoration: InputDecoration(
                              hintText: 'Unit Name',
                              border: InputBorder.none,
                            ),
                            onSaved: (value) {
                              unitName = value;
                            },
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'Please enter valid unit Name';
                              }
                              if (value.length < 4) {
                                return 'Please Enter Name greater than 4 characters';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  saveData();
                },
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.blue,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'Next',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
