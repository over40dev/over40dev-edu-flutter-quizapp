import 'package:firebase_analytics/firebase_analytics.dart';

// Static Global state, Immutable services that do not care about build context.
class Global {
  // App Data
  static final String title = 'CogentX';

  // Services
  static final FirebaseAnalytics analytics = FirebaseAnalytics();
}
