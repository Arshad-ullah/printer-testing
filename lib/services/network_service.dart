import 'dart:io';

class NetworkService {
  Future<List<String>> getLocalIpAddresses() async {
    try {
      final interfaces = await NetworkInterface.list(
        type: InternetAddressType.IPv4,
        includeLinkLocal: false,
      );

      final List<String> ips = [];
      for (final interface in interfaces) {
        for (final addr in interface.addresses) {
          if (!addr.isLoopback && addr.type == InternetAddressType.IPv4) {
            ips.add(addr.address);
          }
        }
      }
      return ips;
    } catch (_) {
      return [];
    }
  }
}
