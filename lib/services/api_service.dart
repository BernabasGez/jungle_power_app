import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../models/power_data.dart';

class ApiService {
  // Simple mock data + caching via SharedPreferences.
  // Replace with real HTTP calls when available.

  static const _snapshotsKey = 'jp_snapshots';
  static const _summariesKey = 'jp_summaries';
  static const _alertsKey = 'jp_alerts';

  Future<void> _cacheSnapshots(List<PowerSnapshot> data) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = jsonEncode(data.map((d) => d.toJson()).toList());
    await prefs.setString(_snapshotsKey, jsonStr);
  }

  Future<void> _cacheSummaries(List<DailySummary> data) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = jsonEncode(data.map((d) => d.toJson()).toList());
    await prefs.setString(_summariesKey, jsonStr);
  }

  Future<void> _cacheAlerts(List<String> alerts) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_alertsKey, alerts);
  }

  Future<List<PowerSnapshot>> _loadCachedSnapshots() async {
    final prefs = await SharedPreferences.getInstance();
    final s = prefs.getString(_snapshotsKey);
    if (s == null) return [];
    final list = (jsonDecode(s) as List).cast<Map<String, dynamic>>();
    return list.map((m) => PowerSnapshot.fromJson(m)).toList();
  }

  Future<List<DailySummary>> _loadCachedSummaries() async {
    final prefs = await SharedPreferences.getInstance();
    final s = prefs.getString(_summariesKey);
    if (s == null) return [];
    final list = (jsonDecode(s) as List).cast<Map<String, dynamic>>();
    return list.map((m) => DailySummary.fromJson(m)).toList();
  }

  Future<List<String>> _loadCachedAlerts() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_alertsKey);
    return list ?? [];
  }

  // Public methods (mocked). Replace these with HTTP requests to your device/cloud API.
  Future<double> fetchCurrentPowerKW() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return 1.85;
  }

  Future<double> fetchTodayKWh() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return 12.8;
  }

  Future<bool> fetchDeviceOnline() async {
    await Future.delayed(const Duration(milliseconds: 160));
    return true;
  }

  Future<List<PowerSnapshot>> fetchRecentSnapshots({bool forceRefresh = false}) async {
    if (!forceRefresh) {
      final cached = await _loadCachedSnapshots();
      if (cached.isNotEmpty) return cached;
    }
    await Future.delayed(const Duration(milliseconds: 300));
    final now = DateTime.now();
    final data = List.generate(48, (i) {
      final t = now.subtract(Duration(minutes: (47 - i) * 30));
      final k = 0.7 + (i % 10) * 0.13 + (i%3)*0.04;
      return PowerSnapshot(time: t, kW: double.parse(k.toStringAsFixed(2)));
    });
    await _cacheSnapshots(data);
    return data;
  }

  Future<List<DailySummary>> fetchDailySummaries({int days = 30, bool forceRefresh = false}) async {
    if (!forceRefresh) {
      final cached = await _loadCachedSummaries();
      if (cached.isNotEmpty) return cached;
    }
    await Future.delayed(const Duration(milliseconds: 300));
    final now = DateTime.now();
    final data = List.generate(days, (i) {
      final d = DateTime(now.year, now.month, now.day).subtract(Duration(days: i));
      final k = 4.0 + (i % 14) * 0.7;
      return DailySummary(date: d, kWh: double.parse(k.toStringAsFixed(2)));
    }).reversed.toList();
    await _cacheSummaries(data);
    return data;
  }

  Future<List<String>> fetchAlerts({bool forceRefresh = false}) async {
    if (!forceRefresh) {
      final cached = await _loadCachedAlerts();
      if (cached.isNotEmpty) return cached;
    }
    await Future.delayed(const Duration(milliseconds: 180));
    final alerts = [
      'HIGH: High usage detected — ${DateTime.now().subtract(const Duration(hours: 2)).toLocal()}',
      'INFO: Firmware check completed — ${DateTime.now().subtract(const Duration(days: 3)).toLocal()}',
    ];
    await _cacheAlerts(alerts);
    return alerts;
  }

  // CSV export helper - writes to app documents directory and returns path
  Future<String> exportSummariesAsCsv(List<DailySummary> summaries) async {
    final header = 'date,kWh\n';
    final rows = summaries.map((s) => '\${s.date.toIso8601String()},\${s.kWh}').join('\n');
    final csv = header + rows;
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/jungle_power_history_\${DateTime.now().millisecondsSinceEpoch}.csv');
    await file.writeAsString(csv);
    return file.path;
  }

  // Clear cache (utility)
  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_snapshotsKey);
    await prefs.remove(_summariesKey);
    await prefs.remove(_alertsKey);
  }
}
