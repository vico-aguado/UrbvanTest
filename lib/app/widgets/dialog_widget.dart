import 'package:flutter/material.dart';
import 'package:urbvan/app/widgets/button_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:urbvan/configuration.dart';

void showAlertDialog(
    {BuildContext context,
    String message,
    Widget child,
    String title,
    String titleButton1 = "Aceptar",
    String titleButton2,
    bool loadingButton1 = false,
    Function() onTapButton1,
    Function() onTapButton2,
    Color colorButton1,
    Color colorButton2,
    Widget asset,
    double fontSizeMessage = 18,
    double fontSizeButton = 16,
    double height = 290,
    bool isOK = false,
    bool dismissible = true,
    bool centerText = true,
    bool isRow = true}) {
  double screenWidth = MediaQuery.of(context).size.width;
  double alto = 40;
  double paddingButtons = 10;
  TextStyle _styleButton = GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white);
  TextStyle _styleTitle = GoogleFonts.lato(fontSize: 19, fontWeight: FontWeight.w700, color: red_light_color);
  TextStyle _styleText = GoogleFonts.lato(fontSize: 15, fontWeight: FontWeight.w400, color: Color.fromRGBO(21, 25, 32, 0.7));

  showDialog(
      barrierDismissible: dismissible,
      context: context,
      builder: (BuildContext context) {
        Widget buttonsArea;
        if (titleButton2 == null || titleButton2 == "") {
          buttonsArea = ButtonWidget(
            height: alto,
            title: titleButton1,
            width: 250,
            style: _styleButton,
            onTap: () {
              if (onTapButton1 != null) {
                onTapButton1();
              }
              if (dismissible) {
                Navigator.of(context).pop();
              }
            },
          );
        } else {
          if (isRow) {
            buttonsArea = Row(
              children: <Widget>[
                SizedBox(
                  width: paddingButtons,
                ),
                SizedBox(
                  width: screenWidth <= 320 ? 90 : 120,
                  child: Center(
                    child: ButtonWidget(
                      height: alto,
                      title: titleButton1,
                      style: _styleButton,
                      width: screenWidth <= 320 ? 90 : 120,
                      isOutline: true,
                      onTap: () async {
                        if (onTapButton1 != null) {
                          await onTapButton1();
                          if (loadingButton1) {
                            await Future.delayed(Duration(milliseconds: 500));
                          }
                        }
                        if (dismissible) {
                          Navigator.of(context).pop(1);
                        }
                      },
                    ),
                  ),
                ),
                Spacer(),
                ButtonWidget(
                  height: alto,
                  title: titleButton2,
                  style: _styleButton,
                  width: screenWidth <= 320 ? 90 : 120,
                  onTap: () {
                    if (onTapButton2 != null) {
                      onTapButton2();
                    }
                    if (dismissible) {
                      Navigator.of(context).pop(2);
                    }
                  },
                ),
                SizedBox(
                  width: paddingButtons,
                )
              ],
            );
          } else {
            buttonsArea = Padding(
              padding: const EdgeInsets.only(right: 10, left: 10),
              child: Column(
                children: <Widget>[
                  ButtonWidget(
                    height: alto,
                    style: _styleButton,
                    title: titleButton2,
                    width: screenWidth,
                    onTap: () {
                      if (onTapButton2 != null) {
                        onTapButton2();
                      }
                      if (dismissible) {
                        Navigator.of(context).pop(2);
                      }
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ButtonWidget(
                    height: alto,
                    style: _styleButton,
                    title: titleButton1,
                    isOutline: true,
                    outlineColor: colorButton2,
                    width: screenWidth,
                    onTap: () {
                      if (onTapButton1 != null) {
                        onTapButton1();
                      }
                      if (dismissible) {
                        Navigator.of(context).pop(1);
                      }
                    },
                  ),
                ],
              ),
            );
          }
        }

        asset = asset != null ? asset : Container();

        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
          backgroundColor: Colors.white,
          child: Container(
            height: height,
            width: 300.0,
            color: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                title != null
                    ? Padding(
                        padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
                        child: asset is Container
                            ? Padding(
                                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: centerText
                                    ? Center(
                                        child: Text(
                                        title,
                                        style: _styleTitle,
                                      ))
                                    : Container(
                                        width: 300,
                                        child: Text(
                                          title,
                                          style: _styleTitle,
                                        ),
                                      ))
                            : Container(
                                child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Spacer(),
                                  if (asset != null) asset,
                                  Spacer(),
                                ],
                              )))
                    : Container(),
                SizedBox(
                  height: title != null ? 5 : 0,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, title != null ? 10 : 0, 20, 10),
                    child: child == null && message == null
                        ? Center(child: Text("Sin mensaje"))
                        : message == null
                            ? child == null
                                ? Center(child: Text("Sin mensaje"))
                                : child
                            : child == null
                                ? Center(
                                    child: Column(
                                    children: [
                                      Spacer(),
                                      centerText
                                          ? Center(
                                              child: Text(
                                              message,
                                              style: _styleText,
                                              textAlign: TextAlign.center,
                                            ))
                                          : Text(
                                              message,
                                              style: _styleText,
                                            ),
                                      Spacer(),
                                    ],
                                  ))
                                : Column(
                                    children: [
                                      centerText
                                          ? Center(
                                              child: Text(
                                              message,
                                              style: _styleText,
                                              textAlign: TextAlign.center,
                                            ))
                                          : Text(
                                              message,
                                              style: _styleText,
                                            ),
                                      Spacer(),
                                      child
                                    ],
                                  ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: buttonsArea,
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        );
      });
}
