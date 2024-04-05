// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:safe_return/models/case_model.dart';
import 'package:safe_return/paths/routes.dart';
import 'package:safe_return/screens/public_case_details.dart';

class AlertListTile extends StatefulWidget {
  const AlertListTile({
    super.key,
    this.model,
  });
  final CaseModel? model;

  @override
  State<AlertListTile> createState() => _AlertListTileState();
}

class _AlertListTileState extends State<AlertListTile> {
  bool showPhoto = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          Routes.publicCaseDetail,
          arguments: PublicCaseDetail(caseModel: widget.model!),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.blue.shade50.withOpacity(0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.model!.dateOfLastContact!,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Row(
                  children: [
                    Text(
                      widget.model!.caseId!,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (showPhoto) {
                            showPhoto = false;
                          } else {
                            showPhoto = true;
                          }
                        });
                      },
                      child: Icon(
                        !showPhoto
                            ? Icons.keyboard_double_arrow_down_outlined
                            : Icons.keyboard_double_arrow_up_outlined,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Text(
              widget.model!.name!,
              style: Theme.of(context).textTheme.bodyMedium!,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.model!.circumstancesOfDisappearance!,
                  style: Theme.of(context).textTheme.bodyMedium!,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (showPhoto) {
                        showPhoto = false;
                      } else {
                        showPhoto = true;
                      }
                    });
                  },
                  child: Text(
                    "View Photo",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          decoration: TextDecoration.underline,
                          color: Colors.blueAccent,
                          decorationColor: Colors.blueAccent,
                        ),
                  ),
                ),
              ],
            ),
            if (widget.model!.images!.isNotEmpty)
              if (showPhoto) ...[
                SizedBox(height: size.height * 0.02),
                SizedBox(
                  height: size.height * 0.2,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.model!.images!.length,
                    separatorBuilder: (context, index) =>
                        SizedBox(width: size.width * 0.03),
                    itemBuilder: (context, index) {
                      String imageUrl = widget.model!.images!.elementAt(index);
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey.shade400,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        height: size.height * 0.18,
                        width: size.width * 0.25,
                        child: Image.network(imageUrl),
                      );
                    },
                  ),
                )
              ],
          ],
        ),
      ),
    );
  }
}
