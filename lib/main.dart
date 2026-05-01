import 'package:flutter/material.dart';

void main() {
  runApp(const DynamicApp());
}

class AppColors {
  static const base = Color(0xFF0A0A0A);
  static const surface = Color(0xFF121212);
  static const softGrey = Color(0xFF1E1E1E);
  static const red = Color(0xFFE50914);
  static const blue = Color(0xFF0F3460);
  static const text = Color(0xFFEAEAEA);
  static const muted = Color(0xFF9B9B9B);
}

class Song {
  const Song({
    required this.title,
    required this.artist,
    required this.colors,
    this.tag = '',
  });

  final String title;
  final String artist;
  final List<Color> colors;
  final String tag;
}

const featuredSong = Song(
  title: 'Midnight Signal',
  artist: 'Astra Vale',
  colors: [Color(0xFFE50914), Color(0xFF0F3460), Color(0xFF121212)],
  tag: 'FEATURED',
);

const recentSongs = [
  Song(
    title: 'Crimson Air',
    artist: 'Nero Bloom',
    colors: [Color(0xFF8E0E18), Color(0xFF121212)],
  ),
  Song(
    title: 'Deep Current',
    artist: 'Luma Tide',
    colors: [Color(0xFF0F3460), Color(0xFF1E1E1E)],
  ),
  Song(
    title: 'Velvet Static',
    artist: 'The Low Keys',
    colors: [Color(0xFF2A2A2A), Color(0xFFE50914)],
  ),
  Song(
    title: 'Night Arcade',
    artist: 'Riven Hall',
    colors: [Color(0xFF181818), Color(0xFF0F3460)],
  ),
  Song(
    title: 'Afterglow',
    artist: 'Mara Lux',
    colors: [Color(0xFF3B0A12), Color(0xFF1E1E1E)],
  ),
];

const mixSongs = [
  Song(
    title: 'Obsidian Room',
    artist: 'Kepler North',
    colors: [Color(0xFF141414), Color(0xFF6E0710)],
  ),
  Song(
    title: 'Low Frequency',
    artist: 'Sable Choir',
    colors: [Color(0xFF0F3460), Color(0xFF0A0A0A)],
  ),
  Song(
    title: 'Redline Drift',
    artist: 'Echo District',
    colors: [Color(0xFFE50914), Color(0xFF1E1E1E)],
  ),
  Song(
    title: 'Glass Pulse',
    artist: 'Iris Venn',
    colors: [Color(0xFF2D2D2D), Color(0xFF0F3460)],
  ),
  Song(
    title: 'Noir Motion',
    artist: 'North Frame',
    colors: [Color(0xFF101010), Color(0xFF3A3A3A)],
  ),
  Song(
    title: 'Signal Fade',
    artist: 'Milo Crest',
    colors: [Color(0xFF3E050B), Color(0xFF0A0A0A)],
  ),
];

class DynamicApp extends StatelessWidget {
  const DynamicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dynamic',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.base,
        fontFamily: 'Inter',
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.red,
          brightness: Brightness.dark,
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
          titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          bodySmall: TextStyle(fontSize: 12, color: AppColors.muted),
        ),
      ),
      home: const CrimsonDepthHome(),
    );
  }
}

class CrimsonDepthHome extends StatefulWidget {
  const CrimsonDepthHome({super.key});

  @override
  State<CrimsonDepthHome> createState() => _CrimsonDepthHomeState();
}

class _CrimsonDepthHomeState extends State<CrimsonDepthHome>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..forward();
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0.03, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fade,
            child: SlideTransition(position: _slide, child: child),
          );
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isCompact = constraints.maxWidth < 860;
            if (isCompact) {
              return const _CompactLayout();
            }

            return const Row(
              children: [
                Expanded(flex: 18, child: _Sidebar()),
                Expanded(flex: 62, child: _MainContent()),
                Expanded(flex: 20, child: _PlayerPanel()),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _CompactLayout extends StatelessWidget {
  const _CompactLayout();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _CompactTopNav(),
        Expanded(child: _MainContent()),
        SizedBox(height: 188, child: _PlayerPanel(isCompact: true)),
      ],
    );
  }
}

class _Sidebar extends StatelessWidget {
  const _Sidebar();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.base,
      padding: const EdgeInsets.fromLTRB(24, 24, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _Logo(),
          const SizedBox(height: 32),
          const _NavItem(icon: Icons.home_rounded, label: 'Home', active: true),
          const SizedBox(height: 8),
          const _NavItem(icon: Icons.search_rounded, label: 'Search'),
          const SizedBox(height: 8),
          const _NavItem(icon: Icons.library_music_rounded, label: 'Library'),
          const Spacer(),
          Text('Playlists', style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 16),
          const _PlaylistLabel('Crimson Focus'),
          const _PlaylistLabel('Late Studio'),
          const _PlaylistLabel('Deep Sea Mix'),
          const _PlaylistLabel('Liked Songs'),
        ],
      ),
    );
  }
}

class _CompactTopNav extends StatelessWidget {
  const _CompactTopNav();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      color: AppColors.base,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: const Row(
        children: [
          _Logo(),
          Spacer(),
          _IconOnlyNav(icon: Icons.home_rounded, active: true),
          _IconOnlyNav(icon: Icons.search_rounded),
          _IconOnlyNav(icon: Icons.library_music_rounded),
        ],
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.graphic_eq_rounded, color: AppColors.red, size: 24),
        SizedBox(width: 8),
        Text(
          'Dynamic',
          style: TextStyle(
            color: AppColors.text,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _NavItem extends StatefulWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    this.active = false,
  });

  final IconData icon;
  final String label;
  final bool active;

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.active ? AppColors.text : AppColors.text.withOpacity(.7);
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 40,
        decoration: BoxDecoration(
          boxShadow: _hovering
              ? [
                  BoxShadow(
                    color: AppColors.blue.withOpacity(.35),
                    blurRadius: 16,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 2,
              height: 24,
              color: widget.active ? AppColors.red : Colors.transparent,
            ),
            const SizedBox(width: 14),
            Icon(widget.icon, color: color, size: 20),
            const SizedBox(width: 12),
            Text(
              widget.label,
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: widget.active ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IconOnlyNav extends StatelessWidget {
  const _IconOnlyNav({required this.icon, this.active = false});

  final IconData icon;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Icon(
        icon,
        color: active ? AppColors.red : AppColors.text.withOpacity(.7),
        size: 22,
      ),
    );
  }
}

class _PlaylistLabel extends StatelessWidget {
  const _PlaylistLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.text,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _MainContent extends StatelessWidget {
  const _MainContent();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.softGrey,
      child: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _TopBar(),
              const SizedBox(height: 24),
              const _FeaturedBanner(),
              const SizedBox(height: 32),
              _SectionHeader(
                title: 'Recently Played',
                action: 'View all',
                onTap: () {},
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 206,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: recentSongs.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 16),
                  itemBuilder: (context, index) {
                    return SizedBox(
                      width: 150,
                      child: _SongCard(song: recentSongs[index]),
                    );
                  },
                ),
              ),
              const SizedBox(height: 32),
              _SectionHeader(
                title: 'Your Mix',
                action: 'Trending',
                onTap: () {},
              ),
              const SizedBox(height: 16),
              LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth;
                  final columns = width > 760 ? 4 : width > 520 ? 3 : 2;
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: mixSongs.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: .82,
                    ),
                    itemBuilder: (context, index) {
                      return _SongCard(song: mixSongs[index]);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 560;
        final greeting = Text(
          'Good Evening',
          style: Theme.of(context).textTheme.titleLarge,
        );
        final search = ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 280),
          child: Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(.05)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.search_rounded,
                  color: AppColors.text.withOpacity(.7),
                  size: 18,
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Search music',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: AppColors.muted, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
        );

        if (compact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [greeting, const SizedBox(height: 16), search],
          );
        }

        return Row(children: [greeting, const Spacer(), search]);
      },
    );
  }
}

class _FeaturedBanner extends StatelessWidget {
  const _FeaturedBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: Stack(
        fit: StackFit.expand,
        children: [
          const _AlbumArtwork(song: featuredSong, radius: 0),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  AppColors.base.withOpacity(.9),
                  AppColors.base.withOpacity(.35),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  'FEATURED PLAYLIST',
                  style: TextStyle(
                    color: AppColors.red,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  featuredSong.title,
                  style: const TextStyle(
                    color: AppColors.text,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  featuredSong.artist,
                  style: const TextStyle(color: AppColors.muted, fontSize: 13),
                ),
                const SizedBox(height: 16),
                _PlayButton(label: 'Play'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.action,
    required this.onTap,
  });

  final String title;
  final String action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const Spacer(),
        TextButton(
          onPressed: onTap,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.muted,
            textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          child: Text(action),
        ),
      ],
    );
  }
}

class _SongCard extends StatefulWidget {
  const _SongCard({required this.song});

  final Song song;

  @override
  State<_SongCard> createState() => _SongCardState();
}

class _SongCardState extends State<_SongCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedScale(
        scale: _hovering ? 1.03 : 1,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: _hovering ? AppColors.red.withOpacity(.65) : Colors.white10,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: _hovering
                    ? AppColors.red.withOpacity(.18)
                    : Colors.black.withOpacity(.18),
                blurRadius: _hovering ? 22 : 12,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _AlbumArtwork(song: widget.song)),
              const SizedBox(height: 10),
              Text(
                widget.song.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.text,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.song.artist,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: AppColors.muted, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AlbumArtwork extends StatelessWidget {
  const _AlbumArtwork({required this.song, this.radius = 8});

  final Song song;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: song.colors,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -24,
            top: -24,
            child: Container(
              width: 112,
              height: 112,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(.08),
              ),
            ),
          ),
          Positioned(
            left: 18,
            bottom: 18,
            child: Icon(
              Icons.album_rounded,
              color: Colors.white.withOpacity(.72),
              size: 46,
            ),
          ),
          Positioned(
            right: 16,
            bottom: 16,
            child: Icon(
              Icons.graphic_eq_rounded,
              color: AppColors.red.withOpacity(.75),
              size: 28,
            ),
          ),
        ],
      ),
    );
  }
}

class _PlayerPanel extends StatelessWidget {
  const _PlayerPanel({this.isCompact = false});

  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    if (isCompact) {
      return Container(
        color: AppColors.base,
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const SizedBox(
              width: 112,
              height: 112,
              child: _AlbumArtwork(song: featuredSong),
            ),
            const SizedBox(width: 16),
            const Expanded(child: _PlayerDetails()),
            const SizedBox(width: 8),
            _RoundControl(icon: Icons.pause_rounded, filled: true, onTap: () {}),
          ],
        ),
      );
    }

    return Container(
      color: AppColors.base,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
      child: SafeArea(
        child: Column(
          children: [
            const AspectRatio(
              aspectRatio: 1,
              child: _AlbumArtwork(song: featuredSong),
            ),
            const SizedBox(height: 24),
            const _PlayerDetails(centered: true),
            const Spacer(),
            const _ProgressBar(),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _RoundControl(icon: Icons.skip_previous_rounded, onTap: () {}),
                const SizedBox(width: 16),
                _RoundControl(
                  icon: Icons.pause_rounded,
                  filled: true,
                  large: true,
                  onTap: () {},
                ),
                const SizedBox(width: 16),
                _RoundControl(icon: Icons.skip_next_rounded, onTap: () {}),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PlayerDetails extends StatelessWidget {
  const _PlayerDetails({this.centered = false});

  final bool centered;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          centered ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Midnight Signal',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: AppColors.text,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Astra Vale',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: AppColors.muted, fontSize: 12),
        ),
        const SizedBox(height: 16),
        if (!centered) const _ProgressBar(),
      ],
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.softGrey,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            FractionallySizedBox(
              widthFactor: .42,
              child: Container(
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.red,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            Positioned(
              left: 106,
              top: -3,
              child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: AppColors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Row(
          children: [
            Text('1:42', style: TextStyle(color: AppColors.muted, fontSize: 12)),
            Spacer(),
            Text('4:05', style: TextStyle(color: AppColors.muted, fontSize: 12)),
          ],
        ),
      ],
    );
  }
}

class _RoundControl extends StatefulWidget {
  const _RoundControl({
    required this.icon,
    required this.onTap,
    this.filled = false,
    this.large = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool filled;
  final bool large;

  @override
  State<_RoundControl> createState() => _RoundControlState();
}

class _RoundControlState extends State<_RoundControl> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final size = widget.large ? 54.0 : 42.0;
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? .94 : 1,
        duration: const Duration(milliseconds: 90),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.filled ? AppColors.red : Colors.transparent,
            border: Border.all(
              color: widget.filled ? AppColors.red : Colors.white24,
            ),
          ),
          child: Icon(
            widget.icon,
            color: widget.filled ? Colors.white : AppColors.text.withOpacity(.82),
            size: widget.large ? 30 : 24,
          ),
        ),
      ),
    );
  }
}

class _PlayButton extends StatefulWidget {
  const _PlayButton({required this.label});

  final String label;

  @override
  State<_PlayButton> createState() => _PlayButtonState();
}

class _PlayButtonState extends State<_PlayButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? .97 : 1,
        duration: const Duration(milliseconds: 90),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.red,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 20),
              const SizedBox(width: 6),
              Text(
                widget.label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
