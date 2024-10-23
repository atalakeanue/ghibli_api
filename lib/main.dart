import 'package:flutter/material.dart'; // Mengimpor paket Flutter untuk membangun antarmuka pengguna
import 'package:http/http.dart'
    as http; // Mengimpor paket http untuk melakukan request HTTP
import 'dart:convert'; // Mengimpor dart:convert untuk mengkonversi data JSON

void main() {
  runApp(MyApp()); // Fungsi utama yang menjalankan aplikasi Flutter
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ghibli Movies', // Menentukan judul aplikasi
      theme: ThemeData(
        primarySwatch:
            Colors.blue, // Mengatur tema utama aplikasi dengan warna biru
        scaffoldBackgroundColor:
            Colors.grey[200], // Mengatur warna latar belakang aplikasi
      ),
      home:
          GhibliMoviesList(), // Menampilkan halaman utama berupa daftar film Ghibli
    );
  }
}

class GhibliMoviesList extends StatefulWidget {
  @override
  _GhibliMoviesListState createState() =>
      _GhibliMoviesListState(); // Menghubungkan StatefulWidget dengan State-nya
}

class _GhibliMoviesListState extends State<GhibliMoviesList> {
  List<dynamic> movies = []; // Membuat variabel untuk menampung data film

  @override
  void initState() {
    super.initState();
    fetchMovies(); // Memanggil fungsi fetchMovies saat widget pertama kali diinisialisasi
  }

  Future<void> fetchMovies() async {
    final response = await http.get(Uri.parse(
        'https://ghibliapi.vercel.app/films')); // Melakukan request HTTP ke API Ghibli
    if (response.statusCode == 200) {
      setState(() {
        movies = json.decode(response
            .body); // Mengupdate state dengan data film yang didapat dari API
      });
    } else {
      throw Exception(
          'Failed to load movies'); // Menampilkan error jika gagal mendapatkan data
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Studio Ghibli Films'), // Menampilkan judul di AppBar
        backgroundColor: Colors.indigo, // Mengatur warna latar AppBar
      ),
      body: ListView.builder(
        itemCount:
            movies.length, // Menentukan jumlah item berdasarkan data film
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0), // Mengatur padding di sekitar item
            child: Card(
              elevation: 5, // Memberikan efek bayangan pada kartu
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    15), // Mengatur sudut kartu menjadi bulat
              ),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieDetailScreen(
                          movie: movies[
                              index]), // Navigasi ke halaman detail film saat item diklik
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Mengatur teks agar rata kiri
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.vertical(
                          top: Radius.circular(
                              15)), // Membulatkan gambar di bagian atas
                      child: AspectRatio(
                        aspectRatio:
                            16 / 9, // Mengatur rasio aspek gambar menjadi 16:9
                        child: Image.network(
                          movies[index]
                              ['movie_banner'], // Menampilkan gambar dari URL
                          fit: BoxFit
                              .cover, // Menyesuaikan gambar dengan ukuran frame
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[
                                  300], // Menampilkan warna latar abu-abu jika gambar gagal dimuat
                              child: Center(
                                child: Icon(Icons.error,
                                    color:
                                        Colors.red), // Menampilkan ikon error
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(
                          16.0), // Mengatur jarak antara konten dan batas kartu
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            movies[index]['title'], // Menampilkan judul film
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight
                                    .bold), // Mengatur gaya teks judul
                          ),
                          SizedBox(
                              height:
                                  8), // Memberikan jarak vertikal antar elemen
                          Text(
                            'Director: ${movies[index]['director']}', // Menampilkan sutradara film
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors
                                    .grey[600]), // Mengatur gaya teks sutradara
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Release: ${movies[index]['release_date']}', // Menampilkan tahun rilis film
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[
                                    600]), // Mengatur gaya teks tanggal rilis
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.star,
                                  color: Colors.amber,
                                  size:
                                      16), // Menampilkan ikon bintang untuk skor
                              SizedBox(width: 4),
                              Text(
                                '${movies[index]['rt_score']}%', // Menampilkan skor Rotten Tomatoes film
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight
                                        .bold), // Mengatur gaya teks skor
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class MovieDetailScreen extends StatelessWidget {
  final Map<String, dynamic> movie; // Variabel untuk menampung detail film

  MovieDetailScreen(
      {required this.movie}); // Konstruktor untuk menerima detail film

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(movie['title']), // Menampilkan judul film di AppBar
        backgroundColor: Colors.indigo, // Mengatur warna AppBar
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9, // Mengatur rasio aspek gambar
              child: Image.network(
                movie['movie_banner'], // Menampilkan banner film
                fit: BoxFit.cover, // Menyesuaikan gambar dengan ukuran frame
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[
                        300], // Menampilkan latar abu-abu jika gambar gagal dimuat
                    child: Center(
                      child: Icon(Icons.error,
                          color: Colors.red), // Menampilkan ikon error
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.all(16.0), // Mengatur jarak konten dari tepi layar
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Original Title: ${movie['original_title']}',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight:
                              FontWeight.bold)), // Menampilkan judul asli film
                  Text(
                      'Romanised Title: ${movie['original_title_romanised']}'), // Menampilkan judul yang diromanisasikan
                  SizedBox(height: 16), // Menambah jarak vertikal
                  Text('Description:',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight:
                              FontWeight.bold)), // Menampilkan deskripsi
                  Text(movie['description']), // Menampilkan sinopsis film
                  SizedBox(height: 16),
                  Text(
                      'Director: ${movie['director']}'), // Menampilkan sutradara film
                  Text(
                      'Producer: ${movie['producer']}'), // Menampilkan produser film
                  Text(
                      'Release Date: ${movie['release_date']}'), // Menampilkan tanggal rilis
                  Text(
                      'Running Time: ${movie['running_time']} minutes'), // Menampilkan durasi film
                  Text(
                      'Rotten Tomatoes Score: ${movie['rt_score']}'), // Menampilkan skor Rotten Tomatoes
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
