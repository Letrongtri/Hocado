import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hocado/app/provider/provider.dart';
import 'package:hocado/core/constants/sizes.dart';
import 'package:hocado/data/models/user.dart';
import 'package:hocado/presentation/widgets/hocado_back.dart';
import 'package:hocado/presentation/widgets/hocado_dialog.dart';
import 'package:image_picker/image_picker.dart';

class ProfileSettingsScreen extends ConsumerStatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  ConsumerState<ProfileSettingsScreen> createState() =>
      _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends ConsumerState<ProfileSettingsScreen> {
  final _editFormKey = GlobalKey<FormState>();
  late User _editedUser;

  XFile? _pickedImage;
  Uint8List? _webImageBytes; // for web

  bool _isLoading = false;

  Future<void> _saveForm() async {
    final isValid = _editFormKey.currentState!.validate();
    if (!isValid) return;

    _editFormKey.currentState!.save();

    setState(() {
      _isLoading = true;
    });

    try {
      await ref
          .read(profileSettingsViewModelProvider.notifier)
          .updateProfile(_editedUser, _pickedImage);
    } catch (e) {
      if (mounted) {
        showErrorSnackbar(context, "Lỗi: $e");
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onPickImage() async {
    final imagePicker = ImagePicker();
    try {
      final imageFile = await imagePicker.pickImage(
        source: ImageSource.gallery,
      );
      if (imageFile == null) return;

      if (kIsWeb) {
        final bytes = await imageFile.readAsBytes();
        setState(() {
          _pickedImage = imageFile;
          _webImageBytes = bytes; // Lưu bytes để hiển thị Preview
        });
      } else {
        setState(() {
          _pickedImage = imageFile;
        });
      }
    } catch (e) {
      if (mounted) {
        showErrorSnackbar(context, "Lỗi chọn ảnh: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final currentUser = ref.watch(currentUserProvider);
    if (currentUser == null) {
      return Center(
        child: Text('Không tìm thấy người dùng'),
      );
    }

    final editedUser = ref.watch(userProfileProvider(currentUser.uid));

    ref.listenManual(
      profileSettingsViewModelProvider,
      (previous, next) {
        if (next is AsyncData && previous is AsyncLoading) {
          context.pop();
          showSuccessSnackbar(context, "Lưu thành công!");
        }
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cài đặt tài khoản',
          style: textTheme.headlineSmall,
        ),
        centerTitle: false,
        leading: HocadoBack(),
        actions: [
          _isLoading
              ? const CircularProgressIndicator()
              : IconButton(
                  onPressed: () async {
                    await _saveForm();
                  },
                  icon: Icon(Icons.check),
                ),
          SizedBox(width: Sizes.sm),
        ],
      ),
      body: editedUser.when(
        data: (user) {
          _editedUser = user;
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: Sizes.md),
            child: _buildMainForm(context, colorScheme, textTheme, user),
          );
        },
        error: (error, stackTrace) => Center(child: Text(error.toString())),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _buildMainForm(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme,
    User user,
  ) {
    return Form(
      key: _editFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: Sizes.md),

          // 1. Ảnh đại diện (Profile Picture)
          _buildProfilePreview(context, colorScheme, user),

          const SizedBox(height: Sizes.xl),

          Text(
            'Tên',
            style: textTheme.titleMedium,
          ),
          const SizedBox(height: Sizes.sm),
          _buildTextFormField(
            colorScheme,
            keyboardType: TextInputType.text,
            value: user.fullName,
            validator: (value) {
              if (value == null || value.isEmpty) return 'Vui lý nhập tên';
              return null;
            },
            onSaved: (value) {
              if (value == null || value.isEmpty) return;
              _editedUser = _editedUser.copyWith(fullName: value);
              return;
            },
          ),
          const SizedBox(height: Sizes.lg),

          Text(
            'Email',
            style: textTheme.titleMedium,
          ),
          const SizedBox(height: Sizes.sm),
          Text(
            user.email,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSecondary,
            ),
          ),
          const SizedBox(height: Sizes.lg),

          Text(
            'Số điện thoại',
            style: textTheme.titleMedium,
          ),
          const SizedBox(height: Sizes.sm),
          _buildTextFormField(
            colorScheme,
            keyboardType: TextInputType.phone,
            value: user.phone,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lý nhập số điện thoại';
              }
              return null;
            },
            onSaved: (value) {
              if (value == null || value.isEmpty) return;
              _editedUser = _editedUser.copyWith(phone: value);
              return;
            },
          ),
          const SizedBox(height: Sizes.lg),

          //Xóa Tài khoản
          Text(
            'Xóa tài khoản',
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.error,
            ),
          ),
          const SizedBox(height: Sizes.sm),
          Text(
            'Chúng tôi sẽ lưu trữ tài khoản của bạn trong 30 ngày trước khi xóa vĩnh viễn.',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSecondary,
            ),
          ),

          const SizedBox(height: Sizes.xl),

          _buildDeleteAccountButton(colorScheme, textTheme),
          const SizedBox(height: Sizes.lg),
        ],
      ),
    );
  }

  Widget _buildDeleteAccountButton(
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          final confirm = await showConfirmDialog(
            context,
            "Xác nhận xóa",
            "Bạn có chắc muốn xóa tài khoản không?",
          );

          if (confirm != null && confirm) {
            if (!mounted) return;
            final pw = await showInputDialog(
              context,
              title: "Mật khẩu",
              hint: "Nhập mật khẩu",
              obscureText: true,
            );
            if (pw == null) return;

            await ref
                .read(profileSettingsViewModelProvider.notifier)
                .deleteAccount(pw);

            if (mounted) {
              showSuccessSnackbar(context, "Xóa tài khoản thành công");
            }
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.error.withAlpha(30),
          foregroundColor: colorScheme.error,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Sizes.md),
            side: BorderSide(
              color: colorScheme.error,
              width: Sizes.dividerHeight,
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: Sizes.md),
        ),
        child: Text(
          'Xóa tài khoản',
          style: textTheme.bodyLarge?.copyWith(
            color: colorScheme.error,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildProfilePreview(
    BuildContext context,
    ColorScheme colorScheme,
    User user,
  ) {
    final hasAvatar = user.avatarUrl != null && user.avatarUrl!.isNotEmpty;

    ImageProvider? backgroundImage;

    if (_pickedImage != null) {
      if (kIsWeb && _webImageBytes != null) {
        backgroundImage = MemoryImage(_webImageBytes!);
      } else if (!kIsWeb) {
        backgroundImage = FileImage(File(_pickedImage!.path));
      }
    } else if (hasAvatar) {
      backgroundImage = NetworkImage(_editedUser.avatarUrl!);
    }

    return Center(
      child: Stack(
        children: [
          InkWell(
            onTap: _onPickImage,
            borderRadius: BorderRadius.circular(50),
            child: CircleAvatar(
              radius: 50,
              backgroundColor: colorScheme.onSecondary,
              backgroundImage: backgroundImage,
              child: backgroundImage == null
                  ? Icon(
                      Icons.person,
                      color: colorScheme.secondary,
                      size: Sizes.iconLg * 2,
                    )
                  : null,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(Sizes.xs),
              decoration: BoxDecoration(
                color: colorScheme.primary,
                shape: BoxShape.circle,
                border: Border.all(color: colorScheme.onPrimary, width: 2),
              ),
              child: Icon(
                Icons.camera_alt,
                size: Sizes.iconSm,
                color: colorScheme.onPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextFormField(
    ColorScheme colorScheme, {
    String? value,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    String? Function(String?)? onSaved,
  }) {
    return TextFormField(
      initialValue: value,
      keyboardType: keyboardType,
      validator: validator,
      onSaved: onSaved,
      cursorColor: colorScheme.onPrimary,
      decoration: InputDecoration(
        filled: true,
        fillColor: colorScheme.secondary,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Sizes.borderRadiusLg),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Sizes.borderRadiusLg),
          borderSide: BorderSide(
            color: colorScheme.onPrimary,
            width: 1.6,
          ),
        ),
      ),
    );
  }
}
