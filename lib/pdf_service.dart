import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart'
    as pw;

class PdfService {

  static Future<pw.Document>
      generateReport(
    List report,
  ) async {

    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) {

          return pw.Column(
            children: [

              pw.Text(
                "Monthly Milk Report",
              ),

              pw.SizedBox(
                height: 20,
              ),

              ...report.map(
                (item) {

                  return pw.Text(
                    "${item["name"]}  Bill:${item["bill"]}  Paid:${item["paid"]}",
                  );
                },
              ),
            ],
          );
        },
      ),
    );

    return pdf;
  }
}