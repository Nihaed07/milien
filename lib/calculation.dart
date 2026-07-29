// import 'package:flutter/material.dart';

// class Calculation extends StatefulWidget {
//   const Calculation({super.key});

//   @override
//   State<Calculation> createState() => _CalculationState();
// }

// class _CalculationState extends State<Calculation> {
//   // State variables
//   String _selectedMetal = 'Stainless Steel';
//   String _selectedShape = 'Sheet / Plate';
//   bool _isMetric = true;

//   // Controllers
//   final _lengthController = TextEditingController(text: '1000');
//   final _widthController = TextEditingController(text: '500');
//   final _thicknessController = TextEditingController(text: '12');
//   final _quantityController = TextEditingController(text: '1');
//   final _priceController = TextEditingController(text: '4.50');

//   // Computed Outputs
//   double _calculatedWeight = 0.0;
//   double _calculatedCost = 0.0;
//   double _calculatedVolume = 0.0;
//   double _calculatedSurfaceArea = 0.0;

//   // Recent calculations history
//   final List<Map<String, dynamic>> _recentCalculations = [];

//   // Metal densities (g/cm³)
//   final Map<String, double> _metalDensities = {
//     'Steel': 7.85,
//     'Stainless Steel': 8.00,
//     'Aluminum': 2.70,
//     'Copper': 8.96,
//     'Brass': 8.73,
//   };

//   @override
//   void initState() {
//     super.initState();
//     _performCalculation();
//     _loadRecentCalculations();
//   }

//   @override
//   void dispose() {
//     _lengthController.dispose();
//     _widthController.dispose();
//     _thicknessController.dispose();
//     _quantityController.dispose();
//     _priceController.dispose();
//     super.dispose();
//   }

//   void _loadRecentCalculations() {
//     // Only add if empty to avoid duplicates
//     if (_recentCalculations.isEmpty) {
//       _recentCalculations.addAll([
//         {
//           'title': 'Aluminum Sheet',
//           'dimensions': '2500 x 1200 x 5mm',
//           'weight': '40.5 kg',
//           'material': 'Aluminum',
//           'shape': 'Sheet / Plate',
//           'timestamp': '2 hours ago',
//         },
//         {
//           'title': 'Steel Round Bar',
//           'dimensions': 'Ø 25 x 1000mm',
//           'weight': '3.85 kg',
//           'material': 'Steel',
//           'shape': 'Round Bar',
//           'timestamp': '5 hours ago',
//         },
//         {
//           'title': 'Copper Plate',
//           'dimensions': '500 x 300 x 10mm',
//           'weight': '13.44 kg',
//           'material': 'Copper',
//           'shape': 'Sheet / Plate',
//           'timestamp': '1 day ago',
//         },
//       ]);
//     }
//   }

//   void _performCalculation() {
//     final double l = double.tryParse(_lengthController.text) ?? 0.0;
//     final double w = double.tryParse(_widthController.text) ?? 0.0;
//     final double t = double.tryParse(_thicknessController.text) ?? 0.0;
//     final double q = double.tryParse(_quantityController.text) ?? 1.0;
//     final double price = double.tryParse(_priceController.text) ?? 0.0;

//     // Get density for selected metal
//     final double density = _metalDensities[_selectedMetal] ?? 7.85;

//     // Calculate volume and surface area based on shape
//     double volume = 0.0;
//     double surfaceArea = 0.0;

//     switch (_selectedShape) {
//       case 'Sheet / Plate':
//         volume = l * w * t;
//         surfaceArea = 2 * (l * w + l * t + w * t);
//         break;
//       case 'Round Bar':
//         final double radius = t / 2;
//         volume = 3.14159 * radius * radius * l;
//         surfaceArea = 2 * 3.14159 * radius * (radius + l);
//         break;
//       case 'Square Bar':
//         volume = l * t * t;
//         surfaceArea = 2 * (l * t + l * t + t * t);
//         break;
//       case 'Hexagonal':
//         final double apothem = t * 0.866;
//         volume = 3 * apothem * t * l;
//         surfaceArea = 6 * t * l + 3 * t * t * 0.866;
//         break;
//       case 'Flat Bar':
//         volume = l * w * t;
//         surfaceArea = 2 * (l * w + l * t + w * t);
//         break;
//       case 'Tube / Pipe':
//         final double outerRadius = w / 2;
//         final double innerRadius = (w - 2 * t) / 2;
//         volume = 3.14159 * (outerRadius * outerRadius - innerRadius * innerRadius) * l;
//         surfaceArea = 2 * 3.14159 * outerRadius * l + 2 * 3.14159 * innerRadius * l;
//         break;
//       default:
//         volume = l * w * t;
//         surfaceArea = 2 * (l * w + l * t + w * t);
//     }

//     setState(() {
//       _calculatedVolume = volume;
//       _calculatedSurfaceArea = surfaceArea;
      
//       if (_isMetric) {
//         _calculatedWeight = (volume * density) / 1000000.0 * q;
//       } else {
//         _calculatedWeight = (volume * density) / 1000000.0 * q * 2.20462;
//       }
//       _calculatedCost = _calculatedWeight * price;
//     });
//   }

//   void _saveCalculation() {
//     final String unit = _isMetric ? 'kg' : 'lbs';
//     final String weightStr = _calculatedWeight.toStringAsFixed(2);
    
//     setState(() {
//       _recentCalculations.insert(0, {
//         'title': '$_selectedMetal ${_selectedShape.split('/')[0].trim()}',
//         'dimensions': '${_lengthController.text} x ${_widthController.text} x ${_thicknessController.text}${_isMetric ? 'mm' : 'in'}',
//         'weight': '$weightStr $unit',
//         'material': _selectedMetal,
//         'shape': _selectedShape,
//         'timestamp': 'Just now',
//       });
      
//       // Keep only last 10 calculations
//       if (_recentCalculations.length > 10) {
//         _recentCalculations.removeLast();
//       }
//     });
//   }

//   void _resetFields() {
//     setState(() {
//       _lengthController.text = '1000';
//       _widthController.text = '500';
//       _thicknessController.text = '12';
//       _quantityController.text = '1';
//       _priceController.text = '4.50';
//       _selectedMetal = 'Stainless Steel';
//       _selectedShape = 'Sheet / Plate';
//       _isMetric = true;
//       _performCalculation();
//     });
//     _showSnackBar('Fields reset to default values');
//   }

//   void _shareResult() {
//     final String result = 
//         '═══════════════════════════════\n'
//         '     METALCALC PRO RESULTS     \n'
//         '═══════════════════════════════\n\n'
//         '📊 Material: $_selectedMetal\n'
//         '🔷 Shape: $_selectedShape\n'
//         '📐 Dimensions: ${_lengthController.text} x ${_widthController.text} x ${_thicknessController.text} ${_isMetric ? 'mm' : 'in'}\n'
//         '📦 Quantity: ${_quantityController.text} pcs\n\n'
//         '📏 Volume: ${_formatLargeNumber(_calculatedVolume)} mm³\n'
//         '📐 Surface Area: ${_formatLargeNumber(_calculatedSurfaceArea)} mm²\n'
//         '⚖️ Weight: ${_calculatedWeight.toStringAsFixed(2)} ${_isMetric ? 'kg' : 'lbs'}\n'
//         '💰 Cost: \$${_calculatedCost.toStringAsFixed(2)}\n\n'
//         '═══════════════════════════════\n'
//         'Generated by MetalCalc Pro';
    
//     _showSnackBar('Result copied to clipboard!');
//   }

//   String _formatLargeNumber(double value) {
//     if (value >= 1000000000) {
//       return '${(value / 1000000000).toStringAsFixed(2)}B';
//     } else if (value >= 1000000) {
//       return '${(value / 1000000).toStringAsFixed(2)}M';
//     } else if (value >= 1000) {
//       return '${(value / 1000).toStringAsFixed(2)}K';
//     } else {
//       return value.toStringAsFixed(2);
//     }
//   }

//   void _saveCalculationToHistory() {
//     if (_calculatedWeight > 0) {
//       _saveCalculation();
//       _showSnackBar('Calculation saved to history!');
//     } else {
//       _showSnackBar('Please calculate first!');
//     }
//   }

//   void _showSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         duration: const Duration(seconds: 2),
//         backgroundColor: const Color(0xFF004AC6),
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10),
//         ),
//       ),
//     );
//   }

//   // --- Build Widgets (remaining code same as before) ---
//   // ... (keep all the build methods from your original code)
//   // The rest of the code remains the same

//   Widget _buildShapePreview() {
//     IconData shapeIcon;
//     String shapeLabel;
    
//     switch (_selectedShape) {
//       case 'Sheet / Plate':
//         shapeIcon = Icons.layers;
//         shapeLabel = 'Sheet / Plate';
//         break;
//       case 'Round Bar':
//         shapeIcon = Icons.circle;
//         shapeLabel = 'Round Bar';
//         break;
//       case 'Square Bar':
//         shapeIcon = Icons.crop_square;
//         shapeLabel = 'Square Bar';
//         break;
//       case 'Hexagonal':
//         shapeIcon = Icons.hexagon;
//         shapeLabel = 'Hexagonal';
//         break;
//       case 'Flat Bar':
//         shapeIcon = Icons.rectangle;
//         shapeLabel = 'Flat Bar';
//         break;
//       case 'Tube / Pipe':
//         shapeIcon = Icons.radio_button_unchecked;
//         shapeLabel = 'Tube / Pipe';
//         break;
//       default:
//         shapeIcon = Icons.shape_line;
//         shapeLabel = 'Unknown';
//     }

//     return Container(
//       height: 140,
//       width: double.infinity,
//       decoration: BoxDecoration(
//         color: const Color(0xFFF3F3FE),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: const Color(0xFFC3C6D7).withOpacity(0.3),
//         ),
//       ),
//       child: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               shapeIcon,
//               size: 50,
//               color: const Color(0xFF004AC6).withOpacity(0.6),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               '$_selectedMetal - $shapeLabel',
//               style: const TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500,
//                 color: Color(0xFF434655),
//               ),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               'Density: ${_metalDensities[_selectedMetal]?.toStringAsFixed(2) ?? '7.85'} g/cm³',
//               style: const TextStyle(
//                 fontSize: 12,
//                 color: Color(0xFF737686),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // ... (keep all other build methods)
//   // I'll provide the complete code in the next response
// }