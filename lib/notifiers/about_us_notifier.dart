import 'package:flutter/foundation.dart';
import '../models/about_us.dart';

class AboutUsNotifier extends ChangeNotifier {
  AboutUs? _aboutUs;
  bool _isLoading = false;
  String? _error;

  AboutUs? get aboutUs => _aboutUs;
  bool get isLoading => _isLoading;
  String? get error => _error;

  AboutUsNotifier() {
    _loadAboutUs();
  }

  void _loadAboutUs() {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulating data load with static data
      // In a real app, this would be an API call
      _aboutUs = AboutUs(
        companyName: 'Medorica Pharma Pvt. Ltd.',
        description: 
            'Medorica Pharma Pvt. Ltd. is a leading pharmaceutical company dedicated to improving healthcare through innovative medicines and quality healthcare solutions. '
            'Established with a vision to provide accessible and affordable healthcare to all, we have been serving the medical community with excellence for years.\n\n'
            'Our state-of-the-art manufacturing facilities comply with international quality standards and are equipped with the latest technology. '
            'We specialize in the development, manufacturing, and marketing of a wide range of pharmaceutical products across various therapeutic segments including cardiovascular, '
            'anti-diabetic, anti-infective, gastroenterology, and respiratory care.\n\n'
            'At Medorica Pharma, we believe in the power of research and innovation. Our dedicated team of scientists and researchers work tirelessly to develop new formulations '
            'and improve existing ones. We are committed to maintaining the highest standards of quality, safety, and efficacy in all our products.\n\n'
            'Our mission is to enhance the quality of life by providing reliable and effective pharmaceutical solutions. We work closely with healthcare professionals, '
            'distributors, and medical representatives to ensure our products reach those who need them most.',
        directorName: 'Dr. Rajesh Kumar',
        directorMessage: 
            'Welcome to Medorica Pharma! It is with great pleasure that I address you as the Director of this esteemed organization. '
            'Our journey has been one of dedication, innovation, and unwavering commitment to healthcare excellence.\n\n'
            'We understand that behind every prescription is a patient seeking better health, and this drives us to maintain the highest standards in everything we do. '
            'Our team is passionate about making a difference in people\'s lives through quality pharmaceutical products.\n\n'
            'I am proud of our medical representatives who work tirelessly in the field, building strong relationships with healthcare professionals and ensuring '
            'that our products are accessible to all who need them. Together, we are working towards a healthier future.\n\n'
            'Thank you for being a part of the Medorica Pharma family.',
        directorPhotoUrl: 'assets/logo/logo.png',
        phone: '+91 98765 43210',
        email: 'info@medoricapharma.com',
        address: '123, Pharma Complex, Industrial Area, Sector 25, Pune, Maharashtra 411001, India',
        mapUrl: 'https://maps.google.com/?q=Pune+Maharashtra+India',
      );
      _error = null;
    } catch (e) {
      _error = 'Failed to load About Us information';
      debugPrint('Error loading About Us: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void refresh() {
    _loadAboutUs();
  }
}
