import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:greenbee_web/core/theme/app_theme.dart';
import 'package:greenbee_web/core/widgets/atoms/glass_container.dart';
import 'package:greenbee_web/features/iot/ui/widgets/molecules/brand_card.dart';
import 'package:greenbee_web/features/iot/providers/iot_provider.dart';

class IotRegistrationPage extends ConsumerStatefulWidget {
  const IotRegistrationPage({super.key});

  @override
  ConsumerState<IotRegistrationPage> createState() => _IotRegistrationPageState();
}

class _IotRegistrationPageState extends ConsumerState<IotRegistrationPage> {
  int _currentStep = 0;
  String? _selectedBrand;
  String? _selectedType;
  final _nameController = TextEditingController();
  final _tokenController = TextEditingController();
  bool _isRegistering = false;

  final List<Map<String, dynamic>> _brands = [
    {'id': 'SAMSUNG', 'name': 'SmartThings', 'icon': Icons.settings_remote_outlined},
    {'id': 'LG', 'name': 'ThinQ', 'icon': Icons.four_k_outlined},
    {'id': 'PHILIPS', 'name': 'Hue', 'icon': Icons.lightbulb_outline},
    {'id': 'XIAOMI', 'name': 'Mi Home', 'icon': Icons.phonelink_setup_outlined},
    {'id': 'CUSTOM', 'name': 'Custom API', 'icon': Icons.code_rounded},
  ];

  final List<Map<String, dynamic>> _types = [
    {'id': 'LIGHT', 'name': 'Light', 'icon': Icons.light_outlined},
    {'id': 'AC', 'name': 'Climate', 'icon': Icons.ac_unit_outlined},
    {'id': 'TV', 'name': 'TV/Display', 'icon': Icons.tv_outlined},
    {'id': 'SENSOR', 'name': 'Sensor', 'icon': Icons.sensors_outlined},
  ];

  void _nextStep() {
    if (_currentStep < 2) {
      setState(() => _currentStep++);
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  Future<void> _submit() async {
    if (_nameController.text.isEmpty || _tokenController.text.isEmpty) return;

    setState(() => _isRegistering = true);
    try {
      await ref.read(iotServiceProvider).registerDevice(
        name: _nameController.text,
        type: _selectedType!,
        provider: _selectedBrand!,
        config: {'api_token': _tokenController.text},
      );
      ref.invalidate(myIotDevicesProvider);
      if (mounted) context.pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to register device. Check your token.')),
      );
    } finally {
      if (mounted) setState(() => _isRegistering = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.voidBlack,
      appBar: AppBar(
        title: const Text('Connect New Device', style: TextStyle(fontFamily: 'Paperlogy', color: AppTheme.textHigh)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppTheme.textHigh),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStepper(),
              const SizedBox(height: 40),
              Expanded(
                child: _buildCurrentStepView(),
              ),
              _buildBottomButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepper() {
    return Row(
      children: List.generate(3, (index) {
        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            height: 4,
            decoration: BoxDecoration(
              color: index <= _currentStep ? AppTheme.accentMint : AppTheme.glassBorder,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildCurrentStepView() {
    switch (_currentStep) {
      case 0:
        return _buildBrandSelection();
      case 1:
        return _buildTypeSelection();
      case 2:
        return _buildConnectForm();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildBrandSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Select Manufacturer', style: AppTheme.headingLarge),
        const SizedBox(height: 8),
        Text('Which brand\'s device do you want to connect?', style: AppTheme.bodySmall),
        const SizedBox(height: 32),
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.2,
            ),
            itemCount: _brands.length,
            itemBuilder: (context, index) {
              final brand = _brands[index];
              return BrandCard(
                name: brand['name'],
                icon: brand['icon'],
                isSelected: _selectedBrand == brand['id'],
                onTap: () => setState(() => _selectedBrand = brand['id']),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTypeSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Select Device Type', style: AppTheme.headingLarge),
        const SizedBox(height: 32),
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.2,
            ),
            itemCount: _types.length,
            itemBuilder: (context, index) {
              final type = _types[index];
              return BrandCard(
                name: type['name'],
                icon: type['icon'],
                isSelected: _selectedType == type['id'],
                onTap: () => setState(() => _selectedType = type['id']),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildConnectForm() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Connection Guide', style: AppTheme.headingLarge),
          const SizedBox(height: 16),
          GlassContainer(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('How to connect:', style: TextStyle(fontFamily: 'Paperlogy', color: AppTheme.accentMint, fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                Text(
                  _getGuideText(),
                  style: const TextStyle(fontFamily: 'Paperlogy', color: AppTheme.textMedium, height: 1.5),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          TextFormField(
            controller: _nameController,
            style: const TextStyle(fontFamily: 'Paperlogy', color: AppTheme.textHigh),
            decoration: AppTheme.glassInputDecoration(label: 'Device Nickname (e.g. Living Room Light)'),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _tokenController,
            style: const TextStyle(fontFamily: 'Paperlogy', color: AppTheme.textHigh),
            obscureText: true,
            decoration: AppTheme.glassInputDecoration(label: 'API Key / Personal Access Token'),
          ),
        ],
      ),
    );
  }

  String _getGuideText() {
    switch (_selectedBrand) {
      case 'SAMSUNG':
        return '1. Log in to the SmartThings Developers portal.\n'
               '2. Go to "My Page" > "Personal Access Tokens".\n'
               '3. Generate a new token with "Devices" and "Scenes" scopes.\n'
               '4. Copy the token and paste it below.';
      case 'LG':
        return '1. Open the LG ThinQ app on your mobile.\n'
               '2. Go to "Menu" > "App Settings" > "Developer Mode".\n'
               '3. Copy the "ThinQ API Key" displayed on the screen.\n'
               '4. Paste the key in the field below.';
      case 'PHILIPS':
        return '1. Ensure your Hue Bridge is connected to the same network.\n'
               '2. Press the physical button on top of your Hue Bridge.\n'
               '3. Within 30 seconds, click the "Generate" button in the Hue API portal.\n'
               '4. Copy the "username" hash provided.';
      default:
        return '1. Log in to your provider\'s official developer portal.\n'
               '2. Look for "Integrations" or "API Management".\n'
               '3. Generate a Client ID or Access Token.\n'
               '4. Copy and paste the credentials below.';
    }
  }

  Widget _buildBottomButtons() {
    final bool canGoNext = (_currentStep == 0 && _selectedBrand != null) ||
                           (_currentStep == 1 && _selectedType != null);
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (_currentStep > 0)
          TextButton(
            onPressed: _prevStep,
            child: const Text('Back', style: TextStyle(fontFamily: 'Paperlogy', color: AppTheme.textMedium)),
          )
        else
          const SizedBox.shrink(),
        ElevatedButton(
          onPressed: _isRegistering ? null : (_currentStep == 2 ? _submit : (canGoNext ? _nextStep : null)),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.accentMint,
            foregroundColor: AppTheme.voidBlack,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: _isRegistering 
            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.voidBlack))
            : Text(_currentStep == 2 ? 'Complete Connection' : 'Next'),
        ),
      ],
    );
  }
}
