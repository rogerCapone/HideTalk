import 'package:cool_alert/cool_alert.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:hide_talk/pages/chats/chat/chat.dart';
import 'package:hide_talk/services/database.dart';
import 'package:hide_talk/services/provider.dart';
import 'package:hide_talk/shared/constants.dart';
import 'package:hide_talk/shared/size_config.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ContactItem extends StatelessWidget {
  final dynamic contact;
  const ContactItem({Key key, this.contact}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: kPrimaryGradientColor,
          borderRadius: BorderRadius.circular(20)),
      child: Card(
        shadowColor: Colors.red,
        color: kSecondaryColor,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onLongPress: () async {
            CoolAlert.show(
              context: context,
              type: CoolAlertType.confirm,
              animType: CoolAlertAnimType.slideInDown,
              barrierDismissible: true,
              title: AppLocalizations.of(context).areYouSure,
              cancelBtnText: AppLocalizations.of(context).notDelete,
              cancelBtnTextStyle:
                  kTextStyleWhiteBodyMedium.copyWith(color: Colors.grey),
              confirmBtnTextStyle: kTextStyleWhiteBodyMedium,
              confirmBtnText: AppLocalizations.of(context).delete,
              confirmBtnColor: Colors.red.withOpacity(0.85),
              text: AppLocalizations.of(context).sureToDelete,
              onCancelBtnTap: () {
                return Navigator.pop(context);
              },
              backgroundColor: Colors.orange.withOpacity(0.9),
              onConfirmBtnTap: () async {
                final uid = await Provider.of(context).auth.getCurrentUID();
                Navigator.pop(context);

                return DatabaseMethods()
                    .removeContact(uid: uid, contact: contact);
              },
            );
          },
          onTap: () {
            // print(contact['photoUrl']);
            // print(contact['userName']);
            // print(contact['uid']);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatDetailPage(
                        image: contact['photoUrl'],
                        userName: contact['userName'],
                        userUid: contact['uid'],
                        fav: contact['fav'])));
          },
          child: Container(
              color: kSecondaryColor,
              margin: EdgeInsets.all(5),
              height: getProportionateScreenWidth(150),
              width: getProportionateScreenWidth(150),
              child: Hero(
                tag: contact['photoUrl'],
                child: ExtendedImage.network(
                  contact['photoUrl'],
                  height: getProportionateScreenWidth(150),
                  width: getProportionateScreenWidth(150),
                  fit: BoxFit.cover,
                  cache: true,

                  //cancelToken: cancellationToken,
                ),
              )),
        ),
      ),
    );
  }
}
