import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(TankApp());
}

class TankApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tank Calculator',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: TankForm(),
    );
  }
}

class TankForm extends StatefulWidget {
  @override
  _TankFormState createState() => _TankFormState();
}

class _TankFormState extends State<TankForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _level323 = TextEditingController();
  final TextEditingController _level321 = TextEditingController();
  final TextEditingController _flowRate = TextEditingController();

  String _result = '';

  final double minLevel323 = 30;
  final double minLevel321 = 160;
  final double proportionIncrease323 = 35;
  final double proportionVolume321 = 340;
  final double maxLevel321 = 634;

  void _calculate() {
    double level323 = double.tryParse(_level323.text) ?? 0;
    double level321 = double.tryParse(_level321.text) ?? 0;
    double flowRate = double.tryParse(_flowRate.text) ?? 1;

    double deficit = level323 - minLevel323;
    double timeToMin = deficit / flowRate;
    double pumpVolume = level321 - minLevel321;
    double increase = (proportionIncrease323 / proportionVolume321) * pumpVolume;
    double newLevel323 = level323 + increase;
    double totalTime = (newLevel323 - minLevel323) / flowRate;
    DateTime nextPumping = DateTime.now().add(Duration(hours: totalTime.round()));

    double fullPumpVolume = maxLevel321 - minLevel321;
    double newLevelAfterFull = level323 + (proportionIncrease323 / proportionVolume321) * fullPumpVolume;
    double totalFullTime = (newLevelAfterFull - minLevel323) / flowRate;

    DateTime solutionEndTime = nextPumping.add(Duration(
      minutes: (totalFullTime * 60).round(),
    ));

    setState(() {
      _result =
          'Без перекачки: ${timeToMin.toStringAsFixed(2)} ч\n'
          'После текущей перекачки: ${totalTime.toStringAsFixed(2)} ч\n'
          'Новый уровень: ${newLevel323.toStringAsFixed(2)}%\n'
          'След. перекачка: ${DateFormat('yyyy-MM-dd HH:mm').format(nextPumping)}\n\n'
          'После полной дозаправки: ${newLevelAfterFull.toStringAsFixed(2)}%\n'
          'Время работы после неё: ${totalFullTime.toStringAsFixed(2)} ч\n'
          'Раствора хватит до: ${DateFormat('yyyy-MM-dd HH:mm').format(solutionEndTime)}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Расчёт по уровням')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _level323,
                decoration: InputDecoration(labelText: 'Уровень в 323 (%):'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _level321,
                decoration: InputDecoration(labelText: 'Уровень в 321 (мм):'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _flowRate,
                decoration: InputDecoration(labelText: 'Расход 323 (%/ч):'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _calculate,
                child: Text('Рассчитать'),
              ),
              SizedBox(height: 20),
              Text(
                _result,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
