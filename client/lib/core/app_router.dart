import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../views/splash_onboarding_view.dart';
import '../views/claim_identity_view.dart';
import '../views/identity_success_view.dart';
import '../views/dashboard_view.dart';
import '../views/linked_methods_view.dart';
import '../views/add_method_view.dart';
import '../views/routing_rules_view.dart';
import '../views/receive_money_view.dart';
import '../views/send_money_view.dart';
import '../views/confirm_recipient_view.dart';
import '../views/choosing_route_view.dart';
import '../views/confirm_payment_view.dart';
import '../views/money_delivered_view.dart';
import '../views/track_transfer_view.dart';
import '../views/profile_view.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashOnboardingView(),
      ),
      GoRoute(
        path: '/claim-identity',
        builder: (context, state) => const ClaimIdentityView(),
      ),
      GoRoute(
        path: '/identity-success',
        builder: (context, state) => const IdentitySuccessView(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardView(),
      ),
      GoRoute(
        path: '/linked-methods',
        builder: (context, state) => const LinkedMethodsView(),
      ),
      GoRoute(
        path: '/add-method',
        builder: (context, state) => const AddMethodView(),
      ),
      GoRoute(
        path: '/routing-rules',
        builder: (context, state) => const RoutingRulesView(),
      ),
      GoRoute(
        path: '/receive-money',
        builder: (context, state) => const ReceiveMoneyView(),
      ),
      GoRoute(
        path: '/send-money',
        builder: (context, state) => const SendMoneyView(),
      ),
      GoRoute(
        path: '/confirm-recipient',
        builder: (context, state) => ConfirmRecipientView(data: state.extra as Map<String, dynamic>),
      ),
      GoRoute(
        path: '/choosing-route',
        builder: (context, state) => ChoosingRouteView(data: state.extra as Map<String, dynamic>),
      ),
      GoRoute(
        path: '/confirm-payment',
        builder: (context, state) => ConfirmPaymentView(data: state.extra as Map<String, dynamic>),
      ),
      GoRoute(
        path: '/money-delivered',
        builder: (context, state) => MoneyDeliveredView(data: state.extra as Map<String, dynamic>),
      ),
      GoRoute(
        path: '/track-transfer',
        builder: (context, state) => const TrackTransferView(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileView(),
      ),
    ],
  );
}
