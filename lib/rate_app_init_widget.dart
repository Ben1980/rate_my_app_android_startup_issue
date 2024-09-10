import 'package:flutter/material.dart';
import 'package:rate_my_app/rate_my_app.dart';

class RateAppInitWidget extends StatefulWidget {
  final Widget Function(RateMyApp) builder;

  const RateAppInitWidget({
    super.key,
    required this.builder,
  });

  @override
  State<RateAppInitWidget> createState() => _RateAppInitWidgetState();
}

class _RateAppInitWidgetState extends State<RateAppInitWidget> {
  RateMyApp? rateMyApp;

  @override
  Widget build(BuildContext context) => RateMyAppBuilder(
        rateMyApp: RateMyApp(
          minDays: 2,
          minLaunches: 2,
          remindDays: 5,
          remindLaunches: 5,
          appStoreIdentifier: "com.example.rate_my_app_android_startup_issue",
          googlePlayIdentifier: "com.example.rate_my_app_android_startup_issue",
        ),
        onInitialized: (context, rateMyApp) {
          setState(() => this.rateMyApp = rateMyApp);
        },
        builder: (context) =>
            rateMyApp == null ? Container() : widget.builder(rateMyApp!),
      );
}

List<Widget> rateActionsBuilder(
        BuildContext context, RateMyApp rateWidget, double? stars) =>
    stars == null
        ? [buildCancelButton(context, rateWidget)]
        : [
            buildOkButton(context, rateWidget, stars),
            buildCancelButton(context, rateWidget),
          ];

Widget buildOkButton(
        BuildContext context, RateMyApp rateWidget, double? stars) =>
    TextButton(
      child: Text("OK"),
      onPressed: () async {
        if (stars != null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              "You rated us $stars stars. Thank you!",
            ),
          ));

          final launcheAppStore = stars >= 3;

          const event = RateMyAppEventType.rateButtonPressed;
          await rateWidget.callEvent(event);

          if (launcheAppStore) {
            rateWidget.launchStore();
          } else {
            final Uri url = Uri.parse(
                'mailto:info@octologs.com?subject=Please tell us why is Octologs not fit your needs?');
            //launchUrl(url);
          }
        }

        if (context.mounted) {
          Navigator.of(context).pop();
        }
      },
    );

Widget buildCancelButton(BuildContext context, RateMyApp rateWidget) =>
    RateMyAppNoButton(rateWidget, text: "CANCEL");
