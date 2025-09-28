import 'package:xpanca_ecommerce/core/shared/widgets/gradient_button.dart';
import 'package:xpanca_ecommerce/core/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class SummaryPanel extends StatelessWidget {
  const SummaryPanel({
    super.key,
    required this.subtotal,
    required this.discount,
    required this.total,
    required this.onCheckout,
    required this.discountCtrl,
  });

  final num subtotal, discount, total;
  final VoidCallback onCheckout;
  final TextEditingController discountCtrl;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Panel putih
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              Row(
                spacing: 8,
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 36,
                      child: TextField(
                        style: const TextStyle(fontSize: 12),
                        controller: discountCtrl,
                        decoration: InputDecoration(
                          hintStyle: const TextStyle(fontSize: 12),
                          hintText: 'Enter Discount Code',
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                                color: Colors.grey.shade300, width: 0.5),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                                color: Colors.grey.shade300, width: 0.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(
                                color: Color(0xFF22C55E), width: 0.5),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 36,
                    child: ElevatedButton(
                      onPressed: () => FocusScope.of(context).unfocus(),
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.only(
                            bottom: 10, left: 16, right: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                          side: BorderSide(
                              color: Colors.grey.shade300, width: 0.5),
                        ),
                      ),
                      child:
                          const Text('Apply', style: TextStyle(fontSize: 12)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _kvRow('Sub total :', rupiah(subtotal.toInt())),
              const SizedBox(height: 6),
              _kvRow('Discount :', rupiah(discount.toInt())),
              const Divider(height: 20, thickness: 0.5),
              _kvRow('total :', rupiah(total.toInt()), isEmphasized: true),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: GradientButton(
            icon: Iconsax.shopping_bag,
            onTap: onCheckout,
            text: 'Checkout',
          ),
        ),
      ],
    );
  }

  Widget _kvRow(String k, String v, {bool isEmphasized = false}) {
    final style = TextStyle(
      fontWeight: isEmphasized ? FontWeight.w800 : FontWeight.w600,
      fontSize: isEmphasized ? 16 : 12,
    );
    return Row(
      children: [
        Expanded(
            child: Text(k, style: TextStyle(fontSize: isEmphasized ? 14 : 12))),
        Text(v, style: style),
      ],
    );
  }
}
