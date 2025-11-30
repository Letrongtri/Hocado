import 'package:flutter/material.dart';
import 'package:hocado/core/constants/images.dart';
import 'package:hocado/data/models/user.dart';

class HocadoAvatar extends StatelessWidget {
  const HocadoAvatar({
    super.key,
    required this.user,
    this.size = 50,
  });

  final User user;
  final double size;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: size + 2,
      backgroundColor: Colors.white, // Viền trắng
      child: CircleAvatar(
        radius: size,
        backgroundImage: user.avatarUrl != null
            ? NetworkImage(
                user.avatarUrl!,
              )
            : AssetImage(
                Images.avatarDefault,
              ),
      ),
    );
  }
}
