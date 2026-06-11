import 'package:flutter/material.dart';

import '../navigation/app_routes.dart';

ThemeData buildAppTheme() {
  const seed = Color(0xFF68D9D2);
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: seed),
  );

  return base.copyWith(
    scaffoldBackgroundColor: Colors.transparent,
    textTheme: base.textTheme.apply(
      bodyColor: const Color(0xFF132238),
      displayColor: const Color(0xFF132238),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.96),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: const Color(0xFF132238).withValues(alpha: 0.12),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: const Color(0xFF132238).withValues(alpha: 0.12),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: seed.withValues(alpha: 0.8), width: 1.4),
      ),
    ),
  );
}

class MockupPalette {
  const MockupPalette({
    required this.accent,
    required this.accentSoft,
    required this.backgroundStart,
    required this.backgroundMid,
    required this.backgroundEnd,
  });

  final Color accent;
  final Color accentSoft;
  final Color backgroundStart;
  final Color backgroundMid;
  final Color backgroundEnd;
}

MockupPalette paletteFor(ScreenThemeVariant variant) => switch (variant) {
  ScreenThemeVariant.auth => const MockupPalette(
    accent: Color(0xFF6FDC87),
    accentSoft: Color(0xFFDEF8E5),
    backgroundStart: Color(0xFFEAF9EF),
    backgroundMid: Color(0xFFF7FBF8),
    backgroundEnd: Color(0xFFEDF8EF),
  ),
  ScreenThemeVariant.collector => const MockupPalette(
    accent: Color(0xFF68D9D2),
    accentSoft: Color(0xFFDFFAF8),
    backgroundStart: Color(0xFFDBFBF7),
    backgroundMid: Color(0xFFFBFFFE),
    backgroundEnd: Color(0xFFEEFAFB),
  ),
  ScreenThemeVariant.admin => const MockupPalette(
    accent: Color(0xFFFF7C5B),
    accentSoft: Color(0xFFFFE2DC),
    backgroundStart: Color(0xFFFFE6DF),
    backgroundMid: Color(0xFFFFFAF8),
    backgroundEnd: Color(0xFFFDEEE9),
  ),
};

class MockupPaletteScope extends InheritedWidget {
  const MockupPaletteScope({
    super.key,
    required this.palette,
    required super.child,
  });

  final MockupPalette palette;

  static MockupPalette of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<MockupPaletteScope>();
    assert(scope != null, 'MockupPaletteScope not found in context.');
    return scope!.palette;
  }

  @override
  bool updateShouldNotify(MockupPaletteScope oldWidget) =>
      oldWidget.palette != palette;
}

class MockupPage extends StatelessWidget {
  const MockupPage({
    super.key,
    required this.theme,
    required this.title,
    required this.children,
    this.subtitle,
    this.backLabel,
    this.backRoute,
    this.footerNote,
  });

  final ScreenThemeVariant theme;
  final String title;
  final String? subtitle;
  final String? backLabel;
  final String? backRoute;
  final List<Widget> children;
  final String? footerNote;

  @override
  Widget build(BuildContext context) {
    final palette = paletteFor(theme);
    final size = MediaQuery.sizeOf(context);
    final isCompact = size.width < 520;
    final radius = isCompact ? 0.0 : 34.0;

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
                child: MockupPaletteScope(
                  palette: palette,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(radius),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.75),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(
                            0xFF0F172A,
                          ).withValues(alpha: 0.12),
                          blurRadius: 50,
                          offset: const Offset(0, 20),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(radius),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
                            child: Stacked(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (backLabel != null && backRoute != null)
                                  TextButton.icon(
                                    onPressed: () => Navigator.of(
                                      context,
                                    ).pushNamed(backRoute!),
                                    icon: const Icon(Icons.arrow_back_rounded),
                                    label: Text(backLabel!),
                                    style: TextButton.styleFrom(
                                      foregroundColor: const Color(0xFF5F6B7A),
                                      padding: EdgeInsets.zero,
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      minimumSize: Size.zero,
                                    ),
                                  ),
                                Text(
                                  title,
                                  style: const TextStyle(
                                    fontSize: 30,
                                    height: 1.05,
                                    fontWeight: FontWeight.w700,
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
                          ),
                          ...children,
                          if (footerNote != null)
                            Padding(
                              padding: const EdgeInsets.fromLTRB(18, 8, 18, 18),
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

class SectionPadding extends StatelessWidget {
  const SectionPadding({super.key, required this.child, this.bottom = 18});

  final Widget child;
  final double bottom;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18, 0, 18, bottom),
      child: child,
    );
  }
}

class Stacked extends StatelessWidget {
  const Stacked({
    super.key,
    required this.children,
    this.gap = 12,
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

class MockupCard extends StatelessWidget {
  const MockupCard({
    super.key,
    required this.child,
    this.accent = false,
    this.padding = const EdgeInsets.all(16),
  });

  final Widget child;
  final bool accent;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final palette = MockupPaletteScope.of(context);
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        gradient: accent
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  palette.accentSoft,
                  Colors.white.withValues(alpha: 0.95),
                ],
              )
            : null,
        color: accent ? null : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF132238).withValues(alpha: 0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.05),
            blurRadius: 24,
            offset: const Offset(0, 8),
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
    final palette = MockupPaletteScope.of(context);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.96),
            palette.accentSoft.withValues(alpha: 0.85),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.9)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.06),
            blurRadius: 30,
            offset: const Offset(0, 12),
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

class MockGrid extends StatelessWidget {
  const MockGrid({
    super.key,
    required this.children,
    this.columns = 2,
    this.spacing = 12,
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
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFF132238).withValues(alpha: 0.1),
        ),
      ),
      child: Stacked(
        gap: 4,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
          ),
          Text(
            value,
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

class DetailTile extends StatelessWidget {
  const DetailTile({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFF132238).withValues(alpha: 0.1),
        ),
      ),
      child: Stacked(
        gap: 4,
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
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
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
      gap: 4,
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
    final palette = MockupPaletteScope.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.accentSoft.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        child: Text(
          label,
          style: TextStyle(
            color: Color.alphaBlend(
              palette.accent.withValues(alpha: 0.72),
              const Color(0xFF000000),
            ),
            fontSize: 12,
            fontWeight: FontWeight.w700,
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
        color: Colors.white.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: const Color(0xFF132238).withValues(alpha: 0.1),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Color(0xFF5F6B7A),
          ),
        ),
      ),
    );
  }
}

class MockField extends StatelessWidget {
  const MockField({
    super.key,
    required this.label,
    this.hintText,
    this.initialValue,
    this.options,
    this.dropdownValue,
    this.onDropdownChanged,
    this.obscureText = false,
    this.maxLines = 1,
  });

  final String label;
  final String? hintText;
  final String? initialValue;
  final List<String>? options;
  final String? dropdownValue;
  final ValueChanged<String?>? onDropdownChanged;
  final bool obscureText;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Stacked(
      gap: 7,
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
            initialValue: initialValue,
            obscureText: obscureText,
            maxLines: maxLines,
            decoration: InputDecoration(hintText: hintText),
          ),
      ],
    );
  }
}

class MockAction {
  const MockAction(
    this.label, {
    this.route,
    this.primary = false,
    this.danger = false,
    this.tiny = false,
    this.onPressed,
  });

  final String label;
  final String? route;
  final bool primary;
  final bool danger;
  final bool tiny;
  final VoidCallback? onPressed;
}

class ActionBar extends StatelessWidget {
  const ActionBar({super.key, required this.actions});

  final List<MockAction> actions;

  @override
  Widget build(BuildContext context) {
    return MockGrid(
      columns: actions.length > 1 ? 2 : 1,
      spacing: 10,
      children: [for (final action in actions) MockButton(action: action)],
    );
  }
}

class MockButton extends StatelessWidget {
  const MockButton({super.key, required this.action});

  final MockAction action;

  @override
  Widget build(BuildContext context) {
    final palette = MockupPaletteScope.of(context);
    final minimumHeight = action.tiny ? 38.0 : 46.0;
    final padding = action.tiny
        ? const EdgeInsets.symmetric(horizontal: 12, vertical: 8)
        : const EdgeInsets.symmetric(horizontal: 16, vertical: 12);

    void onPressed() {
      if (action.onPressed != null) {
        action.onPressed!();
        return;
      }
      if (action.route != null) {
        Navigator.of(context).pushNamed(action.route!);
      }
    }

    if (action.primary || action.danger) {
      final backgroundColor = action.danger
          ? const Color(0xFFFF6D53)
          : palette.accent;
      return FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: Colors.white,
          minimumSize: Size.fromHeight(minimumHeight),
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(action.tiny ? 12 : 16),
          ),
          textStyle: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: action.tiny ? 13 : 14,
          ),
        ),
        child: Text(action.label, textAlign: TextAlign.center),
      );
    }

    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF132238),
        backgroundColor: Colors.white.withValues(alpha: 0.85),
        side: BorderSide(
          color: const Color(0xFF132238).withValues(alpha: 0.12),
        ),
        minimumSize: Size.fromHeight(minimumHeight),
        padding: padding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(action.tiny ? 12 : 16),
        ),
        textStyle: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: action.tiny ? 13 : 14,
        ),
      ),
      child: Text(action.label, textAlign: TextAlign.center),
    );
  }
}

class ListRecordTile extends StatelessWidget {
  const ListRecordTile({
    super.key,
    required this.title,
    required this.subtitle,
    this.note,
    this.extra = const [],
    this.actions = const [],
  });

  final String title;
  final String subtitle;
  final String? note;
  final List<Widget> extra;
  final List<MockAction> actions;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFF132238).withValues(alpha: 0.1),
        ),
      ),
      child: Stacked(
        gap: 6,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
          ),
          Text(
            subtitle,
            style: const TextStyle(
              color: Color(0xFF5F6B7A),
              fontSize: 12,
              height: 1.4,
            ),
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
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final action in actions)
                  MockButton(
                    action: MockAction(
                      action.label,
                      route: action.route,
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
    return MockupCard(
      child: Row(
        children: [
          Expanded(
            child: Stacked(
              gap: 4,
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
