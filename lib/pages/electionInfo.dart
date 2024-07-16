import 'dart:ui';

import 'package:dapptest/services/functions.dart';
import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';

class ElectionInfo extends StatefulWidget {
  final Web3Client ethClient;
  final String electionName;
  const ElectionInfo(
      {Key? key, required this.ethClient, required this.electionName})
      : super(key: key);

  @override
  _ElectionInfoState createState() => _ElectionInfoState();
}

class _ElectionInfoState extends State<ElectionInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text(widget.electionName))),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildInfoCard(
                  context,
                  'Total Candidates',
                  getCandidatesNum(widget.ethClient),
                  Icons.person,
                ),
                buildInfoCard(
                  context,
                  'Total Votes',
                  getTotalVotes(widget.ethClient),
                  Icons.how_to_vote,
                ),
              ],
            ),
            SizedBox(height: 20),
            Divider(),
            FutureBuilder<List>(
              future: getCandidatesNum(widget.ethClient),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data![0].toInt(),
                      itemBuilder: (context, index) {
                        return FutureBuilder<List>(
                          future: candidateInfo(index, widget.ethClient),
                          builder: (context, candidateSnapshot) {
                            if (candidateSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else {
                              return Card(
                                elevation: 4,
                                margin: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 16),
                                child: ListTile(
                                  leading: Icon(Icons.person),
                                  title: Text('Name: ' +
                                      candidateSnapshot.data![0][0].toString()),
                                  subtitle: Text('Votes: ' +
                                      candidateSnapshot.data![0][1].toString()),
                                ),
                              );
                            }
                          },
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInfoCard(
    BuildContext context,
    String label,
    Future<List> future,
    IconData icon,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            FutureBuilder<List>(
              future: future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                return Text(
                  snapshot.data![0].toString(),
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(icon, size: 30),
                SizedBox(width: 8),
                Text(label, style: TextStyle(fontSize: 16)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
