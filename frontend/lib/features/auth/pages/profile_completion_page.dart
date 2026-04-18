import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/constants/auth_colors.dart';
import '../../../core/router/app_router.dart';
import '../services/auth_service.dart';
import '../services/registration_session.dart';
import '../widgets/profile_completion_action_button.dart';
import '../widgets/profile_completion_avatar_section.dart';
import '../widgets/profile_completion_date_field.dart';
import '../widgets/profile_completion_full_name_field.dart';
import '../widgets/profile_completion_gender_field.dart';
import '../widgets/profile_completion_governorate_field.dart';
import '../widgets/profile_completion_hero.dart';
import '../widgets/profile_completion_location_field.dart';
import '../widgets/profile_completion_map_card.dart';
import '../widgets/profile_completion_phone_field.dart';
import '../widgets/profile_completion_privacy_toggle.dart';
import 'location_picker_page.dart';

enum _AvatarAction { gallery, camera, remove }

class ProfileCompletionPage extends StatefulWidget {
  const ProfileCompletionPage({super.key});

  @override
  State<ProfileCompletionPage> createState() => _ProfileCompletionPageState();
}

class _ProfileCompletionPageState extends State<ProfileCompletionPage> {
  final ImagePicker _imagePicker = ImagePicker();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  // Gender options must match backend enum: 'male' | 'female'
  static const List<String> _genderOptions = <String>['Male', 'Female'];
  String _selectedGender = '';

  // Governorate – now selected via dropdown
  String _selectedGovernorate = '';

  // Location – coordinates from Google Maps picker
  double? _selectedLat;
  double? _selectedLng;

  bool _isPublicProfile = true;
  bool _showValidationErrors = false;
  bool _isPickingAvatar = false;
  bool _isSubmitting = false;
  Uint8List? _avatarBytes;

  // Profile picture URL from social provider (shown when no local avatar is chosen).
  String? _socialPictureUrl;

  @override
  void initState() {
    super.initState();
    final RegistrationSession session = RegistrationSession.instance;

    // Pre-fill phone from the registration session.
    _phoneController.text = session.phone ?? '';

    // Pre-fill available fields from social provider hints (Google, etc.).
    final SocialHints? hints = session.socialHints;
    if (hints != null) {
      if (hints.name != null) _fullNameController.text = hints.name!;
      if (hints.picture != null) _socialPictureUrl = hints.picture;
    }

    _fullNameController.addListener(_onFieldChanged);
    _locationController.addListener(_onFieldChanged);
  }

  @override
  void dispose() {
    _fullNameController.removeListener(_onFieldChanged);
    _fullNameController.dispose();
    _phoneController.dispose();
    _dateController.dispose();
    _locationController.removeListener(_onFieldChanged);
    _locationController.dispose();
    super.dispose();
  }

  void _onFieldChanged() {
    if (mounted) setState(() {});
  }

  String _formatDate(DateTime date) {
    final String month = date.month.toString().padLeft(2, '0');
    final String day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  Future<void> _pickDate() async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 20, now.month, now.day),
      firstDate: DateTime(1950),
      lastDate: now,
    );
    if (picked != null) {
      setState(() => _dateController.text = _formatDate(picked));
    }
  }

  // ── Map picker ──────────────────────────────────────────────────────────────

  Future<void> _openLocationPicker() async {
    final PickedLocation? result = await Navigator.push<PickedLocation>(
      context,
      MaterialPageRoute<PickedLocation>(
        builder: (_) => LocationPickerPage(
          initialLatitude: _selectedLat,
          initialLongitude: _selectedLng,
        ),
      ),
    );

    if (result == null || !mounted) return;

    setState(() {
      _selectedLat = result.latitude;
      _selectedLng = result.longitude;
      _locationController.text = result.address;
    });
  }

  // ── Validation ────────────────────────────────────────────────────────────

  String? _fullNameError() {
    if (!_showValidationErrors) return null;
    final String v = _fullNameController.text.trim();
    if (v.isEmpty) return 'Enter your full name.';
    if (v.length < 3) return 'Full name must be at least 3 characters.';
    return null;
  }

  String? _phoneError() {
    if (!_showValidationErrors) return null;
    if (_phoneController.text.trim().isEmpty) {
      return 'Verified phone number is required.';
    }
    return null;
  }

  String? _dateError() {
    if (!_showValidationErrors) return null;
    final String v = _dateController.text.trim();
    if (v.isEmpty) return 'Choose your date of birth.';
    final DateTime? parsed = DateTime.tryParse(v);
    if (parsed == null) return 'Use the date picker to choose a valid date.';
    if (parsed.isAfter(DateTime.now())) {
      return 'Date of birth cannot be in the future.';
    }
    return null;
  }

  String? _governorateError() {
    if (!_showValidationErrors) return null;
    if (_selectedGovernorate.isEmpty) {
      return 'Select your governorate.';
    }
    return null;
  }

  String? _locationError() {
    if (!_showValidationErrors) return null;
    if (_locationController.text.trim().isEmpty) {
      return 'Pick your preferred pitch location on the map.';
    }
    return null;
  }

  bool _isFormValid() {
    final DateTime? parsedDate = DateTime.tryParse(_dateController.text.trim());

    return _fullNameController.text.trim().length >= 3 &&
        _phoneController.text.trim().isNotEmpty &&
        _dateController.text.trim().isNotEmpty &&
        parsedDate != null &&
        !parsedDate.isAfter(DateTime.now()) &&
        _selectedGovernorate.isNotEmpty &&
        _locationController.text.trim().isNotEmpty &&
        _selectedGender.isNotEmpty;
  }

  // ── Avatar picker ─────────────────────────────────────────────────────────

  Future<void> _showAvatarPickerSheet() async {
    if (_isPickingAvatar) return;

    final _AvatarAction? action = await showModalBottomSheet<_AvatarAction>(
      context: context,
      builder: (BuildContext ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Choose from gallery'),
                onTap: () => Navigator.pop(ctx, _AvatarAction.gallery),
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera_outlined),
                title: const Text('Take a photo'),
                onTap: () => Navigator.pop(ctx, _AvatarAction.camera),
              ),
              if (_avatarBytes != null)
                ListTile(
                  leading: const Icon(Icons.delete_outline),
                  title: const Text('Remove photo'),
                  onTap: () => Navigator.pop(ctx, _AvatarAction.remove),
                ),
            ],
          ),
        );
      },
    );

    if (action == null || !mounted) return;

    if (action == _AvatarAction.remove) {
      setState(() => _avatarBytes = null);
      return;
    }

    await _pickAvatar(
      action == _AvatarAction.camera ? ImageSource.camera : ImageSource.gallery,
    );
  }

  Future<void> _pickAvatar(ImageSource source) async {
    setState(() => _isPickingAvatar = true);
    try {
      final XFile? file = await _imagePicker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1200,
      );
      if (file == null || !mounted) return;
      final Uint8List bytes = await file.readAsBytes();
      if (!mounted) return;
      setState(() => _avatarBytes = bytes);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not open the image picker on this device.'),
        ),
      );
    } finally {
      if (mounted) setState(() => _isPickingAvatar = false);
    }
  }

  // ── Submit ────────────────────────────────────────────────────────────────

  Future<void> _onComplete() async {
    if (_isSubmitting) return;
    setState(() => _showValidationErrors = true);

    if (!_isFormValid()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all required fields.')),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final bool isSocialFlow =
          RegistrationSession.instance.socialHints != null;
      if (isSocialFlow) {
        await AuthService.instance.completeSocialProfile(
          fullName: _fullNameController.text.trim(),
          dateOfBirth: _dateController.text.trim(),
          gender: _selectedGender,
          city: _selectedGovernorate,
        );
        if (!mounted) return;
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.home,
          (_) => false,
        );
      } else {
        await AuthService.instance.completeProfile(
          fullName: _fullNameController.text.trim(),
          dateOfBirth: _dateController.text.trim(),
          gender: _selectedGender,
          city: _selectedGovernorate,
        );
        if (!mounted) return;
        Navigator.pushNamed(context, AppRoutes.setPassword);
      }
    } on AuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message),
          backgroundColor: Colors.red.shade700,
        ),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final double safeBottom = MediaQuery.paddingOf(context).bottom;
    final bool isTablet = screenWidth >= 900;
    final bool isIpad = screenWidth >= 600 && screenWidth < 900;
    final double contentMaxWidth = isTablet
        ? 820
        : isIpad
        ? 660
        : 430;
    final double horizontalPadding = isTablet
        ? 32
        : isIpad
        ? 26
        : 20;
    const double designWidth = 390;
    const double designHeight = 844;
    final double layoutWidth = (screenWidth - (horizontalPadding * 2))
        .clamp(260.0, contentMaxWidth)
        .toDouble();
    final double widthScale = (layoutWidth / designWidth).clamp(0.82, 1.32);
    final double heightScale = (screenHeight / designHeight).clamp(0.82, 1.1);
    final double scale = widthScale < heightScale ? widthScale : heightScale;

    return Scaffold(
      backgroundColor: AuthColors.surface,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final double footerHeight = (110 * scale).clamp(96.0, 128.0);
            final bool stackDobGender = layoutWidth < 360;
            final bool useWideRows = layoutWidth >= 560;
            final double sectionSpacing = (24 * scale).clamp(20.0, 28.0);
            final double contentBottomPadding =
                footerHeight + safeBottom + (28 * scale).clamp(20.0, 36.0);

            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: contentMaxWidth),
                child: Stack(
                  children: <Widget>[
                    // Decorative background circle
                    Positioned(
                      top: (8 * scale).clamp(4.0, 12.0),
                      left: (8 * scale).clamp(4.0, 12.0),
                      child: Container(
                        width: (96 * scale).clamp(72.0, 120.0),
                        height: (96 * scale).clamp(72.0, 120.0),
                        decoration: BoxDecoration(
                          color: AuthColors.lime.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),

                    // Scrollable content
                    SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(
                        horizontalPadding,
                        (32 * scale).clamp(24.0, 40.0),
                        horizontalPadding,
                        contentBottomPadding,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          ProfileCompletionHero(
                            stepLabel: '',
                            titleLine1: 'COMPLETE YOUR',
                            titleLine2: 'PROFILE',
                            scale: scale,
                          ),
                          SizedBox(height: (32 * scale).clamp(26.0, 40.0)),
                          ProfileCompletionAvatarSection(
                            title: 'Player Identity',
                            description:
                                'Upload a photo to join squads faster.',
                            scale: scale,
                            imageBytes: _avatarBytes,
                            networkImageUrl: _socialPictureUrl,
                            isLoading: _isPickingAvatar,
                            onPressed: _showAvatarPickerSheet,
                            statusText: _avatarBytes != null
                                ? 'Photo selected. Tap to change it.'
                                : _socialPictureUrl != null
                                ? 'Using your Google photo. Tap to change.'
                                : 'Tap to upload a profile photo.',
                          ),
                          SizedBox(height: sectionSpacing),

                          // Full name + phone row
                          if (useWideRows)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: ProfileCompletionFullNameField(
                                    label: 'Full Name',
                                    controller: _fullNameController,
                                    placeholder: '',
                                    scale: scale,
                                    onChanged: (_) => _onFieldChanged(),
                                    errorText: _fullNameError(),
                                  ),
                                ),
                                SizedBox(width: (16 * scale).clamp(12.0, 20.0)),
                                Expanded(
                                  child: ProfileCompletionPhoneField(
                                    label: 'Phone Number',
                                    controller: _phoneController,
                                    scale: scale,
                                    readOnly: true,
                                    errorText: _phoneError(),
                                  ),
                                ),
                              ],
                            )
                          else ...<Widget>[
                            ProfileCompletionFullNameField(
                              label: 'Full Name',
                              controller: _fullNameController,
                              placeholder: '',
                              scale: scale,
                              onChanged: (_) => _onFieldChanged(),
                              errorText: _fullNameError(),
                            ),
                            SizedBox(height: sectionSpacing),
                            ProfileCompletionPhoneField(
                              label: 'Phone Number',
                              controller: _phoneController,
                              scale: scale,
                              readOnly: true,
                              errorText: _phoneError(),
                            ),
                          ],
                          SizedBox(height: sectionSpacing),

                          // Date of birth + gender row
                          if (stackDobGender) ...<Widget>[
                            ProfileCompletionDateField(
                              label: 'Date of Birth',
                              controller: _dateController,
                              scale: scale,
                              onTap: _pickDate,
                              errorText: _dateError(),
                            ),
                            SizedBox(height: sectionSpacing),
                            ProfileCompletionGenderField(
                              label: 'Gender',
                              options: _genderOptions,
                              value: _selectedGender,
                              scale: scale,
                              onChanged: (String? v) {
                                if (v == null) return;
                                setState(() => _selectedGender = v);
                              },
                              errorText:
                                  _showValidationErrors &&
                                      _selectedGender.isEmpty
                                  ? 'Choose a gender.'
                                  : null,
                            ),
                          ] else
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: ProfileCompletionDateField(
                                    label: 'Date of Birth',
                                    controller: _dateController,
                                    scale: scale,
                                    onTap: _pickDate,
                                    errorText: _dateError(),
                                  ),
                                ),
                                SizedBox(width: (16 * scale).clamp(12.0, 20.0)),
                                Expanded(
                                  child: ProfileCompletionGenderField(
                                    label: 'Gender',
                                    options: _genderOptions,
                                    value: _selectedGender,
                                    scale: scale,
                                    onChanged: (String? v) {
                                      if (v == null) return;
                                      setState(() => _selectedGender = v);
                                    },
                                    errorText:
                                        _showValidationErrors &&
                                            _selectedGender.isEmpty
                                        ? 'Choose a gender.'
                                        : null,
                                  ),
                                ),
                              ],
                            ),
                          SizedBox(height: sectionSpacing),

                          // Governorate + location row
                          if (useWideRows)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: ProfileCompletionGovernorateField(
                                    label: 'Governorate',
                                    selectedGovernorate:
                                        _selectedGovernorate.isEmpty
                                        ? null
                                        : _selectedGovernorate,
                                    scale: scale,
                                    onChanged: (String v) {
                                      setState(() => _selectedGovernorate = v);
                                    },
                                    errorText: _governorateError(),
                                  ),
                                ),
                                SizedBox(width: (16 * scale).clamp(12.0, 20.0)),
                                Expanded(
                                  child: ProfileCompletionLocationField(
                                    label: 'Preferred Pitch Location',
                                    controller: _locationController,
                                    placeholder: 'Pick on map',
                                    scale: scale,
                                    onMapTap: _openLocationPicker,
                                    errorText: _locationError(),
                                  ),
                                ),
                              ],
                            )
                          else ...<Widget>[
                            ProfileCompletionGovernorateField(
                              label: 'Governorate',
                              selectedGovernorate: _selectedGovernorate.isEmpty
                                  ? null
                                  : _selectedGovernorate,
                              scale: scale,
                              onChanged: (String v) {
                                setState(() => _selectedGovernorate = v);
                              },
                              errorText: _governorateError(),
                            ),
                            SizedBox(height: sectionSpacing),
                            ProfileCompletionLocationField(
                              label: 'Preferred Pitch Location',
                              controller: _locationController,
                              placeholder: 'Pick on map',
                              scale: scale,
                              onMapTap: _openLocationPicker,
                              errorText: _locationError(),
                            ),
                          ],
                          SizedBox(height: (12 * scale).clamp(10.0, 14.0)),
                          ProfileCompletionMapCard(
                            badgeText: _selectedLat != null
                                ? 'Selected Location'
                                : 'Tap to Pick Location',
                            scale: scale,
                            latitude: _selectedLat,
                            longitude: _selectedLng,
                            onTap: _openLocationPicker,
                          ),
                          SizedBox(height: (28 * scale).clamp(24.0, 34.0)),
                          ProfileCompletionPrivacyToggle(
                            title: 'Public Profile',
                            subtitle: 'Allow squads to find you',
                            value: _isPublicProfile,
                            scale: scale,
                            onChanged: (bool v) =>
                                setState(() => _isPublicProfile = v),
                          ),
                        ],
                      ),
                    ),

                    // Sticky footer button
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(
                          horizontalPadding,
                          (24 * scale).clamp(16.0, 28.0),
                          horizontalPadding,
                          safeBottom + (20 * scale).clamp(14.0, 24.0),
                        ),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: <Color>[
                              Color(0x00F8F9FA),
                              AuthColors.surface,
                              AuthColors.surface,
                            ],
                            stops: <double>[0.0, 0.35, 1.0],
                          ),
                        ),
                        child: ProfileCompletionActionButton(
                          label: _isSubmitting ? 'Saving…' : 'CONTINUE',
                          scale: scale,
                          onPressed: _isSubmitting ? null : _onComplete,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
