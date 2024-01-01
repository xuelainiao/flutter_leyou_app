/// 是否生产模式
isProduction() {
  return const bool.fromEnvironment('dart.vm.product');
}
