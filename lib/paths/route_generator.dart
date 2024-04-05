import 'package:flutter/material.dart';
import 'package:safe_return/paths/routes.dart';
import 'package:safe_return/screens/case_list.dart';
import 'package:safe_return/screens/enforcer_assign_staff.dart';
import 'package:safe_return/screens/enforcer_dashboard.dart';
import 'package:safe_return/screens/enforcer_verification_detail.dart';
import 'package:safe_return/screens/enforcer_verification_listing.dart';
import 'package:safe_return/screens/indexing_page.dart';
import 'package:safe_return/screens/new_case.dart';
import 'package:safe_return/screens/public_case_details.dart';
import 'package:safe_return/screens/public_dashboard.dart';
import 'package:safe_return/screens/public_registration.dart';
import 'package:safe_return/screens/public_registration_edit.dart';
import 'package:safe_return/screens/update_password.dart';
import 'package:safe_return/screens/view_case.dart';

class RouteGenerator {
  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.indexPage:
        final args = settings.arguments as IndexingPage?;
        return MaterialPageRoute(
          builder: (_) => IndexingPage(
            index: args?.index ?? 0,
          ),
        );

      case Routes.publicRegistration:
        return MaterialPageRoute(
          builder: (_) => const PublicRegistration(),
        );

      case Routes.newCase:
        return MaterialPageRoute(
          builder: (_) => const NewCase(),
        );

      case Routes.publicDashboard:
        return MaterialPageRoute(
          builder: (_) => const PublicDashboard(),
        );
      case Routes.enforcerDashboard:
        return MaterialPageRoute(
          builder: (_) => const EnforcerDashboard(),
        );
      case Routes.enforcerVerificationListing:
        return MaterialPageRoute(
          builder: (_) => const EnforcerVerificationListing(),
        );
      case Routes.enforcerVerificationDetail:
        final args = settings.arguments as EnforcerVerificationDetail;
        return MaterialPageRoute(
          builder: (_) => EnforcerVerificationDetail(
            userData: args.userData,
          ),
        );
      case Routes.enforcerAssignStaff:
        final args = settings.arguments as EnforcerAssignStaff;
        return MaterialPageRoute(
          builder: (_) => EnforcerAssignStaff(
            caseModel: args.caseModel,
          ),
        );

      case Routes.publicCaseDetail:
        final args = settings.arguments as PublicCaseDetail;
        return MaterialPageRoute(
          builder: (_) => PublicCaseDetail(
            caseModel: args.caseModel,
          ),
        );
      case Routes.updatePassword:
        return MaterialPageRoute(
          builder: (_) => const UpdatePassword(),
        );

      case Routes.viewCase:
        return MaterialPageRoute(
          builder: (_) => const ViewCase(),
        );
      case Routes.publicRegistrationEdit:
        final args = settings.arguments as PublicRegistrationEdit;
        return MaterialPageRoute(
          builder: (_) => PublicRegistrationEdit(
            userData: args.userData,
          ),
        );

      case Routes.caseList:
        return MaterialPageRoute(
          builder: (_) => const CaseList(),
        );

      default:
        final args = settings.arguments as IndexingPage?;
        return MaterialPageRoute(
          builder: (_) => IndexingPage(
            index: args?.index ?? 0,
          ),
        );
    }
  }
}
