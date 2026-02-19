import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: Home()),
    ),
  );
}

enum CardType {
  red(Colors.red),
  blue(Colors.blue),
  green(Colors.green),
  yellow(Colors.yellow);

  final Color color;
  const CardType(this.color);
}

class ColorService extends ChangeNotifier {
  final Map<CardType, int> _counts = Map.fromEntries(
    CardType.values.map((e) => MapEntry(e, 0)),
  );
  int getCount(CardType color) => _counts[color] ?? 0;

  void increment(CardType color) {
    _counts[color] = (_counts[color] ?? 0) + 1;
    notifyListeners();
  }
}

ColorService colorService = ColorService();

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentIndex == 0 ? ColorTapsScreen() : StatisticsScreen(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.tap_and_play),
            label: 'Taps',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Statistics',
          ),
        ],
      ),
    );
  }
}

class ColorTapsScreen extends StatelessWidget {
  const ColorTapsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Color Taps')),
      body: Column(
        children: [
          ...CardType.values.map(
            (color) => ListenableBuilder(
              listenable: colorService,
              builder: (context, child) => ColorTap(
                type: color,
                tapCount: colorService.getCount(color),
                onTap: () => colorService.increment(color),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ColorTap extends StatelessWidget {
  final CardType type;
  final int tapCount;
  final VoidCallback onTap;

  const ColorTap({
    super.key,
    required this.type,
    required this.tapCount,
    required this.onTap,
  });

  Color get backgroundColor => type.color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        width: double.infinity,
        height: 100,
        child: Center(
          child: Text(
            'Taps: $tapCount',
            style: TextStyle(fontSize: 24, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Statistics')),
      body: ListenableBuilder(
        listenable: colorService,
        builder: (context, child) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...CardType.values.map(
                (color) => Text(
                  '${color.name} Taps: ${colorService.getCount(color)}',
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
