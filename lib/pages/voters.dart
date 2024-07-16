import 'dart:ui';

import 'package:dapptest/services/functions.dart';
import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';

class voting extends StatefulWidget {
  final Web3Client ethClient;
  final String electionName;
  const voting({Key? key, required this.ethClient, required this.electionName})
      : super(key: key);

  @override
  _voting createState() => _voting();
}

class _voting extends State<voting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text(widget.electionName))),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(height: 20),
            Divider(),
            FutureBuilder<List>(
              future: getCandidatesNum(widget.ethClient),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
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
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              return Card(
                                elevation: 4,
                                margin: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 16),
                                child: ListTile(
                                  title: Text('Name: ' +
                                      candidateSnapshot.data![0][0].toString()),
                                  subtitle: Text('Votes: ' +
                                      candidateSnapshot.data![0][1].toString()),
                                  trailing: ElevatedButton(
                                    onPressed: () {
                                      vote(index, widget.ethClient);
                                    },
                                    child: Text('Vote'),
                                  ),
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
}
