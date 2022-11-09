require 'set'

players = ARGV[0].split(',').map(&:strip).sort

seed = ARGV[1].to_i

raise if seed.nil?

TEAMS = [
  {
    name: 'Netherlands',
    flag: '🇳🇱',
    group: 'A',
    tier: 1,
  },
  {
    name: 'Senegal',
    flag: '🇸🇳',
    group: 'A',
    tier: 2,
  },
  {
    name: 'Ecuador',
    flag: '🇪🇨',
    group: 'A',
    tier: 3,
  },
  {
    name: 'Qatar',
    flag: '🇶🇦',
    group: 'A',
    tier: 4,
  },
  {
    name: 'England',
    flag: '🏴󠁧󠁢󠁥󠁮󠁧󠁿',
    group: 'B',
    tier: 1,
  },
  {
    name: 'Wales',
    flag: '🏴󠁧󠁢󠁷󠁬󠁳󠁿',
    group: 'B',
    tier: 2,
  },
  {
    name: 'USA',
    flag: '🇺🇸',
    group: 'B',
    tier: 3,
  },
  {
    name: 'Iran',
    flag: '🇮🇷',
    group: 'B',
    tier: 4,
  },
  {
    name: 'Argentina',
    flag: '🇦🇷',
    group: 'C',
    tier: 1,
  },
  {
    name: 'Mexico',
    flag: '🇲🇽',
    group: 'C',
    tier: 2,
  },
  {
    name: 'Poland',
    flag: '🇵🇱',
    group: 'C',
    tier: 3,
  },
  {
    name: 'Saudi Arabia',
    flag: '🇸🇦',
    group: 'C',
    tier: 4,
  },
  {
    name: 'France',
    flag: '🇫🇷',
    group: 'D',
    tier: 1,
  },
  {
    name: 'Denmark',
    flag: '🇩🇰',
    group: 'D',
    tier: 2,
  },
  {
    name: 'Australia',
    flag: '🇦🇺',
    group: 'D',
    tier: 3,
  },
  {
    name: 'Tunisia',
    flag: '🇹🇳',
    group: 'D',
    tier: 4,
  },
  {
    name: 'Spain',
    flag: '🇪🇸',
    group: 'E',
    tier: 1,
  },
  {
    name: 'Germany',
    flag: '🇩🇪',
    group: 'E',
    tier: 1,
  },
  {
    name: 'Japan',
    flag: '🇯🇵',
    group: 'E',
    tier: 3,
  },
  {
    name: 'Costa Rica',
    flag: '🇨🇷',
    group: 'E',
    tier: 4,
  },
  {
    name: 'Belgium',
    flag: '🇧🇪',
    group: 'F',
    tier: 2,
  },
  {
    name: 'Croatia',
    flag: '🇭🇷',
    group: 'F',
    tier: 2,
  },
  {
    name: 'Morocco',
    flag: '🇲🇦',
    group: 'F',
    tier: 3,
  },
  {
    name: 'Canada',
    flag: '🇨🇦',
    group: 'F',
    tier: 4,
  },
  {
    name: 'Brazil',
    flag: '🇧🇷',
    group: 'G',
    tier: 1,
  },
  {
    name: 'Switzerland',
    flag: '🇨🇭',
    group: 'G',
    tier: 2,
  },
  {
    name: 'Serbia',
    flag: '🇷🇸',
    group: 'G',
    tier: 3,
  },
  {
    name: 'Cameroon',
    flag: '🇨🇲',
    group: 'G',
    tier: 4,
  },
  {
    name: 'Portugal',
    flag: '🇵🇹',
    group: 'H',
    tier: 1,
  },
  {
    name: 'Uruguay',
    flag: '🇺🇾',
    group: 'H',
    tier: 2,
  },
  {
    name: 'South Korea',
    flag: '🇰🇷',
    group: 'H',
    tier: 3,
  },
  {
    name: 'Ghana',
    flag: '🇬🇭',
    group: 'H',
    tier: 4,
  },
]

random = Random.new(seed)

players.shuffle!(random: random)


teams_by_tier = TEAMS.group_by { |team| team[:tier] }

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
