import 'package:flutter/material.dart';
import 'package:option_battles/providers/price_provider.dart';
import 'components/game_top_bar.dart';
import 'components/button_row.dart';
import 'package:provider/provider.dart';
import 'components/price_chart.dart';

class OptionGame extends StatelessWidget {
  const OptionGame({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                colors: [Colors.blue[900]!, Colors.blue[800]!, Colors.blue[400]!],
              ),
            ),
            child: const GameTopBar(),
          ),
          Expanded(
            child: Consumer<PriceProvider>(
              builder: (context, priceProvider, child) {
                final inGamePrices = priceProvider.inGamePrices;
                final firstPrice = priceProvider.firstPrice;
                final price = priceProvider.price;
                if (inGamePrices.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                return PriceChart(priceData: inGamePrices, firstPrice: firstPrice, currentPrice: price);
              },
            ),
          ),
          const ButtonRow(buttonLabels: ["10 sats", "100 sats", "1000 sats", "10000 sats"]),
          const ButtonRow(buttonLabels: ["go up", "go down"]),
          const ButtonRow(buttonLabels: ["Play"]),
        ],
      ),
    );
  }
}
