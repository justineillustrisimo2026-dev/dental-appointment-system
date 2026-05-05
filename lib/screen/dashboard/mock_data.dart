import 'package:flutter/material.dart';

class MockData {
  static const List<Map<String, dynamic>> services = [
    // ── SERVICE DATA ──
    {
      'id': 'consultation',
      'n': 'Consultation',
      'desc':
          'Discuss your oral health concerns with our dentist. A full exam to assess your dental health and recommend treatments.',
      'p': '₱500',
      'dur': '30 mins',
      'img': 'assets/consultation1.jpg',
      'before': [
        'Bring any previous dental records or x-rays if available.',
        'Brush and floss your teeth prior to the visit.',
        'Prepare a list of medications you are currently taking.',
      ],
      'after': [
        'Follow the personalized treatment plan provided by the dentist.',
        'Schedule any recommended follow-up appointments.',
      ],
      'warnings': [
        'If you have severe, acute pain, please let us know immediately so we can prioritize emergency treatment.',
      ],
    },
    {
      'id': 'xray',
      'n': 'Panoramic X-ray',
      'desc':
          'A wide-view X-ray of your entire mouth to diagnose hidden issues including teeth, jaws, and bone structure.',
      'p': '₱800',
      'dur': '15 mins',
      'img': 'assets/xray.jpg',
      'before': [
        'Remove all jewelry, earrings, and piercings from your head and neck.',
        'Inform the staff if you have any metal implants in your head or jaw.',
      ],
      'after': [
        'You may resume normal activities immediately.',
        'The dentist will review the results with you shortly after.',
      ],
      'warnings': [
        'Cannot be performed if you are pregnant or suspect you might be pregnant.',
        'Cannot be performed on infants without strict pediatric necessity.',
      ],
    },
    {
      'id': 'extraction',
      'n': 'Tooth Extraction',
      'desc':
          'Safe removal of a damaged or decayed tooth to prevent infection and protect surrounding teeth.',
      'p': '₱500',
      'dur': '45 mins',
      'img': 'assets/extraction.jpg',
      'before': [
        'Eat a light meal beforehand; do not come on an empty stomach.',
        'Take any pre-prescribed antibiotics if instructed by the dentist.',
      ],
      'after': [
        'Bite down on the gauze pad for 30-45 minutes to stop bleeding.',
        'Do not use a straw, spit forcefully, or smoke for 24 hours.',
        'Eat only soft foods (yogurt, soup, mashed potatoes) for the first day.',
      ],
      'warnings': [
        'Cannot be performed if you have dangerously high blood pressure on the day of the visit.',
        'Cannot be performed if there is a massive active infection without prior antibiotic treatment.',
      ],
    },
    {
      'id': 'cleaning',
      'n': 'Cleaning',
      'desc':
          'Professional removal of stubborn plaque and tartar to prevent cavities and gum disease effectively.',
      'p': '₱600',
      'dur': '45 mins',
      'img': 'assets/cleaning.jpg',
      'before': [
        'Maintain your normal brushing and flossing routine.',
        'Inform the dentist if you have sensitive teeth so we can apply numbing gel.',
      ],
      'after': [
        'Wait at least 30 minutes before eating or drinking.',
        'Your gums may feel slightly tender; this will subside within a day.',
      ],
      'warnings': [
        'Cannot be performed if you have severe, untreated periodontitis (requires a Deep Scaling procedure instead).',
      ],
    },
    {
      'id': 'filling',
      'n': 'Dental Filling',
      'desc':
          'Removes decay and fills the cavity with durable composite resin to restore the tooth\'s shape and function.',
      'p': '₱500',
      'dur': '1 hour',
      'img': 'assets/filling.jpg',
      'before': ['Brush your teeth thoroughly before your appointment.'],
      'after': [
        'Wait until the anesthesia completely wears off before chewing to avoid biting your cheek or tongue.',
        'Avoid overly hot or cold drinks for 24 hours if experiencing sensitivity.',
      ],
      'warnings': [
        'Cannot be performed if the tooth decay has reached the pulp/nerve (this requires a Root Canal instead).',
      ],
    },
    {
      'id': 'braces',
      'n': 'Braces Installation',
      'desc':
          'Orthodontic devices bonded to teeth with a wire to gradually shift teeth into proper alignment for a perfect smile.',
      'p': '₱35,000',
      'dur': '2 hours',
      'img': 'assets/braces.jpg',
      'before': [
        'Ensure you have had a professional cleaning within the last month.',
        'Eat a full meal before coming in, as your teeth will be tender afterward.',
      ],
      'after': [
        'Stick to a soft-food diet for the first week.',
        'Avoid sticky (caramel, gum) and hard (nuts, ice) foods for the duration of your treatment.',
        'Use orthodontic wax if brackets irritate your cheeks.',
      ],
      'warnings': [
        'Cannot be installed if you have active cavities or severe gum disease.',
        'Cannot be installed if there is insufficient bone density.',
      ],
    },
    {
      'id': 'adjustment',
      'n': 'Braces Adjustment',
      'desc':
          'Regular tightening every 4–6 weeks to continue moving teeth toward their ideal position.',
      'p': '₱500',
      'dur': '30 mins',
      'img': 'assets/adjustment.jpg',
      'before': ['Brush and floss meticulously right before the appointment.'],
      'after': [
        'Expect teeth to feel sore or tight for 1-3 days.',
        'Take over-the-counter pain relievers if necessary.',
        'Switch to soft foods until the tenderness subsides.',
      ],
      'warnings': [
        'If brackets are broken, the adjustment may be delayed or take longer.',
      ],
    },
    {
      'id': 'rootcanal',
      'n': 'Root Canal',
      'desc':
          'Removes infected pulp, cleans and seals root canals to save the tooth from extraction.',
      'p': '₱5,000',
      'dur': '1–2 hours',
      'img': 'assets/rootcanal.jpg',
      'before': [
        'Take all prescribed antibiotics as directed prior to the visit.',
        'Eat a moderate meal before the procedure.',
      ],
      'after': [
        'Do not chew on the treated side until a permanent crown is placed.',
        'Mild discomfort is normal for a few days; take prescribed pain relievers.',
      ],
      'warnings': [
        'Cannot be performed if the tooth root is vertically fractured.',
        'Cannot be performed if the bone support around the tooth is entirely lost.',
      ],
    },
    {
      'id': 'bleaching',
      'n': 'Teeth Bleaching',
      'desc':
          'Peroxide-based whitening removes deep stains for a noticeably brighter, more confident smile.',
      'p': '₱3,000',
      'dur': '1 hour',
      'img': 'assets/bleaching.jpg',
      'before': [
        'A dental cleaning is highly recommended 1-2 weeks prior for best results.',
        'Use sensitivity toothpaste a few days before if you are prone to tooth sensitivity.',
      ],
      'after': [
        'Strictly avoid coffee, tea, red wine, and dark berries for 48 hours (the "White Diet").',
        'Do not smoke for at least 48 hours.',
      ],
      'warnings': [
        'Cannot be performed if you have untreated cavities or exposed tooth roots.',
        'Not recommended for patients under 16 years of age.',
        'Will not whiten existing crowns, veneers, or fillings.',
      ],
    },
    {
      'id': 'wisdom',
      'n': 'Wisdom Tooth',
      'desc':
          'Surgical extraction of impacted third molars causing pain, infection, or crowding of other teeth.',
      'p': '₱2,500',
      'dur': '1 hour',
      'img': 'assets/wisdom.jpg',
      'before': [
        'Arrange for someone to drive you home if you are receiving heavy sedation.',
        'Wear comfortable, loose-fitting clothing.',
      ],
      'after': [
        'Apply an ice pack to your cheek for 15 minutes on, 15 minutes off to reduce swelling.',
        'Do not spit, rinse vigorously, or use a straw to prevent Dry Socket.',
        'Stick to a liquid and soft-food diet for 3 days.',
      ],
      'warnings': [
        'Cannot be extracted if there is a massive acute infection (antibiotics required first).',
        'High risk if the root is wrapped directly around the mandibular nerve (requires specialist evaluation).',
      ],
    },
    {
      'id': 'dentures',
      'n': 'Dentures',
      'desc':
          'Custom-made removable prosthetics replacing missing teeth and restoring ability to chew and speak.',
      'p': '₱15,000',
      'dur': 'Multiple visits',
      'img': 'assets/dentures.jpg',
      'before': [
        'Ensure gums have fully healed if teeth were recently extracted.',
      ],
      'after': [
        'Practice reading aloud to adjust to speaking with dentures.',
        'Remove and clean dentures nightly; soak them in water or denture solution.',
        'Start by eating soft foods cut into small pieces.',
      ],
      'warnings': [
        'May not fit properly if there has been severe, untreated jaw bone loss.',
      ],
    },
    {
      'id': 'crown',
      'n': 'Dental Crown',
      'desc':
          'A tooth-shaped cap placed over a damaged tooth restoring its shape, size, strength, and appearance.',
      'p': '₱8,000',
      'dur': '2 visits',
      'img': 'assets/crown.jpg',
      'before': ['None specific, but ensure the tooth is clean.'],
      'after': [
        'While wearing the temporary crown, avoid sticky or extremely hard foods.',
        'Once the permanent crown is placed, brush and floss normally, paying attention to the gum line.',
      ],
      'warnings': [
        'Cannot be placed if there is insufficient natural tooth structure remaining to hold the crown.',
      ],
    },
    {
      'id': 'bridge',
      'n': 'Dental Bridge',
      'desc':
          'Two crowns anchoring a false tooth in between, bridging the gap left by one or more missing teeth.',
      'p': '₱12,000',
      'dur': '2 visits',
      'img': 'assets/bridge.jpg',
      'before': [
        'Ensure the anchor teeth on either side of the gap are healthy.',
      ],
      'after': [
        'Avoid extremely hard or sticky foods on the temporary bridge.',
        'Use a special floss threader to clean underneath the permanent bridge daily.',
      ],
      'warnings': [
        'Cannot be placed if the neighboring anchor teeth are severely decayed or mobile.',
      ],
    },
  ];

  static const List<Map<String, String>> dentists = [
    // ── DENTIST DATA ──
    {
      'name': 'Dr. Krischelle Ayunan',
      'spec': 'Lead Orthodontist & Endodontist',
      'img': 'assets/krischelle.png',
      'desc':
          'Dr. Ayunan is dedicated to providing personalized, high-quality dental care. With an expert background in advanced orthodontics, she ensures every patient achieves their masterpiece smile utilizing modern, pain-free techniques and precision care.',
      'services':
          'Consultation, Panoramic X-ray, Tooth Extraction, Cleaning, Dental Filling, Braces Installation, Braces Adjustment, Root Canal, Teeth Bleaching, Wisdom Tooth, Dentures, Dental Crown, Dental Bridge',
    },
    {
      'name': 'Dr. Clyde Cabahug',
      'spec': 'General Dentist',
      'img': 'assets/clyde.png',
      'desc':
          'Dr. Cabahug specializes in comprehensive general dentistry. With a gentle approach and a focus on preventative care, he is committed to maintaining optimal oral health for patients of all ages, ensuring a comfortable and stress-free experience.',
      'services':
          'Consultation, Panoramic X-ray, Tooth Extraction, Cleaning, Dental Filling, Teeth Bleaching, Dentures, Dental Crown, Dental Bridge',
    },
  ];

  static const List<Map<String, String>> staff = [
    // ── STAFF DATA ──
    {
      'name': 'Christine Francis Mae Anque',
      'role': 'Front Desk',
      'img': 'assets/christine.png',
    },
    {
      'name': 'Ashly Abucay Pepito',
      'role': 'Assistant',
      'img': 'assets/ashly.png',
    },
    {
      'name': 'Arnette Maica Turtoza',
      'role': 'Assistant',
      'img': 'assets/arnette.png',
    },
  ];

  static const List<Map<String, dynamic>> tips = [
    // ── TIPS DATA ──
    {
      'i': Icons.water_drop_outlined,
      't': 'Stay Hydrated',
      'd':
          'Water after meals washes away food particles. This keeps your mouth fresh and acidic levels balanced.',
    },
    {
      'i': Icons.auto_awesome_outlined,
      't': 'Brush Twice Daily',
      'd':
          'Morning and night, 2 minutes each session. Use a soft-bristled brush to protect your gums.',
    },
    {
      'i': Icons.linear_scale_rounded,
      't': 'Floss Regularly',
      'd':
          'Daily flossing prevents gum disease effectively. It reaches tight spaces where brushing alone cannot.',
    },
    {
      'i': Icons.eco_outlined,
      't': 'Eat Healthily',
      'd':
          'Reduce sugar intake to protect tooth enamel. Crunchy fruits and vegetables also help clean your teeth naturally.',
    },
    {
      'i': Icons.medical_services_outlined,
      't': 'Regular Checkups',
      'd':
          'Visit us every 6 months for professional cleaning. Early detection saves you from more complex procedures.',
    },
  ];
}
