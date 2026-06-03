import 'package:flutter_test/flutter_test.dart';
import 'package:al_andalus/services/deep_link_service.dart';

void main() {
  test('Clean URL test cases', () {
    expect(DeepLinkService.cleanUrl('https://back.al_andalus.com/carPage?id=44'), '/carPage?id=44');
    expect(DeepLinkService.cleanUrl('al_andalus://carPage?id=44'), '/carPage?id=44');
    expect(DeepLinkService.cleanUrl('/carPage?id=44'), '/carPage?id=44');
    expect(DeepLinkService.cleanUrl('carPage?id=44'), '/carPage?id=44');
    expect(DeepLinkService.cleanUrl('https://back.al_andalus.com/carPage'), '/carPage');
    expect(DeepLinkService.cleanUrl('al_andalus://carPage'), '/carPage');
    expect(DeepLinkService.cleanUrl('al_andalus://home/carPage?id=44'), '/home/carPage?id=44');
  });
}
