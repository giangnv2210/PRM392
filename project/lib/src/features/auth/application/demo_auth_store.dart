import '../../../app/router/app_routes.dart';

enum DemoUserRole { admin, collector }

class DemoAuthResult {
  const DemoAuthResult({
    required this.isSuccess,
    required this.message,
    this.route,
  });

  final bool isSuccess;
  final String message;
  final String? route;
}

class DemoUserAccount {
  const DemoUserAccount({
    required this.fullName,
    required this.identifier,
    required this.phone,
    required this.password,
    required this.role,
  });

  final String fullName;
  final String identifier;
  final String phone;
  final String password;
  final DemoUserRole role;

  DemoUserAccount copyWith({
    String? fullName,
    String? identifier,
    String? phone,
    String? password,
    DemoUserRole? role,
  }) {
    return DemoUserAccount(
      fullName: fullName ?? this.fullName,
      identifier: identifier ?? this.identifier,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      role: role ?? this.role,
    );
  }
}

abstract final class DemoAuthStore {
  static final List<DemoUserAccount> _accounts = [
    const DemoUserAccount(
      fullName: 'System Administrator',
      identifier: 'admin@gmail.com',
      phone: '0900000001',
      password: 'admin123',
      role: DemoUserRole.admin,
    ),
    const DemoUserAccount(
      fullName: 'Collector Demo',
      identifier: 'collector@gmail.com',
      phone: '0900000002',
      password: 'collector123',
      role: DemoUserRole.collector,
    ),
  ];

  static final Map<String, String> _resetCodes = {};

  static DemoAuthResult login({
    required String identifier,
    required String password,
  }) {
    final normalizedIdentifier = identifier.trim().toLowerCase();
    final normalizedPassword = password.trim();

    if (normalizedIdentifier.isEmpty || normalizedPassword.isEmpty) {
      return const DemoAuthResult(
        isSuccess: false,
        message: 'Enter both your login identifier and password.',
      );
    }

    final account = _findAccount(normalizedIdentifier);
    if (account == null || account.password != normalizedPassword) {
      return const DemoAuthResult(
        isSuccess: false,
        message:
            'Invalid credentials. Demo accounts: admint@gmail.com / admin123 or collector@gmail.com / collector123.',
      );
    }

    return DemoAuthResult(
      isSuccess: true,
      message: 'Signed in as ${account.fullName}.',
      route: _routeFor(account.role),
    );
  }

  static DemoAuthResult register({
    required String fullName,
    required String identifier,
    required String phone,
    required String password,
    required String confirmPassword,
  }) {
    final normalizedName = fullName.trim();
    final normalizedIdentifier = identifier.trim().toLowerCase();
    final normalizedPhone = phone.trim();

    if (normalizedName.isEmpty ||
        normalizedIdentifier.isEmpty ||
        normalizedPhone.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      return const DemoAuthResult(
        isSuccess: false,
        message: 'Complete all fields before creating the account.',
      );
    }

    if (!normalizedIdentifier.contains('@')) {
      return const DemoAuthResult(
        isSuccess: false,
        message: 'Enter a valid email address.',
      );
    }

    if (password.length < 6) {
      return const DemoAuthResult(
        isSuccess: false,
        message: 'Password must be at least 6 characters.',
      );
    }

    if (password != confirmPassword) {
      return const DemoAuthResult(
        isSuccess: false,
        message: 'Password confirmation does not match.',
      );
    }

    if (_findAccount(normalizedIdentifier) != null ||
        _accounts.any((account) => account.phone == normalizedPhone)) {
      return const DemoAuthResult(
        isSuccess: false,
        message: 'That email or phone number is already registered.',
      );
    }

    _accounts.add(
      DemoUserAccount(
        fullName: normalizedName,
        identifier: normalizedIdentifier,
        phone: normalizedPhone,
        password: password,
        role: DemoUserRole.collector,
      ),
    );

    return DemoAuthResult(
      isSuccess: true,
      message:
          'Account created for $normalizedName. You can now sign in with $normalizedIdentifier.',
      route: AppRoutes.login,
    );
  }

  static DemoAuthResult sendResetCode({required String identifier}) {
    final normalizedIdentifier = identifier.trim().toLowerCase();
    if (normalizedIdentifier.isEmpty) {
      return const DemoAuthResult(
        isSuccess: false,
        message: 'Enter the registered email or phone first.',
      );
    }

    final account = _findAccount(normalizedIdentifier);
    if (account == null) {
      return const DemoAuthResult(
        isSuccess: false,
        message: 'No account matches that email or phone number.',
      );
    }

    _resetCodes[account.identifier] = '123456';
    return DemoAuthResult(
      isSuccess: true,
      message: 'Verification code sent. Use 123456 for the demo reset flow.',
    );
  }

  static DemoAuthResult resetPassword({
    required String identifier,
    required String code,
    required String newPassword,
    required String confirmPassword,
  }) {
    final normalizedIdentifier = identifier.trim().toLowerCase();
    final normalizedCode = code.trim();

    if (normalizedIdentifier.isEmpty ||
        normalizedCode.isEmpty ||
        newPassword.isEmpty ||
        confirmPassword.isEmpty) {
      return const DemoAuthResult(
        isSuccess: false,
        message: 'Complete all fields to reset the password.',
      );
    }

    final account = _findAccount(normalizedIdentifier);
    if (account == null) {
      return const DemoAuthResult(
        isSuccess: false,
        message: 'No account matches that email or phone number.',
      );
    }

    if (_resetCodes[account.identifier] != normalizedCode) {
      return const DemoAuthResult(
        isSuccess: false,
        message: 'Verification code is invalid. Use 123456 in the demo flow.',
      );
    }

    if (newPassword.length < 6) {
      return const DemoAuthResult(
        isSuccess: false,
        message: 'New password must be at least 6 characters.',
      );
    }

    if (newPassword != confirmPassword) {
      return const DemoAuthResult(
        isSuccess: false,
        message: 'Password confirmation does not match.',
      );
    }

    final index = _accounts.indexOf(account);
    _accounts[index] = account.copyWith(password: newPassword);
    _resetCodes.remove(account.identifier);

    return const DemoAuthResult(
      isSuccess: true,
      message: 'Password updated. Sign in with the new password.',
      route: AppRoutes.login,
    );
  }

  static DemoUserAccount? _findAccount(String identifier) {
    for (final account in _accounts) {
      if (account.identifier == identifier || account.phone == identifier) {
        return account;
      }
    }
    return null;
  }

  static String _routeFor(DemoUserRole role) => switch (role) {
    DemoUserRole.admin => AppRoutes.adminDashboard,
    DemoUserRole.collector => AppRoutes.collectorDashboard,
  };
}
