# Sound Assets

This folder contains audio files for interval timer notifications.

## Sound Files

- `start.mp3` - Workout start sound (uplifting beep)
- `work.mp3` - Work interval start (energetic beep)
- `rest.mp3` - Rest interval start (calming beep)
- `complete.mp3` - Workout complete sound (success chime)
- `countdown.mp3` - Last 3 seconds beep (optional)

## Temporary Implementation

For now, the app uses AudioPlayers with tone generation.
In production, replace with actual audio files:
- Download free sounds from freesound.org or similar
- Or use text-to-speech for voice prompts
- Ensure files are short (< 2 seconds) for low latency

## Sound Specifications

- Format: MP3 or WAV
- Sample Rate: 44.1kHz
- Bit Rate: 128kbps
- Duration: 0.5-2 seconds
- Volume: Normalized to prevent clipping
