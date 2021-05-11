import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ugc_notes_admin/Models/Usermodel.dart';
import 'package:ugc_notes_admin/widgets/drawer.dart';

class PremiumUsersScreen extends StatefulWidget {
  @override
  _PremiumUsersScreenState createState() => _PremiumUsersScreenState();
}

class _PremiumUsersScreenState extends State<PremiumUsersScreen> {
  bool isLoading = false;
  List<AppUser> allPremiumUsers = [];

  getAllPremiumUsers() async {
    setState(() {
      isLoading = true;
    });

    final premiumUsers = await FirebaseFirestore.instance
        .collection('users')
        .where("premiumUser", isEqualTo: true)
        .get();

    print(premiumUsers.docs);

    premiumUsers.docs.forEach((element) {
      allPremiumUsers.add(AppUser.fromMap(element.data()));
    });

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    getAllPremiumUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: ScreenDrawer(),
      appBar: AppBar(
        title: Text('Premium Users'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              size: 30,
            ),
            onPressed: () {
              showSearch(
                context: context,
                delegate: CoursesSearch(premiumUsers: allPremiumUsers),
              );
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                  itemCount: allPremiumUsers.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {},
                      child: Card(
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            minLeadingWidth: 0,
                            leading: Container(
                              width: 50,
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        allPremiumUsers[index].profilePic),
                                    radius: 20,
                                  ),
                                  SizedBox(width: 10),
                                ],
                              ),
                            ),
                            title: Text(
                              allPremiumUsers[index].email,
                              style: TextStyle(fontSize: 12),
                            ),
                            subtitle: Text(
                              allPremiumUsers[index].userName,
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
    );
  }
}

class CoursesSearch extends SearchDelegate<String> {
  final List<AppUser> premiumUsers;

  CoursesSearch({this.premiumUsers});

  List<AppUser> searchResults(String query) {
    if (query.isEmpty) {
      return premiumUsers;
    }

    return premiumUsers
        .where((element) => element.email.contains(query))
        .toList();
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {}

  @override
  Widget buildSuggestions(BuildContext context) {
    List<AppUser> results = query.isEmpty ? premiumUsers : searchResults(query);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {},
              child: Card(
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    minLeadingWidth: 0,
                    leading: Container(
                      width: 80,
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage:
                                NetworkImage(results[index].profilePic),
                            radius: 20,
                          ),
                          SizedBox(width: 20),
                        ],
                      ),
                    ),
                    title: Text(results[index].email),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
