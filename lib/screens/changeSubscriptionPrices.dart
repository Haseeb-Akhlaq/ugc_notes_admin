import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class ChangeSubscriptionPricesScreen extends StatefulWidget {
  @override
  _ChangeSubscriptionPricesScreenState createState() =>
      _ChangeSubscriptionPricesScreenState();
}

class _ChangeSubscriptionPricesScreenState
    extends State<ChangeSubscriptionPricesScreen> {
  TextEditingController oneMonthController = TextEditingController();
  TextEditingController threeMonthController = TextEditingController();
  TextEditingController sixMonthController = TextEditingController();
  TextEditingController oneYearController = TextEditingController();

  setPreviousPlans() async {
    final plans = await FirebaseFirestore.instance
        .collection('SubscriptionPrices')
        .doc('11221122')
        .get();

    setState(() {
      oneMonthController.text = plans.data()['1 Month'];
      threeMonthController.text = plans.data()['3 Months'];
      sixMonthController.text = plans.data()['6 Months'];
      oneYearController.text = plans.data()['1 Year'];
    });
  }

  updateDate(context) async {
    await FirebaseFirestore.instance
        .collection('SubscriptionPrices')
        .doc('11221122')
        .set({
      '1 Month': oneMonthController.text,
      '3 Months': threeMonthController.text,
      '6 Months': sixMonthController.text,
      '1 Year': oneYearController.text,
    });
    Navigator.pop(context);
  }

  @override
  void initState() {
    setPreviousPlans();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Subscription Prices'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Text('Change 1 Month Plan :'),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            border: Border.all(
                          color: Colors.black,
                        )),
                        height: 70,
                        width: 70,
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: TextField(
                            controller: oneMonthController,
                            decoration:
                                InputDecoration(border: InputBorder.none),
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Text('Change 3 Months Plan :'),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            border: Border.all(
                          color: Colors.black,
                        )),
                        height: 70,
                        width: 70,
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: TextField(
                            controller: threeMonthController,
                            decoration:
                                InputDecoration(border: InputBorder.none),
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Text('Change 6 Month Plan :'),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            border: Border.all(
                          color: Colors.black,
                        )),
                        height: 70,
                        width: 70,
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: TextField(
                            controller: sixMonthController,
                            decoration:
                                InputDecoration(border: InputBorder.none),
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Text('Change 1 Year Plan :'),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            border: Border.all(
                          color: Colors.black,
                        )),
                        height: 70,
                        width: 70,
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: TextField(
                            controller: oneYearController,
                            decoration:
                                InputDecoration(border: InputBorder.none),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                if (oneMonthController.text == '' ||
                    threeMonthController.text == '' ||
                    sixMonthController.text == '' ||
                    oneYearController.text == '') {
                  Toast.show("Please Select a Valid Price", context,
                      duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                  return;
                }
                updateDate(context);
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
                    'Change',
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
    );
  }
}
