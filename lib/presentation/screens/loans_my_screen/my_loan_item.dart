import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:leeds_library/core/utils/loan_utils.dart';
import 'package:leeds_library/core/utils/utils.dart';
import 'package:leeds_library/data/models/loan.dart';

import '../../../core/theme/app_colors.dart';

class MyLoanItem extends StatelessWidget {
  final Loan loan;
  final Function(Loan) onTap;

  const MyLoanItem({Key? key, required this.loan, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final book = loan.book;
    final reader = loan.reader;

    final loanStatus = getLoanStatus(loan.dateBorrowed);



    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Card(
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    CachedNetworkImage(
                      imageUrl: book.imageUrl ?? '',
                      width: 50,
                      height: 80,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: 50,
                        height: 80,
                        color: Colors.grey[300],
                      ),
                      errorWidget: (context, url, error) => Icon(
                          Icons.book,
                          size: 40,
                          color: Colors.grey[300]),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            book.author ?? '',
                            style: const TextStyle(fontSize: 14),
                            maxLines: 2,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            book.title ?? '',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(
                  thickness: 1,
                  height: 1,
                  indent: 16,
                  endIndent: 16,
                  color: AppColors.cardBackground2),
              SizedBox(
                  width: double.infinity,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [


                                Text(
                                  'Дата отримання: ${loan.dateBorrowed != null ? formatDate(loan.dateBorrowed!) : ''}',
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.black54),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  loanStatus.text,
                                  style: TextStyle(fontSize: 14, color: loanStatus.color, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),

                          ]))),
            ],
          ),
        ),
      ),
    );
  }


}
