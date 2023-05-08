// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:ui' as _i3;

import 'package:auto_route/auto_route.dart' as _i2;
import 'package:flutter/material.dart' as _i1;

class AppRouter extends _i2.RootStackRouter {
  AppRouter([_i1.GlobalKey<_i1.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i2.PageFactory> pagesMap = {
    ContainerRoute.name: (routeData) {
      final args = routeData.argsAs<ContainerRouteArgs>(
          orElse: () => const ContainerRouteArgs());
      return _i2.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i1.Container(
          key: args.key,
          alignment: args.alignment,
          padding: args.padding,
          color: args.color,
          decoration: args.decoration,
          foregroundDecoration: args.foregroundDecoration,
          width: args.width,
          height: args.height,
          constraints: args.constraints,
          margin: args.margin,
          transform: args.transform,
          transformAlignment: args.transformAlignment,
          child: args.child,
          clipBehavior: args.clipBehavior,
        ),
      );
    }
  };

  @override
  List<_i2.RouteConfig> get routes => [
        _i2.RouteConfig(
          ContainerRoute.name,
          path: '/',
        )
      ];
}

/// generated route for
/// [_i1.Container]
class ContainerRoute extends _i2.PageRouteInfo<ContainerRouteArgs> {
  ContainerRoute({
    _i1.Key? key,
    _i1.AlignmentGeometry? alignment,
    _i1.EdgeInsetsGeometry? padding,
    _i3.Color? color,
    _i1.Decoration? decoration,
    _i1.Decoration? foregroundDecoration,
    double? width,
    double? height,
    _i1.BoxConstraints? constraints,
    _i1.EdgeInsetsGeometry? margin,
    _i1.Matrix4? transform,
    _i1.AlignmentGeometry? transformAlignment,
    _i1.Widget? child,
    _i3.Clip clipBehavior = _i3.Clip.none,
  }) : super(
          ContainerRoute.name,
          path: '/',
          args: ContainerRouteArgs(
            key: key,
            alignment: alignment,
            padding: padding,
            color: color,
            decoration: decoration,
            foregroundDecoration: foregroundDecoration,
            width: width,
            height: height,
            constraints: constraints,
            margin: margin,
            transform: transform,
            transformAlignment: transformAlignment,
            child: child,
            clipBehavior: clipBehavior,
          ),
        );

  static const String name = 'ContainerRoute';
}

class ContainerRouteArgs {
  const ContainerRouteArgs({
    this.key,
    this.alignment,
    this.padding,
    this.color,
    this.decoration,
    this.foregroundDecoration,
    this.width,
    this.height,
    this.constraints,
    this.margin,
    this.transform,
    this.transformAlignment,
    this.child,
    this.clipBehavior = _i3.Clip.none,
  });

  final _i1.Key? key;

  final _i1.AlignmentGeometry? alignment;

  final _i1.EdgeInsetsGeometry? padding;

  final _i3.Color? color;

  final _i1.Decoration? decoration;

  final _i1.Decoration? foregroundDecoration;

  final double? width;

  final double? height;

  final _i1.BoxConstraints? constraints;

  final _i1.EdgeInsetsGeometry? margin;

  final _i1.Matrix4? transform;

  final _i1.AlignmentGeometry? transformAlignment;

  final _i1.Widget? child;

  final _i3.Clip clipBehavior;

  @override
  String toString() {
    return 'ContainerRouteArgs{key: $key, alignment: $alignment, padding: $padding, color: $color, decoration: $decoration, foregroundDecoration: $foregroundDecoration, width: $width, height: $height, constraints: $constraints, margin: $margin, transform: $transform, transformAlignment: $transformAlignment, child: $child, clipBehavior: $clipBehavior}';
  }
}
