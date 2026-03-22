import 'package:flutter/material.dart';
import 'services_screen.dart';

class CalendarScreen extends StatefulWidget {
  final List<Map<String, dynamic>> appointments;
  final String patientName;
  final String firstName;
  final String lastName;

  const CalendarScreen({
    super.key,
    required this.appointments,
    required this.patientName,
    required this.firstName,
    required this.lastName,
  });

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  String? selectedFilter = 'All';
  DateTime _currentMonth = DateTime.now();

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
              _buildCalendar(),
              const SizedBox(height: 24),
              _buildFilterRow(),
              const SizedBox(height: 20),
              _buildAppointmentsList(),
              const SizedBox(height: 30),
            ]),
          ),
        ),
      ],
    ),
  );

  Widget _buildHeader() => Container(
    padding: const EdgeInsets.fromLTRB(24, 30, 24, 30),
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [Color(0xFF4A6FA5), Color(0xFF6B8EC9), Color(0xFF8AAEE0)],
      ),
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(40),
        bottomRight: Radius.circular(40),
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'My Appointments',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Icon(
                Icons.calendar_month,
                color: Colors.white,
                size: 30,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            children: [
              const Icon(Icons.event_available, color: Colors.amber, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'You have ${widget.appointments.length} appointment${widget.appointments.length != 1 ? 's' : ''}',
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );

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
            _calNav(Icons.chevron_left, () {
              setState(
                () => _currentMonth = DateTime(
                  _currentMonth.year,
                  _currentMonth.month - 1,
                ),
              );
            }),
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
                    _formatMonthYear(_currentMonth),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ],
              ),
            ),
            _calNav(Icons.chevron_right, () {
              setState(
                () => _currentMonth = DateTime(
                  _currentMonth.year,
                  _currentMonth.month + 1,
                ),
              );
            }),
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
          children: _buildCalendarDays(),
        ),
      ],
    ),
  );

  List<Widget> _buildCalendarDays() {
    int days = DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day;
    int first = DateTime(_currentMonth.year, _currentMonth.month, 1).weekday;
    List<Widget> list = [];

    for (int i = 1; i < first; i++) {
      list.add(Container());
    }

    for (int d = 1; d <= days; d++) {
      bool hasAppt = widget.appointments.any(
        (a) => a['date'].day == d && a['date'].month == _currentMonth.month,
      );
      bool today =
          DateTime.now().day == d &&
          DateTime.now().month == _currentMonth.month &&
          DateTime.now().year == _currentMonth.year;

      list.add(
        Container(
          margin: const EdgeInsets.all(4),
          height: 45,
          decoration: BoxDecoration(
            color: hasAppt
                ? const Color(0xFF4A6FA5).withOpacity(0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: today ? const Color(0xFF4A6FA5) : Colors.transparent,
              width: 2,
            ),
          ),
          child: Center(
            child: Text(
              '$d',
              style: TextStyle(
                color: hasAppt
                    ? const Color(0xFF4A6FA5)
                    : today
                    ? const Color(0xFF4A6FA5)
                    : const Color(0xFF1E293B),
                fontWeight: hasAppt || today
                    ? FontWeight.bold
                    : FontWeight.normal,
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

  Widget _buildFilterRow() => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: ['All', 'Upcoming', 'Completed', 'Cancelled'].map((f) {
        bool isSelected = selectedFilter == f;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: FilterChip(
            label: Text(f),
            selected: isSelected,
            onSelected: (s) => setState(() => selectedFilter = f),
            selectedColor: const Color(0xFF4A6FA5),
            backgroundColor: Colors.white,
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF1E293B),
              fontWeight: FontWeight.w500,
            ),
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        );
      }).toList(),
    ),
  );

  Widget _buildAppointmentsList() {
    List<Map<String, dynamic>> filtered = widget.appointments.where((a) {
      if (selectedFilter == 'All') return true;
      return a['status'] == selectedFilter?.toLowerCase();
    }).toList();

    if (filtered.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(35),
        ),
        child: Column(
          children: [
            Icon(Icons.event_busy, size: 60, color: Colors.grey[400]),
            const SizedBox(height: 16),
            const Text(
              'No appointments found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Book a service to see your appointments here',
              style: TextStyle(color: Color(0xFF64748B)),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filtered.length,
      itemBuilder: (_, i) => _buildAppointmentCard(filtered[i]),
    );
  }

  Widget _buildAppointmentCard(Map<String, dynamic> a) {
    Color statusColor;
    IconData statusIcon;
    String statusText;

    switch (a['status']) {
      case 'completed':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        statusText = 'Completed';
        break;
      case 'cancelled':
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        statusText = 'Cancelled';
        break;
      default:
        statusColor = const Color(0xFF4A6FA5);
        statusIcon = Icons.calendar_month;
        statusText = 'Upcoming';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: a['status'] == 'upcoming'
              ? const Color(0xFF4A6FA5).withOpacity(0.3)
              : Colors.transparent,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(statusIcon, color: statusColor, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    statusText,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4A6FA5).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      a['doctor'][0],
                      style: const TextStyle(
                        color: Color(0xFF4A6FA5),
                        fontSize: 20,
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
                        a['doctor'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        a['service'],
                        style: const TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _infoChip(Icons.calendar_today, _formatDate(a['date'])),
                const SizedBox(width: 12),
                _infoChip(Icons.access_time, _formatTime(a['time'])),
              ],
            ),
            if (a['status'] == 'upcoming') ...[
              const SizedBox(height: 20),
              const Divider(height: 1),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _actionButton(
                      'Reschedule',
                      Icons.refresh,
                      const Color(0xFF4A6FA5),
                      () => _showRescheduleDialog(a),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _actionButton(
                      'Cancel',
                      Icons.cancel,
                      Colors.red,
                      () => _showCancelDialog(a),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _infoChip(IconData i, String t) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: const Color(0xFF4A6FA5).withOpacity(0.05),
      borderRadius: BorderRadius.circular(30),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(i, size: 14, color: const Color(0xFF4A6FA5)),
        const SizedBox(width: 6),
        Text(t, style: const TextStyle(color: Color(0xFF1E293B), fontSize: 13)),
      ],
    ),
  );

  Widget _actionButton(String l, IconData i, Color c, VoidCallback o) =>
      ElevatedButton(
        onPressed: o,
        style: ElevatedButton.styleFrom(
          backgroundColor: c.withOpacity(0.1),
          foregroundColor: c,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(i, size: 18),
            const SizedBox(width: 6),
            Text(l, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      );

  void _showCancelDialog(Map<String, dynamic> a) {
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
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
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Icon(Icons.cancel, color: Colors.red, size: 30),
              ),
              const SizedBox(height: 16),
              const Text(
                'Cancel Appointment',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Are you sure you want to cancel this appointment?',
                style: TextStyle(color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Text(
                      '${a['service']} with ${a['doctor']}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_formatDate(a['date'])} at ${_formatTime(a['time'])}',
                      style: const TextStyle(color: Color(0xFF64748B)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'No, Keep It',
                        style: TextStyle(color: Color(0xFF64748B)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Update the status
                        setState(() {
                          a['status'] = 'cancelled';
                        });

                        // Pop the dialog
                        Navigator.pop(dialogContext);

                        // Show success message
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Appointment cancelled'),
                            backgroundColor: Colors.red,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text('Yes, Cancel'),
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

  void _showRescheduleDialog(Map<String, dynamic> a) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (bottomSheetContext) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Reschedule Appointment',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(bottomSheetContext),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ServicesScreen(
                appointments: widget.appointments,
                onBookAppointment: (newAppt) {
                  // Update the existing appointment
                  setState(() {
                    a['date'] = newAppt['date'];
                    a['time'] = newAppt['time'];
                    a['doctor'] = newAppt['doctor'];
                  });

                  // Pop the bottom sheet
                  Navigator.pop(bottomSheetContext);

                  // Show success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text(
                        'Appointment rescheduled successfully',
                      ),
                      backgroundColor: const Color(0xFF4A6FA5),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  );
                },
                patientName: widget.patientName,
                firstName: widget.firstName,
                lastName: widget.lastName,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime d) =>
      '${['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][d.month - 1]} ${d.day}, ${d.year}';
  String _formatMonthYear(DateTime d) =>
      '${['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][d.month - 1]} ${d.year}';
  String _formatTime(String t) {
    if (t.isEmpty) return '';
    List<String> p = t.split(':');
    if (p.length < 2) return t;
    int h = int.parse(p[0]), m = int.parse(p[1]);
    String period = h >= 12 ? 'PM' : 'AM';
    int displayHour = h > 12 ? h - 12 : h;
    displayHour = displayHour == 0 ? 12 : displayHour;
    return '$displayHour:${m.toString().padLeft(2, '0')} $period';
  }
}
