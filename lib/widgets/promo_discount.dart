import 'package:flutter/material.dart';

class PromoDiscount extends StatelessWidget {
  const PromoDiscount({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Image.asset('assets/images/Discount.png'),
    );
  }
}
