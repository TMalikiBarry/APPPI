import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../core/assets.dart';
import '../../../../core/di.dart';
import '../../../../core/router.dart';
import '../../../../core/theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/models/qrcode_decode_error.dart';
import '../bloc/qrcode_scan/qrcode_scan_bloc.dart';
import '../bloc/qrcode_scan/qrcode_scan_event.dart';
import '../bloc/qrcode_scan/qrcode_scan_state.dart';
import 'qrcode_switch_btn.dart';

class QrcodeScanPage extends StatefulWidget {
  const QrcodeScanPage({super.key, this.action});

  final String? action; // send_now, send_receive, send_schedule

  @override
  State<QrcodeScanPage> createState() => _QrcodeScanPageState();
}

class _QrcodeScanPageState extends State<QrcodeScanPage> {
  //
  MobileScannerController controller = MobileScannerController(
    torchEnabled: false,
    formats: [BarcodeFormat.qrCode],
  );

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations traductions = AppLocalizations.of(context)!;
    QrcodeScanBloc qrcodeScanBloc = QrcodeScanBloc(Di.getQrcodeInputPort());
    double hauteur = MediaQuery.of(context).size.height;
    double textPos = hauteur / 4;

    // Scan window
    late final scanWindow = Rect.fromCenter(
      center: MediaQuery.sizeOf(context).center(const Offset(0, -50)),
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.width * 0.8,
    );

    return BlocProvider<QrcodeScanBloc>(
      create: (_) => qrcodeScanBloc,
      child: BlocConsumer<QrcodeScanBloc, QrcodeScanState>(
        bloc: qrcodeScanBloc,
        listenWhen: (previous, current) =>
            current is QrcodeScanSuccessState ||
            current is QrcodeScanErrorState,
        listener: (context, state) {
          if (state is QrcodeScanSuccessState) {
            AppRouter.pushReplacement(
              context,
              '${AppRouter.qrcodeTransactionSend}?action=${widget.action}',
              params: state.data,
            );
          } else if (state is QrcodeScanErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(_getErrorMessage(
                  state.error,
                  context,
                  traductions,
                )),
              ),
            );
            controller.start();
          }
        },
        builder: (context, state) {
          return Scaffold(
            extendBody: true,
            body: Stack(
              children: <Widget>[
                // Scanner area
                MobileScanner(
                  controller: controller,
                  scanWindow: scanWindow,
                  onDetect: (capture) {
                    final List<Barcode> barcodes = capture.barcodes;
                    for (final barcode in barcodes) {
                      if (barcode.rawValue != null) {
                        controller.stop();
                        qrcodeScanBloc.add(
                          QrcodeScanDecodeEvent(barcode.rawValue!),
                        );
                      }
                    }
                  },
                ),

                // Overlay
                CustomPaint(
                  size: MediaQuery.of(context).size,
                  painter: ScanWindowPainter(
                    borderColor: Colors.white,
                    borderRadius: BorderRadius.circular(16.0),
                    borderStrokeCap: StrokeCap.butt,
                    borderStrokeJoin: StrokeJoin.miter,
                    borderStyle: PaintingStyle.stroke,
                    borderWidth: 2.0,
                    scanWindow: scanWindow,
                    color: const Color.fromRGBO(0, 0, 0, 0.4),
                  ),
                ),

                // Close Btn
                Positioned(
                  top: 45,
                  left: 5,
                  child: IconButton(
                    onPressed: () {
                      controller.stop();
                      AppRouter.pushReplacement(context, AppRouter.home);
                    },
                    icon: const Icon(Icons.close),
                    color: Colors.white,
                  ),
                ),

                // Indication
                Positioned(
                  bottom: textPos,
                  right: 48,
                  left: 48,
                  child: Text(
                    traductions.qrcodeScanPageMessage,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall
                        ?.copyWith(color: Themer.whiteColor),
                  ),
                ),

                //
              ],
            ),
            bottomNavigationBar: Container(
              alignment: Alignment.bottomCenter,
              margin: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 10.0,
              ),
              height: 56,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Icon flash
                  FloatingActionButton(
                    onPressed: () => controller.toggleTorch(),
                    elevation: 0,
                    heroTag: "flash",
                    child: Image.asset(
                      controller.torchEnabled
                          ? Images.iconFlashOn
                          : Images.IconFlashOff,
                      width: 21,
                      height: 21,
                      color: Colors.white,
                      package: 'common_dependencies'
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Switch btn: Scan - Mon code
                  Expanded(
                    child: QrcodeSwitchBtn(
                      cardBgColor: const Color(0xFFE1E4EE),
                      items: [
                        // Scan
                        QrcodeBtnItem(
                          text: traductions.qrcodePageBtnScan,
                          textColor: Themer.primary,
                          btnColor: Themer.whiteColor,
                          // textColor: Theme.of(context).colorScheme.onSurface,
                          // btnColor: Theme.of(context).colorScheme.surface,
                          action: () {},
                        ),

                        // Mon code
                        QrcodeBtnItem(
                          text: traductions.qrcodePageBtnMonCode,
                          textColor: const Color(0xFF667085),
                          btnColor: Colors.transparent,
                          // textColor: Theme.of(context).colorScheme.surface,
                          // btnColor: Colors.transparent,
                          action: () {
                            controller.stop();
                            AppRouter.push(context, AppRouter.qrcodeShow);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Icon Galery
                  FloatingActionButton(
                    onPressed: () async {
                      controller.stop();
                      qrcodeScanBloc.add(const QrcodeScanSelectEvent());
                    },
                    elevation: 0,
                    heroTag: "galery",
                    child:
                        Image.asset(Images.iconsGalerie, width: 21, height: 21,
                            color: Colors.white, package: 'common_dependencies'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Return QR Code Scan Error Message
  String _getErrorMessage(
    QrCodeDecodeError error,
    BuildContext context,
    AppLocalizations traductions,
  ) {
    if (error == QrCodeDecodeError.notQrImage) {
      return traductions.qrcodeDecodeErrorNotQrImage;
    } else if (error == QrCodeDecodeError.invalidAlias) {
      return traductions.qrcodeDecodeErrorInvalideAlias;
    } else {
      return traductions.qrcodeDecodeErrorInvalideFormat;
    }
  }
}

/// This class represents a [CustomPainter] that draws a [scanWindow] rectangle.
class ScanWindowPainter extends CustomPainter {
  /// Construct a new [ScanWindowPainter] instance.
  const ScanWindowPainter({
    required this.borderColor,
    required this.borderRadius,
    required this.borderStrokeCap,
    required this.borderStrokeJoin,
    required this.borderStyle,
    required this.borderWidth,
    required this.color,
    required this.scanWindow,
  });

  /// The color for the scan window border.
  final Color borderColor;

  /// The border radius for the scan window and its border.
  final BorderRadius borderRadius;

  /// The stroke cap for the border around the scan window.
  final StrokeCap borderStrokeCap;

  /// The stroke join for the border around the scan window.
  final StrokeJoin borderStrokeJoin;

  /// The style for the border around the scan window.
  final PaintingStyle borderStyle;

  /// The width for the border around the scan window.
  final double borderWidth;

  /// The color for the scan window box.
  final Color color;

  /// The rectangle that defines the scan window.
  final Rect scanWindow;

  @override
  void paint(Canvas canvas, Size size) {
    if (scanWindow.isEmpty || scanWindow.isInfinite) {
      return;
    }

    // Define the main overlay path covering the entire screen.
    final backgroundPath = Path()..addRect(Offset.zero & size);

    // The cutout rect depends on the border radius.
    final RRect cutoutRect = borderRadius == BorderRadius.zero
        ? RRect.fromRectAndCorners(scanWindow)
        : RRect.fromRectAndCorners(
            scanWindow,
            topLeft: borderRadius.topLeft,
            topRight: borderRadius.topRight,
            bottomLeft: borderRadius.bottomLeft,
            bottomRight: borderRadius.bottomRight,
          );

    // The cutout path is always in the center.
    final Path cutoutPath = Path()..addRRect(cutoutRect);

    // Combine the two paths: overlay minus the cutout area
    final Path overlayWithCutoutPath = Path.combine(
      PathOperation.difference,
      backgroundPath,
      cutoutPath,
    );

    final Paint overlayWithCutoutPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.srcOver; // android

    final Paint borderPaint = Paint()
      ..color = borderColor
      ..style = borderStyle
      ..strokeWidth = borderWidth
      ..strokeCap = borderStrokeCap
      ..strokeJoin = borderStrokeJoin;

    // Paint the overlay with the cutout.
    canvas.drawPath(overlayWithCutoutPath, overlayWithCutoutPaint);

    // Then, draw the border around the cutout area.
    canvas.drawRRect(cutoutRect, borderPaint);
  }

  @override
  bool shouldRepaint(ScanWindowPainter oldDelegate) {
    return oldDelegate.scanWindow != scanWindow ||
        oldDelegate.color != color ||
        oldDelegate.borderRadius != borderRadius;
  }
}
