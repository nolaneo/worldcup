require 'set'
require 'json'

player_args = ARGV[0]
team_arg = ARGV[1]
seed_arg = ARGV[2]

players = player_args.split(',').map(&:strip).sort
seed = seed_arg.to_i

raise if seed.nil?

TEAMS = [
  {
    name: 'Netherlands',
    code: 'NED',
    flag: '🇳🇱',
    group: 'A',
    tier: 1,
  },
  {
    name: 'Senegal',
    code: 'SEN',
    flag: '🇸🇳',
    group: 'A',
    tier: 2,
  },
  {
    name: 'Ecuador',
    code: 'ECU',
    flag: '🇪🇨',
    group: 'A',
    tier: 3,
  },
  {
    name: 'Qatar',
    code: 'QAT',
    flag: '🇶🇦',
    group: 'A',
    tier: 4,
  },
  {
    name: 'England',
    code: 'ENG',
    flag: '🏴󠁧󠁢󠁥󠁮󠁧󠁿',
    group: 'B',
    tier: 1,
  },
  {
    name: 'Wales',
    code: 'WAL',
    flag: '🏴󠁧󠁢󠁷󠁬󠁳󠁿',
    group: 'B',
    tier: 2,
  },
  {
    name: 'USA',
    code: 'USA',
    flag: '🇺🇸',
    group: 'B',
    tier: 3,
  },
  {
    name: 'Iran',
    code: 'IRN',
    flag: '🇮🇷',
    group: 'B',
    tier: 4,
  },
  {
    name: 'Argentina',
    code: 'ARG',
    flag: '🇦🇷',
    group: 'C',
    tier: 1,
  },
  {
    name: 'Mexico',
    code: 'MEX',
    flag: '🇲🇽',
    group: 'C',
    tier: 2,
  },
  {
    name: 'Poland',
    code: 'POL',
    flag: '🇵🇱',
    group: 'C',
    tier: 3,
  },
  {
    name: 'Saudi Arabia',
    code: 'KSA',
    flag: '🇸🇦',
    group: 'C',
    tier: 4,
  },
  {
    name: 'France',
    code: 'FRA',
    flag: '🇫🇷',
    group: 'D',
    tier: 1,
  },
  {
    name: 'Denmark',
    code: 'DEN',
    flag: '🇩🇰',
    group: 'D',
    tier: 2,
  },
  {
    name: 'Australia',
    code: 'AUS',
    flag: '🇦🇺',
    group: 'D',
    tier: 3,
  },
  {
    name: 'Tunisia',
    code: 'TUN',
    flag: '🇹🇳',
    group: 'D',
    tier: 4,
  },
  {
    name: 'Spain',
    code: 'ESP',
    flag: '🇪🇸',
    group: 'E',
    tier: 1,
  },
  {
    name: 'Germany',
    code: 'GER',
    flag: '🇩🇪',
    group: 'E',
    tier: 2,
  },
  {
    name: 'Japan',
    code: 'JPN',
    flag: '🇯🇵',
    group: 'E',
    tier: 3,
  },
  {
    name: 'Costa Rica',
    code: 'CRC',
    flag: '🇨🇷',
    group: 'E',
    tier: 4,
  },
  {
    name: 'Belgium',
    code: 'BEL',
    flag: '🇧🇪',
    group: 'F',
    tier: 1,
  },
  {
    name: 'Croatia',
    code: 'CRO',
    flag: '🇭🇷',
    group: 'F',
    tier: 2,
  },
  {
    name: 'Morocco',
    code: 'MAR',
    flag: '🇲🇦',
    group: 'F',
    tier: 3,
  },
  {
    name: 'Canada',
    code: 'CAN',
    flag: '🇨🇦',
    group: 'F',
    tier: 4,
  },
  {
    name: 'Brazil',
    code: 'BRA',
    flag: '🇧🇷',
    group: 'G',
    tier: 1,
  },
  {
    name: 'Switzerland',
    code: 'SUI',
    flag: '🇨🇭',
    group: 'G',
    tier: 2,
  },
  {
    name: 'Serbia',
    code: 'SRB',
    flag: '🇷🇸',
    group: 'G',
    tier: 3,
  },
  {
    name: 'Cameroon',
    code: 'CMR',
    flag: '🇨🇲',
    group: 'G',
    tier: 4,
  },
  {
    name: 'Portugal',
    code: 'POR',
    flag: '🇵🇹',
    group: 'H',
    tier: 1,
  },
  {
    name: 'Uruguay',
    code: 'URU',
    flag: '🇺🇾',
    group: 'H',
    tier: 2,
  },
  {
    name: 'South Korea',
    code: 'KOR',
    flag: '🇰🇷',
    group: 'H',
    tier: 3,
  },
  {
    name: 'Ghana',
    code: 'GHA',
    flag: '🇬🇭',
    group: 'H',
    tier: 4,
  },
]

random = Random.new(seed)

players.shuffle!(random: random)


teams_by_tier = TEAMS.group_by { |team| team[:tier] }

teams_by_tier.each do |t, teams|
  raise "#{teams.count} in tier #{t}" unless teams.count == 8
end

output_teams_by_tier = {
  1 => [],
  2 => [],
  3 => [],
  4 => [],
}

0.upto(players.count) do |i|
  puts "Generating output teams #{i}"

  if teams_by_tier.all? { |_, v| v.empty? }
  teams_by_tier = TEAMS.group_by { |team| team[:tier] }
  end

  1.upto(4) do |tier|
    team = teams_by_tier[tier].shuffle!(random: random).pop
    output_teams_by_tier[tier] << team
  end
end


number_of_combinations = 20_000

result = 1.upto(number_of_combinations).find do |i|
  puts "Calculating combination #{i}"

  is_ok = 0.upto(players.count).all? do |i|
    output_teams_by_tier.keys.map { |tier| output_teams_by_tier[tier][i][:group] }.uniq.count == 4
    output_teams_by_tier.keys.map { |tier| output_teams_by_tier[tier][i][:name] }.uniq.count >= 4

  end

  if !is_ok
    output_teams_by_tier.each { |_, teams| teams.shuffle!(random: random) }
  end

  is_ok
end

if result.nil?
  raise "No combo found"
else
 puts "Combo found"
end


players.each_with_index do |player, i|
  selected_teams = output_teams_by_tier.keys.map { |tier| output_teams_by_tier[tier][i] }
  team_names = selected_teams.map { |t| "#{t[:flag]}  #{t[:name]} (Group #{t[:group]}, Tier #{t[:tier]})" }.join(", ")
  puts "#{player}: #{team_names}"
end

puts "----"
if team_arg
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
  filename = "public/players/#{team_arg}.json"
  File.write(filename, data.to_json)
  puts "created #{filename}"
end

puts output_teams_by_tier.values.flatten.uniq.map{|team| team[:name]}
puts output_teams_by_tier.values.flatten.uniq.count
