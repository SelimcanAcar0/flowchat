import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';

import '../../../../common/entities/entities.dart';
import '../../../../common/routes/names.dart';
import '../../../../common/utils/date.dart';

Widget chatLeftItem(Msgcontent item) {
  return Container(
    padding: EdgeInsets.only(top: 10.w, left: 15.w, right: 15.w, bottom: 10.w),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ConstrainedBox(
            constraints: BoxConstraints(
                maxWidth: 230.w, minHeight: 40.w, minWidth: 70.w),
            child: Container(
                margin: EdgeInsets.only(right: 10.w, top: 0.w),
                padding: EdgeInsets.only(
                    top: 10.w, left: 10.w, right: 10.w, bottom: 10.w),
                decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 176, 106, 231),
                        Color.fromARGB(255, 166, 112, 231),
                        Color.fromARGB(255, 131, 123, 231),
                        Color.fromARGB(255, 104, 132, 231),
                      ],
                      transform: GradientRotation(90),
                    ),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(5.w),
                        bottomRight: Radius.circular(15.w),
                        topLeft: Radius.circular(5.w),
                        topRight: Radius.circular(5.w))),
                child: item.type == 'text'
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${item.content}',
                          ),
                          SizedBox(
                            height: 3.h,
                          ),
                          Text(
                            '${numberToDay(item.addtime!.toDate().weekday)} ${item.addtime!.toDate().hour}.${item.addtime!.toDate().minute}',
                            style: TextStyle(
                                fontSize: 8.sp, color: Colors.white70),
                          ),
                        ],
                      )
                    : ConstrainedBox(
                        constraints:
                            BoxConstraints(maxWidth: 90.w, minWidth: 70.w),
                        child: GestureDetector(
                          onTap: () {
                            Get.toNamed(AppRoutes.Photoimgview,
                                parameters: {'url': item.content ?? ''});
                          },
                          child: CachedNetworkImage(
                            imageUrl: '${item.content}',
                          ),
                        ),
                      )))
      ],
    ),
  );
}
