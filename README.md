# SongPro for Crystal

[![GitHub release](https://img.shields.io/github/release/SongProOrg/songpro-crystal.svg)](https://github.com/SongProOrg/songpro-crystal/releases)

[SongPro](https://songpro.org) is a text format for transcribing songs.
 
This project is a Crystal Shard that converts the song into a Song data model which can then be converted into various output formats such as text or HTML.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     songpro:
       github: SongProOrg/songpro-crystal
   ```

2. Run `shards install`

## Usage

Given then file `escape-capsule.sng` with the following contents:

```
@title=Escape Capsule
@artist=Brian Kelly
!bandcamp=https://spilth.bandcamp.com/track/escape-capsule-nashville-edition

# Verse 1

Climb a-[D]board [A]
I've been [Bm]waiting for you [F#m]
Climb a-[G]board [D]
You'll be [Asus4]safe in [A7]here

# Chorus 1

[G] I'm a [D]rocket [F#]made for your pro-[Bm]tection
You're [G]safe with me, un-[A]til you leave
```

You can then parse the file to create a `Song` object:

```ruby
require 'songpro'

text = File.read('escape-capsule.sng')
song = SongPro.parse(text)

puts song.title
# Escape Capsule

puts song.artist
# Brian Kelly

puts song.sections[1].name
# Chorus 1

p song.chords
# ["D", "A", "Bm", "F#m", "G", "Asus4", "A7", "F#"]
```

## Development

After checking out the repo, run `crystal spec` to run the tests.

## Contributing

1. Fork it (<https://github.com/SongProOrg/songpro-crystal/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
