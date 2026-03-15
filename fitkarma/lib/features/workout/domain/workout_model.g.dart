// lib/features/workout/domain/workout_model.g.dart
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WorkoutAdapter extends TypeAdapter<Workout> {
  @override
  final int typeId = 30;

  @override
  Workout read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Workout(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      category: fields[3] as String,
      youtubeId: fields[4] as String,
      durationMinutes: fields[5] as int,
      difficulty: fields[6] as String,
      thumbnailUrl: fields[7] as String?,
      tags: (fields[8] as List?)?.cast<String>() ?? [],
      caloriesBurn: fields[9] as int? ?? 0,
      isCustom: fields[10] as bool? ?? false,
      createdAt: fields[11] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Workout obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(4)
      ..write(obj.youtubeId)
      ..writeByte(5)
      ..write(obj.durationMinutes)
      ..writeByte(6)
      ..write(obj.difficulty)
      ..writeByte(7)
      ..write(obj.thumbnailUrl)
      ..writeByte(8)
      ..write(obj.tags)
      ..writeByte(9)
      ..write(obj.caloriesBurn)
      ..writeByte(10)
      ..write(obj.isCustom)
      ..writeByte(11)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkoutAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WorkoutExerciseAdapter extends TypeAdapter<WorkoutExercise> {
  @override
  final int typeId = 31;

  @override
  WorkoutExercise read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WorkoutExercise(
      id: fields[0] as String,
      name: fields[1] as String,
      sets: fields[2] as int? ?? 3,
      reps: fields[3] as int? ?? 10,
      restSeconds: fields[4] as int? ?? 30,
      durationSeconds: fields[5] as int?,
      notes: fields[6] as String?,
      weightKg: fields[7] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, WorkoutExercise obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.sets)
      ..writeByte(3)
      ..write(obj.reps)
      ..writeByte(4)
      ..write(obj.restSeconds)
      ..writeByte(5)
      ..write(obj.durationSeconds)
      ..writeByte(6)
      ..write(obj.notes)
      ..writeByte(7)
      ..write(obj.weightKg);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkoutExerciseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CustomWorkoutAdapter extends TypeAdapter<CustomWorkout> {
  @override
  final int typeId = 32;

  @override
  CustomWorkout read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CustomWorkout(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String? ?? '',
      exercises: (fields[3] as List?)?.cast<WorkoutExercise>() ?? [],
      createdAt: fields[4] as DateTime,
      lastPerformed: fields[5] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, CustomWorkout obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.exercises)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.lastPerformed);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomWorkoutAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WorkoutLogAdapter extends TypeAdapter<WorkoutLog> {
  @override
  final int typeId = 33;

  @override
  WorkoutLog read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WorkoutLog(
      id: fields[0] as String,
      odId: fields[1] as String,
      workoutId: fields[2] as String,
      workoutTitle: fields[3] as String,
      startTime: fields[4] as DateTime,
      endTime: fields[5] as DateTime?,
      durationMinutes: fields[6] as int? ?? 0,
      caloriesBurned: fields[7] as int? ?? 0,
      notes: fields[8] as String?,
      syncStatus: fields[9] as String? ?? 'pending',
      category: fields[10] as String?,
      difficulty: fields[11] as String? ?? 'beginner',
      distanceKm: fields[12] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, WorkoutLog obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.odId)
      ..writeByte(2)
      ..write(obj.workoutId)
      ..writeByte(3)
      ..write(obj.workoutTitle)
      ..writeByte(4)
      ..write(obj.startTime)
      ..writeByte(5)
      ..write(obj.endTime)
      ..writeByte(6)
      ..write(obj.durationMinutes)
      ..writeByte(7)
      ..write(obj.caloriesBurned)
      ..writeByte(8)
      ..write(obj.notes)
      ..writeByte(9)
      ..write(obj.syncStatus)
      ..writeByte(10)
      ..write(obj.category)
      ..writeByte(11)
      ..write(obj.difficulty)
      ..writeByte(12)
      ..write(obj.distanceKm);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkoutLogAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PersonalRecordAdapter extends TypeAdapter<PersonalRecord> {
  @override
  final int typeId = 34;

  @override
  PersonalRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PersonalRecord(
      id: fields[0] as String,
      odId: fields[1] as String,
      exerciseName: fields[2] as String,
      maxWeight: fields[3] as double,
      maxReps: fields[4] as int,
      maxDuration: fields[5] as int,
      achievedAt: fields[6] as DateTime,
      workoutLogId: fields[7] as String?,
      recordType: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PersonalRecord obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.odId)
      ..writeByte(2)
      ..write(obj.exerciseName)
      ..writeByte(3)
      ..write(obj.maxWeight)
      ..writeByte(4)
      ..write(obj.maxReps)
      ..writeByte(5)
      ..write(obj.maxDuration)
      ..writeByte(6)
      ..write(obj.achievedAt)
      ..writeByte(7)
      ..write(obj.workoutLogId)
      ..writeByte(8)
      ..write(obj.recordType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PersonalRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ScheduledWorkoutAdapter extends TypeAdapter<ScheduledWorkout> {
  @override
  final int typeId = 35;

  @override
  ScheduledWorkout read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ScheduledWorkout(
      id: fields[0] as String,
      odId: fields[1] as String,
      workoutId: fields[2] as String,
      title: fields[3] as String,
      scheduledDate: fields[4] as DateTime,
      workoutType: fields[5] as String?,
      isRestDay: fields[6] as bool? ?? false,
      notes: fields[7] as String?,
      completed: fields[8] as bool? ?? false,
      syncStatus: fields[9] as String? ?? 'pending',
    );
  }

  @override
  void write(BinaryWriter writer, ScheduledWorkout obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.odId)
      ..writeByte(2)
      ..write(obj.workoutId)
      ..writeByte(3)
      ..write(obj.title)
      ..writeByte(4)
      ..write(obj.scheduledDate)
      ..writeByte(5)
      ..write(obj.workoutType)
      ..writeByte(6)
      ..write(obj.isRestDay)
      ..writeByte(7)
      ..write(obj.notes)
      ..writeByte(8)
      ..write(obj.completed)
      ..writeByte(9)
      ..write(obj.syncStatus);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScheduledWorkoutAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
