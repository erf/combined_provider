import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:combined_provider/combined_provider.dart';

final counterProvider = StateProvider((ref) => 0);

final regularProvider = Provider<int>((ref) {
  final counter = ref.watch(counterProvider);
  return counter.state;
});

final providerA = FutureProvider<String>((ref) async {
  await Future.delayed(Duration(seconds: 1));
  return "done A";
});

final providerB = FutureProvider<String>((ref) async {
  await Future.delayed(Duration(seconds: 2));
  return "done B";
});

final providerC = Provider<String>((ref) {
  return "done C";
});

final providerD = StateProvider((ref) => "done D");

class MyNotifier extends StateNotifier {
  MyNotifier(state) : super(state);
}

final myNotifier = MyNotifier('done E');

final providerE = StateNotifierProvider<MyNotifier>((ref) {
  return myNotifier;
});

class MyChangeNotifier extends ChangeNotifier {
  get hello => 'done F';
}

final myChangeNotifier = MyChangeNotifier();

final providerF = ChangeNotifierProvider<MyChangeNotifier>((ref) {
  return myChangeNotifier;
});

final List<ProviderBase> providers = [
  providerA,
  providerB,
  providerC,
  providerD,
  providerE,
  providerF,
];

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hello'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('You have pushed the button this many times:'),
            Consumer(builder: (context, watch, _) {
              return Text(watch(counterProvider).state.toString());
            }),
            SizedBox(height: 16),
            Text('Does the value of the regular provider change??'),
            Consumer(builder: (context, watch, _) {
              return Text(watch(regularProvider).toString());
            }),
            SizedBox(height: 16),
            Text('Are all providers loaded?'),
            Consumer(builder: (context, watch, _) {
              return Text(watch(loadedProvider(providers)).toString());
            }),
            SizedBox(height: 16),
            Text('Provider A'),
            Consumer(builder: (context, watch, _) {
              final asyncValue = watch(providerA);
              return asyncValue.when(
                data: (data) => Text(data),
                loading: () => Text('Loading..'),
                error: (_, __) => Text('Error!'),
              );
            }),
            SizedBox(height: 16),
            Text('Provider B'),
            Consumer(builder: (context, watch, _) {
              final asyncValue = watch(providerB);
              return asyncValue.when(
                data: (data) => Text(data),
                loading: () => Text('Loading..'),
                error: (_, __) => Text('Error!'),
              );
            }),
            SizedBox(height: 16),
            Text('Combined'),
            Consumer(builder: (context, watch, _) {
              return Text(
                watch(combinedProvider(providers)).when(
                  data: (data) =>
                      data.fold('', (prev, val) => prev + ' ' + val),
                  loading: () => 'Loading..',
                  error: (error, stack) {
                    return 'Error: ${error.toString()}';
                  },
                ),
              );
            }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read(counterProvider).state++,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
