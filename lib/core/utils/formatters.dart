class WhatsApp {
  static String checkoutMessage({
    required String customerName,
    required List<Map<String, dynamic>> items,
    required int subtotal,
  }) {
    final lines = [
      'Halo Admin, saya ingin order:',
      ...items.map((e) => '- ${e['name']} x${e['qty']} @ ${e['price']}'),
      'Subtotal: $subtotal',
      'Nama: $customerName',
    ];
    return lines.join('\n');
  }

  static Uri waUri({required String phone, required String message}) {
    return Uri.parse('https://wa.me/$phone?text=${Uri.encodeComponent(message)}');
  }
}
