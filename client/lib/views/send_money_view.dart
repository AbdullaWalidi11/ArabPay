import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../providers/app_provider.dart';
import '../services/routing_engine.dart';
import '../models/linked_method.dart';

class SendMoneyView extends StatefulWidget {
  const SendMoneyView({super.key});

  @override
  State<SendMoneyView> createState() => _SendMoneyViewState();
}

class _SendMoneyViewState extends State<SendMoneyView> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  // Step 1 State
  final _idController = TextEditingController();
  final _nameToSaveController = TextEditingController();
  bool _isVerified = false;
  bool _isVerifying = false;
  String? _receiverName;
  String? _receiverStatus;

  // Step 2 State
  RoutingResult? _selectedRoute;

  // Step 3 State
  final _amountController = TextEditingController(text: "0");
  double _amount = 0.0;

  @override
  void dispose() {
    _pageController.dispose();
    _idController.dispose();
    _nameToSaveController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 3) {
      setState(() => _currentStep++);
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      context.pop();
    }
  }

  Future<void> _verifyReceiver() async {
    if (_idController.text.isEmpty) return;

    setState(() {
      _isVerifying = true;
      _isVerified = false;
      _receiverName = null;
    });

    final provider = context.read<AppProvider>();
    final info = await provider.verifyReceiver(_idController.text);

    if (mounted) {
      setState(() {
        _isVerifying = false;
        if (info != null) {
          _isVerified = true;
          _receiverName = info['name'];
          _receiverStatus = info['status'];
          _nameToSaveController.text = _receiverName!;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Receiver not found. Try "@ahmed" or "@sara"')),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: Color(0xFF0F172A)),
          onPressed: _prevStep,
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Money Transfer',
              style: TextStyle(color: Color(0xFF0F172A), fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Step ${_currentStep + 1} of 4',
              style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.helpCircle, color: Color(0xFF64748B)),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Step Progress Bar
          Container(
            height: 6,
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(10),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: (_currentStep + 1) / 4,
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0B132B), Color(0xFF1D4ED8)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1D4ED8).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildStep1(),
                _buildStep2(),
                _buildStep3(),
                _buildStep4(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF0B132B),
        unselectedItemColor: const Color(0xFF94A3B8),
        currentIndex: 1, // Send selected
        backgroundColor: Colors.white,
        elevation: 20,
        onTap: (index) {
          if (index == _currentStep && index == 1) return; // Already on send
          switch (index) {
            case 0:
              context.go('/dashboard');
              break;
            case 1:
              context.go('/send-money');
              break;
            case 2:
              context.go('/receive-money');
              break;
            case 3:
              context.go('/profile');
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

  // --- STEP 1: ENTER RECEIVER ---
  Widget _buildStep1() {
    final provider = context.watch<AppProvider>();
    
    // Get unique recent recipients from transaction history
    final recents = <String, String>{}; // ID -> Name
    for (var tx in provider.recentTransactions) {
      if (tx.recipientId != provider.currentUser?.arabPayId) {
        recents[tx.recipientId] = tx.recipientName;
      }
    }
    final recentList = recents.entries.toList().reversed.take(5).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Who are you sending to?',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
          ),
          const SizedBox(height: 8),
          const Text(
            'Money arrives instantly to any ArabPay ID.',
            style: TextStyle(color: Color(0xFF64748B), fontSize: 14),
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
              border: Border.all(color: const Color(0xFFF1F5F9)),
            ),
            child: Column(
              children: [
                TextField(
                  controller: _idController,
                  onChanged: (val) {
                    if (val.length >= 3) _verifyReceiver();
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter @arabpay_id or Name',
                    hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
                    prefixIcon: const Icon(LucideIcons.user, size: 22, color: Color(0xFF0B132B)),
                    suffixIcon: _isVerifying 
                      ? const Padding(
                          padding: EdgeInsets.all(12),
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : (_isVerified ? const Icon(LucideIcons.checkCircle2, color: Color(0xFF10B981)) : null),
                    filled: true,
                    fillColor: const Color(0xFFF8FAFF),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 20),
                  ),
                ),
                if (_isVerified) ...[
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [const Color(0xFF10B981).withOpacity(0.05), const Color(0xFF10B981).withOpacity(0.1)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFF10B981).withOpacity(0.2)),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: const Color(0xFF10B981),
                          child: Text(
                            _receiverName![0].toUpperCase(),
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _receiverName!,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                              ),
                              Row(
                                children: [
                                  const Icon(LucideIcons.shieldCheck, size: 14, color: Color(0xFF10B981)),
                                  const SizedBox(width: 4),
                                  Text(
                                    _receiverStatus!,
                                    style: const TextStyle(fontSize: 12, color: Color(0xFF059669), fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ],
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
          // Dynamic Recents
          if (recentList.isNotEmpty) ...[
            const Text(
              'Recent Transfers',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF64748B)),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: recentList.length,
                itemBuilder: (context, index) {
                  final item = recentList[index];
                  final colors = [const Color(0xFF3B82F6), const Color(0xFFEC4899), const Color(0xFF10B981), const Color(0xFFF59E0B), const Color(0xFF6366F1)];
                  return _buildRecentAvatar(
                    item.value, 
                    item.value[0].toUpperCase(), 
                    colors[index % colors.length],
                    () {
                      _idController.text = item.key;
                      _verifyReceiver();
                    }
                  );
                },
              ),
            ),
          ],
          const SizedBox(height: 32),
          _buildNextButton(enabled: _isVerified),
        ],
      ),
    );
  }

  // --- STEP 2: SUGGESTED ACCOUNTS & WALLETS ---
  Widget _buildStep2() {
    final provider = context.watch<AppProvider>();
    // Pre-calculate routes for suggestion
    final walletRoute = provider.getRouteResult(500); 
    final bankRoute = provider.getRouteResult(5000); 

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Suggested Routes',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
          ),
          const SizedBox(height: 8),
          const Text(
            'We have analyzed the accounts and found the most optimal ways to transfer money.',
            style: TextStyle(color: Color(0xFF64748B), fontSize: 14),
          ),
          const SizedBox(height: 32),
          
          if (walletRoute != null)
            _buildRouteOption(
              result: walletRoute,
              isOptimal: true,
            ),
          const SizedBox(height: 16),
          if (bankRoute != null)
            _buildRouteOption(
              result: bankRoute,
              isOptimal: false,
            ),
            
          const SizedBox(height: 32),
          _buildNextButton(enabled: _selectedRoute != null),
        ],
      ),
    );
  }

  Widget _buildRouteOption({required RoutingResult result, required bool isOptimal}) {
    final isSelected = _selectedRoute?.method.id == result.method.id;

    return InkWell(
      onTap: () => setState(() => _selectedRoute = result),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF8FAFF) : Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: isSelected ? [
            BoxShadow(
              color: const Color(0xFF0B132B).withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 8),
            )
          ] : [],
          border: Border.all(
            color: isSelected ? const Color(0xFF0B132B) : const Color(0xFFF1F5F9),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: result.method.type == 'wallet' ? const Color(0xFFDBEAFE).withOpacity(0.5) : const Color(0xFFDCFCE7).withOpacity(0.5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                result.method.type == 'wallet' ? LucideIcons.wallet : LucideIcons.landmark,
                color: result.method.type == 'wallet' ? const Color(0xFF1D4ED8) : const Color(0xFF166534),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        result.method.provider, 
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF0F172A))
                      ),
                      const SizedBox(width: 8),
                      if (isOptimal)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [Color(0xFF0B132B), Color(0xFF1D4ED8)]),
                            borderRadius: BorderRadius.circular(20)
                          ),
                          child: const Text('OPTIMAL', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        'Fee: ${result.fee.toStringAsFixed(2)} SAR',
                        style: const TextStyle(color: Color(0xFF64748B), fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 4,
                        height: 4,
                        decoration: const BoxDecoration(color: Color(0xFFCBD5E1), shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        result.estimatedTimeSeconds < 10 ? 'Instant Transfer' : '1-2 Days',
                        style: TextStyle(
                          color: result.estimatedTimeSeconds < 10 ? const Color(0xFF10B981) : const Color(0xFF64748B),
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(
              isSelected ? LucideIcons.checkCircle2 : LucideIcons.circle,
              color: isSelected ? const Color(0xFF0B132B) : const Color(0xFFE2E8F0),
              size: 24,
            ),
          ],
        ),
      ),
    );
  }


  // --- STEP 3: ENTER AMOUNT ---
  Widget _buildStep3() {
    final provider = context.watch<AppProvider>();
    final user = provider.currentUser;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'How much to send?',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
          ),
          const SizedBox(height: 8),
          const Text(
            'Transfer limits depend on your linked account.',
            style: TextStyle(color: Color(0xFF64748B), fontSize: 14),
          ),
          const SizedBox(height: 32),
          
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              children: [
                const Text(
                  'Amount in SAR',
                  style: TextStyle(fontSize: 14, color: Color(0xFF64748B), fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _amountController,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: Color(0xFF0B132B)),
                  decoration: const InputDecoration(
                    hintText: '0',
                    border: InputBorder.none,
                    suffixText: ' SAR',
                    suffixStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8)),
                  ),
                  onChanged: (val) => setState(() => _amount = double.tryParse(val) ?? 0.0),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '≈ \$${(_amount / 3.75).toStringAsFixed(2)} USD',
                    style: const TextStyle(color: Color(0xFF1D4ED8), fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          
          Center(
            child: Column(
              children: [
                Text(
                  'Available Balance: ${user?.balance.toStringAsFixed(2) ?? "0.00"} SAR',
                  style: const TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.w500, fontSize: 14),
                ),
                if (_amount > 0) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: ((user?.balance ?? 0.0) - _amount - (_selectedRoute?.fee ?? 0)) < 0 
                        ? const Color(0xFFFEF2F2) 
                        : const Color(0xFFF0FDF4),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Remaining after transfer: ${((user?.balance ?? 0.0) - _amount - (_selectedRoute?.fee ?? 0)).toStringAsFixed(2)} SAR',
                      style: TextStyle(
                        color: ((user?.balance ?? 0.0) - _amount - (_selectedRoute?.fee ?? 0)) < 0 
                          ? const Color(0xFFEF4444) 
                          : const Color(0xFF166534),
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          const SizedBox(height: 40),
          
          if (_selectedRoute != null)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFFF1F5F9)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _selectedRoute!.method.type == 'wallet' ? LucideIcons.wallet : LucideIcons.landmark, 
                      size: 20,
                      color: const Color(0xFF0B132B),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Funding Source', style: TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                        Text(_selectedRoute!.method.provider, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 32),
          _buildNextButton(enabled: _amount > 0 && (_amount + (_selectedRoute?.fee ?? 0)) <= (user?.balance ?? 0)),
        ],
      ),
    );
  }

  // --- STEP 4: REVIEW & CONFIRM ---
  Widget _buildStep4() {
    final provider = context.watch<AppProvider>();
    final user = provider.currentUser;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Confirm Transfer',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
          ),
          const SizedBox(height: 8),
          const Text(
            'Check the details below before sending.',
            style: TextStyle(color: Color(0xFF64748B), fontSize: 14),
          ),
          const SizedBox(height: 32),
          
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildSummaryItem('From Account', user?.arabPayId ?? 'Your Account'),
                _buildDivider(),
                _buildSummaryItem('Recipient', '$_receiverName (${_idController.text})'),
                _buildDivider(),
                _buildSummaryItem('Route Used', _selectedRoute?.method.provider ?? 'Standard Route'),
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFF),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    children: [
                      _buildSummaryRow('Amount', '${_amount.toStringAsFixed(2)} SAR'),
                      const SizedBox(height: 12),
                      _buildSummaryRow('Service Fee', '+${_selectedRoute?.fee.toStringAsFixed(2) ?? "0.00"} SAR', isGreen: true),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Divider(color: Color(0xFFE2E8F0)),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total to pay', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF0F172A))),
                          Text(
                            '${(_amount + (_selectedRoute?.fee ?? 0)).toStringAsFixed(2)} SAR',
                            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 20, color: Color(0xFF1D4ED8)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            height: 64,
            child: ElevatedButton(
              onPressed: provider.isLoading ? null : () async {
                final success = await provider.processTransaction(
                  amount: _amount,
                  fee: _selectedRoute?.fee ?? 0.0,
                  sourceMethod: _selectedRoute!.method,
                  receiverId: _idController.text,
                  receiverName: _receiverName ?? "Unknown",
                );

                if (success && mounted) {
                  context.go('/money-delivered', extra: {
                    'amount': _amount,
                    'id': _idController.text,
                    'name': _receiverName ?? "Unknown",
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0B132B),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                elevation: 0,
              ),
              child: provider.isLoading 
                ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                : const Text('Confirm & Send Money', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextButton({required bool enabled}) {
    return SizedBox(
      width: double.infinity,
      height: 64,
      child: ElevatedButton(
        onPressed: enabled ? _nextStep : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0B132B),
          disabledBackgroundColor: const Color(0xFFE2E8F0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Continue', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(width: 8),
            Icon(LucideIcons.arrowRight, color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF64748B))),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Text(value, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: Color(0xFF0F172A))),
      ],
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Divider(color: Color(0xFFE2E8F0), thickness: 1.5),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isGreen = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF64748B))),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: isGreen ? const Color(0xFF10B981) : null)),
        ],
      ),
    );
  }

  Widget _buildRecentAvatar(String name, String initial, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.only(right: 20),
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(color: color.withOpacity(0.2), width: 2),
              ),
              child: Center(
                child: Text(
                  initial,
                  style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              name,
              style: const TextStyle(fontSize: 12, color: Color(0xFF0F172A), fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
