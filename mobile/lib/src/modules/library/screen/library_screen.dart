import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kawtharuna/src/core/constants/app_text_style.dart';
import 'package:kawtharuna/src/core/managers/managers.dart';
import 'package:kawtharuna/src/core/utils/utils_collection.dart';
import 'package:kawtharuna/src/core/widgets/app_bar/empty_app_bar_widget.dart';
import 'package:kawtharuna/src/core/widgets/icons/app_menu_icon_widget.dart';
import 'package:kawtharuna/src/modules/main_menu/screens/main_menu_screen.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppThemeManager themeStore = Provider.of<AppThemeManager>(
      context,
      listen: true,
    );
    return Scaffold(
      backgroundColor: themeStore.appColors.scaffoldBgColor,
      appBar: CustomAppBar(
        automaticallyImplyLeading: false,
        titleString: translate.islamic_library,
        leading: AppMenuIconWidget(
          onDrawerPressed: () {
            mainKey.currentState?.openDrawer();
          },
        ),
      ),
      body: SizedBox(
        height: DeviceUtils.getScaledHeight(context, 1),
        width: DeviceUtils.getScaledWidth(context, 1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              'Coming soon',
              style: appTextStyle.medium18.copyWith(
                color: themeStore.appColors.textColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}