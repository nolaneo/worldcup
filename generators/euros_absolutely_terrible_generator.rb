require 'set'

all_players = ARGV[0].split(',').map(&:strip).sort

players = all_players.first(8)
puts "#{players.count} players"

extra_players = all_players.drop(8)
puts "#{extra_players.count} extra players"

seed = ARGV[1].to_i

raise if seed.nil?

TEAMS = [
  {
    name: 'Turkey',
    flag: 'đšđˇ',
    odds: 61,
    group: 'A',
    tier: 2,
  },
  {
    name: 'Italy',
    flag: 'đŽđš',
    odds: 10,
    group: 'A',
    tier: 1,
  },
  {
    name: 'Wales',
    flag: 'đ´ó §ó ˘ó ˇó Źó łó ż',
    odds: 151,
    group: 'A',
    tier: 3,
  },
  {
    name: 'Switzerland',
    flag: 'đ¨đ­',
    odds: 61,
    group: 'A',
    tier: 2,
  },
  {
    name: 'Denmark',
    flag: 'đŠđ°',
    odds: 26,
    group: 'B',
    tier: 2,
  },
  {
    name: 'Finland',
    flag: 'đŤđŽ',
    odds: 251,
    group: 'B',
    tier: 3,
  },
  {
    name: 'Belgium',
    flag: 'đ§đŞ',
    odds: 7.0,
    group: 'B',
    tier: 1,
  },
  {
    name: 'Russia',
    flag: 'đˇđş',
    odds: 76,
    group: 'B',
    tier: 2,
  },
  {
    name: 'Netherlands',
    flag: 'đłđą',
    odds: 11,
    group: 'C',
    tier: 1,
  },
  {
    name: 'Ukraine',
    flag: 'đşđŚ',
    odds: 101,
    group: 'C',
    tier: 3,
  },
  {
    name: 'Austria',
    flag: 'đŚđš',
    odds: 91,
    group: 'C',
    tier: 2,
  },
  {
    name: 'North Macedonia',
    flag: 'đ˛đ°',
    odds: 401,
    group: 'C',
    tier: 3,
  },
  {
    name: 'England',
    flag: 'đ´ó §ó ˘ó Ľó Žó §ó ż',
    odds: 5.5,
    group: 'D',
    tier: 1,
  },
  {
    name: 'Croatia',
    flag: 'đ­đˇ',
    odds: 26,
    group: 'D',
    tier: 2,
  },
  {
    name: 'Scotland',
    flag: 'đ´ó §ó ˘ó łó Łó ´ó ż',
    odds: 201,
    group: 'D',
    tier: 3,
  },
  {
    name: 'Czech Republic',
    flag: 'đ¨đż',
    odds: 101,
    group: 'D',
    tier: 3,
  },
  {
    name: 'Spain',
    flag: 'đŞđ¸',
    odds: 8.0,
    group: 'E',
    tier: 1,
  },
  {
    name: 'Sweden',
    flag: 'đ¸đŞ',
    odds: 76,
    group: 'E',
    tier: 2,
  },
  {
    name: 'Poland',
    flag: 'đľđą',
    odds: 61,
    group: 'E',
    tier: 2,
  },
  {
    name: 'Slovakia',
    flag: 'đ¸đ°',
    odds: 251,
    group: 'E',
    tier: 3,
  },
  {
    name: 'Hungary',
    flag: 'đ­đş',
    odds: 251,
    group: 'F',
    tier: 3,
  },
  {
    name: 'Portugal',
    flag: 'đľđš',
    odds: 8.5,
    group: 'F',
    tier: 1,
  },
  {
    name: 'France',
    flag: 'đŤđˇ',
    odds: 6.5,
    group: 'F',
    tier: 1,
  },
  {
    name: 'Germany',
    flag: 'đŠđŞ',
    odds: 8.5,
    group: 'F',
    tier: 1,
  },
]
