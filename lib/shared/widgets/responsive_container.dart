import 'package:flutter/material.dart';

/// A responsive container that centers content and constrains max width
/// 
/// This widget helps prevent content from becoming too wide on larger screens
/// while ensuring proper responsive behavior on mobile devices.
class ResponsiveContainer extends StatelessWidget {
  /// The child widget to be contained
  final Widget child;
  
  /// Maximum width for the container content
  final double maxWidth;
  
  /// Padding around the container content
  final EdgeInsetsGeometry? padding;
  
  /// Whether to center the content horizontally
  final bool center;
  
  const ResponsiveContainer({
    super.key,
    required this.child,
    this.maxWidth = 600.0,
    this.padding,
    this.center = true,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    
    Widget content = ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: isMobile ? double.infinity : maxWidth,
      ),
      child: child,
    );
    
    if (center) {
      content = Center(child: content);
    }
    
    if (padding != null) {
      content = Padding(
        padding: padding!,
        child: content,
      );
    }
    
    return content;
  }
}

/// A responsive row that wraps to column on mobile
class ResponsiveRowColumn extends StatelessWidget {
  /// The children widgets
  final List<Widget> children;
  
  /// Spacing between children
  final double spacing;
  
  /// Cross axis alignment for row
  final CrossAxisAlignment crossAxisAlignment;
  
  /// Main axis alignment for row
  final MainAxisAlignment mainAxisAlignment;
  
  /// Breakpoint width below which it becomes a column
  final double breakpoint;
  
  const ResponsiveRowColumn({
    super.key,
    required this.children,
    this.spacing = 16.0,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.breakpoint = 600.0,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isColumn = screenWidth < breakpoint;
    
    if (isColumn) {
      return Column(
        crossAxisAlignment: crossAxisAlignment,
        children: _addSpacing(children, spacing, true),
      );
    } else {
      return Row(
        crossAxisAlignment: crossAxisAlignment,
        mainAxisAlignment: mainAxisAlignment,
        children: _addSpacing(children, spacing, false),
      );
    }
  }
  
  List<Widget> _addSpacing(List<Widget> children, double spacing, bool isColumn) {
    if (children.isEmpty) return children;
    
    final List<Widget> spacedChildren = [];
    
    for (int i = 0; i < children.length; i++) {
      spacedChildren.add(children[i]);
      
      if (i < children.length - 1) {
        spacedChildren.add(
          isColumn 
            ? SizedBox(height: spacing)
            : SizedBox(width: spacing),
        );
      }
    }
    
    return spacedChildren;
  }
}

/// A responsive text widget that scales based on screen size
class ResponsiveText extends StatelessWidget {
  /// The text content
  final String text;
  
  /// Base font size (will be scaled)
  final double baseFontSize;
  
  /// Text style
  final TextStyle? style;
  
  /// Text alignment
  final TextAlign? textAlign;
  
  /// Maximum lines
  final int? maxLines;
  
  /// Text overflow behavior
  final TextOverflow? overflow;
  
  /// Scale factor for different screen sizes
  final double mobileScale;
  final double tabletScale;
  final double desktopScale;
  
  const ResponsiveText(
    this.text, {
    super.key,
    required this.baseFontSize,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.mobileScale = 0.9,
    this.tabletScale = 1.0,
    this.desktopScale = 1.1,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    double scale;
    if (screenWidth < 600) {
      scale = mobileScale;
    } else if (screenWidth < 900) {
      scale = tabletScale;
    } else {
      scale = desktopScale;
    }
    
    final scaledFontSize = baseFontSize * scale;
    final minFontSize = 14.0; // Ensure readability
    final finalFontSize = scaledFontSize < minFontSize ? minFontSize : scaledFontSize;
    
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(
        text,
        style: (style ?? const TextStyle()).copyWith(
          fontSize: finalFontSize,
        ),
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
      ),
    );
  }
}