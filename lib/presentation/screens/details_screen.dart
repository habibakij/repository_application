import 'package:flutter/material.dart';
import 'package:flutter_bloc_template/core/theme/app_text_styles.dart';
import 'package:flutter_bloc_template/core/utils/widget/common_app_bar.dart';
import 'package:flutter_bloc_template/data/model/home_screen/repo_model.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class DetailsScreen extends StatelessWidget {
  final Item? item;

  const DetailsScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: "Details"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Last Update:",
                  style: AppTextStyles.titleTextStyle(),
                ),
                Text(
                  " ${DateFormat('dd-MM-yyyy').format(item?.updatedAt ?? DateTime.now())}",
                  style: AppTextStyles.bodyTextStyle(),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Text(
              "Description",
              style: AppTextStyles.titleTextStyle(),
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 4.0),
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(item?.description ?? '',
                  style: AppTextStyles.bodyTextStyle()),
            ),
          ],
        ),
      ),
    );
  }
}
