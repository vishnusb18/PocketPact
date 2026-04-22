// Pacty Animations
// Duolingo-style animations for the Pacty mascot
// Includes bounce, shake, confetti, particles, and floating effects

import 'dart:math';
import 'package:flutter/material.dart';

// Bounce animation controller
class PactyBounceAnimation extends StatefulWidget {
  final Widget child;
  final bool autoPlay;
  final Duration duration;
  final double intensity;

  const PactyBounceAnimation({
    super.key,
    required this.child,
    this.autoPlay = true,
    this.duration = const Duration(milliseconds: 800),
    this.intensity = 1.0,
  });

  @override
  State<PactyBounceAnimation> createState() => _PactyBounceAnimationState();
}

class _PactyBounceAnimationState extends State<PactyBounceAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _animation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: -20.0 * widget.intensity)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: -20.0 * widget.intensity, end: 5.0 * widget.intensity)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 5.0 * widget.intensity, end: 0.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 40,
      ),
    ]).animate(_controller);

    if (widget.autoPlay) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void bounce() {
    _controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _animation.value),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

// Shake animation for errors or attention
class PactyShakeAnimation extends StatefulWidget {
  final Widget child;
  final bool trigger;
  final int shakes;

  const PactyShakeAnimation({
    super.key,
    required this.child,
    this.trigger = false,
    this.shakes = 3,
  });

  @override
  State<PactyShakeAnimation> createState() => _PactyShakeAnimationState();
}

class _PactyShakeAnimationState extends State<PactyShakeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void didUpdateWidget(PactyShakeAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.trigger != oldWidget.trigger && widget.trigger) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final progress = _animation.value;
        final shake = sin(progress * widget.shakes * 2 * pi) * 10 * (1 - progress);
        return Transform.translate(
          offset: Offset(shake, 0),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

// Floating particles animation (sparkles, coins, etc.)
class PactyParticles extends StatefulWidget {
  final int particleCount;
  final Color particleColor;
  final Duration duration;
  final bool autoPlay;
  final IconData? particleIcon;

  const PactyParticles({
    super.key,
    this.particleCount = 10,
    this.particleColor = Colors.amber,
    this.duration = const Duration(milliseconds: 2000),
    this.autoPlay = true,
    this.particleIcon,
  });

  @override
  State<PactyParticles> createState() => _PactyParticlesState();
}

class _PactyParticlesState extends State<PactyParticles>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_Particle> _particles;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _particles = List.generate(
      widget.particleCount,
      (index) => _Particle(
        angle: (index / widget.particleCount) * 2 * pi,
        speed: 50 + Random().nextDouble() * 100,
        size: 4 + Random().nextDouble() * 8,
      ),
    );

    if (widget.autoPlay) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: const Size(200, 200),
          painter: _ParticlesPainter(
            particles: _particles,
            progress: _controller.value,
            color: widget.particleColor,
            icon: widget.particleIcon,
          ),
        );
      },
    );
  }
}

class _Particle {
  final double angle;
  final double speed;
  final double size;

  _Particle({
    required this.angle,
    required this.speed,
    required this.size,
  });
}

class _ParticlesPainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress;
  final Color color;
  final IconData? icon;

  _ParticlesPainter({
    required this.particles,
    required this.progress,
    required this.color,
    this.icon,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(1 - progress)
      ..style = PaintingStyle.fill;

    for (var particle in particles) {
      final distance = particle.speed * progress;
      final x = size.width / 2 + cos(particle.angle) * distance;
      final y = size.height / 2 + sin(particle.angle) * distance - (progress * 50);

      canvas.drawCircle(
        Offset(x, y),
        particle.size * (1 - progress),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_ParticlesPainter oldDelegate) => true;
}

// Confetti animation for celebrations
class PactyConfetti extends StatefulWidget {
  final bool show;
  final Duration duration;

  const PactyConfetti({
    super.key,
    this.show = true,
    this.duration = const Duration(milliseconds: 3000),
  });

  @override
  State<PactyConfetti> createState() => _PactyConfettiState();
}

class _PactyConfettiState extends State<PactyConfetti>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_ConfettiPiece> _confetti;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _confetti = List.generate(
      30,
      (index) => _ConfettiPiece(
        x: Random().nextDouble(),
        velocity: 100 + Random().nextDouble() * 100,
        angle: Random().nextDouble() * 2 * pi,
        rotation: Random().nextDouble() * 2 * pi,
        rotationSpeed: (Random().nextDouble() - 0.5) * 4,
        color: [
          Colors.red,
          Colors.blue,
          Colors.green,
          Colors.yellow,
          Colors.purple,
          Colors.orange,
        ][Random().nextInt(6)],
      ),
    );

    if (widget.show) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(PactyConfetti oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.show != oldWidget.show) {
      if (widget.show) {
        _controller.forward(from: 0);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            size: MediaQuery.of(context).size,
            painter: _ConfettiPainter(
              confetti: _confetti,
              progress: _controller.value,
            ),
          );
        },
      ),
    );
  }
}

class _ConfettiPiece {
  final double x;
  final double velocity;
  final double angle;
  final double rotation;
  final double rotationSpeed;
  final Color color;

  _ConfettiPiece({
    required this.x,
    required this.velocity,
    required this.angle,
    required this.rotation,
    required this.rotationSpeed,
    required this.color,
  });
}

class _ConfettiPainter extends CustomPainter {
  final List<_ConfettiPiece> confetti;
  final double progress;

  _ConfettiPainter({
    required this.confetti,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (var piece in confetti) {
      final paint = Paint()
        ..color = piece.color.withOpacity(1 - progress)
        ..style = PaintingStyle.fill;

      final x = piece.x * size.width;
      final y = piece.velocity * progress;
      final rotation = piece.rotation + piece.rotationSpeed * progress;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(rotation);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          const Rect.fromLTWH(-5, -10, 10, 20),
          const Radius.circular(2),
        ),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter oldDelegate) => true;
}

// Pulse/Glow effect for emphasis
class PactyPulse extends StatefulWidget {
  final Widget child;
  final bool enabled;
  final Color glowColor;

  const PactyPulse({
    super.key,
    required this.child,
    this.enabled = true,
    this.glowColor = const Color(0xFF7B2CBF),
  });

  @override
  State<PactyPulse> createState() => _PactyPulseState();
}

class PactyFloatAnimation extends StatefulWidget {
  final Widget child;
  final bool enabled;
  final double amplitude;
  final Duration duration;

  const PactyFloatAnimation({
    super.key,
    required this.child,
    this.enabled = true,
    this.amplitude = 6,
    this.duration = const Duration(milliseconds: 2400),
  });

  @override
  State<PactyFloatAnimation> createState() => _PactyFloatAnimationState();
}

class _PactyFloatAnimationState extends State<PactyFloatAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat(reverse: true);
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.child;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final dy = -widget.amplitude * _animation.value;
        final scale = 1 + (_animation.value * 0.018);
        return Transform.translate(
          offset: Offset(0, dy),
          child: Transform.scale(scale: scale, child: child),
        );
      },
      child: widget.child,
    );
  }
}

class _PactyPulseState extends State<PactyPulse>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.child;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: widget.glowColor.withOpacity(_animation.value * 0.5),
                blurRadius: 20 * _animation.value,
                spreadRadius: 5 * _animation.value,
              ),
            ],
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
