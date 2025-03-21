import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leeds_library/presentation/screens/barcode_scanner_screen/barcode_scanner_screen.dart';
import 'package:leeds_library/presentation/widgets/barcode_scanner_dialog/bloc/scanner_block.dart';
import 'package:leeds_library/presentation/widgets/barcode_scanner_dialog/bloc/scanner_event.dart';
import 'package:leeds_library/presentation/widgets/barcode_scanner_dialog/bloc/scanner_state.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeScannerDialog extends StatelessWidget {
  const BarcodeScannerDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        height: 400,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                'Сканування штрихкоду',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
                child: BlocProvider(
                    create: (context) => BarcodeScannerBloc()..add(RequestCameraPermission()),
                    //sl<BarcodeScannerBloc>()..add(RequestCameraPermission()),
                    child: Scaffold(
                      body:
                          BlocConsumer<BarcodeScannerBloc, BarcodeScannerState>(
                        listener: (context, state) {},
                        builder: (context, state) {
                          if (state is BarcodeScannerPermissionDenied) {
                            return Center(
                                child: Text("Camera permission denied"));
                          }
                          if (state is BarcodeScannerSuccess) {
                            Navigator.of(context).pop(state.barcode);
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Scanned Code:",
                                      style: TextStyle(fontSize: 18)),
                                  Text(state.barcode,
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(height: 20),
                                  Center(child: CircularProgressIndicator())

                                  /* ElevatedButton(
                        onPressed: () => context
                            .read<BarcodeScannerBloc>()
                            .add(RequestCameraPermission()),
                        child: Text("Scan Again"),
                      ),*/
                                ],
                              ),
                            );

                          }

                          if (state is ServerError) {
                            return Text("error: ${state.error}");
                          }

                          return MobileScanner(
                            onDetect: (BarcodeCapture capture) {
                              final List<Barcode> barcodes = capture.barcodes;
                              if (barcodes.isNotEmpty &&
                                  barcodes.first.rawValue != null) {
                                context.read<BarcodeScannerBloc>().add(
                                    BarcodeScanned(barcodes.first.rawValue!));
                              }
                            },
                          );
                        },
                      ),
                    ))),
            Padding(
              padding: const EdgeInsets.all(12),
              child: ElevatedButton.icon(
                icon: Icon(Icons.close),
                label: Text("Закрити"),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
