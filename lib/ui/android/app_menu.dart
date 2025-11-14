import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../app/navigation.dart';
import '../../l10n/app_l10n.dart';
import '../../util/logger.dart';
import '../icon.dart';
import '../image.dart';
import '../size.dart';
import '../widget/responsive.dart';

class AppMenu extends StatefulWidget {
  final VoidCallback onChanged;

  const AppMenu({super.key, required this.onChanged});

  @override
  State<AppMenu> createState() => _AppMenuState();
}

class _AppMenuState extends State<AppMenu> {
  PackageInfo? packageInfo;

  String get version => packageInfo != null
      ? '${packageInfo!.version}+${packageInfo!.buildNumber}'
      : '';

  @override
  void initState() {
    super.initState();
    loadPackageInfo();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      standard: (_) => standard(0.17),
      medium: (_) => standard(0.3),
    );
  }

  Widget standard(double headerHeightFactor) {
    'headerHeightFactor: $headerHeightFactor'.log();
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSize.spacingMedium),
      child: Column(
        children: [
          header(headerHeightFactor),
          stats(),
          intakes(),
          Spacer(),
          Divider(),
          settings(),
          about(),
        ],
      ),
    );
  }

  Widget header(double headerHeightFactor) {
    final content = Stack(
      children: [
        Positioned(
          top: AppSize.spacingLarge,
          right: AppSize.spacingXL,
          child: Text(
            AppL10n.of(context).appTitle,
            textScaler: TextScaler.linear(1.5),
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Positioned(
          bottom: AppSize.spacingMedium,
          left: AppSize.spacingMedium,
          child: appImage(AppSize.spacing4XL),
        ),
      ],
    );
    return Container(
      padding: EdgeInsets.only(top: AppSize.spacingMedium),
      height: MediaQuery.sizeOf(context).height * headerHeightFactor,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(AppSize.spacingXL * 1.5),
        ),
      ),
      child: content,
    );
  }

  Widget appImage(double size) {
    return Image(
      image: AppImage.logo.assetImage(context),
      height: size,
      fit: BoxFit.fitHeight,
    );
  }

  void loadPackageInfo() async {
    packageInfo = await PackageInfo.fromPlatform();
    setState(() {});
  }

  Widget stats() {
    return ListTile(
      title: Text(AppL10n.of(context).stats),
      leading: AppIcon.stats,
      onTap: () {
        context.navigateBack();
        context.navigateTo(.stats);
      },
    );
  }

  Widget intakes() {
    return ListTile(
      title: Text(AppL10n.of(context).intakes),
      leading: AppIcon.waterGlass(context),
      onTap: () async {
        context.navigateBack();
        await context.navigateTo(.intakes);
        widget.onChanged();
      },
    );
  }

  Widget settings() {
    return ListTile(
      title: Text(AppL10n.of(context).settings),
      leading: AppIcon.settings,
      onTap: () async {
        context.navigateBack();
        await context.navigateTo(.targetSettings);
        widget.onChanged();
      },
    );
  }

  Widget about() {
    final appL10n = AppL10n.of(context);
    return ListTile(
      title: Text(appL10n.about),
      leading: AppIcon.about,
      subtitle: packageInfo != null
          ? Text('${appL10n.version}: $version')
          : null,
      onTap: packageInfo != null
          ? () => showDialog(
              context: context,
              builder: (context) => AboutDialog(
                applicationIcon: appImage(AppSize.spacingXL),
                applicationName: appL10n.appTitle,
                applicationVersion: version,
              ),
            )
          : null,
    );
  }
}
