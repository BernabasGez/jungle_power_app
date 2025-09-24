class PowerSnapshot {
  final DateTime time;
  final double kW;

  PowerSnapshot({required this.time, required this.kW});

  Map<String, dynamic> toJson() => {'time': time.toIso8601String(), 'kW': kW};
  factory PowerSnapshot.fromJson(Map<String, dynamic> j) => PowerSnapshot(time: DateTime.parse(j['time']), kW: (j['kW'] as num).toDouble());
}

class DailySummary {
  final DateTime date;
  final double kWh;

  DailySummary({required this.date, required this.kWh});

  Map<String, dynamic> toJson() => {'date': date.toIso8601String(), 'kWh': kWh};
  factory DailySummary.fromJson(Map<String, dynamic> j) => DailySummary(date: DateTime.parse(j['date']), kWh: (j['kWh'] as num).toDouble());
}
