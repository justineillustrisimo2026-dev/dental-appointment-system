// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'app_theme.dart';

// ── DATA MODELS: Blueprints for ClinicService and DentistInfo objects. ──
class ClinicService {
  final String id, name, description, price, duration;
  final String imagePath;
  const ClinicService(
    this.id,
    this.name,
    this.description,
    this.price,
    this.duration,
    this.imagePath,
  );
}

class DentistInfo {
  final String id, name, specialty, bio;
  final List<String> services;
  final String imagePath;
  const DentistInfo(
    this.id,
    this.name,
    this.specialty,
    this.bio,
    this.services,
    this.imagePath,
  );
}

// ── MAIN SCREEN SETUP: Receives patient data theme and manages the booking flow. ──
class ServicesScreen extends StatefulWidget {
  final List<Map<String, dynamic>> appointments;
  final Function(Map<String, dynamic>) onBookAppointment;
  final String patientName, firstName, lastName, contactNo;
  final bool isDarkMode;

  const ServicesScreen({
    super.key,
    required this.appointments,
    required this.onBookAppointment,
    required this.patientName,
    required this.firstName,
    required this.lastName,
    required this.contactNo,
    required this.isDarkMode,
  });

  @override
  State<ServicesScreen> createState() => ServicesScreenState();
}

class ServicesScreenState extends State<ServicesScreen>
    with TickerProviderStateMixin {
  // ── ANIMATION & UI CONTROLLERS: Manages page transitions, fades, and pulse effects. ──
  final PageController _pageController = PageController();
  late AnimationController _fadeCtrl;
  late Animation<double> _fadeAnim;
  late AnimationController _pulseCtrl;

  // ── STATE VARIABLES: Tracks current step and search inputs. ──
  int _currentStep = 0;
  String _searchQuery = '';

  // ── PATIENT DETAIL CONTROLLERS: Text controllers for Step 4 patient info. ──
  final TextEditingController _fullNameCtrl = TextEditingController();
  final TextEditingController _ageCtrl = TextEditingController();
  final TextEditingController _contactCtrl = TextEditingController();

  // ── DYNAMIC THEME GETTERS: Handles automatic switching between light and dark mode colors. ──
  Color get bg => AppTheme.bg(widget.isDarkMode);
  Color get surface => AppTheme.surface(widget.isDarkMode);
  Color get cardBg => AppTheme.cardBg(widget.isDarkMode);
  Color get innerSurface => AppTheme.innerSurface(widget.isDarkMode);
  Color get ink => AppTheme.txt(widget.isDarkMode);
  Color get inkMuted => AppTheme.txtMuted(widget.isDarkMode);
  Color get bdr => AppTheme.bdr(widget.isDarkMode);
  LinearGradient get goldGradient => AppTheme.goldGradient;
  List<BoxShadow> get profileShadow =>
      AppTheme.profileShadow(widget.isDarkMode);

  // ── MOCK DATABASE: Hardcoded lists of services, dentists, and time slots. ──
  final List<ClinicService> _allServices = const [
    ClinicService(
      "consultation",
      "Consultation",
      "Discuss oral health concerns with the dentist.",
      "₱500",
      "30 mins",
      "assets/consultation1.jpg",
    ),
    ClinicService(
      "xray",
      "Panoramic X-ray",
      "Full mouth X-ray imaging.",
      "₱800",
      "15 mins",
      "assets/xray.jpg",
    ),
    ClinicService(
      "extraction",
      "Tooth Extraction",
      "Remove a damaged or problematic tooth.",
      "₱500",
      "45 mins",
      "assets/extraction.jpg",
    ),
    ClinicService(
      "cleaning",
      "Cleaning",
      "Oral Prophylaxis — professional teeth cleaning.",
      "₱600",
      "45 mins",
      "assets/cleaning.jpg",
    ),
    ClinicService(
      "filling",
      "Dental Filling",
      "Remove cavity and fill tooth with material.",
      "₱500",
      "1 hour",
      "assets/filling.jpg",
    ),
    ClinicService(
      "braces",
      "Braces Installation",
      "Install orthodontic braces.",
      "₱35,000",
      "2 hours",
      "assets/braces.jpg",
    ),
    ClinicService(
      "adjustment",
      "Braces Adjustment",
      "Monthly braces tightening.",
      "₱500",
      "30 mins",
      "assets/adjustment.jpg",
    ),
    ClinicService(
      "rootcanal",
      "Root Canal Treatment",
      "Remove infected pulp and fill root canal.",
      "₱5,000",
      "1–2 hours",
      "assets/rootcanal.jpg",
    ),
    ClinicService(
      "bleaching",
      "Teeth Bleaching",
      "Professional teeth whitening.",
      "₱3,000",
      "1 hour",
      "assets/bleaching.jpg",
    ),
    ClinicService(
      "wisdom",
      "Wisdom Tooth Extraction",
      "Third molar surgical extraction.",
      "₱2,500",
      "1 hour",
      "assets/wisdom.jpg",
    ),
    ClinicService(
      "dentures",
      "Dentures",
      "Removable replacement for missing teeth.",
      "₱15,000",
      "Multiple visits",
      "assets/dentures.jpg",
    ),
    ClinicService(
      "crown",
      "Dental Crown/Jacket",
      "A cap placed over a damaged tooth.",
      "₱8,000",
      "2 visits",
      "assets/crown.jpg",
    ),
    ClinicService(
      "bridge",
      "Dental Bridge",
      "Replace missing teeth using adjacent teeth as anchors.",
      "₱12,000",
      "2 visits",
      "assets/bridge.jpg",
    ),
  ];

  final List<DentistInfo> _dentists = const [
    DentistInfo(
      "krischelle",
      "Dr. Krischelle Ayunan",
      "Orthodontist & Endodontist",
      "Highly skilled specialist handling all comprehensive dental procedures from basic care to complex surgeries and orthodontics.",
      [
        "Consultation",
        "Panoramic X-ray",
        "Tooth Extraction",
        "Cleaning",
        "Dental Filling",
        "Braces Installation",
        "Braces Adjustment",
        "Root Canal Treatment",
        "Teeth Bleaching",
        "Wisdom Tooth Extraction",
        "Dentures",
        "Dental Crown/Jacket",
        "Dental Bridge",
      ],
      "assets/krischelle.png",
    ),
    DentistInfo(
      "clyde",
      "Dr. Clyde Cabahug",
      "General Dentist",
      "Dedicated to providing exceptional general dental care, cleanings, and restorative treatments.",
      [
        "Consultation",
        "Panoramic X-ray",
        "Tooth Extraction",
        "Cleaning",
        "Dental Filling",
        "Teeth Bleaching",
        "Dentures",
        "Dental Crown/Jacket",
        "Dental Bridge",
      ],
      "assets/clyde.png",
    ),
  ];

  final List<String> _timeSlots = const [
    "08:00 AM",
    "09:00 AM",
    "10:00 AM",
    "11:00 AM",
    "01:00 PM",
    "02:00 PM",
    "03:00 PM",
    "04:00 PM",
  ];

  // ── BOOKING SELECTION VARIABLES: Stores the user's specific choices during the booking process. ──
  ClinicService? selectedService;
  DateTime? selectedDate;
  String? selectedTime;
  DentistInfo? selectedDentist;
  int _calendarMonthOffset = 0;

  // ── LIFECYCLE: Sets up animations/text fields on init and disposes them on exit. ──
  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _fadeCtrl.forward();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    final nameStr = "${widget.firstName} ${widget.lastName}".trim();
    if (nameStr == "User Member" ||
        nameStr == "Not provided" ||
        nameStr.isEmpty) {
      _fullNameCtrl.text = "";
    } else {
      _fullNameCtrl.text = nameStr;
    }

    if (widget.contactNo == "Not provided" || widget.contactNo.isEmpty) {
      _contactCtrl.text = "";
    } else {
      _contactCtrl.text = widget.contactNo;
    }
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    _pulseCtrl.dispose();
    _pageController.dispose();
    _fullNameCtrl.dispose();
    _ageCtrl.dispose();
    _contactCtrl.dispose();
    super.dispose();
  }

  // ── EXTERNAL CONTROL LOGIC: Allows external screens to pre-select a service and jump to booking. ──
  void setInitialService(String serviceId) {
    final s = _allServices.firstWhere(
      (element) => element.id == serviceId,
      orElse: () => _allServices.first,
    );
    setState(() {
      _currentStep = 0;
      selectedService = s;
      selectedDate = null;
      selectedTime = null;
      selectedDentist = null;
      _calendarMonthOffset = 0;
      _searchQuery = '';
    });
    if (_pageController.hasClients) {
      _pageController.jumpToPage(0);
    }
    _fadeCtrl.forward(from: 0);
  }

  // ── WIZARD NAVIGATION LOGIC: Handles next/prev steps, validation, and resetting. ──
  void _nextStep() {
    HapticFeedback.lightImpact();
    _fadeCtrl.forward(from: 0);
    _pageController.nextPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
    setState(() => _currentStep++);
  }

  void _prevStep() {
    HapticFeedback.lightImpact();
    _fadeCtrl.forward(from: 0);
    _pageController.previousPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
    setState(() => _currentStep--);
  }

  bool get _canGoNext {
    if (_currentStep == 0) return selectedService != null;
    if (_currentStep == 1) return selectedDate != null && selectedTime != null;
    if (_currentStep == 2) return selectedDentist != null;
    if (_currentStep == 3) {
      return _fullNameCtrl.text.trim().isNotEmpty &&
          _ageCtrl.text.trim().isNotEmpty &&
          _contactCtrl.text.trim().length == 11 &&
          _contactCtrl.text.startsWith('09');
    }
    return false;
  }

  DateTime get _displayMonth {
    final now = DateTime.now();
    return DateTime(now.year, now.month + _calendarMonthOffset, 1);
  }

  List<ClinicService> get _filteredServices {
    if (selectedService != null) {
      return [selectedService!];
    }
    if (_searchQuery.isEmpty) return _allServices;
    return _allServices
        .where((s) => s.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  String _timeToStorage(String displayTime) {
    try {
      final parts = displayTime.split(' ');
      final timeParts = parts[0].split(':');
      int hour = int.parse(timeParts[0]);
      final minute = timeParts[1];
      final period = parts[1];
      if (period == 'PM' && hour != 12) hour += 12;
      if (period == 'AM' && hour == 12) hour = 0;
      return '${hour.toString().padLeft(2, '0')}:$minute';
    } catch (_) {
      return displayTime;
    }
  }

  void _resetBooking() {
    setState(() {
      _currentStep = 0;
      selectedService = null;
      selectedDate = null;
      selectedTime = null;
      selectedDentist = null;
      _calendarMonthOffset = 0;
      _searchQuery = '';
      _fullNameCtrl.clear();
      _contactCtrl.clear();
      _ageCtrl.clear();
    });
    if (_pageController.hasClients) {
      _pageController.jumpToPage(0);
    }
  }

  // ── MAIN BUILD METHOD: Constructs the core wizard layout (Header, PageView, BottomBar). ──
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: Column(
        children: [
          _buildHeader(),
          _buildStepIndicator(),
          Expanded(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _step1Service(),
                  _step2Schedule(),
                  _step3Dentist(),
                  _step4PatientInfo(),
                  _step5Confirm(),
                  _step6Success(),
                ],
              ),
            ),
          ),
          if (_currentStep < 4) _buildBottomBar(),
        ],
      ),
    );
  }

  // ── GLOBAL UI COMPONENTS: Shared UI elements like headers, progress bars, and inputs. ──
  Widget _buildHeader() {
    final steps = [
      "Service",
      "Schedule",
      "Dentist",
      "Details",
      "Review",
      "Status",
    ];
    final titles = [
      "What brings you in?",
      "Pick a date & time",
      "Choose your dentist",
      "Patient Information",
      "Review details",
      "Booking Sent",
    ];

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        boxShadow: profileShadow,
        border: Border(bottom: BorderSide(color: bdr)),
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 12,
        left: 20,
        right: 20,
        bottom: 16,
      ),
      child: Row(
        children: [
          if (_currentStep > 0 && _currentStep < 5)
            GestureDetector(
              onTap: _prevStep,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: innerSurface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: bdr),
                ),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 18,
                  color: ink,
                ),
              ),
            )
          else
            const SizedBox(width: 40),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titles[_currentStep],
                  style: GoogleFonts.dmSans(
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                    color: ink,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "Step ${_currentStep + 1} of 6 — ${steps[_currentStep]}",
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    color: inkMuted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              gradient: goldGradient,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.medical_services_rounded,
              color: Colors.white,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Container(
      color: cardBg,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
      child: Row(
        children: List.generate(6, (i) {
          final done = _currentStep > i;
          final active = _currentStep == i;
          return Expanded(
            child: Row(
              children: [
                Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    height: 4,
                    decoration: BoxDecoration(
                      gradient: done || active ? goldGradient : null,
                      color: done || active ? null : innerSurface,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                if (i < 5) const SizedBox(width: 4),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        12,
        20,
        MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: BoxDecoration(
        color: cardBg,
        border: Border(top: BorderSide(color: bdr)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: AnimatedOpacity(
        opacity: _canGoNext ? 1.0 : 0.45,
        duration: const Duration(milliseconds: 200),
        child: GestureDetector(
          onTap: _canGoNext ? () => _nextStep() : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 56,
            decoration: BoxDecoration(
              gradient: _canGoNext
                  ? goldGradient
                  : LinearGradient(
                      colors: widget.isDarkMode
                          ? [innerSurface, innerSurface]
                          : [Colors.grey.shade300, Colors.grey.shade400],
                    ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: _canGoNext
                  ? [
                      BoxShadow(
                        color: AppTheme.goldDeep.withOpacity(0.35),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [],
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Continue",
                    style: GoogleFonts.dmSans(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? formatters,
    String? hint,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: innerSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: bdr),
      ),
      child: Row(
        children: [
          Icon(icon, color: inkMuted, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              inputFormatters: formatters,
              onChanged: (v) => setState(() {}),
              style: GoogleFonts.dmSans(
                color: AppTheme.inputTxt(widget.isDarkMode),
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                labelText: label,
                labelStyle: GoogleFonts.dmSans(color: inkMuted, fontSize: 12),
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                hintText: hint,
                hintStyle: GoogleFonts.dmSans(
                  color: inkMuted.withOpacity(0.5),
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── WIZARD STEP 1 (SERVICE): Search and select a specific dental procedure. ──
  Widget _step1Service() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: innerSurface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: bdr),
            boxShadow: profileShadow,
          ),
          child: Row(
            children: [
              const Icon(
                Icons.search_rounded,
                color: AppTheme.goldPrimary,
                size: 22,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  onChanged: (val) => setState(() => _searchQuery = val),
                  decoration: InputDecoration(
                    hintText: "Search services...",
                    hintStyle: GoogleFonts.dmSans(
                      color: inkMuted,
                      fontSize: 14,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  style: GoogleFonts.dmSans(
                    color: ink,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (_searchQuery.isNotEmpty)
                GestureDetector(
                  onTap: () => setState(() => _searchQuery = ''),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: bdr),
                    ),
                    child: Icon(Icons.close_rounded, color: inkMuted, size: 18),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (selectedService != null)
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: innerSurface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.goldPrimary.withOpacity(0.4)),
            ),
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppTheme.goldPrimary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "${selectedService!.name} — ${selectedService!.price}",
                    style: GoogleFonts.dmSans(
                      color: AppTheme.goldPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(() {
                    selectedService = null;
                    selectedDentist = null;
                  }),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppTheme.goldPrimary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      size: 16,
                      color: AppTheme.goldPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        if (_filteredServices.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 60),
              child: Column(
                children: [
                  Icon(
                    Icons.search_off_rounded,
                    size: 64,
                    color: inkMuted.withOpacity(0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "No services found",
                    style: GoogleFonts.dmSans(
                      color: inkMuted,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          ..._filteredServices.map((s) => _serviceCard(s)),
      ],
    );
  }

  Widget _serviceCard(ClinicService s) {
    final sel = selectedService?.id == s.id;
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() {
          if (selectedService?.id != s.id) {
            selectedDentist = null;
          }
          selectedService = s;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: sel ? AppTheme.goldPrimary.withOpacity(0.5) : bdr,
            width: sel ? 2 : 1,
          ),
          boxShadow: profileShadow,
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                boxShadow: sel
                    ? [
                        BoxShadow(
                          color: AppTheme.goldPrimary.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [],
                border: Border.all(
                  color: sel ? AppTheme.goldPrimary : Colors.transparent,
                  width: 2,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  s.imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: innerSurface,
                    child: Icon(
                      Icons.image_not_supported_rounded,
                      color: inkMuted.withOpacity(0.5),
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                s.name,
                style: GoogleFonts.dmSans(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: sel ? AppTheme.goldPrimary : ink,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: sel ? innerSurface : innerSurface.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                    border: sel
                        ? Border.all(
                            color: AppTheme.goldPrimary.withOpacity(0.3),
                          )
                        : null,
                  ),
                  child: Text(
                    s.price,
                    style: GoogleFonts.dmSans(
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                      color: AppTheme.goldPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.access_time_rounded, size: 12, color: inkMuted),
                    const SizedBox(width: 4),
                    Text(
                      s.duration,
                      style: GoogleFonts.dmSans(
                        fontSize: 11,
                        color: inkMuted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── WIZARD STEP 2 (SCHEDULE): Calendar UI and time-slot grid for appointment scheduling. ──
  Widget _step2Schedule() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
      children: [
        _buildCalendar(),
        const SizedBox(height: 16),
        _buildTimePicker(),
      ],
    );
  }

  Widget _buildCalendar() {
    final display = _displayMonth;
    final daysInMonth = DateUtils.getDaysInMonth(display.year, display.month);
    final firstWeekday = display.weekday % 7;
    final today = DateTime.now();
    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: bdr),
        boxShadow: profileShadow,
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: _calendarMonthOffset > 0
                    ? () => setState(() => _calendarMonthOffset--)
                    : null,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _calendarMonthOffset > 0
                        ? innerSurface
                        : innerSurface.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: bdr),
                  ),
                  child: Icon(
                    Icons.chevron_left_rounded,
                    color: _calendarMonthOffset > 0
                        ? AppTheme.goldPrimary
                        : inkMuted,
                    size: 22,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _showMonthYearPicker(),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: innerSurface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.goldPrimary.withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        DateFormat('MMMM').format(display),
                        style: GoogleFonts.dmSans(
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                          color: ink,
                        ),
                      ),
                      Text(
                        "${display.year}",
                        style: GoogleFonts.dmSans(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: AppTheme.goldPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: _calendarMonthOffset < 12
                    ? () => setState(() => _calendarMonthOffset++)
                    : null,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _calendarMonthOffset < 12
                        ? innerSurface
                        : innerSurface.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _calendarMonthOffset < 12
                          ? AppTheme.goldPrimary.withOpacity(0.3)
                          : bdr,
                    ),
                  ),
                  child: Icon(
                    Icons.chevron_right_rounded,
                    color: _calendarMonthOffset < 12
                        ? AppTheme.goldPrimary
                        : inkMuted,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]
                .map(
                  (d) => Expanded(
                    child: Center(
                      child: Text(
                        d,
                        style: GoogleFonts.dmSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: inkMuted,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisExtent: 44,
              mainAxisSpacing: 6,
            ),
            itemCount: firstWeekday + daysInMonth,
            itemBuilder: (context, index) {
              if (index < firstWeekday) return const SizedBox();
              final day = index - firstWeekday + 1;
              final date = DateTime(display.year, display.month, day);
              final isPast = date.isBefore(
                DateTime(today.year, today.month, today.day),
              );
              final isDisabled = isPast || date.weekday == DateTime.sunday;
              final isSel =
                  selectedDate != null &&
                  selectedDate!.year == date.year &&
                  selectedDate!.month == date.month &&
                  selectedDate!.day == date.day;
              final isToday =
                  date.year == today.year &&
                  date.month == today.month &&
                  date.day == today.day;
              return GestureDetector(
                onTap: isDisabled
                    ? null
                    : () {
                        HapticFeedback.selectionClick();
                        setState(() {
                          selectedDate = date;
                          selectedTime = null;
                        });
                      },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    gradient: isSel ? goldGradient : null,
                    color: isSel
                        ? null
                        : isToday
                        ? innerSurface
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: isToday && !isSel
                        ? Border.all(
                            color: AppTheme.goldPrimary.withOpacity(0.5),
                            width: 2,
                          )
                        : null,
                    boxShadow: isSel
                        ? [
                            BoxShadow(
                              color: AppTheme.goldPrimary.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : [],
                  ),
                  child: Center(
                    child: Text(
                      "$day",
                      style: GoogleFonts.dmSans(
                        fontSize: 14,
                        fontWeight: isSel || isToday
                            ? FontWeight.w800
                            : FontWeight.w600,
                        color: isSel
                            ? Colors.white
                            : isDisabled
                            ? inkMuted.withOpacity(0.4)
                            : ink,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          if (selectedDate != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: innerSurface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.goldPrimary.withOpacity(0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.calendar_today_rounded,
                    size: 14,
                    color: AppTheme.goldPrimary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    DateFormat('EEEE, MMMM d, yyyy').format(selectedDate!),
                    style: GoogleFonts.dmSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.goldPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showMonthYearPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: bdr,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Select Month & Year",
              style: GoogleFonts.dmSans(
                fontWeight: FontWeight.w800,
                fontSize: 18,
                color: ink,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: ListView.builder(
                itemCount: 13,
                itemBuilder: (_, i) {
                  final now = DateTime.now();
                  final d = DateTime(now.year, now.month + i, 1);
                  return ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: _calendarMonthOffset == i
                            ? innerSurface
                            : (widget.isDarkMode
                                  ? const Color(0xFF1C2333)
                                  : innerSurface),
                        borderRadius: BorderRadius.circular(12),
                        border: _calendarMonthOffset == i
                            ? Border.all(
                                color: AppTheme.goldPrimary.withOpacity(0.5),
                              )
                            : null,
                      ),
                      child: Icon(
                        _calendarMonthOffset == i
                            ? Icons.check_rounded
                            : Icons.calendar_today_rounded,
                        color: _calendarMonthOffset == i
                            ? AppTheme.goldPrimary
                            : inkMuted,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      DateFormat('MMMM yyyy').format(d),
                      style: GoogleFonts.dmSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: _calendarMonthOffset == i
                            ? AppTheme.goldPrimary
                            : ink,
                      ),
                    ),
                    onTap: () {
                      setState(() => _calendarMonthOffset = i);
                      Navigator.pop(ctx);
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => Navigator.pop(ctx),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: innerSurface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    "Cancel",
                    style: GoogleFonts.dmSans(
                      fontWeight: FontWeight.w800,
                      color: ink,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 10),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: AppTheme.goldPrimary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "Available Time Slots",
                style: GoogleFonts.dmSans(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  color: ink,
                ),
              ),
            ],
          ),
        ),
        GridView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisExtent: 44,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemCount: _timeSlots.length,
          itemBuilder: (context, i) {
            final t = _timeSlots[i];
            final sel = selectedTime == t;
            return GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                setState(() => selectedTime = t);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  gradient: sel ? goldGradient : null,
                  color: sel ? null : cardBg,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: sel ? AppTheme.goldPrimary : bdr,
                    width: sel ? 2 : 1,
                  ),
                  boxShadow: sel
                      ? [
                          BoxShadow(
                            color: AppTheme.goldPrimary.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ]
                      : profileShadow,
                ),
                child: Center(
                  child: Text(
                    t,
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: sel ? Colors.white : ink,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // ── WIZARD STEP 3 (DENTIST): Filters and selects an available specialist for the chosen service. ──
  Widget _step3Dentist() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: bdr),
            boxShadow: profileShadow,
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: innerSurface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppTheme.goldPrimary.withOpacity(0.2),
                  ),
                ),
                child: const Icon(
                  Icons.info_outline_rounded,
                  color: AppTheme.goldPrimary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  "Select an available specialist for your chosen service.",
                  style: GoogleFonts.dmSans(
                    fontSize: 13,
                    color: inkMuted,
                    fontWeight: FontWeight.w500,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
        ..._dentists.map((d) => _dentistCard(d)),
      ],
    );
  }

  Widget _dentistCard(DentistInfo d) {
    final canPerform =
        selectedService == null || d.services.contains(selectedService!.name);
    final sel = selectedDentist?.id == d.id && canPerform;
    List<String> displayServices = List.from(d.services);
    if (selectedService != null &&
        displayServices.contains(selectedService!.name)) {
      displayServices.remove(selectedService!.name);
      displayServices.insert(0, selectedService!.name);
    }

    return GestureDetector(
      onTap: () {
        if (canPerform) {
          HapticFeedback.selectionClick();
          setState(() => selectedDentist = d);
        } else {
          HapticFeedback.vibrate();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "${d.name} does not perform ${selectedService!.name}.",
                      style: GoogleFonts.dmSans(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.redAccent.shade200,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }
      },
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: canPerform ? 1.0 : 0.45,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: sel ? AppTheme.goldPrimary.withOpacity(0.5) : bdr,
              width: sel ? 2 : 1,
            ),
            boxShadow: profileShadow,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: sel ? AppTheme.goldPrimary : Colors.transparent,
                      width: sel ? 2 : 1,
                    ),
                    boxShadow: sel
                        ? [
                            BoxShadow(
                              color: AppTheme.goldPrimary.withOpacity(0.4),
                              blurRadius: 15,
                              offset: const Offset(0, 6),
                            ),
                          ]
                        : [],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      d.imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: innerSurface,
                        child: Icon(
                          Icons.person_rounded,
                          color: inkMuted.withOpacity(0.5),
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              d.name,
                              style: GoogleFonts.dmSans(
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                                color: ink,
                              ),
                            ),
                          ),
                          if (sel)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                gradient: goldGradient,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.check_rounded,
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "Selected",
                                    style: GoogleFonts.dmSans(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          else if (!canPerform)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.redAccent.shade100.withOpacity(
                                  0.15,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                "Unavailable",
                                style: GoogleFonts.dmSans(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.redAccent.shade200,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.goldPrimary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          d.specialty,
                          style: GoogleFonts.dmSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.goldPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        d.bio,
                        style: GoogleFonts.dmSans(
                          fontSize: 12,
                          color: inkMuted,
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: displayServices.take(3).map((sv) {
                          final match = selectedService?.name == sv;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              gradient: match ? goldGradient : null,
                              color: match ? null : innerSurface,
                              borderRadius: BorderRadius.circular(8),
                              border: match ? null : Border.all(color: bdr),
                              boxShadow: match
                                  ? [
                                      BoxShadow(
                                        color: AppTheme.goldPrimary.withOpacity(
                                          0.3,
                                        ),
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                  : [],
                            ),
                            child: Text(
                              sv,
                              style: GoogleFonts.dmSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: match ? Colors.white : inkMuted,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── WIZARD STEP 4 (PATIENT): Captures and validates patient personal information. ──
  Widget _step4PatientInfo() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: bdr),
            boxShadow: profileShadow,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader("Personal Details"),
              const SizedBox(height: 24),
              _buildInputField(
                label: "Full Name",
                icon: Icons.person_outline_rounded,
                controller: _fullNameCtrl,
                formatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s\-\.]')),
                ],
              ),
              _buildInputField(
                label: "Age",
                icon: Icons.cake_outlined,
                controller: _ageCtrl,
                keyboardType: TextInputType.number,
                formatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(3),
                ],
              ),
              _buildInputField(
                label: "Contact Number",
                hint: "e.g., 09123456789",
                icon: Icons.phone_outlined,
                controller: _contactCtrl,
                keyboardType: TextInputType.phone,
                formatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(11),
                ],
              ),
              if (_contactCtrl.text.isNotEmpty &&
                  (!_contactCtrl.text.startsWith('09') ||
                      _contactCtrl.text.length != 11))
                Padding(
                  padding: const EdgeInsets.only(left: 12, top: 4),
                  child: Text(
                    "Must be exactly 11 digits and start with '09'",
                    style: GoogleFonts.dmSans(
                      color: Colors.redAccent.shade200,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ── WIZARD STEP 5 (REVIEW): Displays a final summary card before confirming the booking. ──
  Widget _step5Confirm() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
      children: [
        Container(
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: bdr),
            boxShadow: profileShadow,
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: goldGradient,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(27),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.receipt_long_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Appointment Summary",
                            style: GoogleFonts.dmSans(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 17,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "Please review your details",
                            style: GoogleFonts.dmSans(
                              color: Colors.white.withOpacity(0.85),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    AnimatedBuilder(
                      animation: _pulseCtrl,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: 1 + (_pulseCtrl.value * 0.1),
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(
                              Icons.shield_rounded,
                              color: AppTheme.goldPrimary,
                              size: 24,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildSectionHeader("Patient Info"),
                    const SizedBox(height: 8),
                    _confirmRow(
                      Icons.person_outline_rounded,
                      "Name",
                      _fullNameCtrl.text.trim(),
                    ),
                    _confirmRow(
                      Icons.cake_outlined,
                      "Age",
                      "${_ageCtrl.text.trim()} yrs",
                    ),
                    _confirmRow(
                      Icons.phone_outlined,
                      "Contact",
                      _contactCtrl.text.trim(),
                    ),
                    const SizedBox(height: 12),

                    _buildSectionHeader("Service Details"),
                    const SizedBox(height: 8),
                    _confirmRow(
                      Icons.medical_services_outlined,
                      "Service",
                      selectedService?.name ?? "—",
                      highlight: true,
                    ),
                    _confirmRow(
                      Icons.payments_outlined,
                      "Price",
                      selectedService?.price ?? "—",
                      valColor: AppTheme.goldPrimary,
                    ),
                    _confirmRow(
                      Icons.timer_outlined,
                      "Duration",
                      selectedService?.duration ?? "—",
                    ),
                    const SizedBox(height: 12),

                    _buildSectionHeader("Schedule"),
                    const SizedBox(height: 8),
                    _confirmRow(
                      Icons.calendar_today_outlined,
                      "Date",
                      selectedDate != null
                          ? DateFormat('EEE, MMM d, yyyy').format(selectedDate!)
                          : "—",
                    ),
                    _confirmRow(
                      Icons.access_time_rounded,
                      "Time",
                      selectedTime ?? "—",
                    ),
                    const SizedBox(height: 12),

                    _buildSectionHeader("Dentist"),
                    const SizedBox(height: 8),
                    _confirmRow(
                      Icons.person_outline_rounded,
                      "Name",
                      selectedDentist?.name ?? "—",
                    ),
                    _confirmRow(
                      Icons.work_outline_rounded,
                      "Specialty",
                      selectedDentist?.specialty ?? "—",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.goldPrimary.withOpacity(0.05),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppTheme.goldPrimary.withOpacity(0.18)),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: innerSurface,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.info_outline_rounded,
                  color: AppTheme.goldPrimary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "Please arrive 10 minutes early. Bring a valid ID and dental records if available.",
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    color: ink,
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        GestureDetector(
          onTap: () {
            HapticFeedback.mediumImpact();

            widget.onBookAppointment({
              'service': selectedService!.name,
              'doctor': selectedDentist!.name,
              'date': selectedDate!,
              'time': _timeToStorage(selectedTime!),
              'status': 'pending',
              'price': selectedService!.price,
              'duration': selectedService!.duration,
              'specialty': selectedDentist!.specialty,
              'patientName': _fullNameCtrl.text.trim(),
              'patientAge': _ageCtrl.text.trim(),
              'patientContact': _contactCtrl.text.trim(),
            });

            _nextStep();
          },
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              gradient: goldGradient,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.goldPrimary.withOpacity(0.5),
                  blurRadius: 25,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.check_circle_outline_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "Submit Booking Request",
                    style: GoogleFonts.dmSans(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: Text(
            "By confirming, you agree to our terms and conditions",
            style: GoogleFonts.dmSans(
              fontSize: 11,
              color: inkMuted,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  // ── WIZARD STEP 6 (SUCCESS): Confirmation screen showing the pending appointment status. ──
  Widget _step6Success() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: bdr),
                boxShadow: profileShadow,
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: goldGradient,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(27),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.schedule_send_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Request Sent",
                                style: GoogleFonts.dmSans(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 17,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "Pending Dentist Approval",
                                style: GoogleFonts.dmSans(
                                  color: Colors.white.withOpacity(0.85),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: innerSurface,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppTheme.goldPrimary.withOpacity(0.3),
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.hourglass_top_rounded,
                            color: AppTheme.goldPrimary,
                            size: 40,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          "Booking Submitted!",
                          style: GoogleFonts.dmSans(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: ink,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "Your appointment is currently pending. Once the dentist approves it, you will receive a notification with your confirmation code.",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.dmSans(
                            fontSize: 14,
                            color: inkMuted,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                _resetBooking();
              },
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  gradient: goldGradient,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.goldPrimary.withOpacity(0.35),
                      blurRadius: 15,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    "Book Another Appointment",
                    style: GoogleFonts.dmSans(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── HELPER WIDGETS: Reusable widgets for formatting headers and confirmation rows. ──
  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            gradient: goldGradient,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.dmSans(
            fontWeight: FontWeight.w800,
            fontSize: 14,
            color: ink,
          ),
        ),
      ],
    );
  }

  Widget _confirmRow(
    IconData icon,
    String label,
    String val, {
    Color? valColor,
    bool highlight = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: highlight ? innerSurface : innerSurface.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
              border: highlight
                  ? Border.all(color: AppTheme.goldPrimary.withOpacity(0.3))
                  : null,
            ),
            child: Icon(
              icon,
              size: 18,
              color: highlight ? AppTheme.goldPrimary : inkMuted,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.dmSans(
                fontSize: 13,
                color: highlight ? ink : inkMuted,
                fontWeight: highlight ? FontWeight.w700 : FontWeight.w600,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: valColor != null
                  ? valColor.withOpacity(0.1)
                  : innerSurface,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              val,
              style: GoogleFonts.dmSans(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: valColor ?? ink,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
