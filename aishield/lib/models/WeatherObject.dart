import 'package:flutter/material.dart';

class Weather {
  final String? dataSent;
  final String? error;
  final String? temperature;
  final String? waterLevel;
  final String? moisture;
  final String? rainMillimeter;
  final String? time;
  final String? buzzerStatus;
  final double? averageTemperature;
  final double? averagemm;
  final int? averageWaterLevel;
  final int? averageRainMillimeter;

  Weather({
    this.dataSent,
    this.error,
    this.temperature,
    this.waterLevel,
    this.moisture,
    this.rainMillimeter,
    this.time,
    this.buzzerStatus,
    this.averageTemperature,
    this.averagemm,
    this.averageWaterLevel,
    this.averageRainMillimeter,
  });

  Weather.fromMap(Map<String, dynamic> map)
      : dataSent = map['A) dataSent'] ?? "",
        error = map['A) Error'] ?? "",
        temperature = map['B) Temperature'] ?? "",
        waterLevel = map['C) Water Level'] ?? "",
        moisture = map["D) Moisture"] ?? "",
        rainMillimeter = map["E) Rain Millimeter"] ?? "",
        time = map["F) Time"] ?? "",
        buzzerStatus = map["G) Buzzer Status"] ?? "",
        averageTemperature = map["W) Average Temperature"] ?? 0.00,
        averagemm = map["X) Average Mm"] ?? 0.00,
        averageWaterLevel = map["Y) Average Water Level"] ?? 0,
        averageRainMillimeter = map["Z) Average Rain Millimeter"] ?? 0;

  Map<String, dynamic> toMap(String id) {
    return {
      'dataSent': dataSent,
      'error': error,
      'temperature': temperature,
      'waterLevel': waterLevel,
      'moisture': moisture,
      'rainMillimeter': rainMillimeter,
      'time': time,
      'buzzerStatus': buzzerStatus,
      'averageTemperature': averageTemperature,
      'averagemm': averagemm,
      'averageWaterLevel': averageWaterLevel,
      'averageRainMillimeter': averageRainMillimeter
    };
  }
}
