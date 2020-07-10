# SongPro for Crystal

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

```crystal
require "songpro"

song = SongPro.parse(text)
```

TODO: Write usage instructions here

## Development

After checking out the repo, run `crystal spec` to run the tests.

## Contributing

1. Fork it (<https://github.com/SongProOrg/songpro-crystal/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
