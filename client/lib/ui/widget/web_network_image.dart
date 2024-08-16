import 'package:flutter/material.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:universal_html/html.dart' as html;
import 'dart:ui' as ui;

class CachedImage extends StatefulWidget {

  final String url;
  final double width;
  final double height;
  final BoxBorder? border;
  final BorderRadius? borderRadius;
  final bool isCircular;
  final BoxFit? fit;
  final Color? filterColor;
  final FilterQuality? filterQuality;
  final Color? placeHolderColor;
  final Alignment? alignment;
  final bool useCacheKey;
  final String? viewType;
  final VoidCallback? onTap;
  const CachedImage({
    super.key,
    required this.url,
    required this.height,
    required this.width,
    this.border,
    this.borderRadius,
    this.isCircular = false,
    this.fit,
    this.filterColor,
    this.filterQuality,
    this.placeHolderColor,
    this.alignment,
    this.useCacheKey = false,
    this.viewType,
    this.onTap
  });

  @override
  _WebNetworkImageState createState() => _WebNetworkImageState();
}

class _WebNetworkImageState extends State<CachedImage> with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _animation;
  late String viewType;
  final ValueNotifier<double> opacityRatio = ValueNotifier<double>(0.0);

  @override
  void initState() {
    super.initState();
    viewType = widget.viewType ?? 'cached-image-${widget.url.hashCode}-${DateTime.now().toIso8601String()}';
    // ignore:undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      viewType,
          (int viewId) {
        final imgElement = html.ImageElement()
          ..src = widget.url
          ..width = widget.width.toInt()
          ..height = widget.height.toInt()
          ..style.objectFit = widget.fit.toString().split('.').last
          ..style.border = widget.border.toString()
          ..style.borderRadius = '4'
          ..style.width = '${widget.width}px'
          ..style.height = '${widget.height}px'
          ..style.filter = widget.filterColor != null ? 'filter: ${widget.filterColor.toString()}' : '';

        imgElement.onLoad.listen((event) {
          // Start the animation when the image is loaded
          _controller.forward();
        });
        imgElement.onClick.listen((event) {
          if(widget.onTap != null){
            widget.onTap!();
          }
        });
        return imgElement;
      },
    );
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller)
      ..addListener(progressListener);

  }

  void progressListener() {
    final value = (_animation.value) ?? 0;
    if (value > 0) {
      opacityRatio.value = value;
    }
  }

  @override
  void dispose(){
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){

      },
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: ClipRRect(
            borderRadius: widget.borderRadius ?? BorderRadius.zero,
            child: ValueListenableBuilder(
              valueListenable: opacityRatio,
              builder: (context,value,child){
                return Opacity(
                  opacity: _animation.value,
                  child: PointerInterceptor(
                    child: InkWell(
                      onTap: widget.onTap,
                      child: HtmlElementView(
                          viewType: viewType),
                    ),
                  ),
                );
              },
            )
        ),
      ),
    );
  }
}