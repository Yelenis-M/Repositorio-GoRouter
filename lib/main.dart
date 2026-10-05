import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() => runApp(const MyApp());

// 1. Configuración del Router (Tu código adaptado)
final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
      routes: [
        GoRoute(
          path: 'movie/:id',
          builder: (context, state) {
            // Leemos el parámetro de la URL
            final id = state.pathParameters['id'] ?? 'no-id';
            return MovieScreen(movieId: id);
          },
        ),
      ],
    ),
  ],
  errorBuilder: (context, state) => const NotFoundScreen(),
);

// 2. Raíz de la Aplicación
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'GoRouter App',
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      // Tema moderno y oscuro para que se vea "bonito"
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
      ),
    );
  }
}

// 3. Pantalla Principal (HomeScreen)
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Lista simulada de películas
    final List<Map<String, String>> movies = [
      {'id': '550', 'title': 'El Club de la Pelea', 'icon': '🥊'},
      {'id': '278', 'title': 'Sueños de Fuga', 'icon': '🗝️'},
      {'id': '238', 'title': 'El Padrino', 'icon': '🕴️'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cartelera'),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return Card(
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              leading: Text(movie['icon']!, style: const TextStyle(fontSize: 32)),
              title: Text(
                movie['title']!,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              subtitle: Text('ID de película: ${movie['id']}'),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.deepPurpleAccent),
              onTap: () {
                // APILA la pantalla encima de la actual (permite volver atrás)
                context.push('/movie/${movie['id']}');
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navegar a una ruta que no existe para probar el error 404
          context.go('/ruta-inventada');
        },
        label: const Text('Probar Error 404'),
        icon: const Icon(Icons.bug_report),
      ),
    );
  }
}

// 4. Pantalla de Detalle de Película (MovieScreen)
class MovieScreen extends StatelessWidget {
  final String movieId;

  const MovieScreen({super.key, required this.movieId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de Película'),
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.movie_creation_outlined, size: 100, color: Colors.deepPurpleAccent),
            const SizedBox(height: 20),
            Text(
              'Estás viendo la película ID:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                movieId,
                style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 5. Pantalla de Error (NotFoundScreen)
class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 100, color: Colors.redAccent),
            const SizedBox(height: 20),
            const Text(
              '¡Ups! Ruta no encontrada',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () => context.go('/'), // REEMPLAZA la pila para volver al inicio
              icon: const Icon(Icons.home),
              label: const Text('Volver al Inicio'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            )
          ],
        ),
      ),
    );
  }
}