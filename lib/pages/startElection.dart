import 'package:dapptest/pages/adminPage.dart';
import 'package:dapptest/pages/electionInfo.dart';
import 'package:dapptest/pages/voters.dart';
import 'package:dapptest/services/functions.dart';
import 'package:dapptest/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Client? httpClient;
  Web3Client? ethclient;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    httpClient = Client();
    ethclient = Web3Client(infura_url, httpClient!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Start Election'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.how_to_vote,
                  size: 100, color: Colors.blue), // Election app icon
              SizedBox(height: 20),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      filled: true,
                      hintText: 'Enter election name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              buildElevatedButton(
                context,
                'Start Election',
                Icons.how_to_vote,
                () async {
                  if (controller.text.length > 0) {
                    await startElection(controller.text, ethclient!);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ElectionInfo(
                          ethClient: ethclient!,
                          electionName: controller.text,
                        ),
                      ),
                    );
                  }
                },
              ),
              SizedBox(height: 10),
              buildElevatedButton(
                context,
                'Admin Page',
                Icons.admin_panel_settings,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => adminpage(
                        ethClient: ethclient!,
                        electionName: controller.text,
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 10),
              buildElevatedButton(
                context,
                'Election Info',
                Icons.info,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ElectionInfo(
                        ethClient: ethclient!,
                        electionName: controller.text,
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 10),
              buildElevatedButton(
                context,
                'Voting',
                Icons.how_to_vote,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => voting(
                        ethClient: ethclient!,
                        electionName: controller.text,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildElevatedButton(BuildContext context, String text, IconData icon,
      VoidCallback onPressed) {
    return Container(
      width: double.infinity,
      height: 45,
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 20),
        label: Text(text),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
