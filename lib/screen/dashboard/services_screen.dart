import 'package:flutter/material.dart';

class ServicesScreen extends StatefulWidget {
  final List<Map<String, dynamic>> appointments;
  final Function(Map<String, dynamic>) onBookAppointment;
  final String patientName, firstName, lastName;

  const ServicesScreen({
    super.key,
    required this.appointments,
    required this.onBookAppointment,
    required this.patientName,
    required this.firstName,
    required this.lastName,
  });
  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  String? selectedService, selectedDoctor;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  DateTime _currentMonth = DateTime.now();
  int _currentPage = 0;
  late PageController _pageController;

  final List<Map<String, dynamic>> services = [
    {
      'n': 'Consultation',
      'i': Icons.chat,
      'd': 'Dental check-up',
      'p': '500',
      'c': Color(0xFF4A6FA5),
    },
    {
      'n': 'Panoramic X-Ray',
      'i': Icons.radar,
      'd': 'Full mouth X-ray',
      'p': '1,000',
      'c': Color(0xFF4A6FA5),
    },
    {
      'n': 'Oral Prophylaxis',
      'i': Icons.cleaning_services,
      'd': 'Professional cleaning',
      'p': '850-1,200',
      'c': Color(0xFF4A6FA5),
    },
    {
      'n': 'Braces & Adjustments',
      'i': Icons.medical_services,
      'd': '5K down + monthly',
      'p': '5K+1-2K/mo',
      'c': Color(0xFF4A6FA5),
    },
    {
      'n': 'Tooth Extraction',
      'i': Icons.healing,
      'd': 'Simple extraction',
      'p': '850-1,200',
      'c': Color(0xFF4A6FA5),
    },
    {
      'n': 'Wisdom Tooth',
      'i': Icons.medical_services,
      'd': 'Surgical removal',
      'p': '8K-13K',
      'c': Color(0xFF4A6FA5),
    },
    {
      'n': 'Dental Filling',
      'i': Icons.build,
      'd': 'Cavity filling',
      'p': '850-1,200',
      'c': Color(0xFF4A6FA5),
    },
    {
      'n': 'Root Canal',
      'i': Icons.psychology,
      'd': 'Root canal',
      'p': '8,000',
      'c': Color(0xFF4A6FA5),
    },
    {
      'n': 'Dentures',
      'i': Icons.face,
      'd': 'Partial/full',
      'p': 'Starts 1K',
      'c': Color(0xFF4A6FA5),
    },
    {
      'n': 'Dental Bridges',
      'i': Icons.medical_services,
      'd': 'Fixed bridges',
      'p': '1,000',
      'c': Color(0xFF4A6FA5),
    },
    {
      'n': 'Dental Crown',
      'i': Icons.king_bed,
      'd': 'Crowns/jackets',
      'p': '1,000',
      'c': Color(0xFF4A6FA5),
    },
    {
      'n': 'Teeth Whitening',
      'i': Icons.color_lens,
      'd': 'Professional',
      'p': '3K/session',
      'c': Color(0xFF4A6FA5),
    },
  ];

  final List<Map<String, dynamic>> doctors = [
    {
      'n': 'Dr. Justine Illustrisimo',
      's': 'Orthodontist',
      'h': 'Mon-Fri 9-5',
      'a': ['09:00', '10:00', '11:00', '14:00', '15:00'],
      'c': Color(0xFF4A6FA5),
    },
    {
      'n': 'Dr. Sarah Smith',
      's': 'General Dentist',
      'h': 'Tue-Sat 10-6',
      'a': ['10:00', '11:00', '14:00', '15:00', '16:00'],
      'c': Color(0xFF4A6FA5),
    },
    {
      'n': 'Dr. Michael Chen',
      's': 'Oral Surgeon',
      'h': 'Mon-Thu 8-4',
      'a': ['08:00', '09:00', '10:00', '13:00', '14:00'],
      'c': Color(0xFF4A6FA5),
    },
    {
      'n': 'Dr. Maria Santos',
      's': 'Prosthodontist',
      'h': 'Mon-Wed-Fri 9-5',
      'a': ['09:00', '11:00', '13:00', '15:00', '16:00'],
      'c': Color(0xFF4A6FA5),
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.8);
  }

  @override
  Widget build(BuildContext context) => Container(
    color: const Color.fromARGB(255, 255, 255, 255),
    child: CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // REMOVED: SliverToBoxAdapter(child: _buildHeader()),
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _buildSectionTitle('Select Service', Icons.swipe),
              const SizedBox(height: 20),
              _buildServiceCarousel(),
              const SizedBox(height: 20),
              _buildPageIndicator(),
              const SizedBox(height: 30),
              _buildSectionTitle('Select Doctor', Icons.person_search),
              const SizedBox(height: 20),
              ...doctors.map(_buildDoctorCard),
              if (selectedService != null && selectedDoctor != null) ...[
                const SizedBox(height: 30),
                _buildSectionTitle('Select Date', Icons.calendar_month),
                const SizedBox(height: 20),
                _buildCalendar(),
                if (selectedDate != null) ...[
                  const SizedBox(height: 30),
                  _buildSectionTitle('Available Times', Icons.access_time),
                  const SizedBox(height: 20),
                  _buildTimeSlots(),
                ],
                if (selectedDate != null && selectedTime != null) ...[
                  const SizedBox(height: 30),
                  _buildConfirmButton(),
                ],
              ],
              const SizedBox(height: 30),
            ]),
          ),
        ),
      ],
    ),
  );

  Widget _buildSectionTitle(String t, IconData i) => Row(
    children: [
      Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFF4A6FA5).withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Icon(i, color: const Color(0xFF4A6FA5), size: 18),
      ),
      const SizedBox(width: 12),
      Text(
        t,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1E293B),
        ),
      ),
    ],
  );

  Widget _buildServiceCarousel() => SizedBox(
    height: 200, // INCREASED from 160 to 200 for bigger cards
    child: PageView.builder(
      controller: _pageController,
      onPageChanged: (i) => setState(() {
        _currentPage = i;
        selectedService = services[i]['n'];
        selectedDoctor = null;
        selectedDate = null;
        selectedTime = null;
      }),
      itemCount: services.length,
      itemBuilder: (_, i) => _buildServiceCard(services[i], i == _currentPage),
    ),
  );

  Widget _buildServiceCard(Map<String, dynamic> s, bool isSelected) =>
      GestureDetector(
        onTap: () => setState(() {
          selectedService = s['n'];
          selectedDoctor = null;
          selectedDate = null;
          selectedTime = null;
        }),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          transform: isSelected
              ? (Matrix4.identity()..scale(1.02))
              : Matrix4.identity(),
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected ? s['c'] : Colors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: isSelected ? Colors.transparent : Colors.grey[200]!,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? s['c'].withOpacity(0.3)
                    : Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14), // INCREASED padding
                      decoration: BoxDecoration(
                        color: (isSelected ? Colors.white : s['c']).withOpacity(
                          0.2,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        s['i'],
                        color: isSelected ? Colors.white : s['c'],
                        size: 32, // INCREASED icon size
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            s['n'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17, // INCREASED font size
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xFF1E293B),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            s['d'],
                            style: TextStyle(
                              fontSize: 13, // INCREASED font size
                              color: isSelected
                                  ? Colors.white70
                                  : const Color(0xFF64748B),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: (isSelected ? Colors.white : s['c'])
                                  .withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '₱${s['p']}',
                              style: TextStyle(
                                color: isSelected ? Colors.white : s['c'],
                                fontSize: 13, // INCREASED font size
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                const Positioned(
                  top: 8,
                  right: 8,
                  child: Icon(
                    Icons.check_circle,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
            ],
          ),
        ),
      );

  Widget _buildPageIndicator() => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: List.generate(
      services.length,
      (i) => AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 3),
        width: _currentPage == i ? 24 : 8,
        height: 8,
        decoration: BoxDecoration(
          color: _currentPage == i ? const Color(0xFF4A6FA5) : Colors.grey[300],
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    ),
  );

  Widget _buildDoctorCard(Map<String, dynamic> d) {
    bool isSelected = selectedDoctor == d['n'];
    return GestureDetector(
      onTap: () => setState(() {
        selectedDoctor = d['n'];
        selectedDate = null;
        selectedTime = null;
      }),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? d['c'] : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.grey[200]!,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? d['c'].withOpacity(0.3)
                  : Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  d['n'][0],
                  style: TextStyle(
                    color: d['c'],
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    d['n'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isSelected
                          ? Colors.white
                          : const Color(0xFF1E293B),
                    ),
                  ),
                  Text(
                    d['s'],
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white70
                          : const Color(0xFF64748B),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: (isSelected ? Colors.white : d['c']).withOpacity(
                        0.2,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: isSelected ? Colors.white : d['c'],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          d['h'],
                          style: TextStyle(
                            color: isSelected ? Colors.white : d['c'],
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: Colors.white, size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendar() => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(35),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.03),
          blurRadius: 15,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _calNav(
              Icons.chevron_left,
              () => setState(
                () => _currentMonth = DateTime(
                  _currentMonth.year,
                  _currentMonth.month - 1,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF4A6FA5).withOpacity(0.1),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 18,
                    color: const Color(0xFF4A6FA5),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _fmtMonth(_currentMonth),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ],
              ),
            ),
            _calNav(
              Icons.chevron_right,
              () => setState(
                () => _currentMonth = DateTime(
                  _currentMonth.year,
                  _currentMonth.month + 1,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: ['M', 'T', 'W', 'T', 'F', 'S', 'S']
              .map(
                (d) => SizedBox(
                  width: 35,
                  child: Text(
                    d,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF4A6FA5),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 10),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 7,
          children: _buildDays(),
        ),
      ],
    ),
  );

  List<Widget> _buildDays() {
    int days = DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day;
    int first = DateTime(_currentMonth.year, _currentMonth.month, 1).weekday;
    List<Widget> list = [];
    for (int i = 1; i < first; i++) {
      list.add(Container());
    }
    for (int d = 1; d <= days; d++) {
      DateTime date = DateTime(_currentMonth.year, _currentMonth.month, d);
      bool sel =
          selectedDate?.day == d && selectedDate?.month == _currentMonth.month;
      bool today =
          DateTime.now().day == d &&
          DateTime.now().month == _currentMonth.month &&
          DateTime.now().year == _currentMonth.year;
      list.add(
        GestureDetector(
          onTap: () => setState(() => selectedDate = date),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.all(4),
            height: 45,
            decoration: BoxDecoration(
              color: sel
                  ? const Color(0xFF4A6FA5)
                  : today
                  ? const Color(0xFF4A6FA5).withOpacity(0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Center(
              child: Text(
                '$d',
                style: TextStyle(
                  color: sel
                      ? Colors.white
                      : today
                      ? const Color(0xFF4A6FA5)
                      : const Color(0xFF1E293B),
                  fontWeight: sel || today
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ),
          ),
        ),
      );
    }
    return list;
  }

  Widget _calNav(IconData i, VoidCallback o) => Container(
    decoration: BoxDecoration(
      color: const Color(0xFF4A6FA5).withOpacity(0.1),
      borderRadius: BorderRadius.circular(20),
    ),
    child: IconButton(
      icon: Icon(i, color: const Color(0xFF4A6FA5), size: 22),
      onPressed: o,
      padding: const EdgeInsets.all(8),
    ),
  );

  Widget _buildTimeSlots() {
    List<String> slots = doctors.firstWhere(
      (d) => d['n'] == selectedDoctor,
    )['a'];
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: slots.map((t) {
        bool sel =
            selectedTime != null &&
            '${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}' ==
                t;
        return GestureDetector(
          onTap: () => setState(
            () => selectedTime = TimeOfDay(
              hour: int.parse(t.split(':')[0]),
              minute: int.parse(t.split(':')[1]),
            ),
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: sel ? const Color(0xFF4A6FA5) : Colors.white,
              borderRadius: BorderRadius.circular(40),
              border: Border.all(
                color: sel ? Colors.transparent : Colors.grey[300]!,
              ),
              boxShadow: sel
                  ? [
                      BoxShadow(
                        color: const Color(0xFF4A6FA5).withOpacity(0.3),
                        blurRadius: 10,
                      ),
                    ]
                  : null,
            ),
            child: Text(
              _fmtTime(t),
              style: TextStyle(
                color: sel ? Colors.white : const Color(0xFF1E293B),
                fontWeight: sel ? FontWeight.bold : null,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildConfirmButton() => SizedBox(
    width: double.infinity,
    height: 60,
    child: ElevatedButton(
      onPressed: _confirmBooking,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      child: Ink(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF4A6FA5), Color(0xFF6B8EC9)],
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4A6FA5).withOpacity(0.4),
              blurRadius: 15,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Container(
          alignment: Alignment.center,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle, color: Colors.white, size: 24),
              SizedBox(width: 10),
              Text(
                'Confirm Booking',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  void _confirmBooking() {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(35),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF4A6FA5).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Color(0xFF4A6FA5),
                  size: 30,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Confirm Booking',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 20),
              _detailRow(Icons.medical_services, 'Service', selectedService!),
              _detailRow(Icons.person, 'Doctor', selectedDoctor!),
              _detailRow(
                Icons.calendar_today,
                'Date',
                '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
              ),
              _detailRow(
                Icons.access_time,
                'Time',
                _fmtTime(
                  '${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}',
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Color(0xFF64748B)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Add the appointment
                        widget.onBookAppointment({
                          'doctor': selectedDoctor!,
                          'service': selectedService!,
                          'date': selectedDate!,
                          'time':
                              '${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}',
                          'status': 'upcoming',
                        });

                        // Pop the dialog
                        Navigator.pop(context);

                        // Show success message
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Row(
                              children: [
                                Icon(Icons.check_circle, color: Colors.white),
                                SizedBox(width: 8),
                                Text('Booking confirmed!'),
                              ],
                            ),
                            backgroundColor: const Color(0xFF4A6FA5),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        );

                        // RESET FORM
                        setState(() {
                          selectedService = null;
                          selectedDoctor = null;
                          selectedDate = null;
                          selectedTime = null;
                          _currentMonth = DateTime.now();
                          _currentPage = 0;
                          _pageController.jumpToPage(0);
                        });

                        // DO NOT NAVIGATE HERE - The parent dashboard will handle navigation
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4A6FA5),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text('Confirm'),
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

  Widget _detailRow(IconData i, String l, String v) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF4A6FA5).withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(i, size: 18, color: const Color(0xFF4A6FA5)),
        ),
        const SizedBox(width: 12),
        Text(
          '$l:',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(v, style: const TextStyle(color: Color(0xFF64748B))),
        ),
      ],
    ),
  );

  String _fmtMonth(DateTime d) =>
      '${['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][d.month - 1]} ${d.year}';

  String _fmtTime(String t) {
    int h = int.parse(t.split(':')[0]);
    int m = int.parse(t.split(':')[1]);
    String period = h >= 12 ? 'PM' : 'AM';
    int displayHour = h > 12 ? h - 12 : h;
    displayHour = displayHour == 0 ? 12 : displayHour;
    return '$displayHour:${m.toString().padLeft(2, '0')} $period';
  }

  void scale(double d) {}
}
