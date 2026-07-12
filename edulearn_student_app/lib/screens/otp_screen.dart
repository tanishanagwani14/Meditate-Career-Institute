import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../utils/phone_format.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key, required this.phone});

  final String phone;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _controllers = List.generate(6, (_) => TextEditingController());
  final _focusNodes = List.generate(6, (_) => FocusNode());
  int _timer = 60;
  Timer? _t;

  String get _displayPhone {
    final formatted = formatPhoneForDisplay(widget.phone);
    return formatted.isEmpty ? 'your phone number' : formatted;
  }

  @override
  void initState() {
    super.initState();
    _t = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_timer <= 0) return;
      setState(() => _timer--);
    });
  }

  @override
  void dispose() {
    _t?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  bool get _complete => _controllers.every((c) => c.text.isNotEmpty);

  void _onChanged(int i, String v) {
    if (v.length > 1) {
      _controllers[i].text = v.substring(v.length - 1);
    }
    if (v.isNotEmpty && i < 5) {
      _focusNodes[i + 1].requestFocus();
    }
    setState(() {});
  }

  void _resend() {
    setState(() {
      _timer = 60;
      for (final c in _controllers) {
        c.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final muted = Theme.of(context).textTheme.bodySmall?.color;
    final width = MediaQuery.sizeOf(context).width;
    final otpBoxWidth = ((width - 48 - 6 * 8) / 6).clamp(36.0, 48.0);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.arrow_back),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Icon(Icons.shield_outlined, size: 56, color: primary),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'OTP Verification',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "We've sent a code to",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: muted),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _displayPhone,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(6, (i) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: SizedBox(
                              width: otpBoxWidth,
                              child: TextField(
                                controller: _controllers[i],
                                focusNode: _focusNodes[i],
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                maxLength: 1,
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                                decoration: const InputDecoration(counterText: ''),
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                onChanged: (v) => _onChanged(i, v),
                                onSubmitted: (_) {
                                  if (i < 5) _focusNodes[i + 1].requestFocus();
                                },
                              ),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 12),
                      if (_timer > 0)
                        Text('Resend code in ${_timer}s', style: TextStyle(color: muted, fontSize: 13))
                      else
                        TextButton(onPressed: _resend, child: const Text('Resend Code')),
                      const SizedBox(height: 20),
                      FilledButton(
                        onPressed: _complete ? () => context.go('/home') : null,
                        style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
                        child: const Text('Verify & Continue'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
