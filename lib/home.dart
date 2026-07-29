import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:metal_weight/history-service.dart';
import 'package:metal_weight/history.dart';
import 'package:metal_weight/models.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final HistoryService _historyService = HistoryService();
  
  int _bottomNavIndex = 0;
  String _selectedType = 'Weight';
  String _selectedShape = 'Round';
  String _selectedMaterial = 'Steel/MS';
  String _selectedDiaUnit = 'mm';
  String _selectedLengthUnit = 'mm';
  String _selectedRateUnit = 'per kg';

  final TextEditingController _diaController = TextEditingController(text: '0');
  final TextEditingController _lengthController = TextEditingController(text: '0');
  final TextEditingController _qtyController = TextEditingController(text: '0');
  final TextEditingController _rateController = TextEditingController(text: '0');

  double _weightKg = 0;
  double _weightGram = 0;
  double _weightLb = 0;
  double _weightOz = 0;
  double _totalCost =0;

  final List<String> _shapes = [
    'Round',
    'Round Pipe',
    'Round (Hex)',
    'Sphere / Ball',
    'Square',
    'Square Pipe',
    'Square (Round)',
    'Rectangle / Sheet',
    'Rectangle Pipe',
    'Hex',
    'Hex (Round)',
    'Octagonal',
    'Triangle',
    'Trapezoid',
    'Trapezium',
    'Oval',
    'CR Square',
    'CR Rectangle',
    'Angle',
    'Channel',
    'T Bar',
    'I Beam',
    'C Shape',
    'E Shape',
  ];

  final List<String> _materials = [
    'Steel/MS',
    'Stainless Steel',
    'Aluminum',
    'Copper',
    'Brass',
    'Cast Iron',
    'Titanium',
    'Zinc',
    'Lead',
  ];

  final Map<String, double> _densities = {
    'Steel/MS': 7.85,
    'Stainless Steel': 8.00,
    'Aluminum': 2.70,
    'Copper': 8.96,
    'Brass': 8.73,
    'Cast Iron': 7.20,
    'Titanium': 4.51,
    'Zinc': 7.14,
    'Lead': 11.34,
  };

  @override
  void dispose() {
    _diaController.dispose();
    _lengthController.dispose();
    _qtyController.dispose();
    _rateController.dispose();
    super.dispose();
  }

  // The main calculate method - now async
  Future<void> _calculate() async {
    final double dia = double.tryParse(_diaController.text) ?? 0;
    final double length = double.tryParse(_lengthController.text) ?? 0;
    final double qty = double.tryParse(_qtyController.text) ?? 1;
    final double rate = double.tryParse(_rateController.text) ?? 0;

    // Convert units to mm
    double diaMM = dia;
    double lengthMM = length;

    if (_selectedDiaUnit == 'cm') diaMM = dia * 10;
    if (_selectedDiaUnit == 'inch') diaMM = dia * 25.4;
    if (_selectedLengthUnit == 'm') lengthMM = length * 1000;
    if (_selectedLengthUnit == 'ft') lengthMM = length * 304.8;

    double volumeMM3 = 0;
    switch (_selectedShape) {
      case 'Round':
        volumeMM3 = 3.14159 * (diaMM / 2) * (diaMM / 2) * lengthMM;
        break;
      case 'Round Pipe':
        final double innerDia = diaMM - 2;
        volumeMM3 = 3.14159 * ((diaMM / 2) * (diaMM / 2) - (innerDia / 2) * (innerDia / 2)) * lengthMM;
        break;
      case 'Square':
        volumeMM3 = diaMM * diaMM * lengthMM;
        break;
      case 'Square Pipe':
        final double innerDia = diaMM - 2;
        volumeMM3 = (diaMM * diaMM - innerDia * innerDia) * lengthMM;
        break;
      case 'Rectangle / Sheet':
        volumeMM3 = diaMM * lengthMM * 1;
        break;
      case 'Sphere / Ball':
        volumeMM3 = (4 / 3) * 3.14159 * (diaMM / 2) * (diaMM / 2) * (diaMM / 2);
        break;
      case 'Hex':
        volumeMM3 = 2.598 * diaMM * diaMM * lengthMM;
        break;
      case 'Octagonal':
        volumeMM3 = 2.828 * diaMM * diaMM * lengthMM;
        break;
      case 'Triangle':
        volumeMM3 = 0.5 * diaMM * diaMM * lengthMM;
        break;
      default:
        volumeMM3 = 3.14159 * (diaMM / 2) * (diaMM / 2) * lengthMM;
    }

    // Calculate weight
    final double density = _densities[_selectedMaterial] ?? 7.85;
    final double volumeCM3 = volumeMM3 / 1000;
    final double weightPerPiece = volumeCM3 * density / 1000;
    final double totalWeight = weightPerPiece * qty;

    setState(() {
      _weightKg = totalWeight;
      _weightGram = totalWeight * 1000;
      _weightLb = totalWeight * 2.20462;
      _weightOz = totalWeight * 35.274;
      _totalCost = totalWeight * rate;
    });

    // Save to history
    await _saveToHistory(totalWeight);
    _showSnackBar('Calculation complete!');
  }

  // Save calculation to history - FIXED: using iconName instead of icon
  Future<void> _saveToHistory(double weight) async {
    final now = DateTime.now();
    final timeString = _getTimeString(now);
    
    // Get icon name based on shape
    String iconName;
    Color bgColor;
    Color iconColor;
    
    switch (_selectedShape) {
      case 'Round':
        iconName = 'circle';
        bgColor = const Color(0xFFDBE1FF);
        iconColor = const Color(0xFF003EA8);
        break;
      case 'Square':
        iconName = 'square';
        bgColor = const Color(0xFFE8F5E9);
        iconColor = const Color(0xFF2E7D32);
        break;
      case 'Rectangle / Sheet':
        iconName = 'crop_square';
        bgColor = const Color(0xFFFFF3E0);
        iconColor = const Color(0xFFE65100);
        break;
      case 'Sphere / Ball':
        iconName = 'circle';
        bgColor = const Color(0xFFE3F2FD);
        iconColor = const Color(0xFF0D47A1);
        break;
      case 'Round Pipe':
        iconName = 'horizontal_rule';
        bgColor = const Color(0xFFF3E5F5);
        iconColor = const Color(0xFF4A148C);
        break;
      case 'Square Pipe':
        iconName = 'view_column';
        bgColor = const Color(0xFFE0F2F1);
        iconColor = const Color(0xFF004D40);
        break;
      default:
        iconName = 'calculate';
        bgColor = const Color(0xFFF3E5F5);
        iconColor = const Color(0xFF4A148C);
    }

    final calculation = CalculationModel(
      title: '$_selectedMaterial',
      subtitle: '$_selectedShape • ${_diaController.text} x ${_lengthController.text} mm',
      weight: '${weight.toStringAsFixed(1)} kg',
      time: timeString,
      iconName: iconName, // Changed from icon: icon
      bgColor: bgColor,
      iconColor: iconColor,
      weightValue: weight,
      details: {
        'shape': _selectedShape,
        'material': _selectedMaterial,
        'density': _densities[_selectedMaterial],
        'diameter': _diaController.text,
        'length': _lengthController.text,
        'quantity': _qtyController.text,
        'rate': _rateController.text,
        'totalCost': _totalCost.toStringAsFixed(2),
      },
    );

    await _historyService.addCalculation(calculation);
  }

  String _getTimeString(DateTime time) {
    final now = DateTime.now();
    if (time.day == now.day && time.month == now.month && time.year == now.year) {
      return 'Today, ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    } else if (time.day == now.day - 1 && time.month == now.month && time.year == now.year) {
      return 'Yesterday, ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    } else {
      return '${_getMonthShort(time.month)} ${time.day}, ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    }
  }

  String _getMonthShort(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }

  void _reset() {
    setState(() {
      _diaController.text = '';
      _lengthController.text = '';
      _qtyController.text = '1';
      _rateController.text = '';
      _weightKg = 0;
      _weightGram = 0;
      _weightLb = 0;
      _weightOz = 0;
      _totalCost = 0;
    });
    _showSnackBar('Fields reset');
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
        backgroundColor: const Color(0xFF004AC6),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF004AC6),
        elevation: 0,
        title: const Text(
          'Milien',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const History()),
              );
            },
          ),
         
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildTopHeaderSection(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Column(
                children: [
                  _buildVisualizationCard(),
                  const SizedBox(height: 16),
                  _buildInputFields(),
                  const SizedBox(height: 16),
                  _buildControlButtons(),
                  const SizedBox(height: 16),
                  _buildResultGrid(),
                  const SizedBox(height: 12),
                  _buildTotalCostBar(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopHeaderSection() {
    return Container(
      color: const Color(0xFF004AC6),
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.white24, width: 1),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    decoration: const BoxDecoration(
                      border: Border(
                        right: BorderSide(color: Colors.white24, width: 1),
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedShape,
                        dropdownColor: const Color(0xFF004AC6),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                        items: _shapes.map((val) => DropdownMenuItem(value: val, child: Text(val))).toList(),
                        onChanged: (val) => setState(() => _selectedShape = val!),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedMaterial,
                        dropdownColor: const Color(0xFF004AC6),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                        items: _materials.map((val) => DropdownMenuItem(value: val, child: Text(val))).toList(),
                        onChanged: (val) => setState(() => _selectedMaterial = val!),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _buildRadioButton('Weight'),
                    const SizedBox(width: 16),
                    _buildRadioButton('Length'),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      '${_densities[_selectedMaterial]?.toStringAsFixed(2) ?? '7.85'} ',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    const Text(
                      'g/cm³',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRadioButton(String title) {
    return InkWell(
      onTap: () => setState(() => _selectedType = title),
      child: Row(
        children: [
          Radio<String>(
            value: title,
            groupValue: _selectedType,
            activeColor: Colors.white,
            fillColor: MaterialStateProperty.all(Colors.white),
            onChanged: (val) => setState(() => _selectedType = val!),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
          ),
          const SizedBox(width: 4),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVisualizationCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFC3C6D7).withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: SizedBox(
          width: 160,
          height: 160,
          child: Stack(
            alignment: Alignment.center,
            children: [
              _buildShapeVisualization(),
              Positioned(
                right: 5,
                child: SizedBox(
                  height: 80,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Icon(Icons.expand_less, size: 14, color: Color(0xFF737686)),
                      Text('D', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF004AC6))),
                      Icon(Icons.expand_more, size: 14, color: Color(0xFF737686)),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 5,
                child: Row(
                  children: [
                    Container(width: 50, height: 1.5, color: const Color(0xFF004AC6)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      color: Colors.white,
                      child: const Text(
                        'L',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF004AC6)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShapeVisualization() {
    switch (_selectedShape) {
      case 'Round':
        return Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: const Color(0xFF004AC6).withOpacity(0.7),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF004AC6), width: 2),
          ),
        );
      case 'Square':
        return Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: const Color(0xFF004AC6).withOpacity(0.7),
            border: Border.all(color: const Color(0xFF004AC6), width: 2),
          ),
        );
      case 'Sphere / Ball':
        return Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: const RadialGradient(
              colors: [Color(0xFF004AC6), Color(0xFF0066FF)],
              center: Alignment.center,
              radius: 0.7,
            ),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF004AC6), width: 2),
          ),
        );
      case 'Rectangle / Sheet':
        return Container(
          width: 80,
          height: 60,
          decoration: BoxDecoration(
            color: const Color(0xFF004AC6).withOpacity(0.7),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: const Color(0xFF004AC6), width: 2),
          ),
        );
      default:
        return Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: const Color(0xFF004AC6).withOpacity(0.7),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF004AC6), width: 2),
          ),
        );
    }
  }

  Widget _buildInputFields() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFC3C6D7).withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildInputRow('Dia (D)', _diaController, _selectedDiaUnit, ['mm', 'cm', 'inch'], (v) => _selectedDiaUnit = v),
          const SizedBox(height: 8),
          _buildInputRow('Length (L)', _lengthController, _selectedLengthUnit, ['mm', 'm', 'ft'], (v) => _selectedLengthUnit = v),
          const SizedBox(height: 8),
          _buildInputRow('Quantity', _qtyController, 'piece', null, null, isStaticUnit: true),
          const SizedBox(height: 8),
          _buildInputRow('Rate', _rateController, _selectedRateUnit, ['per kg', 'per ton'], (v) => _selectedRateUnit = v),
        ],
      ),
    );
  }

  Widget _buildInputRow(
    String label,
    TextEditingController controller,
    String selectedUnit,
    List<String>? options,
    Function(String)? onUnitChanged, {
    bool isStaticUnit = false,
  }) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF191B23),
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F3FE),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: const Color(0xFFC3C6D7).withOpacity(0.2)),
            ),
            child: TextField(
              controller: controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              textAlign: TextAlign.center,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*$')),
              ],
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 8),
              ),
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 75,
          child: isStaticUnit
              ? Center(
                  child: Text(
                    selectedUnit,
                    style: const TextStyle(fontSize: 12, color: Color(0xFF737686)),
                  ),
                )
              : Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F3FE),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedUnit,
                      isExpanded: true,
                      style: const TextStyle(fontSize: 12, color: Colors.black87),
                      items: options!.map((val) => DropdownMenuItem(value: val, child: Text(val))).toList(),
                      onChanged: (val) {
                        if (val != null && onUnitChanged != null) {
                          setState(() => onUnitChanged(val));
                        }
                      },
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildControlButtons() {
    return Row(
      children: [
        _buildActionButton('0', onTap: () {
          _diaController.text = '0';
          _calculate();
        }),
        const SizedBox(width: 8),
        _buildActionButton('S', onTap: () {
          final temp = _diaController.text;
          _diaController.text = _lengthController.text;
          _lengthController.text = temp;
        }),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            height: 46,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF004AC6), Color(0xFF0066FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(6),
            ),
            child: ElevatedButton(
              onPressed: () => _calculate(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Calculate',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        _buildActionButton('Reset', onTap: _reset, isWide: true),
      ],
    );
  }

  Widget _buildActionButton(String text, {VoidCallback? onTap, bool isWide = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 46,
        padding: EdgeInsets.symmetric(horizontal: isWide ? 16 : 20),
        decoration: BoxDecoration(
          color: const Color(0xFFE7E7F3),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Color(0xFF191B23),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultGrid() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFC3C6D7).withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildResultCard('Kilogram', _weightKg.toStringAsFixed(1))),
              const SizedBox(width: 8),
              Expanded(child: _buildResultCard('Gram', _weightGram.toStringAsFixed(5))),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _buildResultCard('Pound', _weightLb.toStringAsFixed(1))),
              const SizedBox(width: 8),
              Expanded(child: _buildResultCard('Ounce', _weightOz.toStringAsFixed(0))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFF),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE1E5F0), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Color(0xFF737686),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 2),
          Container(height: 1, color: const Color(0xFFE1E5F0)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF004AC6),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildTotalCostBar() {
    final rate = double.tryParse(_rateController.text) ?? 0;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFF004AC6).withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF004AC6).withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Total cost (${rate.toStringAsFixed(1)}/kg) :',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF191B23),
            ),
          ),
          Text(
            _totalCost.toStringAsFixed(2),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF004AC6),
            ),
          ),
        ],
      ),
    );
  }
}