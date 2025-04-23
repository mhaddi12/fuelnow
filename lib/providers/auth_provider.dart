// sign_up_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/auth_model.dart' show SignUpFormState;
import '../view_models/auth_view_model.dart';


final signUpNotifierProvider = StateNotifierProvider<SignUpNotifier, SignUpFormState>(
      (ref) => SignUpNotifier(),
);
