import 'package:xpanca_ecommerce/core/utils/helper.dart';
import 'package:xpanca_ecommerce/features/products/domain/entities/product.dart';
import 'package:xpanca_ecommerce/features/products/presentation/widgets/description_block.dart';
import 'package:flutter/material.dart';

class DetailContent extends StatefulWidget {
  final Product product;
  const DetailContent({super.key, required this.product});

  @override
  State<DetailContent> createState() => _DetailContentState();
}

class _DetailContentState extends State<DetailContent> {
  final _pageCtrl = PageController();
  int _page = 0;
  int _thumb = 0;
  bool _expanded = false;

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final imgs = p.images;
    final theme = Theme.of(context);
    final radius = BorderRadius.circular(20);

    // ======= SECTION 1: IMAGE DISPLAY (widget inti #1) =======
    Widget imageSection = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: radius,
          child: AspectRatio(
            aspectRatio: 1.5,
            child: Stack(
              fit: StackFit.expand,
              children: [
                PageView.builder(
                  controller: _pageCtrl,
                  itemCount: imgs.isEmpty ? 1 : imgs.length,
                  onPageChanged: (i) => setState(() {
                    _page = i;
                    _thumb = i;
                  }),
                  itemBuilder: (_, i) {
                    final url = imgs.isEmpty ? '' : imgs[i].url;
                    return url.isEmpty
                        ? const ColoredBox(color: Color(0xFFF2F2F2))
                        : Image.network(url, fit: BoxFit.cover);
                  },
                ),
                Positioned(
                  bottom: 12,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      imgs.isEmpty ? 1 : imgs.length,
                      (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: _page == i ? 18 : 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: _page == i ? Colors.green : Colors.white70,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        if (imgs.length > 1)
          SizedBox(
            height: 45,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: imgs.length,
              itemBuilder: (_, i) {
                final isActive = i == _thumb;
                return GestureDetector(
                  onTap: () {
                    setState(() => _thumb = i);
                    _pageCtrl.animateToPage(
                      i,
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOut,
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isActive ? Colors.green : Colors.transparent,
                        width: 1,
                      ),
                    ),
                    padding: const EdgeInsets.all(2),
                    child: CircleAvatar(
                        backgroundImage: NetworkImage(imgs[i].url)),
                  ),
                );
              },
            ),
          ),
      ],
    );

    // ======= SECTION 2: PRODUCT INFO (widget inti #2) =======
    Widget infoSection = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(p.name,
                          style: theme.textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700)),
                      Text(p.category,
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(color: Colors.grey[600])),
                    ]),
              ),
              Text(
                rupiah(p.price),
                style: theme.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.w700, fontSize: 18),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        DescriptionBlock(
          text: p.description,
          expanded: _expanded,
          onToggle: () => setState(() => _expanded = !_expanded),
        ),
      ],
    );

    // ======= RESPONSIVE SWITCHER =======
    return LayoutBuilder(
      builder: (context, c) {
        const desktopBp = 900.0; // breakpoint – atur sesuai selera
        final isDesktop = c.maxWidth >= desktopBp;

        if (!isDesktop) {
          // MOBILE/TABLET: tetap ListView vertikal
          return ListView(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
            children: [
              // IMAGE DISPLAY (inti #1)
              imageSection,
              const SizedBox(height: 10),
              // INFO (inti #2)
              infoSection,
              const SizedBox(height: 120),
            ],
          );
        }

        // DESKTOP: tetap pakai ListView sebagai container scroll,
        // tapi dua inti diletakkan dalam Row (gambar di KIRI).
        return ListView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // KIRI: IMAGE DISPLAY (lebih lebar)
                    Expanded(
                      flex: 6,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: imageSection,
                      ),
                    ),
                    // KANAN: INFO
                    Expanded(
                      flex: 5,
                      child: infoSection,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
