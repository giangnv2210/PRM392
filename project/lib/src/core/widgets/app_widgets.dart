import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum ScreenThemeVariant { auth, collector, admin }

void showAppMessage(BuildContext context, String message) {
  final messenger = ScaffoldMessenger.of(context);
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}

void openAppRoute(
  BuildContext context,
  String route, {
  bool replaceRoute = false,
}) {
  final navigator = Navigator.of(context);
  if (replaceRoute) {
    navigator.pushReplacementNamed(route);
    return;
  }
  navigator.pushNamed(route);
}

class AppPalette {
  const AppPalette({
    required this.accent,
    required this.accentDeep,
    required this.accentSoft,
    required this.backgroundStart,
    required this.backgroundMid,
    required this.backgroundEnd,
  });

  final Color accent;
  final Color accentDeep;
  final Color accentSoft;
  final Color backgroundStart;
  final Color backgroundMid;
  final Color backgroundEnd;
}

AppPalette paletteFor(ScreenThemeVariant variant) => switch (variant) {
  ScreenThemeVariant.auth => const AppPalette(
    accent: Color(0xFF19C37D),
    accentDeep: Color(0xFF087A4D),
    accentSoft: Color(0xFFD7FFE9),
    backgroundStart: Color(0xFF16C784),
    backgroundMid: Color(0xFFB9F7D6),
    backgroundEnd: Color(0xFFF7FFF9),
  ),
  ScreenThemeVariant.collector => const AppPalette(
    accent: Color(0xFF00A7B5),
    accentDeep: Color(0xFF075B67),
    accentSoft: Color(0xFFD8FAFF),
    backgroundStart: Color(0xFF00A7B5),
    backgroundMid: Color(0xFFA9F0F4),
    backgroundEnd: Color(0xFFF8FEFF),
  ),
  ScreenThemeVariant.admin => const AppPalette(
    accent: Color(0xFFFF8A00),
    accentDeep: Color(0xFF9B3F00),
    accentSoft: Color(0xFFFFE2B8),
    backgroundStart: Color(0xFFFF8A00),
    backgroundMid: Color(0xFFFFCF87),
    backgroundEnd: Color(0xFFFFFBF4),
  ),
};

class AppPaletteScope extends InheritedWidget {
  const AppPaletteScope({
    super.key,
    required this.palette,
    required super.child,
  });

  final AppPalette palette;

  static AppPalette of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppPaletteScope>();
    assert(scope != null, 'AppPaletteScope not found in context.');
    return scope!.palette;
  }

  @override
  bool updateShouldNotify(AppPaletteScope oldWidget) =>
      oldWidget.palette != palette;
}

class AppScreen extends StatelessWidget {
  const AppScreen({
    super.key,
    required this.theme,
    required this.title,
    required this.children,
    this.subtitle,
    this.backLabel,
    this.backRoute,
    this.backUsesReplacement = false,
    this.showHeader = false,
    this.footerNote,
  });

  final ScreenThemeVariant theme;
  final String title;
  final String? subtitle;
  final String? backLabel;
  final String? backRoute;
  final bool backUsesReplacement;
  final bool showHeader;
  final List<Widget> children;
  final String? footerNote;

  @override
  Widget build(BuildContext context) {
    final palette = paletteFor(theme);
    final size = MediaQuery.sizeOf(context);
    final isCompact = size.width < 520;
    final radius = isCompact ? 0.0 : 38.0;

    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              palette.backgroundStart,
              palette.backgroundMid,
              palette.backgroundEnd,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(isCompact ? 0 : 20),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 420,
                  minHeight: isCompact ? size.height : size.height - 40,
                ),
                child: AppPaletteScope(
                  palette: palette,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.94),
                      borderRadius: BorderRadius.circular(radius),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.75),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(
                            0xFF0F172A,
                          ).withValues(alpha: 0.18),
                          blurRadius: 56,
                          offset: const Offset(0, 24),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(radius),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (showHeader)
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                18,
                                18,
                                18,
                                16,
                              ),
                              child: Stacked(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (backLabel != null && backRoute != null)
                                    _CompactBackButton(
                                      label: backLabel!,
                                      route: backRoute!,
                                      replaceRoute: backUsesReplacement,
                                    ),
                                  Text(
                                    title,
                                    style: const TextStyle(
                                      fontSize: 32,
                                      height: 1.05,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  if (subtitle != null)
                                    Text(
                                      subtitle!,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        height: 1.45,
                                        color: Color(0xFF5F6B7A),
                                      ),
                                    ),
                                ],
                              ),
                            )
                          else if (backLabel != null && backRoute != null)
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                12,
                                10,
                                12,
                                10,
                              ),
                              child: _CompactBackButton(
                                label: backLabel!,
                                route: backRoute!,
                                replaceRoute: backUsesReplacement,
                              ),
                            )
                          else
                            const SizedBox(height: 18),
                          ...children,
                          if (footerNote != null)
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                20,
                                12,
                                20,
                                24,
                              ),
                              child: Text(
                                footerNote!,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF5F6B7A),
                                ),
                              ),
                            )
                          else
                            const SizedBox(height: 18),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CompactBackButton extends StatelessWidget {
  const _CompactBackButton({
    required this.label,
    required this.route,
    required this.replaceRoute,
  });

  final String label;
  final String route;
  final bool replaceRoute;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () => openAppRoute(context, route, replaceRoute: replaceRoute),
      icon: const Icon(Icons.arrow_back_rounded, size: 18),
      label: Text(label),
      style: TextButton.styleFrom(
        foregroundColor: AppPaletteScope.of(context).accentDeep,
        backgroundColor: Colors.white.withValues(alpha: 0.72),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: Size.zero,
        textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class SectionPadding extends StatelessWidget {
  const SectionPadding({super.key, required this.child, this.bottom = 24});

  final Widget child;
  final double bottom;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, bottom),
      child: child,
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Stacked(
            gap: 8,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  height: 1.15,
                  fontWeight: FontWeight.w900,
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: const TextStyle(
                    fontSize: 12,
                    height: 1.35,
                    color: Color(0xFF5F6B7A),
                  ),
                ),
            ],
          ),
        ),
        if (trailing != null) ...[const SizedBox(width: 14), trailing!],
      ],
    );
  }
}

class EmptyStateCard extends StatelessWidget {
  const EmptyStateCard({super.key, required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(18),
      child: Stacked(
        gap: 8,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
          ),
          Text(
            message,
            style: const TextStyle(
              color: Color(0xFF5F6B7A),
              fontSize: 12,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class AppModalSheet extends StatelessWidget {
  const AppModalSheet({
    super.key,
    required this.title,
    required this.children,
    this.theme = ScreenThemeVariant.admin,
  });

  final String title;
  final List<Widget> children;
  final ScreenThemeVariant theme;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    return AppPaletteScope(
      palette: paletteFor(theme),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(22, 22, 22, bottomInset + 24),
          child: Stacked(
            children: [
              SectionHeader(title: title),
              ...children,
            ],
          ),
        ),
      ),
    );
  }
}

class AppDropdownField<T> extends StatelessWidget {
  const AppDropdownField({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.itemLabel,
    required this.onChanged,
  });

  final String label;
  final T value;
  final List<T> items;
  final String Function(T item) itemLabel;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Stacked(
      gap: 10,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: AppPaletteScope.of(context).accentDeep,
          ),
        ),
        DropdownButtonFormField<T>(
          initialValue: value,
          items: [
            for (final item in items)
              DropdownMenuItem<T>(value: item, child: Text(itemLabel(item))),
          ],
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class Stacked extends StatelessWidget {
  const Stacked({
    super.key,
    required this.children,
    this.gap = 16,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  final List<Widget> children;
  final double gap;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        for (var index = 0; index < children.length; index++) ...[
          if (index > 0) SizedBox(height: gap),
          children[index],
        ],
      ],
    );
  }
}

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.accent = false,
    this.padding = const EdgeInsets.all(20),
  });

  final Widget child;
  final bool accent;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final palette = AppPaletteScope.of(context);
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        gradient: accent
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  palette.accentSoft.withValues(alpha: 0.98),
                  Colors.white.withValues(alpha: 0.95),
                ],
              )
            : null,
        color: accent ? null : Colors.white.withValues(alpha: 0.98),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: accent
              ? palette.accent.withValues(alpha: 0.2)
              : const Color(0xFF132238).withValues(alpha: 0.08),
        ),
        boxShadow: [
          BoxShadow(
            color: palette.accentDeep.withValues(alpha: accent ? 0.13 : 0.08),
            blurRadius: 30,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: child,
    );
  }
}

class HeroPanel extends StatelessWidget {
  const HeroPanel({super.key, required this.child, this.center = false});

  final Widget child;
  final bool center;

  @override
  Widget build(BuildContext context) {
    final palette = AppPaletteScope.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.98),
            palette.accentSoft.withValues(alpha: 0.96),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: palette.accent.withValues(alpha: 0.22)),
        boxShadow: [
          BoxShadow(
            color: palette.accentDeep.withValues(alpha: 0.24),
            blurRadius: 36,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: DefaultTextStyle.merge(
        style: const TextStyle(color: Color(0xFF132238)),
        textAlign: center ? TextAlign.center : TextAlign.start,
        child: child,
      ),
    );
  }
}

class ResponsiveGrid extends StatelessWidget {
  const ResponsiveGrid({
    super.key,
    required this.children,
    this.columns = 2,
    this.spacing = 16,
  });

  final List<Widget> children;
  final int columns;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) {
      return const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final effectiveColumns = constraints.maxWidth < 340
            ? 1
            : columns.clamp(1, children.length);
        final itemWidth = effectiveColumns == 1
            ? constraints.maxWidth
            : (constraints.maxWidth - (spacing * (effectiveColumns - 1))) /
                  effectiveColumns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final child in children)
              SizedBox(width: itemWidth, child: child),
          ],
        );
      },
    );
  }
}

class MetricTile extends StatelessWidget {
  const MetricTile({super.key, required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    final palette = AppPaletteScope.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            palette.accent.withValues(alpha: 0.18),
            Colors.white.withValues(alpha: 0.96),
          ],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: palette.accent.withValues(alpha: 0.18)),
      ),
      child: Stacked(
        gap: 8,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF132238),
              fontSize: 17,
              height: 1.15,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class DetailTile extends StatelessWidget {
  const DetailTile({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.98),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF132238).withValues(alpha: 0.08),
        ),
      ),
      child: Stacked(
        gap: 8,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF132238).withValues(alpha: 0.72),
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class LabeledValue extends StatelessWidget {
  const LabeledValue({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Stacked(
      gap: 9,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF5F6B7A),
            fontSize: 13,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}

class StatusPill extends StatelessWidget {
  const StatusPill(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    final palette = AppPaletteScope.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.accentDeep,
        borderRadius: BorderRadius.circular(999),
        boxShadow: [
          BoxShadow(
            color: palette.accentDeep.withValues(alpha: 0.18),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class AppChip extends StatelessWidget {
  const AppChip(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppPaletteScope.of(context).accentSoft.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: AppPaletteScope.of(context).accent.withValues(alpha: 0.16),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Color(0xFF132238),
          ),
        ),
      ),
    );
  }
}

class AppField extends StatelessWidget {
  const AppField({
    super.key,
    required this.label,
    this.hintText,
    this.initialValue,
    this.controller,
    this.options,
    this.dropdownValue,
    this.onDropdownChanged,
    this.obscureText = false,
    this.maxLines = 1,
    this.keyboardType,
  }) : assert(
         initialValue == null || controller == null,
         'Provide either initialValue or controller, not both.',
       );

  final String label;
  final String? hintText;
  final String? initialValue;
  final TextEditingController? controller;
  final List<String>? options;
  final String? dropdownValue;
  final ValueChanged<String?>? onDropdownChanged;
  final bool obscureText;
  final int maxLines;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Stacked(
      gap: 10,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF132238).withValues(alpha: 0.82),
          ),
        ),
        if (options != null)
          DropdownButtonFormField<String>(
            initialValue: dropdownValue ?? options!.first,
            onChanged: onDropdownChanged ?? (_) {},
            items: options!
                .map(
                  (option) => DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  ),
                )
                .toList(),
            icon: const Icon(Icons.keyboard_arrow_down_rounded),
          )
        else
          TextFormField(
            controller: controller,
            initialValue: initialValue,
            obscureText: obscureText,
            maxLines: maxLines,
            keyboardType: keyboardType,
            onTap: () {
              SystemChannels.textInput.invokeMethod<void>('TextInput.show');
            },
            decoration: InputDecoration(hintText: hintText),
          ),
      ],
    );
  }
}

class AppAction {
  const AppAction(
    this.label, {
    this.route,
    this.icon,
    this.replaceRoute = false,
    this.primary = false,
    this.danger = false,
    this.tiny = false,
    this.onPressed,
  });

  final String label;
  final String? route;
  final IconData? icon;
  final bool replaceRoute;
  final bool primary;
  final bool danger;
  final bool tiny;
  final VoidCallback? onPressed;
}

class ActionBar extends StatelessWidget {
  const ActionBar({super.key, required this.actions});

  final List<AppAction> actions;

  @override
  Widget build(BuildContext context) {
    return ResponsiveGrid(
      columns: actions.length > 1 ? 2 : 1,
      spacing: 14,
      children: [for (final action in actions) AppActionButton(action: action)],
    );
  }
}

class AppActionButton extends StatelessWidget {
  const AppActionButton({super.key, required this.action});

  final AppAction action;

  @override
  Widget build(BuildContext context) {
    final palette = AppPaletteScope.of(context);
    final minimumHeight = action.tiny ? 48.0 : 60.0;
    final padding = action.tiny
        ? const EdgeInsets.symmetric(horizontal: 16, vertical: 12)
        : const EdgeInsets.symmetric(horizontal: 22, vertical: 16);
    final icon = action.icon ?? _iconForAction(action);

    void onPressed() {
      if (action.onPressed != null) {
        action.onPressed!();
        return;
      }
      if (action.route != null) {
        openAppRoute(context, action.route!, replaceRoute: action.replaceRoute);
        return;
      }
      showAppMessage(context, '${action.label} is not wired to data yet.');
    }

    if (action.primary || action.danger) {
      final backgroundColor = action.danger
          ? const Color(0xFFFF6D53)
          : palette.accentDeep;
      return FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: Colors.white,
          minimumSize: Size.fromHeight(minimumHeight),
          padding: padding,
          shape: const StadiumBorder(),
          elevation: action.tiny ? 1 : 5,
          textStyle: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: action.tiny ? 13 : 15,
          ),
        ),
        child: _ButtonContent(
          icon: icon,
          label: action.label,
          compact: action.tiny,
        ),
      );
    }

    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: palette.accentDeep,
        backgroundColor: palette.accentSoft.withValues(alpha: 0.6),
        side: BorderSide(color: palette.accent.withValues(alpha: 0.28)),
        minimumSize: Size.fromHeight(minimumHeight),
        padding: padding,
        shape: const StadiumBorder(),
        textStyle: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: action.tiny ? 13 : 15,
        ),
      ),
      child: _ButtonContent(
        icon: icon,
        label: action.label,
        compact: action.tiny,
      ),
    );
  }
}

class _ButtonContent extends StatelessWidget {
  const _ButtonContent({
    required this.icon,
    required this.label,
    required this.compact,
  });

  final IconData icon;
  final String label;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: compact ? 17 : 20),
          SizedBox(width: compact ? 6 : 9),
          Text(label, textAlign: TextAlign.center, maxLines: 1),
        ],
      ),
    );
  }
}

IconData _iconForAction(AppAction action) {
  if (action.danger) {
    return Icons.delete_rounded;
  }
  final label = action.label.toLowerCase();
  if (label.contains('login') || label.contains('sign in')) {
    return Icons.login_rounded;
  }
  if (label.contains('register') || label.contains('account')) {
    return Icons.person_add_alt_1_rounded;
  }
  if (label.contains('password') || label.contains('code')) {
    return Icons.lock_reset_rounded;
  }
  if (label.contains('save') || label.contains('confirm')) {
    return Icons.check_circle_rounded;
  }
  if (label.contains('cancel') || label.contains('discard')) {
    return Icons.close_rounded;
  }
  if (label.contains('back')) {
    return Icons.arrow_back_rounded;
  }
  if (label.contains('settings')) {
    return Icons.tune_rounded;
  }
  if (label.contains('scan') || label.contains('qr')) {
    return Icons.qr_code_scanner_rounded;
  }
  if (label.contains('customer') || label.contains('assigned')) {
    return Icons.groups_rounded;
  }
  if (label.contains('payment') ||
      label.contains('collection') ||
      label.contains('paid')) {
    return Icons.payments_rounded;
  }
  if (label.contains('bill')) {
    return Icons.receipt_long_rounded;
  }
  if (label.contains('add') ||
      label.contains('create') ||
      label.contains('new')) {
    return Icons.add_circle_rounded;
  }
  if (label.contains('edit')) {
    return Icons.edit_rounded;
  }
  if (label.contains('remove') || label.contains('deactivate')) {
    return Icons.block_rounded;
  }
  if (label.contains('logout')) {
    return Icons.logout_rounded;
  }
  if (label.contains('call')) {
    return Icons.call_rounded;
  }
  if (label.contains('export') ||
      label.contains('download') ||
      label.contains('print')) {
    return Icons.file_download_rounded;
  }
  if (label.contains('assign')) {
    return Icons.assignment_ind_rounded;
  }
  if (label.contains('approve') || label.contains('resolve')) {
    return Icons.verified_rounded;
  }
  if (label.contains('retry')) {
    return Icons.refresh_rounded;
  }
  if (label.contains('flash')) {
    return Icons.flash_on_rounded;
  }
  if (label.contains('clear')) {
    return Icons.cleaning_services_rounded;
  }
  if (label.contains('receipt') || label.contains('record')) {
    return Icons.article_rounded;
  }
  if (label.contains('review') ||
      label.contains('view') ||
      label.contains('open') ||
      label.contains('detail')) {
    return Icons.visibility_rounded;
  }
  return Icons.arrow_forward_rounded;
}

class ListRecordTile extends StatelessWidget {
  const ListRecordTile({
    super.key,
    required this.title,
    required this.subtitle,
    this.note,
    this.headerTrailing,
    this.extra = const [],
    this.actions = const [],
  });

  final String title;
  final String subtitle;
  final String? note;
  final Widget? headerTrailing;
  final List<Widget> extra;
  final List<AppAction> actions;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFF132238).withValues(alpha: 0.1),
        ),
      ),
      child: Stacked(
        gap: 12,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stacked(
                  gap: 8,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Color(0xFF5F6B7A),
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              if (headerTrailing != null) ...[
                const SizedBox(width: 12),
                headerTrailing!,
              ],
            ],
          ),
          if (note != null)
            Text(
              note!,
              style: const TextStyle(
                color: Color(0xFF5F6B7A),
                fontSize: 13,
                height: 1.45,
              ),
            ),
          ...extra,
          if (actions.isNotEmpty)
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (final action in actions)
                  AppActionButton(
                    action: AppAction(
                      action.label,
                      route: action.route,
                      icon: action.icon,
                      replaceRoute: action.replaceRoute,
                      primary: action.primary,
                      danger: action.danger,
                      tiny: true,
                      onPressed: action.onPressed,
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

class ToggleOptionCard extends StatefulWidget {
  const ToggleOptionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.initialValue,
  });

  final String title;
  final String subtitle;
  final bool initialValue;

  @override
  State<ToggleOptionCard> createState() => _ToggleOptionCardState();
}

class _ToggleOptionCardState extends State<ToggleOptionCard> {
  late bool _value = widget.initialValue;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          Expanded(
            child: Stacked(
              gap: 8,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                Text(
                  widget.subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF5F6B7A),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: _value,
            onChanged: (value) => setState(() => _value = value),
          ),
        ],
      ),
    );
  }
}

class CameraPreviewCard extends StatelessWidget {
  const CameraPreviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.1,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xCC08121C), Color(0x6608121C)],
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF8FE2DC),
                      Color(0xFF5BB8D5),
                      Color(0xFF1F567E),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(top: -54, right: -40, child: _CameraGlow(size: 180)),
            Positioned(left: -14, bottom: -40, child: _CameraGlow(size: 120)),
            Positioned.fill(
              child: Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 42,
                    vertical: 58,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Stack(
                    children: const [
                      Positioned(
                        left: 18,
                        right: 18,
                        top: 54,
                        child: Divider(color: Colors.white, thickness: 2),
                      ),
                      Positioned(
                        left: 18,
                        right: 18,
                        bottom: 54,
                        child: Divider(color: Colors.white, thickness: 2),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CameraGlow extends StatelessWidget {
  const _CameraGlow({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: 0.12),
      ),
    );
  }
}
