import 'dart:io';
import 'package:e_concierge_tourism/common/google_search_api/google_search_api.dart';
import 'package:e_concierge_tourism/view/hotel_booking/successs_page.dart/success_booking.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:http/http.dart' as http;

class PdfApi {
  static var hotelImage;
  static Future<File> generatePdf(
      BookingDetails details, String image, String propertyName) async {
    final lang = detectInputLanguage(details.roomsAndmembers);
    final textDirection =
        lang == 'ar' ? pw.TextDirection.rtl : pw.TextDirection.ltr;
    final fontData =
        await rootBundle.load('assets/fonts/IBMPlexSansArabic-Regular.ttf');
    final customFont = pw.Font.ttf(fontData);
    final pdf = pw.Document();
    final hotelImageBytes = await _networkImageToBytes(image);
    if (hotelImageBytes != null) hotelImage = pw.MemoryImage(hotelImageBytes);

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          // pw.Image(hotelImage),
          // Header
          pw.Header(
            level: 0,
            child: pw.Text(
                propertyName[0].toUpperCase() + propertyName.substring(1),
                style: pw.TextStyle(
                    fontSize: 28,
                    fontWeight: pw.FontWeight.bold,
                    font: customFont),
                textDirection: textDirection),
          ),

          // Hotel Image
          if (hotelImage != null)
            pw.Image(
              hotelImage,
            ),

          // Booking Info Section
          pw.SizedBox(height: 20),
          pw.Text('Booking Information'.tr,
              style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                  font: customFont),
              textDirection: textDirection),
          pw.Divider(),
          pw.SizedBox(height: 10),
          pw.Text('${'Hotel'.tr}: ${details.hotelName}',
              style: pw.TextStyle(fontSize: 16, font: customFont),
              textDirection: textDirection),
          pw.Text('${'Check-in'.tr}: ${details.checkinTime}',
              style: pw.TextStyle(fontSize: 16, font: customFont),
              textDirection: textDirection),
          pw.Text('${'Check-out'.tr}: ${details.checkoutTime}',
              style: pw.TextStyle(fontSize: 16, font: customFont),
              textDirection: textDirection),
          pw.Text(
              '${'duration'.tr}: ${details.nightDays} ${'and'.tr} ${details.morningDays}',
              style: pw.TextStyle(fontSize: 16, font: customFont),
              textDirection: textDirection),
          pw.Text('${'Rooms and members'.tr}: ${details.roomsAndmembers}',
              textDirection: textDirection,
              style: pw.TextStyle(fontSize: 16, font: customFont)),
          pw.SizedBox(height: 10),

          // Customer Info Section
          pw.Text('Customer Information'.tr,
              style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                  font: customFont),
              textDirection: textDirection),
          pw.Divider(),
          pw.SizedBox(height: 10),
          pw.Text(
              '${'Name'.tr}: ${details.selectedOption ?? ""} ${details.firstName} ${details.lastName}',
              style: pw.TextStyle(fontSize: 16, font: customFont),
              textDirection: textDirection),
          pw.Text('${'email'.tr}: ${details.email}',
              style: pw.TextStyle(fontSize: 16, font: customFont),
              textDirection: textDirection),
          pw.Text('${'Mobile Number'.tr}: ${details.mobileNumber}',
              style: pw.TextStyle(fontSize: 16, font: customFont),
              textDirection: textDirection),
          pw.SizedBox(height: 10),

          // Payment Info Section
          pw.Text('Payment Information'.tr,
              style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                  font: customFont),
              textDirection: textDirection),
          pw.Divider(),
          pw.SizedBox(height: 10),
          pw.Text('${'Total Amount'.tr}: ${details.totalPrice}',
              style: pw.TextStyle(fontSize: 16, font: customFont),
              textDirection: textDirection),
          pw.SizedBox(height: 20),

          // Thank You Note
          pw.Text(
            'Thank you for your booking!'.tr,
            style: pw.TextStyle(
                fontSize: 18, fontWeight: pw.FontWeight.bold, font: customFont),
            textDirection: textDirection,
          ),
          pw.SizedBox(height: 20),

          // Signature Section
          pw.Directionality(
            textDirection: textDirection,
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('${'Signature'.tr}:',
                    style: pw.TextStyle(fontSize: 16, font: customFont),
                    textDirection: textDirection),
                pw.Container(width: 200, height: 1, color: PdfColors.black),
              ],
            ),
          )
        ],
      ),
    );

    return saveDocument(name: 'booking_receipt.pdf', pdf: pdf);
  }

  static Future<Uint8List?> _networkImageToBytes(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  static Future<File> saveDocument(
      {required String name, required pw.Document pdf}) async {
    final bytes = await pdf.save();

    final dir = GetPlatform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    final file = File('${dir!.path}/$name');

    await file.writeAsBytes(bytes);

    return file;
  }

  static Future<void> openFile(File file) async {
    final url = file.path;
    await OpenFile.open(url);
  }
}
