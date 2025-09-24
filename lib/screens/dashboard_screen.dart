import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/power_data.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<PowerSnapshot> powerData = [];
  bool deviceOn = true;
  bool connected = true;

  double currentConsumption = 3.2; // kWh
  double currentPower = 120.0; // Watts
  double voltage = 220.0; // Volts
  double current = 0.55; // Amps
  double costPerKWh = 2.5; // Mock cost per kWh in ETB

  @override
  void initState() {
    super.initState();
    _generateMockData();
  }

  void _generateMockData() {
    final now = DateTime.now();
    powerData = List.generate(
      24,
      (i) => PowerSnapshot(
        time: now.subtract(Duration(hours: 23 - i)),
        kW: (0.5 + (i % 6) * 0.1), // Random-ish values
      ),
    );
  }

  double getEstimatedCost() {
    double totalKWh = powerData.fold(0, (sum, item) => sum + item.kW);
    return totalKWh * costPerKWh;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text("Power Monitoring Dashboard"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPowerStatsCard(),
            const SizedBox(height: 20),
            _buildDeviceStatusCard(),
            const SizedBox(height: 20),
            _buildCostCard(),
            const SizedBox(height: 20),
            _buildPowerChart(),
          ],
        ),
      ),
    );
  }

  Widget _buildPowerStatsCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Current Power Statistics",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStat("Consumption", "$currentConsumption kWh"),
                _buildStat("Power", "$currentPower W"),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStat("Voltage", "$voltage V"),
                _buildStat("Current", "$current A"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceStatusCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Device Status",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    Icon(
                      deviceOn ? Icons.power : Icons.power_off,
                      color: deviceOn ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 8),
                    Text(deviceOn ? "ON" : "OFF"),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      connected ? Icons.wifi : Icons.wifi_off,
                      color: connected ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 8),
                    Text(connected ? "Connected" : "Disconnected"),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCostCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Estimated Cost (Current Month)",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              "${getEstimatedCost().toStringAsFixed(2)} ETB",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPowerChart() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Power Consumption (Last 24 Hours)",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 250,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 4,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index >= powerData.length) return const Text("");
                          return Text(
                            "${powerData[index].time.hour}:00",
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: powerData
                          .asMap()
                          .entries
                          .map((e) => FlSpot(e.key.toDouble(), e.value.kW))
                          .toList(),
                      isCurved: true,
                      color: Colors.deepPurple,
                      barWidth: 3,
                      belowBarData: BarAreaData(
                          show: true,
                          color: Colors.deepPurple.withOpacity(0.3)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 16)),
      ],
    );
  }
}
