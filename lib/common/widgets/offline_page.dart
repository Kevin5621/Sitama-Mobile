// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:Sitama/core/config/assets/app_images.dart';
// import 'package:Sitama/common/bloc/button/button_state.dart';
// import 'package:Sitama/common/bloc/button/button_state_cubit.dart';

// class OfflinePage extends StatelessWidget {
//   final VoidCallback onRetry;

//   const OfflinePage({super.key, required this.onRetry});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => ButtonStateCubit(),
//       child: BlocBuilder<ButtonStateCubit, ButtonState>(
//         builder: (context, state) {
//           return Center(
//             child: Padding(
//               padding: const EdgeInsets.all(24.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Image.asset(
//                     AppImages.offline,
//                     height: 200,
//                     width: 200,
//                   ),
//                   const SizedBox(height: 24),
//                   Text(
//                     'Tidak ada koneksi internet',
//                     style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                           fontWeight: FontWeight.bold,
//                         ),
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     'Periksa koneksi internet Anda dan coba lagi',
//                     style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                           color: Colors.grey,
//                         ),
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 24),
//                   ElevatedButton.icon(
//                     onPressed: state is ButtonLoadingState ? null : onRetry,
//                     icon: state is ButtonLoadingState
//                         ? const SizedBox(
//                             width: 20,
//                             height: 20,
//                             child: CircularProgressIndicator(
//                               strokeWidth: 2,
//                             ),
//                           )
//                         : const Icon(Icons.refresh),
//                     label: Text(
//                       state is ButtonLoadingState
//                           ? 'Menghubungkan...'
//                           : 'Coba Lagi',
//                     ),
//                     style: ElevatedButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 24,
//                         vertical: 12,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }