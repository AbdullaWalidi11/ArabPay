import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../providers/app_provider.dart';
import '../models/linked_method.dart';
import '../theme/app_colors.dart';

class AddMethodView extends StatefulWidget {
  const AddMethodView({super.key});

  @override
  State<AddMethodView> createState() => _AddMethodViewState();
}

class _AddMethodViewState extends State<AddMethodView> {
  int _currentStep = 0; // Start at Step 1 (index 0)
  String? _selectedCountry;
  String? _selectedMethod;
  String? _selectedInstitution;
  final _nicknameController = TextEditingController();

  List<String> _countries = [];
  Map<String, List<Map<String, dynamic>>> _countryInstitutions = {};
  List<String> _availableInstitutions = [];

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  Future<void> _loadAllData() async {
    final String response =
        await rootBundle.loadString('assets/data/institutions.json');
    final data = json.decode(response);
    final List<dynamic> countriesJson = data['countries'];

    setState(() {
      _countries =
          countriesJson.map((c) => c['country_name'] as String).toList();
      for (var country in countriesJson) {
        _countryInstitutions[country['country_name']] =
            List<Map<String, dynamic>>.from(country['institutions']);
      }
    });
  }

  void _filterInstitutions() {
    if (_selectedCountry != null && _selectedMethod != null) {
      final String targetType =
          _selectedMethod == 'Bank Account' ? 'bank' : 'wallet';
      setState(() {
        _availableInstitutions = _countryInstitutions[_selectedCountry!]!
            .where((inst) => inst['type'] == targetType)
            .map((inst) => inst['name'] as String)
            .toList();
        _selectedInstitution = null; // Reset when selection changes
      });
    }
  }

  final Map<String, String> _currencies = {
    'Saudi Arabia': 'SAR - Saudi Riyal',
    'Egypt': 'EGP - Egyptian Pound',
    'Jordan': 'JOD - Jordanian Dinar',
    'UAE': 'AED - UAE Dirham',
    'United Arab Emirates': 'AED - UAE Dirham',
    'Morocco': 'MAD - Moroccan Dirham',
    'Qatar': 'QAR - Qatari Riyal',
    'Kuwait': 'KWD - Kuwaiti Dinar',
  };

  void _nextStep() {
    if (_currentStep < 2) {
      setState(() => _currentStep++);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(LucideIcons.arrowLeft,
                        color: Color(0xFF0F172A)),
                    onPressed: () => context.pop(),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Add Receiving Method',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon:
                        const Icon(LucideIcons.bell, color: Color(0xFF0F172A)),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 8),
                  const CircleAvatar(
                    radius: 16,
                    backgroundColor: Color(0xFFFFD1C1),
                    child:
                        Icon(LucideIcons.user, color: Colors.brown, size: 16),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    // Custom Stepper
                    _buildStepper(),
                    const SizedBox(height: 24),

                    // Main Form Card
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEFF6FF),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(LucideIcons.wallet,
                                    color: Color(0xFF1D4ED8), size: 24),
                              ),
                              const SizedBox(width: 16),
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Receiving Account',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF0F172A)),
                                  ),
                                  Text(
                                    'Configure how you\'d like to receive\nfunds.',
                                    style: TextStyle(
                                        fontSize: 13, color: Color(0xFF64748B)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),

                          // STEP 1: Country
                          _buildLabel('Destination Country'),
                          const SizedBox(height: 12),
                          _buildCountryPicker(),
                          const SizedBox(height: 24),

                          // STEP 2: Method Type (Visible if country selected)
                          if (_selectedCountry != null) ...[
                            _buildLabel('Method Type'),
                            const SizedBox(height: 12),
                            _buildMethodOption(
                                LucideIcons.landmark,
                                'Bank Account',
                                _selectedMethod == 'Bank Account'),
                            const SizedBox(height: 12),
                            _buildMethodOption(
                                LucideIcons.smartphone,
                                'Mobile Wallet',
                                _selectedMethod == 'Mobile Wallet'),
                            const SizedBox(height: 12),
                          ],

                          // STEP 3: Details (Visible if method selected)
                          if (_selectedMethod != null) ...[
                            _buildLabel('Select Provider'),
                            const SizedBox(height: 12),
                            _buildInstitutionPicker(),
                            const SizedBox(height: 24),

                            _buildLabel('Currency'),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEFF6FF),
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(color: const Color(0xFFDBEAFE)),
                              ),
                              child: Row(
                                children: [
                                  const Icon(LucideIcons.refreshCw,
                                      size: 20, color: Color(0xFF1D4ED8)),
                                  const SizedBox(width: 12),
                                  Text(
                                    _currencies[_selectedCountry] ??
                                        'SAR - Saudi Riyal',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1D4ED8)),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),

                            _buildLabel('Account Nickname'),
                            const SizedBox(height: 12),
                            _buildTextField('e.g. My Savings', LucideIcons.tag,
                                _nicknameController),
                            const SizedBox(height: 32),

                            // Security Note
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF0FDF4),
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(color: const Color(0xFFDCFCE7)),
                              ),
                              child: const Row(
                                children: [
                                  Icon(LucideIcons.shieldCheck,
                                      color: Color(0xFF166534), size: 20),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      'Your data is encrypted using 256-bit institutional grade security.',
                                      style: TextStyle(
                                          color: Color(0xFF166534),
                                          fontSize: 12,
                                          height: 1.4),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Main Action Button (Enabled only when all steps finished)
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: (_selectedCountry != null &&
                                _selectedMethod != null &&
                                _selectedInstitution != null)
                            ? () {
                                final provider = context.read<AppProvider>();
                                provider.addLinkedMethod(LinkedMethod(
                                  id: 'new_${DateTime.now().millisecondsSinceEpoch}',
                                  type: _selectedMethod!
                                          .toLowerCase()
                                          .contains('wallet')
                                      ? 'wallet'
                                      : 'bank',
                                  provider: _selectedInstitution!,
                                  accountEnding: '9988',
                                  country: _selectedCountry!,
                                  currency: _currencies[_selectedCountry]!
                                      .split(' ')[0],
                                  isActive: true,
                                ));
                                context.pop();
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0B132B),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          disabledBackgroundColor:
                              const Color(0xFF0B132B).withOpacity(0.5),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Link Method',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold)),
                            SizedBox(width: 12),
                            Icon(LucideIcons.arrowRight,
                                color: Colors.white, size: 20),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF0B132B),
        unselectedItemColor: const Color(0xFF94A3B8),
        currentIndex: 2,
        backgroundColor: Colors.white,
        elevation: 20,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/dashboard');
              break;
            case 1:
              context.push('/send-money');
              break;
            case 2:
              context.push('/receive-money');
              break;
            case 3:
              context.push('/profile');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(LucideIcons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(LucideIcons.send), label: 'Send'),
          BottomNavigationBarItem(
              icon: Icon(LucideIcons.qrCode), label: 'Receive'),
          BottomNavigationBarItem(
              icon: Icon(LucideIcons.userCircle), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildStepper() {
    bool step1Done = _selectedCountry != null;
    bool step2Done = _selectedMethod != null;

    return Row(
      children: [
        // Step 1
        _buildStepCircle(1, step1Done, _currentStep == 0),
        Expanded(
            child: Container(
                height: 2,
                color: step1Done
                    ? const Color(0xFF065F46)
                    : const Color(0xFFDBEAFE))),
        // Step 2
        _buildStepCircle(2, step2Done, _currentStep == 1),
        Expanded(
            child: Container(
                height: 2,
                color: step2Done
                    ? const Color(0xFF065F46)
                    : const Color(0xFFDBEAFE))),
        // Step 3
        _buildStepCircle(3, false, _currentStep == 2),
        const SizedBox(width: 12),
        Text('Step ${_currentStep + 1} of 3',
            style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
      ],
    );
  }

  Widget _buildStepCircle(int step, bool isDone, bool isActive) {
    if (isDone) {
      return Container(
        width: 28,
        height: 28,
        padding: const EdgeInsets.all(4),
        decoration: const BoxDecoration(
            color: Color(0xFF065F46), shape: BoxShape.circle),
        child: const Icon(LucideIcons.check, color: Colors.white, size: 14),
      );
    }
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF0F172A) : const Color(0xFFDBEAFE),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          '$step',
          style: TextStyle(
            color: isActive ? Colors.white : const Color(0xFF1D4ED8),
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Text(label,
        style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A)));
  }

  Widget _buildCountryPicker() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedCountry,
          hint: const Text('Select Country',
              style: TextStyle(color: Color(0xFF94A3B8))),
          isExpanded: true,
          icon: const Icon(LucideIcons.chevronDown,
              size: 20, color: Color(0xFF64748B)),
          items: _countries.map((String country) {
            return DropdownMenuItem<String>(
              value: country,
              child: Row(
                children: [
                  const Icon(LucideIcons.globe,
                      size: 20, color: Color(0xFF64748B)),
                  const SizedBox(width: 12),
                  Text(country),
                ],
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedCountry = value;
              _selectedMethod = null; // Reset method
              _selectedInstitution = null; // Reset institution
              if (_currentStep == 0) _currentStep = 1;
            });
            _filterInstitutions();
          },
        ),
      ),
    );
  }

  Widget _buildMethodOption(IconData icon, String label, bool isSelected) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedMethod = label;
          if (_currentStep == 1) _currentStep = 2;
        });
        _filterInstitutions();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: isSelected
                  ? const Color(0xFF0F172A)
                  : const Color(0xFFE2E8F0),
              width: isSelected ? 2 : 1),
        ),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFF0F172A), size: 24),
            const SizedBox(height: 8),
            Text(label,
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildInstitutionPicker() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedInstitution,
          hint: const Text('Select Bank/Wallet',
              style: TextStyle(color: Color(0xFF94A3B8))),
          isExpanded: true,
          icon: const Icon(LucideIcons.chevronDown,
              size: 20, color: Color(0xFF64748B)),
          items: _availableInstitutions.map((String name) {
            return DropdownMenuItem<String>(
              value: name,
              child: Row(
                children: [
                  const Icon(LucideIcons.building2,
                      size: 20, color: Color(0xFF64748B)),
                  const SizedBox(width: 12),
                  Text(name),
                ],
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedInstitution = value;
            });
          },
        ),
      ),
    );
  }

  Widget _buildTextField(
      String hint, IconData icon, TextEditingController controller) {
    return TextField(
      controller: controller,
      onChanged: (_) => setState(() {}),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
        prefixIcon: Icon(icon, size: 20, color: const Color(0xFF64748B)),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
      ),
    );
  }
}
