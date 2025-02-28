import 'package:flutter/material.dart';

class PromoDiscountHeader extends StatelessWidget {
  const PromoDiscountHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 0, right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Promo & Discount",
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          TextButton(
            onPressed: () {
              // code to navigate to another screen
            },
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "See all",
                  style: TextStyle(fontSize: 14, color: Colors.yellow),
                ),
                SizedBox(
                  width: 5,
                ),
                Icon(Icons.arrow_forward_ios, color: Colors.yellow, size: 14)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
