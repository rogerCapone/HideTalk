// import 'dart:async';

// import 'package:a_iop/services/database.dart';
// import 'package:a_iop/services/globals.dart';
// import 'package:bloc/bloc.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:equatable/equatable.dart';
// import 'package:purchases_flutter/object_wrappers.dart';
// import 'package:purchases_flutter/purchases_flutter.dart';

// part 'subscription_event.dart';
// part 'subscription_state.dart';

// class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
//   SubscriptionBloc() : super(SubscriptionInitial());

//   @override
//   Stream<SubscriptionState> mapEventToState(
//     SubscriptionEvent event,
//   ) async* {
//     if (event is LoadPageEvent) {
//       yield LoadingPageState(text: 'Loading...');

//       try {
//         final List<Product> products = await Purchases.getProducts();
//         print(products.toString());

//         dynamic _goldPlan = products[0];
//         dynamic __silverPlan = products[1];

//         //fetch the current user
//         DocumentSnapshot _currentUser = await Global.appRef.getAppDataDoc();

//         if (_currentUser.data()['activeSubscription'] == 'GoldPlan') {
//           yield GoldPlanSubscribedState(goldPlan: _goldPlan);
//         } else if (_currentUser.data()['activeSubscription'] == 'SilverPlan') {
//           yield SilverPlanSubscribedState(silverPlan: __silverPlan);
//         } else {
//           yield NoPlanSubscribedState(
//               goldPlan: _goldPlan, silverPlan: __silverPlan);
//         }
//       } catch (error) {
//         yield ErrorState(error: error);
//       }
//     }

//     if (event is BuyProductEvent) {
//       try {
//         PurchaserInfo purchaserInfo =
//             await Purchases.purchaseProduct(event.sku);
//         final String activeSubscription =
//             purchaserInfo.activeSubscriptions.first;
//         DocumentSnapshot _currentUser = await Global.appRef.getAppDataDoc();

//         if (activeSubscription == GOLD_PLAN) {
//           await DatabaseMethods().updateSub(
//               uid: _currentUser.data()['uid'], activeSubscription: GOLD_PLAN);
//           yield GoldPlanSubscribedState(goldPlan: _goldPlan);
//         } else if (activeSubscription == SILVER_PLAN) {
//           await DatabaseMethods().updateSub(
//               uid: _currentUser.data()['uid'], activeSubscription: SILVER_PLAN);
//           yield SilverPlanSubscribedState(silverPlan: _silverPlan);
//         }
//       } catch (e) {
//         print(e.toString());
//       }
//     }

//     if (event is ResetSubscriptionEvent) {
//       //Show that app needs to be reset (close and open)
//     }
//   }
// }
