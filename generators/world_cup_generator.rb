require 'set'
require 'json'

player_args = ARGV[0]
seed_arg = ARGV[1]
filename_arg = ARGV[2]

players = player_args.split(',').map(&:strip).sort
seed = seed_arg.nil? ? rand(0..10000) : seed_arg.to_i

puts "Seed: #{seed}"

# MENS_TEAMS = [
#   {
#     name: 'Netherlands',
#     code: 'NED',
#     flag: '🇳🇱',
#     group: 'A',
#     tier: 1,
#   },
#   {
#     name: 'Senegal',
#     code: 'SEN',
#     flag: '🇸🇳',
#     group: 'A',
#     tier: 2,
#   },
#   {
#     name: 'Ecuador',
#     code: 'ECU',
#     flag: '🇪🇨',
#     group: 'A',
#     tier: 3,
#   },
#   {
#     name: 'Qatar',
#     code: 'QAT',
#     flag: '🇶🇦',
#     group: 'A',
#     tier: 4,
#   },
#   {
#     name: 'England',
#     code: 'ENG',
#     flag: '🏴󠁧󠁢󠁥󠁮󠁧󠁿',
#     group: 'B',
#     tier: 1,
#   },
#   {
#     name: 'Wales',
#     code: 'WAL',
#     flag: '🏴󠁧󠁢󠁷󠁬󠁳󠁿',
#     group: 'B',
#     tier: 2,
#   },
#   {
#     name: 'USA',
#     code: 'USA',
#     flag: '🇺🇸',
#     group: 'B',
#     tier: 3,
#   },
#   {
#     name: 'Iran',
#     code: 'IRN',
#     flag: '🇮🇷',
#     group: 'B',
#     tier: 4,
#   },
#   {
#     name: 'Argentina',
#     code: 'ARG',
#     flag: '🇦🇷',
#     group: 'C',
#     tier: 1,
#   },
#   {
#     name: 'Mexico',
#     code: 'MEX',
#     flag: '🇲🇽',
#     group: 'C',
#     tier: 2,
#   },
#   {
#     name: 'Poland',
#     code: 'POL',
#     flag: '🇵🇱',
#     group: 'C',
#     tier: 3,
#   },
#   {
#     name: 'Saudi Arabia',
#     code: 'KSA',
#     flag: '🇸🇦',
#     group: 'C',
#     tier: 4,
#   },
#   {
#     name: 'France',
#     code: 'FRA',
#     flag: '🇫🇷',
#     group: 'D',
#     tier: 1,
#   },
#   {
#     name: 'Denmark',
#     code: 'DEN',
#     flag: '🇩🇰',
#     group: 'D',
#     tier: 2,
#   },
#   {
#     name: 'Australia',
#     code: 'AUS',
#     flag: '🇦🇺',
#     group: 'D',
#     tier: 3,
#   },
#   {
#     name: 'Tunisia',
#     code: 'TUN',
#     flag: '🇹🇳',
#     group: 'D',
#     tier: 4,
#   },
#   {
#     name: 'Spain',
#     code: 'ESP',
#     flag: '🇪🇸',
#     group: 'E',
#     tier: 1,
#   },
#   {
#     name: 'Germany',
#     code: 'GER',
#     flag: '🇩🇪',
#     group: 'E',
#     tier: 1,
#   },
#   {
#     name: 'Japan',
#     code: 'JPN',
#     flag: '🇯🇵',
#     group: 'E',
#     tier: 3,
#   },
#   {
#     name: 'Costa Rica',
#     code: 'CRC',
#     flag: '🇨🇷',
#     group: 'E',
#     tier: 4,
#   },
#   {
#     name: 'Belgium',
#     code: 'BEL',
#     flag: '🇧🇪',
#     group: 'F',
#     tier: 2,
#   },
#   {
#     name: 'Croatia',
#     code: 'CRO',
#     flag: '🇭🇷',
#     group: 'F',
#     tier: 2,
#   },
#   {
#     name: 'Morocco',
#     code: 'MAR',
#     flag: '🇲🇦',
#     group: 'F',
#     tier: 3,
#   },
#   {
#     name: 'Canada',
#     code: 'CAN',
#     flag: '🇨🇦',
#     group: 'F',
#     tier: 4,
#   },
#   {
#     name: 'Brazil',
#     code: 'BRA',
#     flag: '🇧🇷',
#     group: 'G',
#     tier: 1,
#   },
#   {
#     name: 'Switzerland',
#     code: 'SUI',
#     flag: '🇨🇭',
#     group: 'G',
#     tier: 2,
#   },
#   {
#     name: 'Serbia',
#     code: 'SRB',
#     flag: '🇷🇸',
#     group: 'G',
#     tier: 3,
#   },
#   {
#     name: 'Cameroon',
#     code: 'CMR',
#     flag: '🇨🇲',
#     group: 'G',
#     tier: 4,
#   },
#   {
#     name: 'Portugal',
#     code: 'POR',
#     flag: '🇵🇹',
#     group: 'H',
#     tier: 1,
#   },
#   {
#     name: 'Uruguay',
#     code: 'URU',
#     flag: '🇺🇾',
#     group: 'H',
#     tier: 2,
#   },
#   {
#     name: 'South Korea',
#     code: 'KOR',
#     flag: '🇰🇷',
#     group: 'H',
#     tier: 3,
#   },
#   {
#     name: 'Ghana',
#     code: 'GHA',
#     flag: '🇬🇭',
#     group: 'H',
#     tier: 4,
#   },
# ]

TEAMS = [
  {
      "country": "Norway",
      "group": "A",
      "code": "NOR",
      "flag": "🇳🇴",
      "tier": 1
  },
  {
      "country": "Switzerland",
      "group": "A",
      "code": "SUI",
      "flag": "🇨🇭",
      "tier": 2
  },
  {
      "country": "New Zealand",
      "group": "A",
      "code": "NZL",
      "flag": "🇳🇿",
      "tier": 3
  },
  {
      "country": "Philippines",
      "group": "A",
      "code": "PHI",
      "flag": "🇵🇭",
      "tier": 4
  },
  {
      "country": "Australia",
      "group": "B",
      "code": "AUS",
      "flag": "🇦🇺",
      "tier": 1
  },
  {
      "country": "Canada",
      "group": "B",
      "code": "CAN",
      "flag": "🇨🇦",
      "tier": 2
  },
  {
      "country": "Republic of Ireland",
      "group": "B",
      "code": "IRL",
      "flag": "🇮🇪",
      "tier": 3
  },
  {
      "country": "Nigeria",
      "group": "B",
      "code": "NGA",
      "flag": "🇳🇬",
      "tier": 4
  },
  {
      "country": "Spain",
      "group": "C",
      "code": "ESP",
      "flag": "🇪🇸",
      "tier": 1
  },
  {
      "country": "Japan",
      "group": "C",
      "code": "JPN",
      "flag": "🇯🇵",
      "tier": 2
  },
  {
      "country": "Zambia",
      "group": "C",
      "code": "ZAM",
      "flag": "🇿🇲",
      "tier": 3
  },
  {
      "country": "Costa Rica",
      "group": "C",
      "code": "CRC",
      "flag": "🇨🇷",
      "tier": 4
  },
  {
      "country": "England",
      "group": "D",
      "code": "ENG",
      "flag": "🏴󠁧󠁢󠁥󠁮󠁧󠁿",
      "tier": 1
  },
  {
      "country": "Denmark",
      "group": "D",
      "code": "DEN",
      "flag": "🇩🇰",
      "tier": 2
  },
  {
      "country": "China",
      "group": "D",
      "code": "CHN",
      "flag": "🇨🇳",
      "tier": 3
  },
  {
      "country": "Haiti",
      "group": "D",
      "code": "HAI",
      "flag": "🇭🇹",
      "tier": 4
  },
  {
      "country": "USA",
      "group": "E",
      "code": "USA",
      "flag": "🇺🇸",
      "tier": 1
  },
  {
      "country": "Netherlands",
      "group": "E",
      "code": "NED",
      "flag": "🇳🇱",
      "tier": 2
  },
  {
      "country": "Portugal",
      "group": "E",
      "code": "POR",
      "flag": "🇵🇹",
      "tier": 3
  },
  {
      "country": "Vietnam",
      "group": "E",
      "code": "VIE",
      "flag": "🇻🇳",
      "tier": 4
  },
  {
      "country": "France",
      "group": "F",
      "code": "FRA",
      "flag": "🇫🇷",
      "tier": 1
  },
  {
      "country": "Brazil",
      "group": "F",
      "code": "BRA",
      "flag": "🇧🇷",
      "tier": 2
  },
  {
      "country": "Jamaica",
      "group": "F",
      "code": "JAM",
      "flag": "🇯🇲",
      "tier": 3
  },
  {
      "country": "Panama",
      "group": "F",
      "code": "PAN",
      "flag": "🇵🇦",
      "tier": 4
  },
  {
      "country": "Sweden",
      "group": "G",
      "code": "SWE",
      "flag": "🇸🇪",
      "tier": 1
  },
  {
      "country": "Italy",
      "group": "G",
      "code": "ITA",
      "flag": "🇮🇹",
      "tier": 2
  },
  {
      "country": "Argentina",
      "group": "G",
      "code": "ARG",
      "flag": "🇦🇷",
      "tier": 3
  },
  {
      "country": "South Africa",
      "group": "G",
      "code": "RSA",
      "flag": "🇿🇦",
      "tier": 4
  },
  {
      "country": "Germany",
      "group": "H",
      "code": "GER",
      "flag": "🇩🇪",
      "tier": 1
  },
  {
      "country": "Colombia",
      "group": "H",
      "code": "COL",
      "flag": "🇨🇴",
      "tier": 2
  },
  {
      "country": "South Korea",
      "group": "H",
      "code": "KOR",
      "flag": "🇰🇷",
      "tier": 3
  },
  {
      "country": "Morocco",
      "group": "H",
      "code": "MAR",
      "flag": "🇲🇦",
      "tier": 4
  }
]

@random = Random.new(seed)

players.shuffle!(random: @random)

number_of_combinations = 10_000

output_teams_by_tier = {}

def generate_player_teams(output:, players:)

  teams_by_tier = TEAMS.group_by { |team| team[:tier] }


  players.each_with_index do |player, index|

    if teams_by_tier.values.all? { |teams| teams.empty? }
      puts "Reset teams"
      teams_by_tier = TEAMS.group_by { |team| team[:tier] }
    end

    used_groups_for_player = []

    teams_by_tier.each do |tier, teams|
      teams.shuffle!(random: @random)
      available_teams = teams.reject { |team| used_groups_for_player.include?(team[:group]) }

      if available_teams.empty?
        return false
      else
        team = available_teams.pop
        teams.delete(team)
        output[tier] << team
        used_groups_for_player << team[:group]
      end
    end
  end
  
  puts "Combination found"
  true
end

def ensure_unique_groups(output:, players:)
  players.each_with_index do |player, index|
    
    groups = output.keys.map { |tier| output[tier][index][:group] }
    
    unless groups.uniq.count == 4
      return false
    end
  end

  true
end

def other_groups_used(output:, player:, swap_tier:)
  (output.keys - [swap_tier]).map { |tier| output[tier][player][:group] }
end

def swap(output:, players_with_most_overlaps:, players_with_fewest_overlaps:)
  player = players_with_most_overlaps.sample(random: @random)

  tier_to_swap = output.keys.sample(random: @random)

  other_groups_used_by_player = other_groups_used(output: output, player: player, swap_tier: tier_to_swap)

  swap_player = players_with_fewest_overlaps.find { |index| !other_groups_used_by_player.include?(output[tier_to_swap][index][:group]) }

  return if swap_player.nil?

  # puts "Swapping teams for player #{player} with player #{swap_player} on tier #{tier_to_swap}"

  a = output[tier_to_swap][player]
  b = output[tier_to_swap][swap_player]

  output[tier_to_swap][player] = b
  output[tier_to_swap][swap_player] = a
end

def balance_overlaps(output:, players:)
  player_indices = (0..players.count - 1)

  balance_attempts = 0

  while balance_attempts < 100 do
    players_by_overlap_count = player_indices.group_by do |index|
      output.keys.select do |tier|
        team_for_player = output[tier][index]

        output[tier].group_by(&:itself).transform_values(&:count)[team_for_player] > 1
      end.count
    end

    keys = players_by_overlap_count.keys.sort

    if keys.count < 2
      names = players_by_overlap_count.map do |k, v|
        [k, v.map { |player_index| players[player_index] }]
      end.to_h

      puts "Final overlap counts: #{names}"

      return true
    end

    if keys.last - keys.first <= 1
      names = players_by_overlap_count.map do |k, v|
        [k, v.map { |player_index| players[player_index] }]
      end.to_h

      puts "Final overlap counts: #{names}"

      return true
    end

    balance_attempts += 1

    swap(output: output, players_with_most_overlaps: players_by_overlap_count[keys.last], players_with_fewest_overlaps: players_by_overlap_count[keys.first])
  end
end

result = 1.upto(number_of_combinations).find do |i|
  puts "Calculating combination #{i}"

  output = {
    1 => [],
    2 => [],
    3 => [],
    4 => [],
  }

  success = generate_player_teams(players: players, output: output)

  next false unless success

  next false unless ensure_unique_groups(players: players, output: output)

  balance_overlaps(players: players, output: output)

  next false unless ensure_unique_groups(players: players, output: output)

  output_teams_by_tier = output

  true
end


players.each_with_index do |player, i|
  selected_teams = output_teams_by_tier.keys.map { |tier| output_teams_by_tier[tier][i] }
  team_names = selected_teams.map { |t| "#{t[:flag]}  #{t[:name]} (Group #{t[:group]}, Tier #{t[:tier]})" }.join(", ")
  puts "#{player}: #{team_names}"
end

puts "----"
if filename_arg
  data = {
    players: players.map.with_index { |p, i|
      selected_teams = output_teams_by_tier.keys.map { |tier| output_teams_by_tier[tier][i] }
      {
        name: p,
        teams: selected_teams.map{ |t| t[:code]},
        image: ""
      }
    }
  }
  filename = "public/players/#{filename_arg}.json"
  File.write(filename, data.to_json)
  puts "created #{filename}"
end


puts "Unique teams used: #{output_teams_by_tier.values.flatten.map{ |t| t[:code] }.uniq.count}"
