import 'dart:math';

import 'package:flutter/material.dart';

import '../../data/models.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';

String money(double v) {
  final whole = v.truncate().toString().replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (_) => ',',
  );
  final cents = ((v - v.truncate()) * 100).round().toString().padLeft(2, '0');
  return '\$$whole.$cents';
}

class FeesScreen extends StatelessWidget {
  const FeesScreen({super.key});

  Future<void> _pay(
    BuildContext context,
    AppState state,
    List<Invoice> invoices,
  ) async {
    final total = invoices.fold<double>(0, (s, i) => s + i.amount);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(Icons.lock_rounded, color: AppColors.navy),
        title: const Text('Confirm payment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final i in invoices)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    Expanded(child: Text(i.title)),
                    Text(money(i.amount)),
                  ],
                ),
              ),
            const Divider(height: 20),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Total',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
                Text(
                  money(total),
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Paid with saved student wallet (demo – no real money).',
              style: TextStyle(fontSize: 12.5, color: AppColors.muted),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text('Pay ${money(total)}'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    for (final i in invoices) {
      state.payInvoice(i);
    }
    final receipt = 'RCPT-${100000 + Random().nextInt(899999)}';
    showCampusSnackBar(
      context,
      'Payment successful · Receipt $receipt',
      icon: Icons.verified_rounded,
    );
  }

  void _showReceipt(BuildContext context, Invoice i) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(Icons.receipt_long_rounded, color: AppColors.success),
        title: const Text('Payment receipt'),
        content: Text(
          '${i.title}\n${i.id}\nAmount: ${money(i.amount)}\nStatus: Paid in full',
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final unpaid = state.invoices.where((i) => !i.paid).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Fees & payments')),
      body: SingleChildScrollView(
        child: ResponsiveBody(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: unpaid.isEmpty
                        ? const [Color(0xFF2E6B45), Color(0xFF3F8A5B)]
                        : const [Color(0xFF8E2231), Color(0xFFA83A48)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: AppStyle.cardRadius,
                  boxShadow: AppStyle.softShadow,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Outstanding balance',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      money(state.outstanding),
                      style: const TextStyle(
                        fontFamily: 'Georgia',
                        fontFamilyFallback: AppStyle.serifFallback,
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      unpaid.isEmpty
                          ? 'All invoices are settled. Thank you!'
                          : '${unpaid.length} unpaid invoice${unpaid.length == 1 ? '' : 's'}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13.5,
                      ),
                    ),
                    if (unpaid.isNotEmpty) ...[
                      const SizedBox(height: 14),
                      FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.danger,
                        ),
                        onPressed: () => _pay(context, state, unpaid),
                        icon: const Icon(Icons.payments_rounded),
                        label: const Text('Pay all'),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Text('Invoices', style: AppStyle.heading.copyWith(fontSize: 17)),
              const SizedBox(height: 10),
              for (final i in state.invoices)
                CampusCard(
                  padding: const EdgeInsets.all(14),
                  onTap: i.paid ? () => _showReceipt(context, i) : null,
                  child: Row(
                    children: [
                      IconTile(
                        icon: i.paid
                            ? Icons.check_rounded
                            : Icons.receipt_long_rounded,
                        color: i.paid ? AppColors.success : AppColors.danger,
                        background: i.paid
                            ? AppColors.successTint
                            : AppColors.dangerTint,
                        size: 44,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              i.title,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              '${i.id} · Due ${i.dueDate}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.muted,
                              ),
                            ),
                            const SizedBox(height: 6),
                            StatusBadge(
                              label: i.paid ? 'Paid' : 'Unpaid',
                              compact: true,
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            money(i.amount),
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              color: AppColors.navy,
                            ),
                          ),
                          const SizedBox(height: 4),
                          if (!i.paid)
                            TextButton(
                              onPressed: () => _pay(context, state, [i]),
                              child: const Text('Pay'),
                            )
                          else
                            const Text(
                              'View receipt',
                              style: TextStyle(
                                fontSize: 12.5,
                                color: AppColors.muted,
                              ),
                            ),
                        ],
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
}
