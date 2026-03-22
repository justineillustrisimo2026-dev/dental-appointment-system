import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final String patientName;
  final String firstName;
  final String lastName;
  final String contactNo;

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
    with TickerProviderStateMixin {
  bool _isEditing = false;
  bool _obscurePassword = true;

  // Editable fields
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late TextEditingController _contactController;

  // Non-editable fields
  late final String _firstName;
  late final String _lastName;

  // Store original values
  late String _originalUsername;
  late String _originalPassword;
  late String _originalContact;

  @override
  void initState() {
    super.initState();
    _firstName = widget.firstName;
    _lastName = widget.lastName;

    _usernameController = TextEditingController(text: widget.patientName);
    _passwordController = TextEditingController(text: '********');
    _contactController = TextEditingController(text: widget.contactNo);

    _originalUsername = widget.patientName;
    _originalPassword = '********';
    _originalContact = widget.contactNo;
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _saveProfile() {
    bool hasChanges =
        _usernameController.text != _originalUsername ||
        _passwordController.text != _originalPassword ||
        _contactController.text != _originalContact;

    if (!hasChanges) {
      setState(() {
        _isEditing = false;
      });
      return;
    }

    setState(() {
      _originalUsername = _usernameController.text;
      _originalPassword = _passwordController.text;
      _originalContact = _contactController.text;
      _isEditing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text('Profile updated successfully!'),
          ],
        ),
        backgroundColor: const Color(0xFF4A6FA5),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );
  }

  void _showCancelDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
        title: const Text('Discard Changes?'),
        content: const Text(
          'Are you sure you want to cancel editing? Your changes will not be saved.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF4A6FA5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text('Continue Editing'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _usernameController.text = _originalUsername;
                _passwordController.text = _originalPassword;
                _contactController.text = _originalContact;
                _isEditing = false;
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text('Discard'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Container(
    color: const Color.fromARGB(255, 255, 255, 255),
    child: CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(child: _buildHeader()),
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 40),
              _buildNameDisplay(),
              const SizedBox(height: 8),
              _buildUsernameDisplay(),
              const SizedBox(height: 30),
              _buildInfoCards(),
              const SizedBox(height: 20),
              _buildActionButtons(), // Edit button at the bottom after password
              const SizedBox(height: 30),
            ]),
          ),
        ),
      ],
    ),
  );

  Widget _buildHeader() => Stack(
    clipBehavior: Clip.none,
    children: [
      Container(
        height: 180,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF4A6FA5),
              const Color(0xFF6B8EC9),
              const Color(0xFF8AAEE0),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(50),
            bottomRight: Radius.circular(50),
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4A6FA5).withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 40, 24, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'My Profile',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Manage your account information',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.person, color: Colors.white, size: 28),
              ),
            ],
          ),
        ),
      ),
      Positioned(
        bottom: -50,
        left: 0,
        right: 0,
        child: Center(child: _buildProfileAvatar()),
      ),
    ],
  );

  Widget _buildProfileAvatar() => Container(
    width: 120,
    height: 120,
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFF4A6FA5), Color(0xFF6B8EC9)],
      ),
      shape: BoxShape.circle,
      border: Border.all(color: Colors.white, width: 4),
      boxShadow: [
        BoxShadow(
          color: const Color(0xFF4A6FA5).withOpacity(0.3),
          blurRadius: 15,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: Center(
      child: Text(
        '${_firstName[0]}${_lastName[0]}',
        style: const TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ),
  );

  Widget _buildNameDisplay() => Text(
    '$_firstName $_lastName',
    style: const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Color(0xFF1E293B),
    ),
    textAlign: TextAlign.center,
  );

  Widget _buildUsernameDisplay() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    decoration: BoxDecoration(
      color: const Color(0xFF4A6FA5).withOpacity(0.1),
      borderRadius: BorderRadius.circular(30),
      border: Border.all(
        color: const Color(0xFF4A6FA5).withOpacity(0.3),
        width: 1,
      ),
    ),
    child: Text(
      '@${_usernameController.text}',
      style: const TextStyle(
        color: Color(0xFF4A6FA5),
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    ),
  );

  Widget _buildInfoCards() => Column(
    children: [
      _buildInfoCard(
        icon: Icons.person_outline,
        label: 'First Name',
        value: _firstName,
        color: const Color(0xFF4A6FA5),
      ),
      const SizedBox(height: 12),
      _buildInfoCard(
        icon: Icons.person,
        label: 'Last Name',
        value: _lastName,
        color: const Color(0xFF6B8EC9),
      ),
      const SizedBox(height: 12),
      _buildEditableCard(
        icon: Icons.account_circle_outlined,
        label: 'Username',
        controller: _usernameController,
        isEditable: _isEditing,
        color: const Color(0xFF8AAEE0),
      ),
      const SizedBox(height: 12),
      _buildEditableCard(
        icon: Icons.phone_outlined,
        label: 'Contact Number',
        controller: _contactController,
        isEditable: _isEditing,
        keyboardType: TextInputType.phone,
        color: const Color(0xFF10B981),
      ),
      const SizedBox(height: 12),
      _buildPasswordCard(
        icon: Icons.lock_outline,
        label: 'Password',
        controller: _passwordController,
        isEditable: _isEditing,
        color: const Color(0xFFF59E0B),
      ),
    ],
  );

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(25),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 15,
          offset: const Offset(0, 5),
        ),
      ],
      border: Border.all(color: color.withOpacity(0.3), width: 1.5),
    ),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withOpacity(0.2), width: 1),
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: color.withOpacity(0.8),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _buildEditableCard({
    required IconData icon,
    required String label,
    required TextEditingController controller,
    required bool isEditable,
    required Color color,
    TextInputType keyboardType = TextInputType.text,
  }) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(25),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 15,
          offset: const Offset(0, 5),
        ),
      ],
      border: Border.all(
        color: isEditable ? color : color.withOpacity(0.3),
        width: isEditable ? 2 : 1.5,
      ),
    ),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withOpacity(0.2), width: 1),
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: color.withOpacity(0.8),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 6),
              isEditable
                  ? TextField(
                      controller: controller,
                      keyboardType: keyboardType,
                      decoration: InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        hintText: 'Enter $label',
                        hintStyle: const TextStyle(
                          color: Color(0xFF94A3B8),
                          fontSize: 16,
                        ),
                        contentPadding: EdgeInsets.zero,
                      ),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E293B),
                      ),
                    )
                  : Text(
                      controller.text,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E293B),
                      ),
                    ),
            ],
          ),
        ),
        if (isEditable)
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: color.withOpacity(0.2), width: 1),
            ),
            child: Icon(Icons.edit, color: color, size: 20),
          ),
      ],
    ),
  );

  Widget _buildPasswordCard({
    required IconData icon,
    required String label,
    required TextEditingController controller,
    required bool isEditable,
    required Color color,
  }) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(25),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 15,
          offset: const Offset(0, 5),
        ),
      ],
      border: Border.all(
        color: isEditable ? color : color.withOpacity(0.3),
        width: isEditable ? 2 : 1.5,
      ),
    ),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withOpacity(0.2), width: 1),
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: color.withOpacity(0.8),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 6),
              isEditable
                  ? TextField(
                      controller: controller,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        hintText: 'Enter new password',
                        hintStyle: const TextStyle(
                          color: Color(0xFF94A3B8),
                          fontSize: 16,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: color,
                            size: 22,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        contentPadding: EdgeInsets.zero,
                      ),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E293B),
                      ),
                    )
                  : const Text(
                      '••••••••',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E293B),
                      ),
                    ),
            ],
          ),
        ),
        if (isEditable)
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: color.withOpacity(0.2), width: 1),
            ),
            child: Icon(Icons.edit, color: color, size: 20),
          ),
      ],
    ),
  );

  Widget _buildActionButtons() => Column(
    children: [
      if (_isEditing)
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 12),
          child: TextButton.icon(
            onPressed: _showCancelDialog,
            icon: const Icon(Icons.close, color: Colors.red, size: 20),
            label: const Text(
              'Cancel',
              style: TextStyle(
                color: Colors.red,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              side: const BorderSide(color: Colors.red, width: 1.5),
            ),
          ),
        ),
      Container(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: _isEditing ? _saveProfile : _toggleEdit,
          icon: Icon(_isEditing ? Icons.save : Icons.edit, size: 20),
          label: Text(
            _isEditing ? 'Save Changes' : 'Edit Profile',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4A6FA5),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            elevation: 3,
          ),
        ),
      ),
    ],
  );

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _contactController.dispose();
    super.dispose();
  }
}
