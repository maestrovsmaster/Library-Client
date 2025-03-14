import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leeds_library/core/di/di_container.dart';
import 'package:leeds_library/presentation/block/barcode_scanner/barcode_scanner_block.dart';
import 'package:leeds_library/presentation/block/barcode_scanner/barcode_scanner_event.dart';
import 'package:leeds_library/presentation/block/barcode_scanner/barcode_scanner_state.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeScannerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) =>
            sl<BarcodeScannerBloc>()..add(RequestCameraPermission()),
        child: Scaffold(
          appBar: AppBar(title: const Text('Scan Barcode')),
          body: BlocConsumer<BarcodeScannerBloc, BarcodeScannerState>(
            listener: (context, state) {},
            builder: (context, state) {
              if (state is BarcodeScannerPermissionDenied) {
                return Center(child: Text("Camera permission denied"));
              }
              if (state is BarcodeScannerSuccess) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Scanned Code:", style: TextStyle(fontSize: 18)),
                      Text(state.barcode,
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold)),
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
              if (state is BookNotFound) {
                return Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      Text("Book not found"),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => context
                            .read<BarcodeScannerBloc>()
                            .add(RequestCameraPermission()),
                        child: Text("Scan Again"),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          //go to create book
                        },
                        child: Text("Add new book"),
                      ),
                    ]));
              }
              if (state is BookFound) {
                return Text("Book  found: ${state.book.title}");
              }

              if (state is ServerError) {
                return Text("Server error: ${state.error}");
              }
              if (state is BookFound) {}
              return MobileScanner(
                onDetect: (BarcodeCapture capture) {
                  final List<Barcode> barcodes = capture.barcodes;
                  if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
                    context
                        .read<BarcodeScannerBloc>()
                        .add(BarcodeScanned(barcodes.first.rawValue!));
                  }
                },
              );
            },
          ),
        ));
  }
}
