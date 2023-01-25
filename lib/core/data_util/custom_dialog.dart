import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:withapp_did/core/wedid_core.dart';

class WEDIDConfirmDialog {
  static Future<bool> confirmDialog({required BuildContext context,String? title, String? content, VoidCallback? callback}) async {
    return await showDialog(
      context: context,
      useSafeArea: false,
      barrierDismissible: false,
      builder: (context) {
        return Stack(
          children: [
            Positioned.fill(
              child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [WEDIDColor.w2AC870, WEDIDColor.w04FFFE],
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                    )
                  ),
                ),
            ),
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.r),
              ),
              child: AlertDialog(
                backgroundColor: WEDIDColor.w000000,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0.r)),
                ),
                actionsAlignment: MainAxisAlignment.center,
                title: Text(title ?? '알림',
                    textAlign: TextAlign.center,
                    style: WEDIDTextStyle.nanumSquareNeoE.copyWith(fontSize: 20.sp,letterSpacing: -0.4)),
                content: Text(content ?? '정보가 수정되었습니다',
                    textAlign: TextAlign.center,
                    style: WEDIDTextStyle.nanumSquareNeoE.copyWith(fontSize: 14.sp,letterSpacing: -0.4,color: WEDIDColor.w7C7C7C)),
                actions: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: callback ?? () => Navigator.of(context).pop(true),
                      child: Text('확인', style: WEDIDTextStyle.nanumSquareNeoE.copyWith(fontSize: 14.sp,letterSpacing: -0.4,color: WEDIDColor.w000000)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  static Future<bool> confirmCancelDialog({required BuildContext context, String? title, String? content, VoidCallback? callback}) async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.r),
          ),
          child: AlertDialog(
            backgroundColor: WEDIDColor.w000000,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0.r)),
            ),
            actionsPadding: EdgeInsets.only(bottom: 22.h,right: 18.w,left: 18.w),
            actionsAlignment: MainAxisAlignment.center,
            title: Text(title ?? '알림',
                textAlign: TextAlign.center,
                style: WEDIDTextStyle.nanumSquareNeoE.copyWith(fontSize: 20.sp,letterSpacing: -0.4)),
            content: Text(content ?? '정보가 수정되었습니다',
                textAlign: TextAlign.center,
                style: WEDIDTextStyle.nanumSquareNeoE.copyWith(fontSize: 14.sp,letterSpacing: -0.4,color: WEDIDColor.w7C7C7C)),
            actions: [
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: Text('취소', style: WEDIDTextStyle.nanumSquareNeoE.copyWith(fontSize: 14.sp,letterSpacing: -0.4,color: WEDIDColor.w000000)),
                      ),
                    ),
                  ),
                  SizedBox(width: 21.w),
                  Expanded(
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: callback ?? () => Navigator.of(context).pop(true),
                        child: Text('확인', style: WEDIDTextStyle.nanumSquareNeoE.copyWith(fontSize: 14.sp,letterSpacing: -0.4,color: WEDIDColor.w000000)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
