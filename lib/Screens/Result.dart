import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Results extends StatelessWidget {
  final double kAB;
  final double kBC;
  final double dfA1;
  final double dfA2;
  final double dfB1;
  final double dfB2;
  final double femA1;
  final double femA2;
  final double femB1;
  final double femB2;
  final String selectedUnit;

  Results({
    super.key,
    required this.kAB,
    required this.kBC,
    required this.dfA1,
    required this.dfA2,
    required this.dfB1,
    required this.dfB2,
    required this.femA1,
    required this.femA2,
    required this.femB1,
    required this.femB2,
    required this.selectedUnit,
  });

  double bmA1 = 0, bmA2 = 0, bmB1 = 0, bmB2 = 0;
  double coA1 = 0, coA2 = 0, coB1 = 0, coB2 = 0;
  int ctr = 1;
  double finalAnswer = 0;

  String roundOff(double number) {
    String roundedNumber = number.toStringAsFixed(2);
    return roundedNumber;
  }

  double roundOffNumber(double number) {
    String roundedNumber;
    roundedNumber = number.toStringAsFixed(2);
    number = double.parse(roundedNumber);
    return number;
  }

  Table generatedFirstTable() {
    finalAnswer = femA2;
    //Invert the sign
    if (femA1 > 0) {
      bmA1 = -femA1;
    } else {
      bmA1 = femA1.abs();
    }

    bmA2 = (femA2 + femB1) * dfA2 * -1;
    bmB1 = (femA2 + femB1) * dfB1 * -1;

    //Invert the sign
    if (femB2 > 0) {
      bmB2 = -femB2;
    } else {
      bmB2 = bmB2.abs();
    }

    coA1 = bmA2 / 2;
    coA2 = bmA1 / 2;
    coB1 = bmB2 / 2;
    coB2 = bmB1 / 2;

    finalAnswer = finalAnswer + bmA2 + coA2;

    return Table(
      border: TableBorder.all(),
      children: [
        TableRow(
          children: [
            const TableCell(child: Center(child: Text('BM'))),
            TableCell(child: Center(child: Text(roundOff(bmA1)))),
            TableCell(child: Center(child: Text(roundOff(bmA2)))),
            TableCell(child: Center(child: Text(roundOff(bmB1)))),
            TableCell(child: Center(child: Text(roundOff(bmB2)))),
          ],
        ),
        TableRow(
          children: [
            const TableCell(child: Center(child: Text('CO'))),
            TableCell(child: Center(child: Text(roundOff(coA1)))),
            TableCell(child: Center(child: Text(roundOff(coA2)))),
            TableCell(child: Center(child: Text(roundOff(coB1)))),
            TableCell(child: Center(child: Text(roundOff(coB2)))),
          ],
        ),
      ],
    );
  }

  Table generateLoopingTable() {
    //Invert the sign
    if (coA1 > 0) {
      bmA1 = -coA1;
    } else {
      bmA1 = coA1.abs();
    }

    bmA2 = (coA2 + coB1) * dfA2 * -1;
    bmB1 = (coA2 + coB1) * dfB1 * -1;

    //Invert the sign
    if (coB2 > 0) {
      bmB2 = -coB2;
    } else {
      bmB2 = coB2.abs();
    }

    coA1 = bmA2 / 2;
    coA2 = bmA1 / 2;
    coB1 = bmB2 / 2;
    coB2 = bmB1 / 2;

    finalAnswer = finalAnswer + bmA2 + coA2;

    if (roundOffNumber(coA1) == 0) {
      ctr = 0;
    }

    return Table(
      border: TableBorder.all(),
      children: [
        TableRow(
          children: [
            const TableCell(child: Center(child: Text('BM'))),
            TableCell(child: Center(child: Text(roundOff(bmA1)))),
            TableCell(child: Center(child: Text(roundOff(bmA2)))),
            TableCell(child: Center(child: Text(roundOff(bmB1)))),
            TableCell(child: Center(child: Text(roundOff(bmB2)))),
          ],
        ),
        TableRow(
          children: [
            const TableCell(child: Center(child: Text('CO'))),
            TableCell(child: Center(child: Text(roundOff(coA1)))),
            TableCell(child: Center(child: Text(roundOff(coA2)))),
            TableCell(child: Center(child: Text(roundOff(coB1)))),
            TableCell(child: Center(child: Text(roundOff(coB2)))),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Results'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Table(
                border: TableBorder.all(),
                children: [
                  TableRow(
                    children: [
                      const TableCell(
                        child: Center(child: Text('K')),
                      ),
                      TableCell(child: Center(child: Text(roundOff(kAB)))),
                      TableCell(child: Center(child: Text(roundOff(kBC)))),
                    ],
                  ),
                ],
              ),
              Table(
                border: TableBorder.all(),
                children: [
                  TableRow(
                    children: [
                      const TableCell(child: Center(child: Text('df'))),
                      TableCell(child: Center(child: Text(roundOff(dfA1)))),
                      TableCell(child: Center(child: Text(roundOff(dfA2)))),
                      TableCell(child: Center(child: Text(roundOff(dfB1)))),
                      TableCell(child: Center(child: Text(roundOff(dfB2)))),
                    ],
                  ),
                  TableRow(
                    children: [
                      const TableCell(child: Center(child: Text('FEM'))),
                      TableCell(child: Center(child: Text(roundOff(femA1)))),
                      TableCell(child: Center(child: Text(roundOff(femA2)))),
                      TableCell(child: Center(child: Text(roundOff(femB1)))),
                      TableCell(child: Center(child: Text(roundOff(femB2)))),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              generatedFirstTable(),
              const SizedBox(height: 10),
              for (int i = 0; ctr != 0; i++) ...[
                generateLoopingTable(),
                const SizedBox(
                  height: 10,
                ),
              ],
              const SizedBox(
                height: 10,
              ),
              Text(
                  'Final Answer: $finalAnswer or ${roundOff(finalAnswer)} $selectedUnit'),
            ],
          ),
        ),
      ),
    );
  }
}
