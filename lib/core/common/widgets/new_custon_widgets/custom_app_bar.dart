import 'package:flutter/widgets.dart';
import 'package:get/get.dart';


import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../../utils/constants/icon_path.dart';
import '../custom_text.dart';



class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    super.key, required this.firstText, required this.secondText, this.width,
  });

  final String firstText,secondText;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(

          children: [
            GestureDetector(
                onTap: (){
                  Get.back();
                },
                child: Image.asset(IconPath.backArrowIcon,width: getWidth(24),height: getHeight(24),)),
            SizedBox(width: getWidth(14),),
            CustomText(text: firstText,fontSize: getWidth(17),fontWeight: FontWeight.w600,),
          ],
        ),
        SizedBox(height: getHeight(6),),
        Row(
          children: [
            SizedBox(width: getWidth(40),),
            SizedBox(
                width: width??getWidth(350),
                child: CustomText(text: secondText,color: AppColors.textGrey,fontSize: getWidth(14),)),
          ],
        ),
      ],
    );
  }
}