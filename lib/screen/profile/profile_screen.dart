import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final String patientName, firstName, lastName, contactNo;
  const ProfileScreen({
    super.key,
    required this.patientName,
    required this.firstName,
    required this.lastName,
    required this.contactNo,
  });
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  bool _isEditing = false;
  bool _obscurePassword = true;

  late TextEditingController _usernameCtrl, _passwordCtrl, _contactCtrl;
  late String _origUsername, _origPassword, _origContact;
  late final String _firstName, _lastName;

  // ── ✨ LUXURY GOLD THEME ──
  final Color goldPrimary = const Color(0xFFD4AF37);
  final Color goldDark = const Color(0xFFA67C00);
  final Color goldLight = const Color(0xFFF9E4B7);

  bool get isDark => Theme.of(context).brightness == Brightness.dark;
  Color get bg => isDark ? const Color(0xFF0F172A) : Colors.white;
  Color get card => isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC);
  Color get surface =>
      isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9);
  Color get text => isDark ? Colors.white : const Color(0xFF1E293B);
  Color get textMuted =>
      isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
  Color get border =>
      isDark ? const Color(0xFF475569) : const Color(0xFFE2E8F0);
  Color get danger => const Color(0xFFEF4444);
  Color get success => const Color(0xFF10B981);

  @override
  void initState() {
    super.initState();
    _firstName = widget.firstName;
    _lastName = widget.lastName;
    _usernameCtrl = TextEditingController(text: widget.patientName);
    _passwordCtrl = TextEditingController(text: '********');
    _contactCtrl = TextEditingController(text: widget.contactNo);
    _origUsername = widget.patientName;
    _origPassword = '********';
    _origContact = widget.contactNo;
  }

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    _contactCtrl.dispose();
    super.dispose();
  }

  Widget _pad(Widget w) =>
      Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: w);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bg,
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(top: 115, bottom: 100),
        children: [
          _pad(
            Text(
              'My Profile',
              style: TextStyle(
                color: text,
                fontSize: 26,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
              ),
            ),
          ),
          _pad(
            Text(
              'Manage your personal information',
              style: TextStyle(
                color: textMuted,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 32),

          _avatarSection(),
          const SizedBox(height: 32),

          _pad(_sectionLabel('Personal Details')),
          const SizedBox(height: 16),
          _pad(
            _readOnlyCard(
              Icons.person_rounded,
              'First Name',
              _firstName,
              goldDark,
            ),
          ),
          const SizedBox(height: 12),
          _pad(
            _readOnlyCard(
              Icons.person_outline_rounded,
              'Last Name',
              _lastName,
              goldDark,
            ),
          ),

          const SizedBox(height: 32),
          _pad(_sectionLabel('Account Settings')),
          const SizedBox(height: 16),
          _pad(
            _editableCard(
              Icons.alternate_email_rounded,
              'Username',
              _usernameCtrl,
              TextInputType.text,
              goldPrimary,
            ),
          ),
          const SizedBox(height: 12),
          _pad(
            _editableCard(
              Icons.phone_rounded,
              'Contact Number',
              _contactCtrl,
              TextInputType.phone,
              goldPrimary,
            ),
          ),
          const SizedBox(height: 12),
          _pad(_passwordCard()),

          const SizedBox(height: 40),
          _pad(_actionButtons()),
        ],
      ),
    );
  }

  Widget _avatarSection() => Center(
    child: Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          width: 110,
          height: 110,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(colors: [goldPrimary, goldDark]),
            border: Border.all(color: bg, width: 4),
            boxShadow: [
              BoxShadow(
                color: goldDark.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Center(
            child: Text(
              '${_firstName[0]}${_lastName[0]}',
              style: const TextStyle(
                fontSize: 38,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ),
        ),
        if (_isEditing)
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: card,
              shape: BoxShape.circle,
              border: Border.all(color: goldPrimary),
            ),
            child: Icon(Icons.camera_alt_rounded, size: 18, color: goldDark),
          ),
      ],
    ),
  );

  Widget _sectionLabel(String title) => Row(
    children: [
      Container(
        width: 4,
        height: 18,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [goldPrimary, goldDark]),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
      const SizedBox(width: 10),
      Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: text,
        ),
      ),
    ],
  );

  Widget _readOnlyCard(IconData icon, String label, String val, Color col) =>
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: border),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: col.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: col, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      color: col,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    val,
                    style: TextStyle(
                      color: text,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Fixed',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: textMuted,
                ),
              ),
            ),
          ],
        ),
      );

  Widget _editableCard(
    IconData icon,
    String label,
    TextEditingController ctrl,
    TextInputType type,
    Color col,
  ) => AnimatedContainer(
    duration: const Duration(milliseconds: 250),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: card,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: _isEditing ? goldPrimary : border,
        width: _isEditing ? 1.5 : 1,
      ),
      boxShadow: _isEditing
          ? [BoxShadow(color: goldPrimary.withOpacity(0.1), blurRadius: 12)]
          : null,
    ),
    child: Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: goldPrimary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: goldDark, size: 22),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: goldDark,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              _isEditing
                  ? TextField(
                      controller: ctrl,
                      keyboardType: type,
                      style: TextStyle(
                        color: text,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      decoration: const InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                    )
                  : Text(
                      ctrl.text,
                      style: TextStyle(
                        color: text,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ],
          ),
        ),
        Icon(
          _isEditing ? Icons.edit_rounded : Icons.chevron_right_rounded,
          color: _isEditing ? goldPrimary : textMuted,
          size: 18,
        ),
      ],
    ),
  );

  Widget _passwordCard() => AnimatedContainer(
    duration: const Duration(milliseconds: 250),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: card,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: _isEditing ? goldPrimary : border),
    ),
    child: Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: goldPrimary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(Icons.lock_rounded, color: goldDark, size: 22),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Password',
                style: TextStyle(
                  fontSize: 12,
                  color: goldDark,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              _isEditing
                  ? TextField(
                      controller: _passwordCtrl,
                      obscureText: _obscurePassword,
                      style: TextStyle(
                        color: text,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      decoration: const InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                    )
                  : Text(
                      '••••••••',
                      style: TextStyle(
                        color: text,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
            ],
          ),
        ),
        if (_isEditing)
          IconButton(
            icon: Icon(
              _obscurePassword
                  ? Icons.visibility_off_rounded
                  : Icons.visibility_rounded,
              color: goldPrimary,
              size: 20,
            ),
            onPressed: () =>
                setState(() => _obscurePassword = !_obscurePassword),
          )
        else
          Icon(Icons.chevron_right_rounded, color: textMuted, size: 18),
      ],
    ),
  );

  Widget _actionButtons() => Column(
    children: [
      if (_isEditing) ...[
        ElevatedButton(
          onPressed: _saveProfile,
          style: ElevatedButton.styleFrom(
            backgroundColor: goldDark,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: const Text(
            'SAVE CHANGES',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
          ),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: _cancelEdit,
          child: Text(
            'Cancel',
            style: TextStyle(color: danger, fontWeight: FontWeight.bold),
          ),
        ),
      ] else
        ElevatedButton.icon(
          onPressed: () => setState(() => _isEditing = true),
          icon: const Icon(Icons.edit_rounded, color: Colors.white, size: 18),
          label: const Text(
            'EDIT PROFILE',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: goldDark,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
    ],
  );

  void _saveProfile() {
    setState(() => _isEditing = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Profile updated!',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _cancelEdit() {
    setState(() {
      _usernameCtrl.text = _origUsername;
      _passwordCtrl.text = _origPassword;
      _contactCtrl.text = _origContact;
      _isEditing = false;
    });
  }
}
