import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'dynamic_ui_renderer.dart';
import 'phone_frame_wrapper.dart';

enum ComparisonMode { splitSlider, sideBySide, toggle }

class UiComparisonWidget extends StatefulWidget {
  final Uint8List? originalImageBytes;
  final Map<String, dynamic>? uiSpec;
  final String screenSummary;

  const UiComparisonWidget({
    super.key,
    required this.originalImageBytes,
    required this.uiSpec,
    required this.screenSummary,
  });

  @override
  State<UiComparisonWidget> createState() => _UiComparisonWidgetState();
}

class _UiComparisonWidgetState extends State<UiComparisonWidget> {
  ComparisonMode _mode = ComparisonMode.splitSlider;
  double _sliderPosition = 0.5; // 0.0 = all generated, 1.0 = all original
  bool _showOriginalInToggle = false;
  bool _wrapInPhoneMockup = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Control Bar
        _buildControlBar(),
        const SizedBox(height: 8),

        // Main Viewer
        Expanded(
          child: _buildComparisonContent(),
        ),
      ],
    );
  }

  Widget _buildControlBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.surfaceBorder.withOpacity(0.5)),
        ),
      ),
      child: Row(
        children: [
          // Mode Selector
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildModeChip(
                    mode: ComparisonMode.splitSlider,
                    label: 'Split Slider',
                    icon: Icons.splitscreen_rounded,
                  ),
                  const SizedBox(width: 8),
                  _buildModeChip(
                    mode: ComparisonMode.sideBySide,
                    label: 'Side-by-Side',
                    icon: Icons.view_column_rounded,
                  ),
                  const SizedBox(width: 8),
                  _buildModeChip(
                    mode: ComparisonMode.toggle,
                    label: 'Toggle View',
                    icon: Icons.swap_horiz_rounded,
                  ),
                ],
              ),
            ),
          ),

          // Phone Frame Toggle
          IconButton(
            tooltip: _wrapInPhoneMockup ? 'Disable Frame' : 'Enable Frame',
            icon: Icon(
              _wrapInPhoneMockup ? Icons.phone_android : Icons.crop_free,
              color: _wrapInPhoneMockup ? AppColors.primary : AppColors.textMuted,
              size: 20,
            ),
            onPressed: () {
              setState(() {
                _wrapInPhoneMockup = !_wrapInPhoneMockup;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildModeChip({
    required ComparisonMode mode,
    required String label,
    required IconData icon,
  }) {
    final isSelected = _mode == mode;
    return InkWell(
      onTap: () {
        setState(() {
          _mode = mode;
        });
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.surfaceBorder,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? AppColors.primaryLight : AppColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComparisonContent() {
    switch (_mode) {
      case ComparisonMode.splitSlider:
        return _buildSplitSliderView();
      case ComparisonMode.sideBySide:
        return _buildSideBySideView();
      case ComparisonMode.toggle:
        return _buildToggleView();
    }
  }

  // --- 1. Split Slider View ---
  Widget _buildSplitSliderView() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Generated UI (Bottom layer)
            PhoneFrameWrapper(
              showFrame: _wrapInPhoneMockup,
              child: DynamicUiRenderer(
                uiSpec: widget.uiSpec,
                fallbackSummary: widget.screenSummary,
              ),
            ),

            // Original Screenshot clipped by slider position
            if (widget.originalImageBytes != null)
              ClipRect(
                clipper: _HorizontalWipeClipper(_sliderPosition),
                child: PhoneFrameWrapper(
                  showFrame: _wrapInPhoneMockup,
                  child: Image.memory(
                    widget.originalImageBytes!,
                    fit: BoxFit.contain,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              ),

            // Vertical Divider & Drag Handle
            Positioned(
              left: constraints.maxWidth * _sliderPosition - 16,
              top: 0,
              bottom: 0,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onHorizontalDragUpdate: (details) {
                  setState(() {
                    _sliderPosition += details.delta.dx / constraints.maxWidth;
                    _sliderPosition = _sliderPosition.clamp(0.05, 0.95);
                  });
                },
                child: SizedBox(
                  width: 32,
                  child: Center(
                    child: Container(
                      width: 28,
                      height: 52,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.35),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.drag_indicator,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Legend indicators
            Positioned(
              bottom: 16,
              left: 20,
              child: _buildBadge('Original Screenshot', Colors.black.withOpacity(0.75)),
            ),
            Positioned(
              bottom: 16,
              right: 20,
              child: _buildBadge('Generated Flutter UI', AppColors.primary.withOpacity(0.85)),
            ),
          ],
        );
      },
    );
  }

  // --- 2. Side-by-Side View ---
  Widget _buildSideBySideView() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 700;

        final originalWidget = Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: _buildBadge('1. Original Screenshot', AppColors.surfaceLight),
            ),
            Expanded(
              child: widget.originalImageBytes != null
                  ? PhoneFrameWrapper(
                      showFrame: _wrapInPhoneMockup,
                      child: Image.memory(
                        widget.originalImageBytes!,
                        fit: BoxFit.contain,
                      ),
                    )
                  : const Center(child: Text('No original screenshot available')),
            ),
          ],
        );

        final generatedWidget = Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: _buildBadge('2. Generated Flutter UI', AppColors.primary),
            ),
            Expanded(
              child: PhoneFrameWrapper(
                showFrame: _wrapInPhoneMockup,
                child: DynamicUiRenderer(
                  uiSpec: widget.uiSpec,
                  fallbackSummary: widget.screenSummary,
                ),
              ),
            ),
          ],
        );

        if (isWide) {
          return Row(
            children: [
              Expanded(child: originalWidget),
              const VerticalDivider(width: 1),
              Expanded(child: generatedWidget),
            ],
          );
        } else {
          return PageView(
            children: [originalWidget, generatedWidget],
          );
        }
      },
    );
  }

  // --- 3. Toggle View ---
  Widget _buildToggleView() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: SegmentedButton<bool>(
            segments: const [
              ButtonSegment<bool>(
                value: true,
                label: Text('Original Screenshot'),
                icon: Icon(Icons.image_outlined, size: 16),
              ),
              ButtonSegment<bool>(
                value: false,
                label: Text('Generated Flutter UI'),
                icon: Icon(Icons.flutter_dash, size: 16),
              ),
            ],
            selected: {_showOriginalInToggle},
            onSelectionChanged: (newSelection) {
              setState(() {
                _showOriginalInToggle = newSelection.first;
              });
            },
          ),
        ),
        Expanded(
          child: PhoneFrameWrapper(
            showFrame: _wrapInPhoneMockup,
            child: _showOriginalInToggle
                ? (widget.originalImageBytes != null
                    ? Image.memory(widget.originalImageBytes!, fit: BoxFit.contain)
                    : const Center(child: Text('No original screenshot')))
                : DynamicUiRenderer(
                    uiSpec: widget.uiSpec,
                    fallbackSummary: widget.screenSummary,
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white24, width: 0.8),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _HorizontalWipeClipper extends CustomClipper<Rect> {
  final double fraction;

  _HorizontalWipeClipper(this.fraction);

  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, size.width * fraction, size.height);
  }

  @override
  bool shouldReclip(covariant _HorizontalWipeClipper oldClipper) {
    return oldClipper.fraction != fraction;
  }
}
