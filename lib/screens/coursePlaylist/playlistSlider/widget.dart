import 'package:carousel_slider/carousel_slider.dart';
import 'package:cca_vijayapura/screens/coursePlaylist/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PlaylistSlider extends StatefulWidget {
  final Playlist playlist;
  const PlaylistSlider({Key? key, required this.playlist}) : super(key: key);

  @override
  State<PlaylistSlider> createState() => _PlaylistSliderState();
}

class _PlaylistSliderState extends State<PlaylistSlider> {
  final items = [1, 2, 3, 4, 5];
  int currentSlide = 0;
  bool autoPlay = false;

  Uri base_url = Uri.parse(
      """${const String.fromEnvironment("SERVER_PROTOCOL")}://${const String.fromEnvironment("SERVER_HOST")}:${const String.fromEnvironment("SERVER_PORT")}""");

  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                "PC/PCI",
                style: TextStyle(
                    fontSize: 24.0,
                    color: Color(0xFF6750A3),
                    fontWeight: FontWeight.w800),
              ),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/playlist_videos'),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      "assets/icons/right_arrow.svg",
                      colorFilter: const ColorFilter.mode(
                        Color(0xFFFF0099),
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Text(
                      "full course",
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Color(0xFFFF0099),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        CarouselSlider(
          carouselController: _controller,
          options: CarouselOptions(
            autoPlay: autoPlay,
            height: 180.0,
            disableCenter: true,
            enableInfiniteScroll: false,
            viewportFraction: 0.7,
            padEnds: false,
            // enlargeCenterPage: true,
            onPageChanged: (i, _) => setState(() => currentSlide = i),
          ),
          items: widget.playlist.videos.asMap().entries.map((item) {
            final i = item.key;
            final video = item.value;
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: i == 0 ? 0 : 15),
                          width: MediaQuery.of(context).size.width,
                          // padding: const EdgeInsets.symmetric(
                          //     horizontal: 15.0, vertical: 10),
                          // decoration: BoxDecoration(
                          //   color: const Color(0xFF6750A3),
                          //   borderRadius: BorderRadius.circular(18.0),
                          // ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Image.network(
                              "$base_url${video.linkToVideoPreviewImage}",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          video.title,
                          style: const TextStyle(
                            fontSize: 16.0,
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            );
          }).toList(),
        )
      ],
    );
  }
}
