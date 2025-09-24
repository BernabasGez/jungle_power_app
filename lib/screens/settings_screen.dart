import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool useKWh = true;

  @override
  Widget build(BuildContext context) {
    final api = Provider.of<ApiService>(context, listen: false);
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Settings', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 12),
          Card(child: SwitchListTile(title: const Text('Use kWh (else Wh)'), value: useKWh, onChanged: (v){ setState(()=> useKWh=v); })),
          const SizedBox(height: 8),
          Card(child: ListTile(title: const Text('Company'), subtitle: const Text('Jungle Power'))),
          const SizedBox(height: 8),
          Card(child: ListTile(
            title: const Text('Clear cached data'),
            trailing: ElevatedButton(onPressed: () async { await api.clearCache(); if (!mounted) return; ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cache cleared'))); }, child: const Text('Clear')),
          )),
        ],
      ),
    );
  }
}
