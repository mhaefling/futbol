module Displayable

  # Calls all stat methods and displays those Futbol Stats
  def display_stats
    puts "Welcome to Futbol statistics!"
    puts "-----------------------------"
    puts "Game Statistics"
    puts "---------------"
    puts "Highest Total Score: #{highest_total_score}"
    puts "Lowest Total Score: #{lowest_total_score}"
    puts "Percentage of Home Wins: #{percentage_home_wins}"
    puts "Percentage of Visitor Wins: #{percentage_visitor_wins}"
    puts "Percentage of Ties: #{percentage_ties}"
    puts "Number of Games per season: "
    season_hash_display(:count_of_games_by_season, "games")
    puts "Average Goals per Game: #{average_goals_per_game}"
    # puts "Average Goals per Season: " 
    # season_hash_dispaly(:average_goals_per_season, "goals")
    puts "\n"
    puts "League Statistics"
    puts "-----------------"
    puts "Number of Teams: #{count_of_teams}"
    puts "Team with Best Offense: #{best_offense}"
    puts "Team with Worst Offense: #{worst_offense}"
    puts "Highest Scoring Visitor: #{highest_scoring_visitor}"
    puts "Highest Scoring Home Team: #{highest_scoring_home_team}"
    puts "Lowest Scoring Visitor: #{lowest_scoring_visitor}"
    puts "Lowest Scoring Home Team: #{lowest_scoring_home_team}"
    puts "\n"
    puts "Season Statistics"
    puts "-----------------"
    # puts "What season stats should display?"
    # user_input = gets.chomp
    test_season = "20132014"
    puts "Winningest Coach: #{winningest_coach(test_season)}"
    puts "Worst Coach: #{worst_coach(test_season)}"
    puts "Most Accurate Team: #{most_accurate_team(test_season)}"
    puts "Least Accurate Team: #{least_accurate_team(test_season)}"
    puts "Team with Most Tackles: #{most_tackles(test_season)}"
    puts "Team with Fewest Tackles: #{fewest_tackles(test_season)}"
  end

  # Helper method to iterate through the hash of number of game sper season
  # And display them as a table
  def season_hash_display(method, stat_type)
    season_game_hash = send(method)
    puts "    season | num of #{stat_type}"
    puts "  ------------------------"
    season_game_hash.each do |season, stat|
      puts "  #{season} | #{stat}"
    end

  end
end