import 'package:flutter/material.dart';

class BillCalculatorScreen extends StatefulWidget {
  @override
  _BillCalculatorScreenState createState() => _BillCalculatorScreenState();
}

class _BillCalculatorScreenState extends State<BillCalculatorScreen> {
  // Tariff categories (removed Street Lighting)
  final List<String> customerTypes = [
    'Residential',
    'General Service',
    'Low Voltage Industrial',
    'Medium Voltage Industrial',
  ];

  // Payment types
  final List<String> paymentTypes = ['Prepaid', 'Postpaid'];

  // Years and quarters
  final List<String> years = ['2024/25', '2025/26', '2026/27', '2027/28'];
  final List<String> quarters = ['Q1', 'Q2', 'Q3', 'Q4'];

  // Selected values
  String selectedCustomerType = 'Residential';
  String selectedPaymentType = 'Postpaid';
  String selectedYear = '2024/25';
  String selectedQuarter = 'Q1';
  double consumedUnits = 0.0;

  // Calculation results
  double energyCharge = 0.0;
  double serviceCharge = 0.0;
  double vat = 0.0;
  double regulatoryFee = 0.0;
  double tvLicenseFee = 0.0;
  double totalBill = 0.0;

  // Service charges by customer type and payment type (removed Street Lighting)
  final Map<String, Map<String, double>> serviceCharges = {
    'Residential': {'Prepaid': 15.97, 'Postpaid': 45.80},
    'General Service': {'Prepaid': 65.00, 'Postpaid': 120.00},
    'Low Voltage Industrial': {'Prepaid': 150.00, 'Postpaid': 250.00},
    'Medium Voltage Industrial': {'Prepaid': 500.00, 'Postpaid': 800.00},
  };

  // Tariff rates data structure (removed Street Lighting)
  final Map<String, Map<String, Map<String, double>>> tariffRates = {
    'Residential': {
      '2024/25': {'Q1': 0.27, 'Q2': 0.35, 'Q3': 0.43, 'Q4': 0.52},
      '2025/26': {'Q1': 0.60, 'Q2': 0.68, 'Q3': 0.76, 'Q4': 0.84},
      '2026/27': {'Q1': 0.92, 'Q2': 1.00, 'Q3': 1.08, 'Q4': 1.16},
      '2027/28': {'Q1': 1.24, 'Q2': 1.32, 'Q3': 1.40, 'Q4': 1.48},
    },
    'General Service': {
      '2024/25': {'Q1': 2.12, 'Q2': 2.61, 'Q3': 3.09, 'Q4': 3.57},
      '2025/26': {'Q1': 4.05, 'Q2': 4.53, 'Q3': 5.01, 'Q4': 5.50},
      '2026/27': {'Q1': 5.98, 'Q2': 6.46, 'Q3': 6.94, 'Q4': 7.42},
      '2027/28': {'Q1': 7.90, 'Q2': 8.39, 'Q3': 8.87, 'Q4': 9.35},
    },
    'Low Voltage Industrial': {
      '2024/25': {'Q1': 1.53, 'Q2': 1.76, 'Q3': 2.02, 'Q4': 2.29},
      '2025/26': {'Q1': 2.56, 'Q2': 2.82, 'Q3': 3.09, 'Q4': 3.36},
      '2026/27': {'Q1': 3.62, 'Q2': 3.88, 'Q3': 4.15, 'Q4': 4.41},
      '2027/28': {'Q1': 4.68, 'Q2': 4.93, 'Q3': 5.20, 'Q4': 5.46},
    },
    'Medium Voltage Industrial': {
      '2024/25': {'Q1': 1.19, 'Q2': 1.39, 'Q3': 1.61, 'Q4': 1.83},
      '2025/26': {'Q1': 2.05, 'Q2': 2.27, 'Q3': 2.49, 'Q4': 2.71},
      '2026/27': {'Q1': 2.94, 'Q2': 3.16, 'Q3': 3.38, 'Q4': 3.60},
      '2027/28': {'Q1': 3.82, 'Q2': 4.04, 'Q3': 4.26, 'Q4': 4.48},
    },
  };

  // Residential tiered rates
  final Map<String, Map<String, Map<String, double>>> residentialTieredRates = {
    '0-50': {
      '2024/25': {'Q1': 0.27, 'Q2': 0.35, 'Q3': 0.43, 'Q4': 0.52},
      '2025/26': {'Q1': 0.60, 'Q2': 0.68, 'Q3': 0.76, 'Q4': 0.84},
      '2026/27': {'Q1': 0.92, 'Q2': 1.00, 'Q3': 1.08, 'Q4': 1.16},
      '2027/28': {'Q1': 1.24, 'Q2': 1.32, 'Q3': 1.40, 'Q4': 1.48},
    },
    '51-100': {
      '2024/25': {'Q1': 0.77, 'Q2': 0.95, 'Q3': 1.13, 'Q4': 1.31},
      '2025/26': {'Q1': 1.49, 'Q2': 1.67, 'Q3': 1.85, 'Q4': 2.03},
      '2026/27': {'Q1': 2.21, 'Q2': 2.39, 'Q3': 2.57, 'Q4': 2.76},
      '2027/28': {'Q1': 2.94, 'Q2': 3.12, 'Q3': 3.30, 'Q4': 3.48},
    },
    '101-200': {
      '2024/25': {'Q1': 1.63, 'Q2': 1.89, 'Q3': 2.15, 'Q4': 2.41},
      '2025/26': {'Q1': 2.67, 'Q2': 2.93, 'Q3': 3.19, 'Q4': 3.45},
      '2026/27': {'Q1': 3.72, 'Q2': 3.98, 'Q3': 4.24, 'Q4': 4.50},
      '2027/28': {'Q1': 4.76, 'Q2': 5.02, 'Q3': 5.28, 'Q4': 5.55},
    },
    '201-300': {
      '2024/25': {'Q1': 2.00, 'Q2': 2.46, 'Q3': 2.92, 'Q4': 3.38},
      '2025/26': {'Q1': 3.84, 'Q2': 4.30, 'Q3': 4.76, 'Q4': 5.22},
      '2026/27': {'Q1': 5.68, 'Q2': 6.14, 'Q3': 6.60, 'Q4': 7.06},
      '2027/28': {'Q1': 7.52, 'Q2': 7.98, 'Q3': 8.44, 'Q4': 8.89},
    },
    '301-400': {
      '2024/25': {'Q1': 2.20, 'Q2': 2.66, 'Q3': 3.12, 'Q4': 3.57},
      '2025/26': {'Q1': 4.03, 'Q2': 4.49, 'Q3': 4.95, 'Q4': 5.41},
      '2026/27': {'Q1': 5.86, 'Q2': 6.32, 'Q3': 6.78, 'Q4': 7.24},
      '2027/28': {'Q1': 7.70, 'Q2': 8.15, 'Q3': 8.61, 'Q4': 9.07},
    },
    '401-500': {
      '2024/25': {'Q1': 2.41, 'Q2': 2.85, 'Q3': 3.29, 'Q4': 3.73},
      '2025/26': {'Q1': 4.17, 'Q2': 4.62, 'Q3': 5.06, 'Q4': 5.50},
      '2026/27': {'Q1': 5.94, 'Q2': 6.39, 'Q3': 6.83, 'Q4': 7.27},
      '2027/28': {'Q1': 7.71, 'Q2': 8.16, 'Q3': 8.60, 'Q4': 9.04},
    },
    '501+': {
      '2024/25': {'Q1': 2.48, 'Q2': 2.92, 'Q3': 3.35, 'Q4': 3.79},
      '2025/26': {'Q1': 4.23, 'Q2': 4.66, 'Q3': 5.10, 'Q4': 5.54},
      '2026/27': {'Q1': 5.97, 'Q2': 6.41, 'Q3': 6.84, 'Q4': 7.28},
      '2027/28': {'Q1': 7.72, 'Q2': 8.15, 'Q3': 8.59, 'Q4': 9.03},
    },
  };

  final TextEditingController _unitsController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _unitsController.dispose();
    super.dispose();
  }

  // Calculate residential bill with tiered pricing
  double _calculateResidentialEnergyCharge(double units) {
    double total = 0.0;

    if (units > 500) {
      total += (units - 500) *
          residentialTieredRates['501+']![selectedYear]![selectedQuarter]!;
      units = 500;
    }
    if (units > 400) {
      total += (units - 400) *
          residentialTieredRates['401-500']![selectedYear]![selectedQuarter]!;
      units = 400;
    }
    if (units > 300) {
      total += (units - 300) *
          residentialTieredRates['301-400']![selectedYear]![selectedQuarter]!;
      units = 300;
    }
    if (units > 200) {
      total += (units - 200) *
          residentialTieredRates['201-300']![selectedYear]![selectedQuarter]!;
      units = 200;
    }
    if (units > 100) {
      total += (units - 100) *
          residentialTieredRates['101-200']![selectedYear]![selectedQuarter]!;
      units = 100;
    }
    if (units > 50) {
      total += (units - 50) *
          residentialTieredRates['51-100']![selectedYear]![selectedQuarter]!;
      units = 50;
    }
    if (units > 0) {
      total += units *
          residentialTieredRates['0-50']![selectedYear]![selectedQuarter]!;
    }

    return total;
  }

  // Calculate bill based on inputs
  void calculateBill() {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();

      setState(() {
        // Calculate energy charge
        if (selectedCustomerType == 'Residential') {
          energyCharge = _calculateResidentialEnergyCharge(consumedUnits);
        } else {
          energyCharge = consumedUnits *
              tariffRates[selectedCustomerType]![selectedYear]![
                  selectedQuarter]!;
        }

        // Get service charge
        serviceCharge =
            serviceCharges[selectedCustomerType]![selectedPaymentType]!;

        // Calculate subtotal
        double subtotal = energyCharge + serviceCharge;

        // Calculate VAT (15%) - exempt if residential and usage < 200 kWh
        if (selectedCustomerType == 'Residential' && consumedUnits <= 200) {
          vat = 0.0;
        } else {
          vat = subtotal * 0.15;
        }

        // Calculate regulatory fee (0.5%)
        regulatoryFee = subtotal * 0.005;

        // TV license fee (10 birr for residential, 0 for others)
        tvLicenseFee = (selectedCustomerType == 'Residential') ? 10.0 : 0.0;

        // Calculate total bill
        totalBill = subtotal + vat + regulatoryFee + tvLicenseFee;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.calculate, size: 32),
            SizedBox(width: 12),
            Text("Ethiopian Electric Utility Bill Calculator"),
          ],
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Customer type dropdown
              DropdownButtonFormField<String>(
                value: selectedCustomerType,
                decoration: InputDecoration(
                  labelText: "Customer Type",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                items: customerTypes.map((type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCustomerType = value!;
                  });
                },
              ),
              SizedBox(height: 16),

              // Payment type dropdown
              DropdownButtonFormField<String>(
                value: selectedPaymentType,
                decoration: InputDecoration(
                  labelText: "Payment Type",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.payment),
                ),
                items: paymentTypes.map((type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedPaymentType = value!;
                  });
                },
              ),
              SizedBox(height: 16),

              // Year dropdown
              DropdownButtonFormField<String>(
                value: selectedYear,
                decoration: InputDecoration(
                  labelText: "Tariff Year",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                items: years.map((year) {
                  return DropdownMenuItem<String>(
                    value: year,
                    child: Text(year),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedYear = value!;
                  });
                },
              ),
              SizedBox(height: 16),

              // Quarter dropdown
              DropdownButtonFormField<String>(
                value: selectedQuarter,
                decoration: InputDecoration(
                  labelText: "Quarter",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.date_range),
                ),
                items: quarters.map((quarter) {
                  return DropdownMenuItem<String>(
                    value: quarter,
                    child: Text(quarter),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedQuarter = value!;
                  });
                },
              ),
              SizedBox(height: 16),

              // Consumed units input
              TextFormField(
                controller: _unitsController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: "Consumed Units (kWh)",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.bolt),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter consumed units';
                  }
                  final parsedValue = double.tryParse(value);
                  if (parsedValue == null || parsedValue < 0) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    consumedUnits = double.tryParse(value) ?? 0.0;
                  });
                },
              ),
              SizedBox(height: 24),

              // Calculate button
              ElevatedButton(
                onPressed: calculateBill,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                child: Text(
                  "Calculate Bill",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              SizedBox(height: 24),

              // Results section
              if (totalBill > 0) ...[
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            "Bill Calculation Results",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        _buildResultRow("Energy Charge:",
                            "${energyCharge.toStringAsFixed(2)} ETB"),
                        _buildResultRow("Service Charge:",
                            "${serviceCharge.toStringAsFixed(2)} ETB"),
                        _buildResultRow(
                            "VAT (15%):", "${vat.toStringAsFixed(2)} ETB"),
                        _buildResultRow("Regulatory Fee (0.5%):",
                            "${regulatoryFee.toStringAsFixed(2)} ETB"),
                        if (tvLicenseFee > 0)
                          _buildResultRow("TV License Fee:",
                              "${tvLicenseFee.toStringAsFixed(2)} ETB"),
                        Divider(thickness: 2),
                        _buildResultRow(
                          "TOTAL BILL:",
                          "${totalBill.toStringAsFixed(2)} ETB",
                          isTotal: true,
                        ),
                        SizedBox(height: 16),
                        if (selectedCustomerType == 'Residential' &&
                            consumedUnits <= 200)
                          Text(
                            "* VAT exempted for residential customers using 200 kWh or less",
                            style: TextStyle(
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                              color: Colors.green,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Theme.of(context).primaryColor : null,
            ),
          ),
        ],
      ),
    );
  }
}
