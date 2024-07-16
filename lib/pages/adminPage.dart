import 'dart:ui';

import 'package:dapptest/services/functions.dart';
import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';

class adminpage extends StatefulWidget {
  final Web3Client ethClient;
  final String electionName;
  const adminpage(
      {Key? key, required this.ethClient, required this.electionName})
      : super(key: key);

  @override
  _adminpage createState() => _adminpage();
}

class _adminpage extends State<adminpage> {
  TextEditingController addCandidateController = TextEditingController();
  TextEditingController authorizeVoterController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text(widget.electionName))),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(height: 20),
            buildInputCard(
              context,
              'Enter Candidate Name',
              addCandidateController,
              () {
                addCandidate(addCandidateController.text, widget.ethClient);
              },
              'Add Candidate',
              Icons.person_add,
            ),
            SizedBox(height: 20),
            buildInputCard(
              context,
              'Enter Voter Address',
              authorizeVoterController,
              () {
                authorizeVoter(authorizeVoterController.text, widget.ethClient);
              },
              'Add Voter',
              Icons.how_to_vote,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInputCard(
    BuildContext context,
    String hintText,
    TextEditingController controller,
    VoidCallback onPressed,
    String buttonText,
    IconData icon,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  filled: true,
                  hintText: hintText,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            SizedBox(width: 10),
            ElevatedButton.icon(
              icon: Icon(icon, size: 20),
              label: Text(buttonText),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: onPressed,
            ),
          ],
        ),
      ),
    );
  }
}
