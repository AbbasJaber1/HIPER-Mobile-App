import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[900],
        title: Text('About Us'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            // Use Image.asset with BoxFit.cover to handle aspect ratio
            Container(
              width: 120, // Set the width of the container
              height: 120, // Set the height of the container
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/cropped-hiperao.png'),
                  fit: BoxFit.cover, // Ensure the image covers the space while maintaining aspect ratio
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'About Our Company',
              style: GoogleFonts.roboto(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.red[900],
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                '''
HIPER is an Application brand created especially to respond to the growing virtual demand for quality solutions in Angola, so that they are accessible not only through physical points of sale in the country, but also anywhere with internet access.

HIPER is the latest innovative branch that completes the supply chain of ICC Angola Lda, which is the leader in the home appliances market in Angola, and has been operating for more than 20 years in the fields of:

Distribution: exclusive distributor of more than ten leading global brands in domestic and industrial solutions such as Midea, Hisense, TCL, Clea, Toshiba, Electrolux, Frigidaire, Delonghi, Kenwood, Braun, Wahl, Babyliss, Luxcor, Primacor, Prestigío, Casa de Luxo;
Retail: owns more than 25 stores in Luanda, known as Hiperelectro, Hiperflex, Hipertinta, Hipertubo, including Hiper Armazéns;

Local producer: it has 8 manufacturing units of plastic and oil paints, mattresses and accessories, tubes, and an assembly unit of electrodmetics from Midea and Hisense.
                ''',
                textAlign: TextAlign.left,
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Our Values',
              style: GoogleFonts.roboto(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.red[900],
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.check_circle, color: Colors.red[900]),
                    title: Text(
                      'Customer Satisfaction',
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.check_circle, color: Colors.red[900]),
                    title: Text(
                      'Innovation',
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.check_circle, color: Colors.red[900]),
                    title: Text(
                      'Integrity',
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Contact Us',
              style: GoogleFonts.roboto(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.red[900],
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  Text(
                    'Email: abbasmoulla68@gmail.com',
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Phone: +961 81605882 / +961 81076902',
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
