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

  // ── ☀️ DYNAMIC THEMED (Matches Dashboard Automatically) ──
  bool get isDark => Theme.of(context).brightness == Brightness.dark;

  // ── PREMIUM SLATE BLUE DARK MODE ──
  Color get bg => isDark ? const Color(0xFF0F172A) : const Color(0xFFF4F6F9);
  Color get card => isDark ? const Color(0xFF1E293B) : Colors.white;
  Color get surface =>
      isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
  Color get text => isDark ? const Color(0xFFF8FAFC) : const Color(0xFF1E293B);
  Color get textMuted =>
      isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
  Color get border =>
      isDark ? const Color(0xFF475569) : const Color(0xFFE2E8F0);

  Color get primary => const Color(0xFF4A6CF7);
  Color get accent => const Color(0xFF00D4FF);
  Color get success => const Color(0xFF10B981);
  Color get danger => const Color(0xFFEF4444);
  Color get warning => const Color(0xFFF59E0B);

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
                fontSize: 24,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
              ),
            ),
          ),
          const SizedBox(height: 4),
          _pad(
            Text(
              'Manage your account info cleanly',
              style: TextStyle(
                color: textMuted,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 32),

          _avatarSection(),
          const SizedBox(height: 32),

          _pad(_sectionLabel('Personal Information')),
          const SizedBox(height: 16),
          _pad(
            _readOnlyCard(
              Icons.person_rounded,
              'First Name',
              _firstName,
              primary,
            ),
          ),
          const SizedBox(height: 12),
          _pad(
            _readOnlyCard(
              Icons.person_outline_rounded,
              'Last Name',
              _lastName,
              primary,
            ),
          ),

          const SizedBox(height: 32),
          _pad(_sectionLabel('Account Details')),
          const SizedBox(height: 16),
          _pad(
            _editableCard(
              Icons.alternate_email_rounded,
              'Username',
              _usernameCtrl,
              TextInputType.text,
              accent,
            ),
          ),
          const SizedBox(height: 12),

          // CHANGED: "success" is now "accent" to match Username!
          _pad(
            _editableCard(
              Icons.phone_rounded,
              'Contact',
              _contactCtrl,
              TextInputType.phone,
              accent,
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

  // ── CORE COMPONENTS ─────────────────────────────────────────────────────────────

  Widget _avatarSection() => Center(
    child: Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          width: 104,
          height: 104,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(colors: [primary, accent]),
            border: Border.all(color: bg, width: 4),
            boxShadow: [
              BoxShadow(
                color: primary.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          // FIXED: Now correctly pulls the first letter of both the first and last name!
          child: Center(
            child: Text(
              '${_firstName[0]}${_lastName[0]}',
              style: const TextStyle(
                fontSize: 36,
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
              border: Border.all(color: border),
            ),
            child: Icon(Icons.camera_alt_rounded, size: 16, color: primary),
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
          gradient: LinearGradient(
            colors: [primary, accent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
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
                color: col.withOpacity(0.15),
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
        color: _isEditing ? col.withOpacity(0.5) : border,
        width: _isEditing ? 1.5 : 1,
      ),
      boxShadow: _isEditing
          ? [BoxShadow(color: col.withOpacity(0.1), blurRadius: 12)]
          : null,
    ),
    child: Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: col.withOpacity(0.15),
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
          color: _isEditing ? col : textMuted,
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
      border: Border.all(
        color: _isEditing ? accent.withOpacity(0.5) : border,
        width: _isEditing ? 1.5 : 1,
      ),
      boxShadow: _isEditing
          ? [BoxShadow(color: accent.withOpacity(0.1), blurRadius: 12)]
          : null,
    ),
    child: Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: accent.withOpacity(0.15),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(Icons.lock_rounded, color: accent, size: 22),
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
                  color: accent,
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
          GestureDetector(
            onTap: () => setState(() => _obscurePassword = !_obscurePassword),
            child: Icon(
              _obscurePassword
                  ? Icons.visibility_off_rounded
                  : Icons.visibility_rounded,
              color: accent,
              size: 20,
            ),
          )
        else
          Icon(Icons.chevron_right_rounded, color: textMuted, size: 18),
      ],
    ),
  );

  Widget _actionButtons() => Column(
    children: [
      if (_isEditing) ...[
        GestureDetector(
          onTap: _cancelEdit,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: danger.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: danger.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.close_rounded, color: danger, size: 18),
                const SizedBox(width: 8),
                Text(
                  'Cancel',
                  style: TextStyle(color: danger, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
      ],
      GestureDetector(
        onTap: _isEditing
            ? _saveProfile
            : () => setState(() => _isEditing = true),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [primary, accent]),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: primary.withOpacity(0.3),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _isEditing ? Icons.save_rounded : Icons.edit_rounded,
                color: Colors.white,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                _isEditing ? 'Save Changes' : 'Edit Profile',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );

  // ── LOGIC OPERATIONS ────────────────────────────────────────────────────────────

  void _saveProfile() {
    final changed =
        _usernameCtrl.text != _origUsername ||
        _passwordCtrl.text != _origPassword ||
        _contactCtrl.text != _origContact;
    if (changed) {
      _origUsername = _usernameCtrl.text;
      _origPassword = _passwordCtrl.text;
      _origContact = _contactCtrl.text;
    }
    setState(() => _isEditing = false);
    if (changed) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
              SizedBox(width: 8),
              Text(
                'Profile updated successfully!',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          backgroundColor: success,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _cancelEdit() => showDialog(
    context: context,
    builder: (_) => Dialog(
      backgroundColor: card,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: danger.withOpacity(0.1),
              child: Icon(Icons.edit_off_rounded, color: danger, size: 30),
            ),
            const SizedBox(height: 16),
            Text(
              'Discard Changes?',
              style: TextStyle(
                color: text,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your unsaved changes will be lost.',
              textAlign: TextAlign.center,
              style: TextStyle(color: textMuted),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Keep Editing',
                      style: TextStyle(
                        color: textMuted,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _usernameCtrl.text = _origUsername;
                        _passwordCtrl.text = _origPassword;
                        _contactCtrl.text = _origContact;
                        _isEditing = false;
                      });
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: danger,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      'Discard',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
