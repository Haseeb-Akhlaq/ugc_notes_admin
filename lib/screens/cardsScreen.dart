import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ugc_notes_admin/Models/cardModel.dart';
import 'package:ugc_notes_admin/providers/addNewCourseProvider.dart';

class CardsScreen extends StatefulWidget {
  @override
  _CardsScreenState createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String cardContent;
  List<CardModel> allCards = [];

  saveData() {
    bool isValid = _formKey.currentState.validate();

    if (!isValid) {
      return;
    }

    _formKey.currentState.save();

    allCards.add(CardModel(
        cardId: (allCards.length + 1).toString(), cardContent: cardContent));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cards Screen'),
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (_) {
                    return GestureDetector(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Enter Card Content'),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20.0,
                                              right: 10,
                                              top: 5,
                                              bottom: 5),
                                          child: TextFormField(
                                            textAlign: TextAlign.left,
                                            maxLines: 10,
                                            decoration: InputDecoration(
                                              hintText: 'Card Content',
                                              border: InputBorder.none,
                                            ),
                                            onSaved: (value) {
                                              cardContent = value;
                                            },
                                            validator: (String value) {
                                              if (value.isEmpty) {
                                                return 'Please enter valid Card Content';
                                              }
                                              if (value.length < 4) {
                                                return 'Please Enter Content greater than 4 characters';
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
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.blue,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      'Add Card',
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
                  },
                );
              }),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: allCards.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(allCards[index].cardContent),
                  );
                }),
          ),
          GestureDetector(
            onTap: () {
              Provider.of<AddNewCourseProvider>(context, listen: false)
                  .addAllCards(allCards);
              Navigator.pop(context);
              Navigator.pop(context);
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
                  'Done',
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
    );
  }
}
