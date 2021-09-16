import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';

import './widgets/transaction_list.dart';

import './widgets/new_transaction.dart';

import './models/transaction.dart';
import './widgets/chart.dart';

//void main() => runApp(MyApp());
void main()
{
 // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //    DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitUp,    
  //   ]);
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.amber,
          fontFamily: 'Quicksand',
          textTheme: ThemeData.light().textTheme.copyWith(
              title: TextStyle(
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
              button: TextStyle(
                  color: Colors.white,
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold,
                  fontSize: 15)),
          appBarTheme: AppBarTheme(
              textTheme: ThemeData.light().textTheme.copyWith(
                      title: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  )))),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  //  String titleInput;
  //  String amountInput;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [
    // Transaction(
    //     id: '12', title: 'new shoes', amount: 69.00, date: DateTime.now()),
    // Transaction(
    //     id: '1', title: 'weekly grocery', amount: 69.00, date: DateTime.now())
  ];
 bool _showChart = false;
  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  void _addNewTransaction(
      String txTitle, double txAmount, DateTime chosenDate) {
    final newTx = Transaction(
        title: txTitle,
        amount: txAmount,
        date: chosenDate,
        id: DateTime.now().toString());

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: NewTransaction(_addNewTransaction),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) {
        return tx.id == id;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape= mediaQuery.orientation == Orientation.landscape;
    final appBar = AppBar(
      title: Text('Personal Expenses'),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => _startAddNewTransaction(context),
        )
      ],
    );
    final txListWidget =Container(
                height: (mediaQuery.size.height - appBar.preferredSize.height - mediaQuery.padding.top) * 0.7,
                child: TransactionList(_userTransactions, _deleteTransaction)
                );
    return Scaffold(
      appBar: appBar,
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            
            children: <Widget>[
              if(isLandscape) Row(
                mainAxisAlignment: MainAxisAlignment.center,children: <Widget>[
                Text('show chart'),
                Switch(value:_showChart,onChanged:(val){
                    setState(() { 
                      _showChart = val;
                    });
                },),
              ],),
              if(!isLandscape) Container(
                height: (mediaQuery.size.height - 
                appBar.preferredSize.height - 
                mediaQuery.padding.top) * 0.3, 
              child: Chart(_recentTransactions)
              ),
              if(!isLandscape) txListWidget,
            if(isLandscape) _showChart ?  Container(
                height: (mediaQuery.size.height - 
                appBar.preferredSize.height - 
                mediaQuery.padding.top) * 0.5, 
              child: Chart(_recentTransactions)
              ) : txListWidget
              
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
        ),
        onPressed: () => _startAddNewTransaction(context),
      ),
    );
  }
}
