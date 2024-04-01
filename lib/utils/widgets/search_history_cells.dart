import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconify_flutter/iconify.dart';
import 'package:sonicity/utils/widgets/widgets.dart';

class SearchHistoryCell extends StatelessWidget {
  final String itemText;
  final VoidCallback onTap, onRemove;
  SearchHistoryCell({super.key, required this.itemText, required this.onTap, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: (theme.brightness == Brightness.light) ? Color(0xFFC2C2C2) : Color(0xFF3d3d3d),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: onTap,
              child: Text(
                itemText,
                style: theme.textTheme.labelSmall!.copyWith(
                  color: (theme.brightness == Brightness.light) ? Colors.black : Colors.white
                ),
              ),
            ),
            Gap(8),
            GestureDetector(
              onTap: onRemove,
              child: Iconify(Ri.close_circle_fill, size: 20,),
            )
          ],
        ),
      ),
    );
  }
}