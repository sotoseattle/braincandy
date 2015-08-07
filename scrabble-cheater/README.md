# Scrabble Cheater

I'd like you to help me cheat at Scrabble. I'm not very good at coming up with
various words from my tiles, so I'd like you to write some code to give me all
of the possible words that can be created given a set of tiles. Don't worry so
much about scoring or trying to find the "best" word, or trying to match
what's on the board. (But those are great enhancements!) The maximum number of
tiles you can have in Scrabble is seven, so you'll need to find all of the
words that can be made out of those tiles.

On most unix systems (including Mac OS X), you can find a word dictionary in
"/usr/share/dict/words" - let's assume that all of these words (including
"zymogenic"!) are up valid for scrabble. Feel free to use your own custom
dictionary, but this will do for this purpose.

Here's sample code that reads in all of the words into an array, removes
newlines, and downcases them.
```ruby
words = File.readlines("/usr/share/dict/words").map(&:chomp).map(&:downcase)
```

## Cheat a Bit!

My first approach was to create a trie with hashes and load the 'words' into it.

Then the longest word is a simple exercise of going through all the permutations of the chosen tiles and trying them all on the trie until we find an existing word. The search of permutations goes from the longest to shortest word, and the method returns the first viable solution (longest word).

```ruby
sc = Scrabble.new
p sc.longest_word 'ptteoao'.chars
# => 'potate'
```

## Cheat in Style!

If we are going to cheat, we should do it in style. With a bold face. Con un par.

We should be able to come up with a word, that may not exist, but that actually sounds like it could. It is then up to you to lie your way through and convince your opponents that the word is valid, real and makes sense (given whatever crazy definition you can come up with).

The method should be called 'bullshit!' and will take into account the probabilities of certain letters being next to others. The combination with highest probability wins the day and is returned by the bullshitting method.

```ruby
sc = Scrabble.new
p sc.bullshit! 'ptteeaa'.chars
# => 'teapeat' (residue that collects at the bottom of beer vats during fermentation)
```

to be developed...

