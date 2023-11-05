// ignore: file_names
import 'package:flutter/material.dart';
import 'Result.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedNumberOfSpans = 2;
  String selectedLoadType = "Point Load";
  String selectedLoadType2 = "Point Load";
  String selectedUnit = "lb/ft.^2";

  final TextEditingController _lengthControllerAB = TextEditingController();
  final TextEditingController _lengthControllerBC = TextEditingController();

  //Two Span Controller AB
  final TextEditingController _2spanLoadAB = TextEditingController();
  final TextEditingController _2spanLlAB = TextEditingController();

  //Two Span Controller BC
  final TextEditingController _2spanLoadBC = TextEditingController();
  final TextEditingController _2spanLlBC = TextEditingController();

  int calculateLCM(int a, int b) {
    return (a * b) ~/ calculateGCD(a, b);
  }

  int calculateGCD(int a, int b) {
    if (b == 0) {
      return a;
    } else {
      return calculateGCD(b, a % b);
    }
  }

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

  void _calculate() {
    //Point Load & Point Load Combination 2 spans
    if (selectedLoadType == 'Point Load' && selectedLoadType2 == 'Point Load') {
      String inputAB = _lengthControllerAB.text;
      String inputBC = _lengthControllerBC.text;

      //Getting Values from Inputs AB
      String twospanLoadABInput = _2spanLoadAB.text;
      String twospanLlABInput = _2spanLlAB.text;

      //Getting Values from Inputs BC
      String twospanLoadBCInput = _2spanLoadBC.text;
      String twospanlLBCInput = _2spanLlBC.text;

      int lengthAB = int.tryParse(inputAB) ?? 0;
      int lengthBC = int.tryParse(inputBC) ?? 0;

      //Convert Values from Input AB to double
      double twospanLoadABData = double.tryParse(twospanLoadABInput) ?? 0;
      double twospanLlABData = double.tryParse(twospanLlABInput) ?? 0;

      //Convert Values from Input AB to double
      double twospanLoadBCData = double.tryParse(twospanLoadBCInput) ?? 0;
      double twospanLlBCData = double.tryParse(twospanlLBCInput) ?? 0;

      //Getting LCM
      int lcm = calculateLCM(lengthAB, lengthBC);

      //Getting Values of K
      double kAB = lcm / lengthAB;
      double kBC = lcm / lengthBC;

      double dfA1 = 1;
      double dfA2 = (kAB) / (kAB + kBC);
      double dfB1 = (kBC) / (kAB + kBC);
      double dfB2 = 1;

      double femA1, femA2;
      double femB1, femB2;

      //Calculating FEM AB1
      femA1 = (twospanLoadABData *
              twospanLlABData *
              ((lengthAB - twospanLlABData) * (lengthAB - twospanLlABData))) /
          ((lengthAB) * (lengthAB));
      if (femA1 > 0) {
        femA1 = -femA1;
      }

      //Calculating FEM AB2
      femA2 = (twospanLoadABData *
              ((twospanLlABData) * (twospanLlABData)) *
              ((lengthAB - twospanLlABData))) /
          ((lengthAB) * (lengthAB));
      if (femA2 < 0) {
        femA2 = femA2.abs();
      }

      //Calculating FEM BC1
      femB1 = (twospanLoadBCData *
              twospanLlBCData *
              ((lengthBC - twospanLlBCData) * (lengthBC - twospanLlBCData))) /
          ((lengthBC) * (lengthBC));
      print(
          '($twospanLoadBCData * $twospanLlBCData (($lengthBC - $twospanLlBCData) * ($lengthBC - $twospanLlBCData))) / (($lengthBC) *($lengthBC))');
      if (femB1 > 0) {
        femB1 = -femB1;
      }

      //Calculating FEM BC2
      femB2 = (twospanLoadBCData *
              ((twospanLlBCData) * (twospanLlBCData)) *
              ((lengthBC - twospanLlBCData))) /
          ((lengthBC) * (lengthBC));
      if (femB2 < 0) {
        femB2 = femB2.abs();
      }

      // Show modal dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Results'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
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
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => Results(
                        kAB: kAB,
                        kBC: kBC,
                        dfA1: dfA1,
                        dfA2: dfA2,
                        dfB1: dfB1,
                        dfB2: dfB2,
                        femA1: femA1,
                        femA2: femA2,
                        femB1: femB1,
                        femB2: femB2,
                        selectedUnit: selectedUnit,
                      ),
                    ),
                  );
                },
                child: const Text('Show more'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: [
                    const Text("Select Number of Spans: "),
                    const SizedBox(width: 10),
                    DropdownButton<int>(
                      value: _selectedNumberOfSpans,
                      onChanged: (int? newValue) {
                        setState(() {
                          _selectedNumberOfSpans = newValue!;
                        });
                      },
                      items: List.generate(3, (index) => index + 2)
                          .map((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text(value.toString()),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text("Unit: "),
                    const SizedBox(width: 10),
                    DropdownButton<String>(
                      value: selectedUnit,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedUnit = newValue!;
                        });
                      },
                      items: [
                        "lb/ft.^2",
                        "kN/m^2",
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                const Divider(
                  color: Colors.blue, // Set the color to blue
                  thickness: 3, // Adjust the thickness of the line as needed
                ),
                if (_selectedNumberOfSpans == 2) ...[
                  const Text(
                    "Span A-B:",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15, // Adjust the font size as needed
                    ),
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: TextField(
                          controller: _lengthControllerAB,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Enter length',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Text("Type of Load:"),
                      const SizedBox(width: 10),
                      DropdownButton<String>(
                        value: selectedLoadType,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedLoadType = newValue!;
                          });
                        },
                        items: [
                          "Point Load",
                          "Uniformly Distributed",
                          "Varying",
                          "Inverted Varying",
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  if (selectedLoadType == 'Point Load') ...[
                    Row(
                      children: [
                        Flexible(
                          child: TextField(
                            controller: _2spanLoadAB,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Enter Load',
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: TextField(
                            controller: _2spanLlAB,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Enter Location form Left',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                  if (selectedLoadType == 'Uniformly Distributed' ||
                      selectedLoadType == 'Varying' ||
                      selectedLoadType == 'Inverted Varying') ...[
                    Row(
                      children: [
                        Flexible(
                          child: TextField(
                            controller: _2spanLoadAB,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Enter Load',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                  const Divider(
                    color: Colors.blue, // Set the color to blue
                    thickness: 3, // Adjust the thickness of the line as needed
                  ),
                  const Text(
                    "Span B-C:",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15, // Adjust the font size as needed
                    ),
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: TextField(
                          controller: _lengthControllerBC,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Enter length',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Text("Type of Load:"),
                      const SizedBox(width: 10),
                      DropdownButton<String>(
                        value: selectedLoadType2,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedLoadType2 = newValue!;
                          });
                        },
                        items: [
                          "Point Load",
                          "Uniformly Distributed",
                          "Varying",
                          "Inverted Varying",
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  if (selectedLoadType2 == 'Point Load') ...[
                    Row(
                      children: [
                        Flexible(
                          child: TextField(
                            controller: _2spanLoadBC,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Enter Load',
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: TextField(
                            controller: _2spanLlBC,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Enter Location form Left',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (selectedLoadType2 == 'Uniformly Distributed' ||
                      selectedLoadType2 == 'Varying' ||
                      selectedLoadType2 == 'Inverted Varying') ...[
                    Row(
                      children: [
                        Flexible(
                          child: TextField(
                            controller: _2spanLoadBC,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Enter Load',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ],
                if (_selectedNumberOfSpans == 3 ||
                    _selectedNumberOfSpans == 4) ...[
                  const Center(
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        Text('Development in Progess..'),
                      ],
                    ),
                  )
                ],
              ]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _calculate,
        tooltip: 'Calculate',
        child: const Icon(Icons.play_arrow),
      ),
    );
  }
}
