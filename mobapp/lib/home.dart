import 'package:flutter/material.dart';
import 'package:mobapp/components/doughnut.dart';
import 'package:http/http.dart' as http;

class HomeFragment extends StatefulWidget {
  HomeFragment({Key? key}) : super(key: key);

  @override
  State<HomeFragment> createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment> {
  bool _switchWP = false;
  bool _switchDoor = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int selectedTile = 0;
  delayedSplash(index) {
    setState(() {
      // your code to update the state here
      selectedTile = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('User Dashboard'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState!.isDrawerOpen
                ? _scaffoldKey.currentState?.closeDrawer()
                : _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      drawer: Drawer(
        backgroundColor: Theme.of(context).primaryColor,
        child: ListView(
          children: [
            Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Color(0xFFF0F8FF),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://ntvb.tmsimg.com/assets/assets/182420_v9_bc.jpg'),
                    radius: 28,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'John Doe',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text('john@doe.com'),
                const SizedBox(
                  height: 30,
                ),
                const Divider(
                  height: 1,
                  thickness: 1,
                ),
                ListTile(
                  leading: const Icon(
                    Icons.person,
                  ),
                  title: const Text('Personal Account'),
                  shape: const StadiumBorder(),
                  selectedTileColor: const Color(0xFFF0F8FF),
                  selected: selectedTile == 0,
                  selectedColor: Colors.black,
                  iconColor: const Color(0xFFF0F8FF),
                  onTap: () {
                    setState(() {
                      selectedTile = 0;
                    });
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.settings,
                  ),
                  title: const Text('Settings'),
                  shape: const StadiumBorder(),
                  selectedTileColor: const Color(0xFFF0F8FF),
                  selected: selectedTile == 1,
                  selectedColor: Colors.black,
                  iconColor: const Color(0xFFF0F8FF),
                  onTap: () {
                    setState(() {
                      selectedTile = 1;
                    });
                  },
                )
              ],
            )
          ],
        ),
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 15,
            ),
            const Text(
              "STATS",
              style: TextStyle(
                fontSize: 22,
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 300,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Doughnut(
                      title: "ldr",
                      color: const Color.fromRGBO(255, 206, 86, 1),
                      max: 1100),
                  Doughnut(
                    title: "wind",
                    color: const Color.fromRGBO(54, 162, 235, 1),
                    max: 700,
                  ),
                  Doughnut(
                      title: "water",
                      color: const Color.fromRGBO(255, 99, 132, 1),
                      max: 600),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            const Text(
              "CONTROL",
              style: TextStyle(
                fontSize: 22,
                color: Colors.black,
              ),
            ),
            Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: SizedBox(
                  height: 200,
                  child: ListView(
                    children: [
                      ListTile(
                        title: const Text("Water Pump"),
                        trailing: Switch(
                          value: _switchWP,
                          onChanged: (value) async {
                            _switchWP
                                ? await http.get(Uri.parse(
                                    'http://172.20.7.13:5000/command/f'))
                                : await http.get(Uri.parse(
                                    'http://172.20.7.13:5000/command/w'));
                            setState(() {
                              _switchWP = value;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text("Open/Close door"),
                        trailing: Switch(
                          value: _switchDoor,
                          onChanged: (value) async {
                            _switchDoor
                                ? await http.get(Uri.parse(
                                    'http://172.20.7.13:5000/command/c'))
                                : await http.get(Uri.parse(
                                    'http://172.20.7.13:5000/command/d'));
                            setState(() {
                              _switchDoor = value;
                            });
                          },
                        ),
                      ),
                      Row(
                        children: [
                          TextButton(
                              onPressed: () async {
                                await http.get(Uri.parse(
                                    'http://172.20.7.13:5000/command/q'));
                              },
                              child: const Text('Update Solar')),
                          TextButton(
                              onPressed: () {}, child: const Text('Open Door')),
                        ],
                      )
                    ],
                  ),
                ))
          ]),
    );
  }
}
