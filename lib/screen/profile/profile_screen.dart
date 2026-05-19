// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

// ── ADDED NETWORK IMPORTS ──
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfileScreen extends StatefulWidget {
  final String patientName, firstName, lastName, contactNo;

  final Uint8List? profileImageBytes;
  final Function(Uint8List?)? onImageChanged;
  final Function(bool)? onThemeChanged;

  const ProfileScreen({
    super.key,
    required this.patientName,
    required this.firstName,
    required this.lastName,
    required this.contactNo,
    this.profileImageBytes,
    this.onImageChanged,
    this.onThemeChanged,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  bool _isEditing = false;
  bool _isSaving = false; // Tracks API request status
  late bool _isDarkMode;

  late TextEditingController _usernameCtrl, _contactCtrl;

  Uint8List? _profileImageBytes;
  final ImagePicker _picker = ImagePicker();

  // ── LOCAL PALETTE ──
  static const Color _goldPrimary = Color(0xFFB59410);
  static const Color _goldMid = Color(0xFFD4AF37);
  static const Color _goldDeep = Color(0xFFB88A44);
  static const Color _goldShine = Color(0xFFF0D86C);

  bool get isDark => _isDarkMode;
  Color get bg => isDark ? const Color(0xFF1A160F) : const Color(0xFFF9F9F9);
  Color get cardBg => isDark ? const Color(0xFF262016) : Colors.white;
  Color get innerSurface =>
      isDark ? const Color(0xFF332B1E) : const Color(0xFFFAF6EE);
  Color get ink => isDark ? const Color(0xFFFAF6EE) : const Color(0xFF2C2410);
  Color get inkMuted =>
      isDark ? const Color(0xFFA6967A) : const Color(0xFF8A7A5A);
  Color get bdr =>
      isDark ? const Color(0xFF403626) : _goldMid.withOpacity(0.20);
  LinearGradient get goldGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [_goldDeep, _goldMid, _goldShine, _goldMid],
    stops: [0.0, 0.35, 0.65, 1.0],
  );

  @override
  void initState() {
    super.initState();
    _isDarkMode = false;
    _profileImageBytes = widget.profileImageBytes;

    _usernameCtrl = TextEditingController(text: widget.patientName);
    _contactCtrl = TextEditingController(text: widget.contactNo);
  }

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _contactCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() => _profileImageBytes = bytes);

      if (widget.onImageChanged != null) {
        widget.onImageChanged!(bytes);
      }

      HapticFeedback.mediumImpact();
    }
  }

  // ── UPDATED HTTP UPDATE LOGIC BASED ON SWAGGER ──
  Future<void> _updateProfile() async {
    if (_usernameCtrl.text.trim().isEmpty || _contactCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Fields cannot be empty', style: GoogleFonts.dmSans()),
          backgroundColor: Colors.redAccent.shade200,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);
    HapticFeedback.lightImpact();

    try {
      // Pointing directly to the PUT /Patient endpoint seen in your Swagger UI
      final url = Uri.parse('http://10.119.199.210:5000/Patient');

      final response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          // Make sure these property names perfectly match your C# Patient DTO!
          "patientName": widget.patientName,
          "username": _usernameCtrl.text.trim(),
          "contactNumber": _contactCtrl.text.trim(),
        }),
      );

      if (!mounted) return;

      if (response.statusCode == 200 || response.statusCode == 204) {
        setState(() => _isEditing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Profile updated successfully!',
              style: GoogleFonts.dmSans(fontWeight: FontWeight.w600),
            ),
            backgroundColor: Colors.green.shade600,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to update. Error: ${response.statusCode}',
              style: GoogleFonts.dmSans(),
            ),
            backgroundColor: Colors.redAccent.shade200,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Connection error. Is the API running?',
            style: GoogleFonts.dmSans(),
          ),
          backgroundColor: Colors.redAccent.shade200,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(brightness: isDark ? Brightness.dark : Brightness.light),
      child: Scaffold(
        backgroundColor: bg,
        body: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 250,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      _goldPrimary.withOpacity(isDark ? 0.15 : 0.08),
                      bg.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),
            ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(
                top: 80,
                bottom: 120,
                left: 20,
                right: 20,
              ),
              children: [
                _buildHeader(),
                const SizedBox(height: 32),
                _buildHeroCard(),
                const SizedBox(height: 32),

                _sectionLabel('Personal Details'),
                const SizedBox(height: 12),
                _buildCard([
                  _row(
                    Icons.person_rounded,
                    'First Name',
                    widget.firstName,
                    true,
                  ),
                  Divider(height: 1, color: bdr, indent: 64),
                  _row(
                    Icons.person_outline_rounded,
                    'Last Name',
                    widget.lastName,
                    true,
                  ),
                ]),
                const SizedBox(height: 32),

                _sectionLabel('Account Settings'),
                const SizedBox(height: 12),
                _buildCard([
                  _editRow(
                    Icons.alternate_email_rounded,
                    'Username',
                    _usernameCtrl,
                  ),
                  Divider(height: 1, color: bdr, indent: 64),
                  _editRow(
                    Icons.phone_rounded,
                    'Contact Number',
                    _contactCtrl,
                    TextInputType.phone,
                  ),
                  Divider(height: 1, color: bdr, indent: 64),
                  _row(
                    Icons.lock_outline_rounded,
                    'Password',
                    '••••••••',
                    true,
                  ),
                ]),
                const SizedBox(height: 32),

                _sectionLabel('General Settings'),
                const SizedBox(height: 12),
                _buildCard([_darkModeToggle()]),
              ],
            ),
            if (_isEditing) _buildSaveBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'My Profile',
            style: GoogleFonts.dmSans(
              color: ink,
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            'Manage personal information',
            style: GoogleFonts.dmSans(color: inkMuted, fontSize: 14),
          ),
        ],
      ),
    ],
  );

  Widget _buildHeroCard() => Container(
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: cardBg,
      borderRadius: BorderRadius.circular(32),
      border: Border.all(color: bdr),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(isDark ? 0.2 : 0.03),
          blurRadius: 15,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: Column(
      children: [
        Container(
          width: 110,
          height: 110,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: innerSurface,
            border: Border.all(color: _goldMid.withOpacity(0.4), width: 3),
          ),
          child: ClipOval(
            child: _profileImageBytes != null
                ? Image.memory(
                    _profileImageBytes!,
                    fit: BoxFit.cover,
                    width: 110,
                    height: 110,
                  )
                : Container(
                    decoration: BoxDecoration(gradient: goldGradient),
                    child: Center(
                      child: Text(
                        '${widget.firstName[0]}${widget.lastName[0]}',
                        style: GoogleFonts.dmSans(
                          fontSize: 36,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          '${widget.firstName} ${widget.lastName}',
          style: GoogleFonts.dmSans(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: ink,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _goldPrimary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'Verified Patient',
            style: GoogleFonts.dmSans(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: _goldPrimary,
            ),
          ),
        ),
        const SizedBox(height: 24),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: innerSurface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: bdr),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.camera_alt_rounded, color: ink, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        'Set Photo',
                        style: GoogleFonts.dmSans(
                          color: ink,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _isEditing = true),
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: _goldPrimary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.edit_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Edit Profile',
                        style: GoogleFonts.dmSans(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );

  Widget _buildCard(List<Widget> children) => Container(
    decoration: BoxDecoration(
      color: cardBg,
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: bdr),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(isDark ? 0.2 : 0.03),
          blurRadius: 15,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: Column(children: children),
  );

  Widget _darkModeToggle() => Padding(
    padding: const EdgeInsets.all(16),
    child: Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: innerSurface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
            color: inkMuted,
            size: 20,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dark Mode',
                style: GoogleFonts.dmSans(
                  fontSize: 15,
                  color: ink,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'Switch to dark theme',
                style: GoogleFonts.dmSans(fontSize: 12, color: inkMuted),
              ),
            ],
          ),
        ),
        Switch(
          value: _isDarkMode,
          activeColor: Colors.white,
          activeTrackColor: _goldPrimary,
          inactiveTrackColor: isDark
              ? Colors.grey.shade800
              : Colors.grey.shade300,
          onChanged: (v) {
            setState(() => _isDarkMode = v);
            if (widget.onThemeChanged != null) widget.onThemeChanged!(v);
          },
        ),
      ],
    ),
  );

  Widget _buildSaveBar() => Positioned(
    bottom: 0,
    left: 0,
    right: 0,
    child: Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBg,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.4 : 0.05),
            offset: const Offset(0, -5),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                // Revert changes if they cancel
                _usernameCtrl.text = widget.patientName;
                _contactCtrl.text = widget.contactNo;
                setState(() => _isEditing = false);
              },
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  color: innerSurface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: bdr),
                ),
                child: Center(
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.dmSans(
                      color: inkMuted,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: _isSaving
                  ? null
                  : _updateProfile, // ── TRIGGERS HTTP CALL ──
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  gradient: goldGradient,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: _isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : Text(
                          'Save Changes',
                          style: GoogleFonts.dmSans(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );

  Widget _sectionLabel(String t) => Row(
    children: [
      Container(
        width: 4,
        height: 16,
        decoration: BoxDecoration(
          gradient: goldGradient,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
      const SizedBox(width: 8),
      Text(
        t,
        style: GoogleFonts.dmSans(
          fontSize: 15,
          fontWeight: FontWeight.w800,
          color: ink,
        ),
      ),
    ],
  );

  Widget _row(IconData i, String l, String v, bool f) => Padding(
    padding: const EdgeInsets.all(16),
    child: Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: innerSurface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(i, color: inkMuted, size: 20),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l, style: GoogleFonts.dmSans(fontSize: 12, color: inkMuted)),
            Text(
              v,
              style: GoogleFonts.dmSans(
                color: ink,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const Spacer(),
        if (f)
          Icon(
            Icons.lock_outline_rounded,
            size: 16,
            color: inkMuted.withOpacity(0.5),
          ),
      ],
    ),
  );

  Widget _editRow(
    IconData i,
    String l,
    TextEditingController c, [
    TextInputType t = TextInputType.text,
  ]) => Padding(
    padding: const EdgeInsets.all(16),
    child: Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: innerSurface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(i, color: inkMuted, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l, style: GoogleFonts.dmSans(fontSize: 12, color: inkMuted)),
              _isEditing
                  ? TextField(
                      controller: c,
                      keyboardType: t,
                      style: GoogleFonts.dmSans(
                        color: ink,
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                      decoration: const InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                      ),
                    )
                  : Text(
                      c.text,
                      style: GoogleFonts.dmSans(
                        color: ink,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ],
          ),
        ),
      ],
    ),
  );
}
