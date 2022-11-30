import 'package:flutter/material.dart';
import 'package:flutter_study_2/common/const/colors.dart';
import 'package:flutter_study_2/common/layout/default_layout.dart';
import 'package:flutter_study_2/common/view/root_tab.dart';
import 'package:go_router/go_router.dart';

class OrderDoneScreen extends StatelessWidget {
  static String get routeName => 'order_done';

  const OrderDoneScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              Icons.thumb_up_alt_outlined,
              size: 100.0,
              color: PRIMARY_COLOR,
            ),
            const SizedBox(
              height: 16.0,
            ),
            Text(
              '결제완료',
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 16.0,
            ),
            ElevatedButton(
              onPressed: () {
                context.goNamed(RootTab.routeName);
              },
              child: Text('홈으로'),
              style: ElevatedButton.styleFrom(
                primary: PRIMARY_COLOR,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
