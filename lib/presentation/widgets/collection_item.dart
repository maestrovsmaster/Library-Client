/*import 'package:flutter/material.dart';
import 'package:leeds_library/data/models/item_model.dart';

class CollectionItem extends StatelessWidget {
  final ItemModel item;
  final Function(ItemModel) onTap;

  const CollectionItem({
    super.key,
    required this.item, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    final year = item.year != null ? "${item.year}" : "";
    final batch = item.batchNumber != null ? "${item.batchNumber}" : "";
    final title = "${item.name}\n$year";
    final titleBatch = "#$batch";
    final subtitle = "(${item.count} / ${item.total})";

    return InkWell(
      onTap: () {
       onTap(item);
      },
      child: Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Image.asset(
                'assets/images/img_bottle.png',
                fit: BoxFit.contain,
                width: double.infinity,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.start,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              titleBatch,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.start,
              maxLines: 1,
            ),
            const SizedBox(height: 4),



            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.start,
            ),
          ],
        ),
      ),
    ));
  }
}*/

