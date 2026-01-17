import 'package:flutter/material.dart';

class PaymentMethodSelector extends StatelessWidget {
  final String? selectedProvider;
  final Function(String) onProviderSelected;

  const PaymentMethodSelector({
    super.key,
    required this.selectedProvider,
    required this.onProviderSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Mode de paiement',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _PaymentMethodCard(
                provider: 'orange',
                title: 'Orange Money',
                isSelected: selectedProvider == 'orange',
                onTap: () => onProviderSelected('orange'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _PaymentMethodCard(
                provider: 'mtn',
                title: 'MTN Mobile Money',
                isSelected: selectedProvider == 'mtn',
                onTap: () => onProviderSelected('mtn'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PaymentMethodCard extends StatelessWidget {
  final String provider;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentMethodCard({
    required this.provider,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? Colors.blue[50] : null,
        ),
        child: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: provider == 'orange' ? Colors.orange : Colors.yellow,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  provider == 'orange' ? 'OM' : 'MOMO',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(height: 4),
              Icon(
                Icons.check_circle,
                color: Colors.blue[700],
                size: 20,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
