import 'package:flutter/material.dart';
import '../../../../core/theme/app_typography.dart';

class DynamicUiRenderer extends StatelessWidget {
  final Map<String, dynamic>? uiSpec;
  final String fallbackSummary;

  const DynamicUiRenderer({
    super.key,
    required this.uiSpec,
    this.fallbackSummary = 'Rendered Screen',
  });

  @override
  Widget build(BuildContext context) {
    if (uiSpec == null || uiSpec!.isEmpty) {
      return _buildEmptySpecPlaceholder();
    }

    try {
      final type = uiSpec!['type']?.toString().toLowerCase() ?? 'scaffold';
      if (type == 'scaffold') {
        return _buildScaffold(uiSpec!);
      }
      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: _buildWidget(uiSpec!),
          ),
        ),
      );
    } catch (e) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Unable to render visual UI tree: $e',
            style: const TextStyle(color: Colors.redAccent),
          ),
        ),
      );
    }
  }

  Widget _buildEmptySpecPlaceholder() {
    return Container(
      color: const Color(0xFFF8FAFC),
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.phone_android, size: 54, color: Color(0xFF94A3B8)),
            const SizedBox(height: 16),
            Text(
              fallbackSummary,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF334155),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Interactive preview synthesized from Flutter specifications.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScaffold(Map<String, dynamic> spec) {
    final bgColorHex = spec['backgroundColor']?.toString();
    final bgColor = _parseColor(bgColorHex, Colors.white);

    PreferredSizeWidget? appBarWidget;
    final appBarData = spec['appBar'];
    if (appBarData is Map<String, dynamic>) {
      final title = appBarData['title']?.toString() ?? '';
      final appBgColor = _parseColor(
        appBarData['backgroundColor']?.toString(),
        const Color(0xFF6366F1),
      );
      final fgColor = _parseColor(
        appBarData['foregroundColor']?.toString(),
        Colors.white,
      );
      final showBack = appBarData['showBackButton'] == true;

      appBarWidget = AppBar(
        title: Text(
          title,
          style: TextStyle(
            color: fgColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: appBgColor,
        elevation: 0.5,
        leading: showBack
            ? IconButton(
                icon: Icon(Icons.arrow_back, color: fgColor),
                onPressed: () {},
              )
            : null,
      );
    }

    final bodyData = spec['body'];

    return Scaffold(
      backgroundColor: bgColor,
      appBar: appBarWidget,
      body: SafeArea(
        child: bodyData is Map<String, dynamic>
            ? SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: _parseEdgeInsets(bodyData['padding'] ?? 16.0),
                child: _buildWidget(bodyData),
              )
            : const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildWidget(Map<String, dynamic> data) {
    final type = data['type']?.toString().toLowerCase() ?? 'container';

    switch (type) {
      case 'column':
        return _buildColumn(data);
      case 'row':
        return _buildRow(data);
      case 'text':
        return _buildText(data);
      case 'button':
      case 'elevatedbutton':
        return _buildButton(data);
      case 'outlinedbutton':
        return _buildOutlinedButton(data);
      case 'textfield':
      case 'input':
        return _buildTextField(data);
      case 'card':
      case 'container':
        return _buildContainer(data);
      case 'spacing':
      case 'sizedbox':
        return _buildSpacing(data);
      case 'icon':
        return _buildIcon(data);
      case 'avatar':
      case 'circleavatar':
        return _buildAvatar(data);
      case 'imageplaceholder':
      case 'image':
        return _buildImagePlaceholder(data);
      case 'badge':
      case 'chip':
        return _buildChip(data);
      case 'divider':
        return _buildDivider(data);
      case 'listtile':
        return _buildListTile(data);
      case 'switch':
        return _buildSwitch(data);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildColumn(Map<String, dynamic> data) {
    final childrenRaw = data['children'];
    final children = <Widget>[];

    if (childrenRaw is List) {
      for (final item in childrenRaw) {
        if (item is Map<String, dynamic>) {
          children.add(_buildWidget(item));
        }
      }
    }

    final crossAlign = _parseCrossAxisAlignment(data['crossAxisAlignment']);
    final mainAlign = _parseMainAxisAlignment(data['mainAxisAlignment']);

    Widget col = Column(
      mainAxisAlignment: mainAlign,
      crossAxisAlignment: crossAlign,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );

    if (data['padding'] != null) {
      col = Padding(
        padding: _parseEdgeInsets(data['padding']),
        child: col,
      );
    }

    return col;
  }

  Widget _buildRow(Map<String, dynamic> data) {
    final childrenRaw = data['children'];
    final children = <Widget>[];

    if (childrenRaw is List) {
      for (final item in childrenRaw) {
        if (item is Map<String, dynamic>) {
          final isExpanded = item['expanded'] == true;
          final built = _buildWidget(item);
          children.add(isExpanded ? Expanded(child: built) : built);
        }
      }
    }

    final crossAlign = _parseCrossAxisAlignment(data['crossAxisAlignment']);
    final mainAlign = _parseMainAxisAlignment(data['mainAxisAlignment']);

    return Row(
      mainAxisAlignment: mainAlign,
      crossAxisAlignment: crossAlign,
      children: children,
    );
  }

  Widget _buildText(Map<String, dynamic> data) {
    final text = data['text']?.toString() ?? '';
    final fontSize = _parseDouble(data['fontSize'] ?? data['font_size'], 14.0);
    final fontWeight = _parseFontWeight(data['fontWeight'] ?? data['font_weight']);
    final color = _parseColor(data['color']?.toString(), const Color(0xFF1E293B));
    final textAlign = _parseTextAlign(data['textAlign']);

    return Text(
      text,
      textAlign: textAlign,
      style: AppTypography.font(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        height: 1.3,
      ),
    );
  }

  Widget _buildButton(Map<String, dynamic> data) {
    final text = data['text']?.toString() ?? 'Action';
    final bgColor = _parseColor(
      data['backgroundColor']?.toString() ?? data['color']?.toString(),
      const Color(0xFF6366F1),
    );
    final textColor = _parseColor(
      data['textColor']?.toString(),
      Colors.white,
    );
    final iconName = data['icon']?.toString();

    final buttonChild = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (iconName != null) ...[
          Icon(_getIconData(iconName), size: 18, color: textColor),
          const SizedBox(width: 8),
        ],
        Text(
          text,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ],
    );

    return SizedBox(
      width: data['fullWidth'] == true ? double.infinity : null,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: textColor,
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              _parseDouble(data['borderRadius'], 12.0),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
        onPressed: () {},
        child: buttonChild,
      ),
    );
  }

  Widget _buildOutlinedButton(Map<String, dynamic> data) {
    final text = data['text']?.toString() ?? 'Button';
    final borderColor = _parseColor(
      data['borderColor']?.toString(),
      const Color(0xFF6366F1),
    );
    final textColor = _parseColor(
      data['textColor']?.toString(),
      borderColor,
    );

    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        foregroundColor: textColor,
        side: BorderSide(color: borderColor, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            _parseDouble(data['borderRadius'], 12.0),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      ),
      onPressed: () {},
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildTextField(Map<String, dynamic> data) {
    final hint = data['hintText']?.toString() ?? data['label']?.toString() ?? '';
    final iconName = data['icon']?.toString() ?? data['prefixIcon']?.toString();
    final isObscure = data['obscureText'] == true;

    return TextField(
      enabled: false,
      obscureText: isObscure,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
        prefixIcon: iconName != null
            ? Icon(_getIconData(iconName), color: const Color(0xFF64748B), size: 20)
            : null,
        filled: true,
        fillColor: const Color(0xFFF1F5F9),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            _parseDouble(data['borderRadius'], 12.0),
          ),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            _parseDouble(data['borderRadius'], 12.0),
          ),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
      ),
    );
  }

  Widget _buildContainer(Map<String, dynamic> data) {
    final bgColor = _parseColor(
      data['backgroundColor']?.toString() ?? data['color']?.toString(),
      Colors.white,
    );
    final borderColor = _parseColor(
      data['borderColor']?.toString(),
      const Color(0xFFE2E8F0),
    );
    final borderRadius = _parseDouble(data['borderRadius'], 14.0);

    Widget? childWidget;
    if (data['child'] is Map<String, dynamic>) {
      childWidget = _buildWidget(data['child']);
    } else if (data['children'] is List) {
      childWidget = _buildColumn(data);
    }

    return Container(
      width: _parseDoubleNullable(data['width']),
      height: _parseDoubleNullable(data['height']),
      margin: _parseEdgeInsets(data['margin'] ?? 0),
      padding: _parseEdgeInsets(data['padding'] ?? 14.0),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: childWidget,
    );
  }

  Widget _buildSpacing(Map<String, dynamic> data) {
    final h = _parseDouble(data['height'], 16.0);
    final w = _parseDouble(data['width'], 0.0);
    return SizedBox(height: h, width: w > 0 ? w : null);
  }

  Widget _buildIcon(Map<String, dynamic> data) {
    final iconName = data['name']?.toString() ?? data['icon']?.toString() ?? 'star';
    final size = _parseDouble(data['size'], 24.0);
    final color = _parseColor(data['color']?.toString(), const Color(0xFF6366F1));

    return Icon(_getIconData(iconName), size: size, color: color);
  }

  Widget _buildAvatar(Map<String, dynamic> data) {
    final radius = _parseDouble(data['radius'], 24.0);
    final initials = data['initials']?.toString() ?? 'U';
    final bgColor = _parseColor(data['color']?.toString(), const Color(0xFF6366F1));

    return CircleAvatar(
      radius: radius,
      backgroundColor: bgColor,
      child: Text(
        initials,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: radius * 0.7,
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder(Map<String, dynamic> data) {
    final height = _parseDouble(data['height'], 160.0);
    final caption = data['caption']?.toString() ?? 'Image';
    final color = _parseColor(data['color']?.toString(), const Color(0xFFF1F5F9));

    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.image, size: 36, color: Color(0xFF94A3B8)),
            const SizedBox(height: 6),
            Text(
              caption,
              style: const TextStyle(
                color: Color(0xFF64748B),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(Map<String, dynamic> data) {
    final text = data['text']?.toString() ?? '';
    final bgColor = _parseColor(data['color']?.toString(), const Color(0xFFEEF2FF));
    final textColor = _parseColor(data['textColor']?.toString(), const Color(0xFF4F46E5));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildDivider(Map<String, dynamic> data) {
    final color = _parseColor(data['color']?.toString(), const Color(0xFFE2E8F0));
    return Divider(color: color, height: 24, thickness: 1);
  }

  Widget _buildListTile(Map<String, dynamic> data) {
    final title = data['title']?.toString() ?? '';
    final subtitle = data['subtitle']?.toString();
    final leadingIcon = data['leading']?.toString();

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: leadingIcon != null
          ? CircleAvatar(
              backgroundColor: const Color(0xFFEEF2FF),
              child: Icon(_getIconData(leadingIcon), color: const Color(0xFF6366F1), size: 20),
            )
          : null,
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF1E293B)),
      ),
      subtitle: subtitle != null
          ? Text(subtitle, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)))
          : null,
      trailing: const Icon(Icons.chevron_right, color: Color(0xFF94A3B8), size: 20),
    );
  }

  Widget _buildSwitch(Map<String, dynamic> data) {
    final label = data['label']?.toString() ?? 'Toggle';
    final val = data['value'] == true;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF1E293B)),
        ),
        Switch(
          value: val,
          onChanged: (_) {},
          activeColor: const Color(0xFF6366F1),
        ),
      ],
    );
  }

  // --- Helper Parsers ---

  Color _parseColor(String? hexString, Color fallback) {
    if (hexString == null || hexString.isEmpty) return fallback;
    try {
      String hex = hexString.replaceAll('#', '').trim();
      if (hex.length == 6) {
        hex = 'FF$hex';
      }
      return Color(int.parse(hex, radix: 16));
    } catch (_) {
      return fallback;
    }
  }

  double _parseDouble(dynamic value, double fallback) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? fallback;
    return fallback;
  }

  double? _parseDoubleNullable(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  EdgeInsets _parseEdgeInsets(dynamic value) {
    if (value is num) return EdgeInsets.all(value.toDouble());
    if (value is Map<String, dynamic>) {
      return EdgeInsets.only(
        left: _parseDouble(value['left'], 0),
        top: _parseDouble(value['top'], 0),
        right: _parseDouble(value['right'], 0),
        bottom: _parseDouble(value['bottom'], 0),
      );
    }
    return const EdgeInsets.all(16);
  }

  FontWeight _parseFontWeight(dynamic weight) {
    final str = weight?.toString().toLowerCase() ?? '';
    if (str.contains('bold') || str.contains('700') || str.contains('800')) {
      return FontWeight.bold;
    }
    if (str.contains('semi') || str.contains('600')) {
      return FontWeight.w600;
    }
    if (str.contains('medium') || str.contains('500')) {
      return FontWeight.w500;
    }
    if (str.contains('light') || str.contains('300')) {
      return FontWeight.w300;
    }
    return FontWeight.normal;
  }

  TextAlign _parseTextAlign(dynamic align) {
    final str = align?.toString().toLowerCase() ?? '';
    if (str == 'center') return TextAlign.center;
    if (str == 'right' || str == 'end') return TextAlign.right;
    return TextAlign.left;
  }

  CrossAxisAlignment _parseCrossAxisAlignment(dynamic align) {
    final str = align?.toString().toLowerCase() ?? '';
    if (str == 'center') return CrossAxisAlignment.center;
    if (str == 'start') return CrossAxisAlignment.start;
    if (str == 'end') return CrossAxisAlignment.end;
    return CrossAxisAlignment.stretch;
  }

  MainAxisAlignment _parseMainAxisAlignment(dynamic align) {
    final str = align?.toString().toLowerCase() ?? '';
    if (str == 'center') return MainAxisAlignment.center;
    if (str == 'spacebetween' || str == 'space_between') {
      return MainAxisAlignment.spaceBetween;
    }
    if (str == 'spaceevenly' || str == 'space_evenly') {
      return MainAxisAlignment.spaceEvenly;
    }
    return MainAxisAlignment.start;
  }

  IconData _getIconData(String name) {
    final lower = name.toLowerCase().replaceAll('-', '_');
    switch (lower) {
      case 'search':
        return Icons.search;
      case 'email':
      case 'mail':
        return Icons.email_outlined;
      case 'lock':
      case 'password':
        return Icons.lock_outline;
      case 'home':
        return Icons.home_outlined;
      case 'star':
        return Icons.star_rounded;
      case 'person':
      case 'user':
        return Icons.person_outline;
      case 'settings':
        return Icons.settings_outlined;
      case 'notifications':
      case 'bell':
        return Icons.notifications_outlined;
      case 'favorite':
      case 'heart':
        return Icons.favorite_outline;
      case 'arrow_back':
      case 'back':
        return Icons.arrow_back;
      case 'check':
        return Icons.check_circle_outline;
      case 'close':
        return Icons.close;
      case 'filter':
        return Icons.tune;
      case 'menu':
        return Icons.menu;
      case 'calendar':
        return Icons.calendar_today_outlined;
      case 'shopping_cart':
      case 'cart':
        return Icons.shopping_cart_outlined;
      default:
        return Icons.circle_outlined;
    }
  }
}
