import 'package:flutter/material.dart';
import 'package:snacktoast/snacktoast.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Entry point
// ─────────────────────────────────────────────────────────────────────────────

void main() {
  SnackToastKit.configure(
    const SnackToastConfig(
      defaultPosition: SnackToastPosition.bottom,
      visualStyle: SnackToastVisualStyle.gradient,
      animationStyle: SnackToastAnimation.bounceUp,
      showProgressBar: true,
      enableSwipeToDismiss: true,
      animateIcon: true,
      glassBlurIntensity: 20.0,
      // Default sizing: wrap content
      wrapContent: true,
    ),
  );
  runApp(const ExampleApp());
}

// ─────────────────────────────────────────────────────────────────────────────
// App shell
// ─────────────────────────────────────────────────────────────────────────────

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SnackToast Demo',
      debugShowCheckedModeBanner: false,
      navigatorKey: SnackToastKit.navigatorKey,
      scaffoldMessengerKey: SnackToastKit.scaffoldMessengerKey,
      theme: _buildTheme(),
      home: const ExamplePage(),
    );
  }

  ThemeData _buildTheme() => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: _C.bg,
    colorScheme: ColorScheme.dark(primary: _C.accent, surface: _C.surface),
    appBarTheme: const AppBarTheme(
      backgroundColor: _C.bgElevated,
      foregroundColor: _C.textPrimary,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontFamily: 'monospace',
        color: _C.textPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.2,
      ),
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Design tokens
// ─────────────────────────────────────────────────────────────────────────────

abstract final class _C {
  static const bg = Color(0xFF080B14);
  static const bgElevated = Color(0xFF0E1220);
  static const surface = Color(0xFF141827);
  static const surfaceHi = Color(0xFF1C2235);
  static const border = Color(0xFF252D44);
  static const accent = Color(0xFF6C63FF);
  static const accentSoft = Color(0xFF3D3778);
  static const textPrimary = Color(0xFFF0F2FF);
  static const textSecondary = Color(0xFF8891B0);
  static const textMuted = Color(0xFF4A5270);
  static const success = Color(0xFF1B8A4A);
  static const error = Color(0xFFD32F2F);
  static const warning = Color(0xFFE65100);
  static const info = Color(0xFF0277BD);
}

// ─────────────────────────────────────────────────────────────────────────────
// ExamplePage
// ─────────────────────────────────────────────────────────────────────────────

class ExamplePage extends StatefulWidget {
  const ExamplePage({super.key});

  @override
  State<ExamplePage> createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  // ── Live config state ─────────────────────────────────────────────────────
  SnackToastVisualStyle _visualStyle = SnackToastVisualStyle.gradient;
  SnackToastType _activeType = SnackToastType.success;
  bool _showProgressBar = true;
  bool _enableSwipe = true;
  bool _animateIcon = true;

  // ── Sizing demo state ─────────────────────────────────────────────────────
  bool _wrapContent = true;
  double _fixedHeight = 72.0;
  double _fixedWidth = 320.0;

  void _syncConfig() {
    SnackToastKit.configure(
      SnackToastConfig(
        visualStyle: _visualStyle,
        showProgressBar: _showProgressBar,
        enableSwipeToDismiss: _enableSwipe,
        animateIcon: _animateIcon,
        glassBlurIntensity: 20.0,
        defaultPosition: SnackToastPosition.bottom,
        successColor: _C.success,
        errorColor: _C.error,
        warningColor: _C.warning,
        infoColor: _C.info,
        // Sizing is managed per-call in the sizing section demos.
        wrapContent: true,
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Build
  // ─────────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SNACKTOAST / DEMO'),
        actions: [
          TextButton.icon(
            onPressed: SnackToastKit.dismissAll,
            icon: const Icon(Icons.clear_all_rounded, size: 16),
            label: const Text('Clear'),
            style: TextButton.styleFrom(
              foregroundColor: _C.textSecondary,
              textStyle: const TextStyle(fontSize: 12),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 80),
        children: [
          _buildHero(),
          _buildConfigPanel(),
          _divider('NOTIFICATION TYPES'),
          _buildTypeSection(),
          _divider('VISUAL STYLES'),
          _buildVisualStyleSection(),
          _divider('ANIMATION FAMILIES'),
          _buildAnimFamilies(),
          _divider('COLOR & STYLE CUSTOMISATION'),
          _buildColorCustomisationSection(),
          _divider('SIZING CONTROL'),
          _buildSizingSection(),
          _divider('DECORATION OVERRIDE'),
          _buildDecorationOverrideSection(),
          _divider('SNACKBARS'),
          _buildSnackbarSection(),
          _divider('ADVANCED'),
          _buildAdvancedSection(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Hero
  // ─────────────────────────────────────────────────────────────────────────

  Widget _buildHero() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 20, 16, 4),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A1040), Color(0xFF0E1220)],
        ),
        border: Border.all(color: _C.accentSoft),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _C.accentSoft,
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(Icons.layers_rounded, color: _C.accent, size: 26),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SnackToast Kit',
                  style: TextStyle(
                    color: _C.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  '18 animations · 5 styles · live config',
                  style: TextStyle(color: _C.textSecondary, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Config panel
  // ─────────────────────────────────────────────────────────────────────────

  Widget _buildConfigPanel() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      decoration: BoxDecoration(
        color: _C.bgElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _C.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                const Icon(Icons.tune_rounded, size: 15, color: _C.accent),
                const SizedBox(width: 7),
                const Text(
                  'LIVE CONFIG',
                  style: TextStyle(
                    color: _C.accent,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.4,
                  ),
                ),
                const Spacer(),
                Text(
                  'affects all demos',
                  style: TextStyle(color: _C.textMuted, fontSize: 11),
                ),
              ],
            ),
          ),
          const Divider(color: _C.border, height: 1),
          // Visual style chips
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _cfgLabel('Visual Style'),
                const SizedBox(height: 7),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: SnackToastVisualStyle.values.map((s) {
                      final active = s == _visualStyle;
                      return Padding(
                        padding: const EdgeInsets.only(right: 7),
                        child: GestureDetector(
                          onTap: () {
                            setState(() => _visualStyle = s);
                            _syncConfig();
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 13,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: active ? _C.accentSoft : _C.surface,
                              borderRadius: BorderRadius.circular(7),
                              border: Border.all(
                                color: active ? _C.accent : _C.border,
                              ),
                            ),
                            child: Text(
                              s.name,
                              style: TextStyle(
                                color: active ? _C.accent : _C.textSecondary,
                                fontSize: 11.5,
                                fontWeight: active
                                    ? FontWeight.w700
                                    : FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          // Toggles
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 14),
            child: Row(
              children: [
                _cfgToggle('Progress Bar', _showProgressBar, (v) {
                  setState(() => _showProgressBar = v);
                  _syncConfig();
                }),
                const SizedBox(width: 7),
                _cfgToggle('Swipe Dismiss', _enableSwipe, (v) {
                  setState(() => _enableSwipe = v);
                  _syncConfig();
                }),
                const SizedBox(width: 7),
                _cfgToggle('Icon Anim', _animateIcon, (v) {
                  setState(() => _animateIcon = v);
                  _syncConfig();
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Notification types
  // ─────────────────────────────────────────────────────────────────────────

  Widget _buildTypeSection() {
    final types = [
      (
        SnackToastType.success,
        'Success',
        _C.success,
        Icons.check_circle_rounded,
        'Profile saved!',
      ),
      (
        SnackToastType.error,
        'Error',
        _C.error,
        Icons.error_rounded,
        'Failed to save',
      ),
      (
        SnackToastType.warning,
        'Warning',
        _C.warning,
        Icons.warning_rounded,
        'Low battery!',
      ),
      (SnackToastType.info, 'Info', _C.info, Icons.info_rounded, 'New message'),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: types.map((t) {
              final (type, label, color, icon, _) = t;
              final active = type == _activeType;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: GestureDetector(
                    onTap: () => setState(() => _activeType = type),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: active
                            ? color.withValues(alpha: 0.16)
                            : _C.surface,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: active ? color : _C.border,
                          width: active ? 1.5 : 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            icon,
                            color: active ? color : _C.textMuted,
                            size: 19,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            label,
                            style: TextStyle(
                              color: active ? color : _C.textSecondary,
                              fontSize: 11,
                              fontWeight: active
                                  ? FontWeight.w700
                                  : FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
          _fullBtn(
            label: 'Fire ${_activeType.name.toUpperCase()} toast',
            icon: Icons.send_rounded,
            color: _typeColor(_activeType),
            onTap: () => SnackToastKit.toast(
              _typeMessage(_activeType),
              type: _activeType,
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Visual styles preview
  // ─────────────────────────────────────────────────────────────────────────

  Widget _buildVisualStyleSection() {
    final styles = [
      (
        SnackToastVisualStyle.standard,
        'Standard',
        Icons.layers_rounded,
        'Opaque gradient card',
      ),
      (
        SnackToastVisualStyle.glass,
        'Glass',
        Icons.blur_on_rounded,
        'Frosted blur',
      ),
      (
        SnackToastVisualStyle.gradient,
        'Gradient',
        Icons.gradient_rounded,
        'Rich 3-stop gradient',
      ),
      (
        SnackToastVisualStyle.minimal,
        'Minimal',
        Icons.view_sidebar_rounded,
        'White + accent bar',
      ),
      (
        SnackToastVisualStyle.outlined,
        'Outlined',
        Icons.border_outer_rounded,
        'Transparent + border',
      ),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: styles.map((s) {
          final (style, label, icon, desc) = s;
          return Padding(
            padding: const EdgeInsets.only(bottom: 7),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => SnackToastKit.toast(
                '$label style preview',
                title: desc,
                type: _activeType,
                visualStyle: style,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 11,
                ),
                decoration: BoxDecoration(
                  color: _C.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _C.border),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: _C.surfaceHi,
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: Icon(icon, color: _C.accent, size: 17),
                    ),
                    const SizedBox(width: 11),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            label,
                            style: const TextStyle(
                              color: _C.textPrimary,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            desc,
                            style: const TextStyle(
                              color: _C.textSecondary,
                              fontSize: 11.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _C.accentSoft,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'PREVIEW',
                        style: TextStyle(
                          color: _C.accent,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Animation families
  // ─────────────────────────────────────────────────────────────────────────

  Widget _buildAnimFamilies() {
    return Column(
      children: [
        _animFamily(
          icon: Icons.swap_vert_rounded,
          label: 'Vertical Origin',
          sublabel: 'Y-axis translate + opacity',
          color: const Color(0xFF6C63FF),
          items: [
            (
              'slideUp',
              'Slide Up',
              () => SnackToastKit.toast(
                'Sliding up!',
                animationStyle: SnackToastAnimation.slideUp,
              ),
            ),
            (
              'slideDown',
              'Slide Down',
              () => SnackToastKit.toast(
                'Sliding down!',
                animationStyle: SnackToastAnimation.slideDown,
                position: SnackToastPosition.top,
              ),
            ),
            (
              'fadeDrop',
              'Fade Drop',
              () => SnackToastKit.toast(
                'Dropping in!',
                animationStyle: SnackToastAnimation.fadeDrop,
                position: SnackToastPosition.top,
              ),
            ),
            (
              'fadeRise',
              'Fade Rise',
              () => SnackToastKit.toast(
                'Rising up!',
                animationStyle: SnackToastAnimation.fadeRise,
              ),
            ),
            (
              'bounceUp',
              'Bounce Up',
              () => SnackToastKit.toast(
                'Bounced!',
                animationStyle: SnackToastAnimation.bounceUp,
              ),
            ),
          ],
        ),
        _animFamily(
          icon: Icons.swap_horiz_rounded,
          label: 'Horizontal Edge Slides',
          sublabel: 'X-axis entry from screen edges',
          color: const Color(0xFF00BFA5),
          items: [
            (
              'slideLeft',
              'Slide Left',
              () => SnackToastKit.toast(
                'From the right!',
                animationStyle: SnackToastAnimation.slideLeft,
              ),
            ),
            (
              'slideRight',
              'Slide Right',
              () => SnackToastKit.toast(
                'From the left!',
                animationStyle: SnackToastAnimation.slideRight,
              ),
            ),
            (
              'slideFromLeft',
              'From Left Edge',
              () => SnackToastKit.toast(
                'Off-screen left!',
                animationStyle: SnackToastAnimation.slideFromLeft,
              ),
            ),
            (
              'slideFromRight',
              'From Right Edge',
              () => SnackToastKit.toast(
                'Off-screen right!',
                animationStyle: SnackToastAnimation.slideFromRight,
              ),
            ),
          ],
        ),
        _animFamily(
          icon: Icons.open_with_rounded,
          label: 'Corner Sweeps',
          sublabel: 'Diagonal origin → axis center',
          color: const Color(0xFFFF6B6B),
          items: [
            (
              'topLeftSweep',
              'Top Left',
              () => SnackToastKit.toast(
                'Top-left!',
                animationStyle: SnackToastAnimation.topLeftSweep,
                position: SnackToastPosition.top,
              ),
            ),
            (
              'topRightSweep',
              'Top Right',
              () => SnackToastKit.toast(
                'Top-right!',
                animationStyle: SnackToastAnimation.topRightSweep,
                position: SnackToastPosition.top,
              ),
            ),
            (
              'bottomLeftSweep',
              'Bottom Left',
              () => SnackToastKit.toast(
                'Bottom-left!',
                animationStyle: SnackToastAnimation.bottomLeftSweep,
              ),
            ),
            (
              'bottomRightSweep',
              'Bottom Right',
              () => SnackToastKit.toast(
                'Bottom-right!',
                animationStyle: SnackToastAnimation.bottomRightSweep,
              ),
            ),
          ],
        ),
        _animFamily(
          icon: Icons.auto_awesome_rounded,
          label: 'Physics & Atmospheric',
          sublabel: 'Spring, blur, flip & radial ring',
          color: const Color(0xFFFFB300),
          items: [
            (
              'scaleSpring',
              'Scale Spring',
              () => SnackToastKit.toast(
                'Spring!',
                animationStyle: SnackToastAnimation.scaleSpring,
                position: SnackToastPosition.center,
              ),
            ),
            (
              'fade',
              'Fade',
              () => SnackToastKit.toast(
                'Fading...',
                animationStyle: SnackToastAnimation.fade,
              ),
            ),
            (
              'centerPop',
              'Center Pop',
              () => SnackToastKit.toast(
                'Focus pop!',
                animationStyle: SnackToastAnimation.centerPop,
                position: SnackToastPosition.center,
              ),
            ),
            (
              'flipReveal',
              'Flip Reveal',
              () => SnackToastKit.toast(
                'Flipped!',
                animationStyle: SnackToastAnimation.flipReveal,
                position: SnackToastPosition.center,
              ),
            ),
            (
              'radialExpansion',
              'Radial Expansion',
              () => SnackToastKit.toast(
                'Expanding!',
                animationStyle: SnackToastAnimation.radialExpansion,
                position: SnackToastPosition.center,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _animFamily({
    required IconData icon,
    required String label,
    required String sublabel,
    required Color color,
    required List<(String, String, VoidCallback)> items,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 15),
              ),
              const SizedBox(width: 9),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      color: _C.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    sublabel,
                    style: const TextStyle(
                      color: _C.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 9),
          Wrap(
            spacing: 7,
            runSpacing: 7,
            children: items.map((item) {
              final (enumName, btnLabel, onTap) = item;
              return GestureDetector(
                onTap: onTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 11,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: _C.surface,
                    borderRadius: BorderRadius.circular(9),
                    border: Border.all(color: _C.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        btnLabel,
                        style: const TextStyle(
                          color: _C.textPrimary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '.$enumName',
                        style: TextStyle(
                          color: color.withValues(alpha: 0.8),
                          fontSize: 10,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // ── NEW: Color & Style Customisation ────────────────────────────────────
  // ─────────────────────────────────────────────────────────────────────────

  Widget _buildColorCustomisationSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionNote(
            'Text and background colors can be customised globally via '
            'SnackToastConfig or per-notification via toast() parameters. '
            'Role-specific colors (titleColor, messageColor) let you style '
            'title and body independently.',
          ),
          const SizedBox(height: 12),

          // 1. Custom background + foreground
          _fullBtn(
            label: 'Custom Background + Foreground Colors',
            icon: Icons.color_lens_rounded,
            color: const Color(0xFF9C27B0),
            onTap: () => SnackToastKit.toast(
              'Both colors overridden per-call.',
              title: 'Custom Colors',
              type: SnackToastType.custom,
              backgroundColor: const Color(0xFF1A0033),
              foregroundColor: const Color(0xFFE040FB),
              animationStyle: SnackToastAnimation.scaleSpring,
              position: SnackToastPosition.center,
            ),
          ),
          const SizedBox(height: 8),

          // 2. Role-specific colors (title vs message different colors)
          _fullBtn(
            label: 'Independent Title & Message Colors',
            icon: Icons.text_fields_rounded,
            color: const Color(0xFF00BFA5),
            onTap: () => SnackToastKit.toast(
              'This message is in amber — different from the title.',
              title: 'Teal Title',
              type: SnackToastType.info,
              // Title in white, message in amber — fully independent
              titleColor: Colors.white,
              messageColor: Colors.amber.shade300,
              visualStyle: SnackToastVisualStyle.standard,
            ),
          ),
          const SizedBox(height: 8),

          // 3. Custom TextStyle per role
          _fullBtn(
            label: 'Custom TextStyle Per Role',
            icon: Icons.format_size_rounded,
            color: const Color(0xFFFF6B6B),
            onTap: () => SnackToastKit.toast(
              'Message in italic 14px with wide letter spacing.',
              title: 'Bold 16px Title',
              type: SnackToastType.warning,
              // Completely custom typography per role
              titleStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              ),
              messageStyle: const TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                letterSpacing: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 8),

          // 4. Global config with role-specific colors
          _fullBtn(
            label: 'Global Config: titleColor + messageColor',
            icon: Icons.settings_rounded,
            color: _C.accent,
            onTap: () {
              // Temporarily configure role-specific colors globally,
              // then restore after 6 seconds.
              SnackToastKit.configure(
                SnackToastKit.config.copyWith(
                  titleColor: Colors.yellow.shade200,
                  messageColor: Colors.white70,
                ),
              );
              SnackToastKit.toast(
                'Message in white70 — set globally via SnackToastConfig.',
                title: 'Yellow Title',
                type: SnackToastType.success,
                duration: const Duration(seconds: 4),
                onDismissed: _syncConfig, // restore on dismiss
              );
            },
          ),
          const SizedBox(height: 8),

          // 5. Snackbar with role-specific colors
          _fullBtn(
            label: 'Snackbar with Role-Specific Colors',
            icon: Icons.call_to_action_rounded,
            color: _C.info,
            onTap: () => SnackToastKit.snackbar(
              'Syncing data in the background.',
              title: 'Sync Active',
              type: SnackToastType.info,
              // Per-call snackbar color overrides
              titleColor: Colors.lightBlue.shade100,
              messageColor: Colors.white60,
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // ── NEW: Sizing Control ──────────────────────────────────────────────────
  // ─────────────────────────────────────────────────────────────────────────

  Widget _buildSizingSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionNote(
            'By default wrapContent=true — height fits content automatically. '
            'Set wrapContent=false and provide fixedHeight/fixedWidth for '
            'uniform fixed-size notifications.',
          ),
          const SizedBox(height: 12),

          // wrapContent toggle
          Row(
            children: [
              const Text(
                'wrapContent:',
                style: TextStyle(color: _C.textSecondary, fontSize: 13),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () => setState(() => _wrapContent = !_wrapContent),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _wrapContent ? _C.accentSoft : _C.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _wrapContent ? _C.accent : _C.border,
                    ),
                  ),
                  child: Text(
                    _wrapContent ? 'true  (default)' : 'false',
                    style: TextStyle(
                      color: _wrapContent ? _C.accent : _C.textSecondary,
                      fontSize: 12,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Fixed size sliders — visible only when wrapContent=false
          if (!_wrapContent) ...[
            const SizedBox(height: 12),
            _sliderRow('fixedHeight', _fixedHeight, 48, 120, (v) {
              setState(() => _fixedHeight = v);
            }),
            const SizedBox(height: 6),
            _sliderRow('fixedWidth', _fixedWidth, 180, 400, (v) {
              setState(() => _fixedWidth = v);
            }),
          ],

          const SizedBox(height: 12),

          // Fire with current sizing settings
          _fullBtn(
            label: _wrapContent
                ? 'Fire Wrap-Content Toast (default)'
                : 'Fire Fixed ${_fixedHeight.round()}×${_fixedWidth.round()} Toast',
            icon: Icons.straighten_rounded,
            color: const Color(0xFF00BFA5),
            onTap: () => SnackToastKit.toast(
              _wrapContent
                  ? 'Height wraps to fit this content automatically.'
                  : 'Fixed size: ${_fixedHeight.round()}px × ${_fixedWidth.round()}px',
              title: _wrapContent ? 'Wrap Content' : 'Fixed Size',
              type: SnackToastType.info,
              wrapContent: _wrapContent,
              fixedHeight: _wrapContent ? null : _fixedHeight,
              fixedWidth: _wrapContent ? null : _fixedWidth,
            ),
          ),
          const SizedBox(height: 8),

          // minWidth demo
          _fullBtn(
            label: 'Min Width (prevents narrow cards)',
            icon: Icons.width_normal_rounded,
            color: const Color(0xFFFFB300),
            onTap: () => SnackToastKit.toast(
              'OK',
              type: SnackToastType.success,
              // Without minWidth, a 2-char message would produce a tiny card.
              minWidth: 220.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sliderRow(
    String label,
    double value,
    double min,
    double max,
    ValueChanged<double> onChange,
  ) {
    return Row(
      children: [
        SizedBox(
          width: 90,
          child: Text(
            '$label:',
            style: const TextStyle(
              color: _C.textSecondary,
              fontSize: 12,
              fontFamily: 'monospace',
            ),
          ),
        ),
        Expanded(
          child: Slider(
            value: value,
            min: min,
            max: max,
            activeColor: _C.accent,
            inactiveColor: _C.border,
            onChanged: onChange,
          ),
        ),
        Text(
          '${value.round()}px',
          style: const TextStyle(
            color: _C.textMuted,
            fontSize: 11,
            fontFamily: 'monospace',
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // ── NEW: Decoration Override ─────────────────────────────────────────────
  // ─────────────────────────────────────────────────────────────────────────

  Widget _buildDecorationOverrideSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionNote(
            'decorationOverride replaces the computed BoxDecoration entirely, '
            'giving you full control over gradients, borders, images, and '
            'shapes — while the icon, text, and progress bar are still rendered '
            'inside automatically.',
          ),
          const SizedBox(height: 12),

          // Neon border override
          _fullBtn(
            label: 'Neon Border + Dark Background',
            icon: Icons.auto_fix_high_rounded,
            color: const Color(0xFF00E5FF),
            onTap: () => SnackToastKit.toast(
              'Custom BoxDecoration — full control.',
              title: 'Decoration Override',
              type: SnackToastType.info,
              decorationOverride: BoxDecoration(
                color: const Color(0xFF001020),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF00E5FF), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00E5FF).withValues(alpha: 0.35),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              foregroundColor: const Color(0xFF00E5FF),
            ),
          ),
          const SizedBox(height: 8),

          // Purple-to-pink gradient override
          _fullBtn(
            label: 'Custom Gradient Override',
            icon: Icons.gradient_rounded,
            color: const Color(0xFFFF4081),
            onTap: () => SnackToastKit.toast(
              'Gradient defined entirely by decorationOverride.',
              title: 'Custom Gradient',
              type: SnackToastType.success,
              decorationOverride: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF6A0DAD),
                    Color(0xFFFF4081),
                    Color(0xFFFF6E40),
                  ],
                  stops: [0.0, 0.55, 1.0],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF4081).withValues(alpha: 0.40),
                    blurRadius: 28,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Snackbars
  // ─────────────────────────────────────────────────────────────────────────

  Widget _buildSnackbarSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              _typeBtn(
                'Success',
                _C.success,
                () => SnackToastKit.snackbarSuccess('Upload complete!'),
              ),
              const SizedBox(width: 7),
              _typeBtn(
                'Error',
                _C.error,
                () => SnackToastKit.snackbarError('Connection lost'),
              ),
              const SizedBox(width: 7),
              _typeBtn(
                'Warning',
                _C.warning,
                () => SnackToastKit.snackbarWarning('Storage full'),
              ),
              const SizedBox(width: 7),
              _typeBtn(
                'Info',
                _C.info,
                () => SnackToastKit.snackbarInfo('Update available'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _fullBtn(
            label: 'Undo Action Snackbar',
            icon: Icons.undo_rounded,
            color: _C.accent,
            onTap: () => SnackToastKit.snackbar(
              'File deleted permanently.',
              title: 'Deleted',
              type: SnackToastType.warning,
              action: SnackBarAction(
                label: 'UNDO',
                textColor: Colors.amber,
                onPressed: () => SnackToastKit.success('File restored!'),
              ),
            ),
          ),
          const SizedBox(height: 8),
          _fullBtn(
            label: 'Minimal Style Snackbar',
            icon: Icons.view_sidebar_rounded,
            color: _C.textSecondary,
            onTap: () => SnackToastKit.snackbar(
              'Syncing in the background.',
              title: 'Sync',
              type: SnackToastType.info,
              visualStyle: SnackToastVisualStyle.minimal,
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Advanced
  // ─────────────────────────────────────────────────────────────────────────

  Widget _buildAdvancedSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _fullBtn(
            label: 'Custom Widget Toast',
            icon: Icons.widgets_rounded,
            color: const Color(0xFF9C27B0),
            onTap: _showCustomWidgetToast,
          ),
          const SizedBox(height: 8),
          _fullBtn(
            label: 'Queued Burst (5 toasts)',
            icon: Icons.queue_rounded,
            color: const Color(0xFF00BFA5),
            onTap: _showQueuedBurst,
          ),
          const SizedBox(height: 8),
          _fullBtn(
            label: 'Instant Unqueued Toast',
            icon: Icons.flash_on_rounded,
            color: const Color(0xFFFFB300),
            onTap: () => SnackToastKit.toast(
              'Bypasses queue — displayed immediately.',
              type: SnackToastType.warning,
              queued: false,
              animationStyle: SnackToastAnimation.flipReveal,
              position: SnackToastPosition.center,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: SnackToastKit.dismissAll,
              icon: const Icon(Icons.clear_all_rounded, size: 18),
              label: const Text('Dismiss All Notifications'),
              style: OutlinedButton.styleFrom(
                foregroundColor: _C.textSecondary,
                side: const BorderSide(color: _C.border),
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Advanced callbacks
  // ─────────────────────────────────────────────────────────────────────────

  void _showCustomWidgetToast() {
    SnackToastKit.toast(
      '',
      position: SnackToastPosition.bottom,
      customWidget: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 48),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF6C63FF), Color(0xFF9C27B0)],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6C63FF).withValues(alpha: 0.45),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.star_rounded,
                color: Colors.amber,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Level Up!',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'You reached Level 10!',
                    style: TextStyle(color: Colors.white70, fontSize: 12.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showQueuedBurst() {
    const messages = [
      ('Step 1 complete', SnackToastType.success),
      ('Step 2 complete', SnackToastType.success),
      ('Step 3 complete', SnackToastType.success),
      ('Warning on step 4', SnackToastType.warning),
      ('All steps done!', SnackToastType.info),
    ];
    for (final (msg, type) in messages) {
      SnackToastKit.toast(msg, type: type, queued: true);
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Reusable widgets / helpers
  // ─────────────────────────────────────────────────────────────────────────

  Widget _divider(String label) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: _C.textMuted,
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.6,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(child: Divider(color: _C.border, height: 1)),
        ],
      ),
    );
  }

  Widget _fullBtn({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 15),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: color.withValues(alpha: 0.12),
          foregroundColor: color,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 13),
          textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: color.withValues(alpha: 0.3)),
          ),
        ),
      ),
    );
  }

  Widget _typeBtn(String label, Color color, VoidCallback onTap) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color.withValues(alpha: 0.12),
          foregroundColor: color,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 11),
          textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: color.withValues(alpha: 0.3)),
          ),
        ),
        child: Text(label),
      ),
    );
  }

  Widget _cfgLabel(String text) => Text(
    text,
    style: const TextStyle(
      color: _C.textSecondary,
      fontSize: 11,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.8,
    ),
  );

  Widget _cfgToggle(String label, bool value, ValueChanged<bool> onChange) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onChange(!value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: value ? _C.accentSoft : _C.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: value ? _C.accent : _C.border),
          ),
          child: Column(
            children: [
              Icon(
                value ? Icons.toggle_on_rounded : Icons.toggle_off_rounded,
                color: value ? _C.accent : _C.textMuted,
                size: 18,
              ),
              const SizedBox(height: 3),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: value ? _C.accent : _C.textSecondary,
                  fontSize: 10.5,
                  fontWeight: value ? FontWeight.w700 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionNote(String text) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _C.accentSoft.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _C.accentSoft),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: _C.textSecondary,
          fontSize: 12,
          height: 1.5,
        ),
      ),
    );
  }

  Color _typeColor(SnackToastType type) => switch (type) {
    SnackToastType.success => _C.success,
    SnackToastType.error => _C.error,
    SnackToastType.warning => _C.warning,
    SnackToastType.info => _C.info,
    SnackToastType.custom => _C.accent,
  };

  String _typeMessage(SnackToastType type) => switch (type) {
    SnackToastType.success => 'Profile saved successfully!',
    SnackToastType.error => 'Failed to save. Check your connection.',
    SnackToastType.warning => 'Low battery — plug in soon.',
    SnackToastType.info => 'New message received.',
    SnackToastType.custom => 'Custom notification.',
  };
}
