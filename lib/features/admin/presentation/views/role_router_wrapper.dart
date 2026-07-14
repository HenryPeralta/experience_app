import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/presentation/providers/dependency_injection.dart';
import '../../../onboarding/presentation/views/onboarding_view.dart';
import 'admin_dashboard_view.dart';

/// Wrapper que valida el rol del usuario y lo redirige a la pantalla apropiada
class RoleRouterWrapper extends ConsumerWidget {
  const RoleRouterWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserAsyncProvider);

    return userAsync.when(
      data: (user) {
        if (user == null) {
          // Si no hay usuario, mostrar onboarding
          return const OnboardingView();
        }

        // Verificar el rol y redirigir
        if (user.role == UserRole.admin) {
          return const AdminDashboardView();
        } else {
          // Los usuarios normales primero ven el onboarding
          return const OnboardingView();
        }
      },
      loading: () => Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (err, st) => Scaffold(
        body: Center(
          child: Text('Error: $err'),
        ),
      ),
    );
  }
}
