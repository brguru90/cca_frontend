import 'package:carousel_slider/carousel_slider.dart';
import 'package:cca_vijayapura/screens/coursePlaylist/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PlaylistSlider extends StatefulWidget {
  final Playlist playlist;
  final bool paid;
  final Function() onBuyClick;
  const PlaylistSlider({
    Key? key,
    required this.playlist,
    this.paid = false,
    required this.onBuyClick,
  }) : super(key: key);

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

  Widget purchaseSelectedStatus({required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 2,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(
          color:
              widget.playlist.selectedForPurchase ? Colors.green : Colors.white,
          width: 2,
        ),
      ),
      child: child,
    );
  }

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
              Row(
                children: [
                  const Text(
                    "PC/PCI",
                    style: TextStyle(
                      fontSize: 24.0,
                      color: Color(0xFF6750A3),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  ...(() {
                    if (!widget.paid) {
                      return [
                        const SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                          onTap: widget.onBuyClick,
                          child: purchaseSelectedStatus(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(3.0),
                              ),
                              child: Row(
                                children: [
                                  const Text(
                                    "Buy for ",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      wordSpacing: 0,
                                      letterSpacing: 0,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                    child: Icon(
                                      Icons.currency_rupee,
                                      color: Colors.white,
                                      size: 12,
                                    ),
                                  ),
                                  Text(
                                    "${widget.playlist.price}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      wordSpacing: 0,
                                      letterSpacing: 0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ];
                    }
                    return [const SizedBox()];
                  })(),
                ],
              ),
              GestureDetector(
                onTap: () => Navigator.pushNamed(
                  context,
                  '/playlist_videos',
                  arguments: {"playlist": widget.playlist, "paid": widget.paid},
                ),
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
                              fit: BoxFit.fill,
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
