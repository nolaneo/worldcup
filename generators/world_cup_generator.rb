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
    tier: 2,
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
    tier: 1,
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

number_of_combinations = 20_000

results = 1.upto(number_of_combinations).map do |i|
  puts "Calculating combination #{i}"

  teams = TEAMS.dup
  res = {}
  success = true

  players.each do |player|
    res[player] = []
    used_groups = []
    
    1.upto(4) do |current_tier|
      teams.shuffle!(random: random)
      available_teams = teams.reject { |t| used_groups.include?(t[:group]) || t[:tier] != current_tier }

      if available_teams.empty?
        success = false
        break
      end

      team = available_teams.pop
      teams.delete(team)
      res[player] << team
      used_groups << team[:group]
    end

    break if success == false
  end

  next nil unless success


  {
    combination: res,
  }
end.compact

results.shuffle!(random: random)

results.first[:combination].each do |player, selected_teams|
  team_names = selected_teams.map { |t| "#{t[:flag]}  #{t[:name]} (Group #{t[:group]}, Tier #{t[:tier]})" }.join(", ")
  puts "#{player}: #{team_names}"
end

first_choice_sets = results.first[:combination].map { |_, selected_teams| Set.new(selected_teams.map{ |t| t[:name] }) }

available_additional_team_selections = results[1][:combination].values.select do |selected_teams|
  set = Set.new(selected_teams.map{ |t| t[:name] })
  next true if first_choice_sets.all? { |other_set| other_set.intersection(set).count < 2 }
  false
end

extra_players.each_with_index do |player, i|
  selected_teams = available_additional_team_selections[i]
  team_names = selected_teams.map { |t| "#{t[:flag]}  #{t[:name]} (Group #{t[:group]}, Tier #{t[:tier]})" }.join(", ")
  puts "#{player}: #{team_names}"
end