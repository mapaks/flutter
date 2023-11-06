// ignore_for_file: avoid_print, use_key_in_widget_constructors, avoid_function_literals_in_foreach_calls, use_build_context_synchronously, unused_local_variable

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:robbinlaw/models/stock-list.dart';
import 'package:robbinlaw/models/stock.dart';
import 'package:robbinlaw/services/stock-service.dart';
import 'package:robbinlaw/services/db-service.dart';

class HomeView extends StatefulWidget {
  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {
  final StockService _stockService = StockService();
  final SQFliteDbService _databaseService = SQFliteDbService();
  var _stockList = <Stock>[];
  String _stockSymbol = "";

  @override
  void initState() {
    super.initState();
    getOrCreateDbAndDisplayAllStocksInDb();
  }

  void getOrCreateDbAndDisplayAllStocksInDb() async {
    await _databaseService.getOrCreateDatabaseHandle();
    _stockList = await _databaseService.getAllStocksFromDb();
    await _databaseService.printAllStocksInDbToConsole();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock Ticker'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
            child: const Text(
              'Delete All Records and Db',
            ),
            onPressed: () async {
              _stockList.forEach(
                (e) async {
                  await _databaseService.deleteStock(e);
                },
              );
              _stockList = await _databaseService.getAllStocksFromDb();
              await _databaseService.printAllStocksInDbToConsole();
              await _databaseService.deleteDb();
              setState(() {});
            },
          ),
          ElevatedButton(
            child: const Text(
              'Add Stock',
            ),
            onPressed: () {
              _inputStock();
            },
          ),
          //We must use an Expanded widget to get
          //the dynamic ListView to play nice
          //with the TextButton.
          //StockList(stocks: _stockList),
          Expanded(
            child: StockList(stocks: _stockList),
          ),
        ],
      ),
    );
  }

  Future<void> _inputStock() async {
    await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Input Stock Symbol'),
            contentPadding: const EdgeInsets.all(5.0),
            content: TextField(
              decoration: const InputDecoration(hintText: "Symbol"),
              onChanged: (String value) {
                _stockSymbol = value;
              },
            ),
            actions: <Widget>[
              TextButton(
                child: const Text("Add Stock"),
                onPressed: () async {
                  if (_stockSymbol.isNotEmpty) {
                    print('User entered Symbol: $_stockSymbol');
                    var symbol = _stockSymbol;
                    var companyName = '';
                    var price = '';
                    try {
                      //TODO:
                      //Inside of this try,
                      //get the company data with _stockService.getCompanyInfo
                      //then get the stock data with _stockService.getQuote
                      //but remember you must use await,
                      //then if it is not null,
                      //dig out the symbol, companyName, and latestPrice,
                      //then create a new object of
                      //type Stock and add it to
                      //the database by calling
                      //_databaseService.insertStock,
                      //then get all the stocks from
                      //the database with
                      //_databaseService.getAllStocksFromDb and
                      //attach them to _stockList,
                      //then print all stocks to the console and,
                      //finally call setstate at the end.
                      var companyData =
                          await _stockService.getCompanyInfo(symbol);
                      if (companyData != null) {
                        // Add checking for API rate limit
                        if (companyData['Information'] != null) {
                          print('API rate limit exceeded.');
                        } else {
                          symbol = companyData['Symbol'];
                          companyName = companyData['Name'];
                        }
                      }

                      var stockData = await _stockService.getQuote(symbol);
                      if (stockData != null) {
                        // Add checking for API rate limit
                        if (companyData['Information'] != null) {
                          print('API rate limit exceeded.');
                        } else {
                          price = stockData['Global Quote']['05. price'];
                        }
                      }

                      if (symbol != '' && companyName != '' && price != '') {
                        await _databaseService.insertStock(Stock(
                            symbol: symbol, name: companyName, price: price));
                      }

                      _stockList = await _databaseService.getAllStocksFromDb();
                      _stockList.forEach((stock) {
                        print(stock);
                      });

                      setState(() {});
                    } catch (e) {
                      print('HomeView _inputStock catch: $e');
                    }
                  }
                  _stockSymbol = "";
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text("Cancel"),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }
}
