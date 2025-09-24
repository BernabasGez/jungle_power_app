import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  List<String> alerts = [];
  Set<int> read = {};
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => loading = true);
    final api = Provider.of<ApiService>(context, listen: false);
    alerts = await api.fetchAlerts();
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final high = alerts.where((a) => a.startsWith('HIGH')).toList();
    final info = alerts.where((a) => a.startsWith('INFO')).toList();
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text('Alerts', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 12),
            if (loading) const Center(child: CircularProgressIndicator()),
            if (!loading) ...[
              if (high.isNotEmpty) Padding(padding: const EdgeInsets.symmetric(vertical:8.0), child: Text('High severity', style: Theme.of(context).textTheme.titleMedium)),
              ...high.asMap().entries.map((e) => Card(
                child: ListTile(
                  leading: const Icon(Icons.warning, color: Colors.redAccent),
                  title: Text(e.value),
                  trailing: IconButton(icon: Icon(read.contains(e.key) ? Icons.check_circle : Icons.circle_outlined), onPressed: (){ setState(()=> read.add(e.key)); }),
                ),
              )),
              if (info.isNotEmpty) Padding(padding: const EdgeInsets.symmetric(vertical:8.0), child: Text('Info', style: Theme.of(context).textTheme.titleMedium)),
              ...info.asMap().entries.map((e) => Card(
                child: ListTile(
                  leading: const Icon(Icons.info_outline, color: Colors.blueAccent),
                  title: Text(e.value),
                  trailing: IconButton(icon: Icon(read.contains(e.key+1000) ? Icons.check_circle : Icons.circle_outlined), onPressed: (){ setState(()=> read.add(e.key+1000)); }),
                ),
              )),
            ],
          ],
        ),
      ),
    );
  }
}
