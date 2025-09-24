import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../models/power_data.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<DailySummary> summaries = [];
  List<DailySummary> filtered = [];
  bool loading = true;
  String range = '30d';
  final _searchCtl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
    _searchCtl.addListener(_applySearch);
  }

  @override
  void dispose() {
    _searchCtl.dispose();
    super.dispose();
  }

  void _applySearch() {
    final q = _searchCtl.text.toLowerCase();
    setState(() {
      if (q.isEmpty) filtered = summaries;
      else filtered = summaries.where((s) => s.date.toIso8601String().contains(q)).toList();
    });
  }

  Future<void> _load({bool force = false}) async {
    setState(() { loading = true; });
    final api = Provider.of<ApiService>(context, listen: false);
    summaries = await api.fetchDailySummaries(days: range == '30d' ? 30 : (range == '7d' ? 7 : 365), forceRefresh: force);
    filtered = summaries;
    setState(() { loading = false; });
  }

  Future<void> _exportCsv() async {
    final api = Provider.of<ApiService>(context, listen: false);
    final path = await api.exportSummariesAsCsv(summaries);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('CSV exported to: \$path')));
  }

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat('#,##0.00');
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () => _load(force: true),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text('History', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: TextField(controller: _searchCtl, decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search by date (ISO)'))),
              const SizedBox(width: 12),
              ChoiceChip(label: const Text('7d'), selected: range=='7d', onSelected: (v){ setState(()=>range='7d'); _load(); }),
              const SizedBox(width: 8),
              ChoiceChip(label: const Text('30d'), selected: range=='30d', onSelected: (v){ setState(()=>range='30d'); _load(); }),
              const SizedBox(width: 8),
              ChoiceChip(label: const Text('365d'), selected: range=='365d', onSelected: (v){ setState(()=>range='365d'); _load(); }),
            ]),
            const SizedBox(height: 12),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              ElevatedButton.icon(onPressed: _exportCsv, icon: const Icon(Icons.download), label: const Text('Export CSV')),
            ]),
            const SizedBox(height: 12),
            if (loading) const Center(child: CircularProgressIndicator()),
            if (!loading)
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Column(
                  children: filtered.map((s) => ListTile(
                    title: Text(DateFormat.yMMMd().format(s.date)),
                    trailing: Text('${fmt.format(s.kWh)} kWh'),
                  )).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
