// lib\screens\dashboard\portfolios.dart

import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class PortfoliosWidget extends StatelessWidget {
  const PortfoliosWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            indicatorColor: AppConstants.accentColor,
            labelStyle: const TextStyle(
              fontFamily: 'Rajdhani',
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 14,
            ),
            tabs: const [
              Tab(text: 'Model Portfolios'),
              Tab(text: 'Personal Insights'),
            ],
          ),
          const SizedBox(height: 8),
          const Expanded(
            child: TabBarView(
              children: [
                ModelPortfoliosTab(),
                PersonalPortfolioTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ModelPortfoliosTab extends StatelessWidget {
  const ModelPortfoliosTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      children: [
        Card(
          color: AppConstants.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: AppConstants.accentColor.withOpacity(0.5)),
          ),
          elevation: 4,
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            title: const Text(
              'DeFi Starter Portfolio',
              style: TextStyle(
                  fontFamily: 'Rajdhani', color: AppConstants.textColor),
            ),
            subtitle: const Text(
              'Asset allocation: 40% ETH, 30% DAI, 30% UNI\nPerformance: +8% this month',
              style: TextStyle(
                  fontFamily: 'Roboto', color: AppConstants.textColor),
            ),
            onTap: () {
              // TODO: Detailed portfolio view.
            },
          ),
        ),
        // Additional portfolio cards...
      ],
    );
  }
}

class PersonalPortfolioTab extends StatelessWidget {
  const PersonalPortfolioTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Enter your Ethereum wallet address:',
            style:
                TextStyle(color: AppConstants.textColor, fontFamily: 'Roboto'),
          ),
          const SizedBox(height: 8),
          TextField(
            style: const TextStyle(color: AppConstants.textColor),
            decoration: InputDecoration(
              hintText: '0x...',
              hintStyle: const TextStyle(color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppConstants.accentColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppConstants.accentColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: AppConstants.accentColor, width: 2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.accentColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              // TODO: Fetch personal insights.
            },
            child: const Text(
              'Get Insights',
              style: TextStyle(color: Colors.black, fontFamily: 'Rajdhani'),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Your portfolio will be displayed here once fetched.',
            style: TextStyle(color: AppConstants.textColor),
          ),
        ],
      ),
    );
  }
}
