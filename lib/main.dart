import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: MyStateful(
          child: Column(
            children: <Widget>[
              MyCounter(),
              MyButton(),
            ],
          ),
        ),
      ),
    );
  }
}

// MyStateful and MyInherited juntos agem como o Provider.
class MyStateful extends StatefulWidget {
  const MyStateful({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  MyState createState() => MyState();
}

class MyState extends State<MyStateful> {
  int _count = 0;

  void increment() {
    setState(() {
      _count += 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: MyInherited(
            count: _count,
            increment: increment,
            child: widget.child,
          ),
        ),
      ],
    );
  }
}

class MyInherited extends InheritedWidget {
  const MyInherited({
    Key? key,
    required this.count,
    required this.increment,
    required Widget child,
  }) : super(key: key, child: child);

  final int count;
  final void Function() increment;

  @override
  bool updateShouldNotify(MyInherited oldWidget) {
    return count != oldWidget.count;
  }

  static MyInherited of(BuildContext context) {
    final MyInherited? result =
        context.dependOnInheritedWidgetOfExactType<MyInherited>();
    assert(result != null, 'No MyInherited found in context');
    return result!;
  }
}

class MyCounter extends StatelessWidget {
  const MyCounter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      'Contador: ${MyInherited.of(context).count}',
      style: const TextStyle(fontSize: 40),
    );
  }
}

class MyButton extends StatelessWidget {
  const MyButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black, // Background color
      ),
      onPressed: () {
        MyInherited.of(context).increment();
      },
      child: const Text('Incrementar'),
    );
  }
}
