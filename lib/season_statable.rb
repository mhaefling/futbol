module SeasonStatable
    
    def winningest_coach(season)
        season_games = games_by_season(season)
        coach_wins = Hash.new(0)
        total_coach_game = Hash.new(0)
        coach_wins_in_season(season_games, coach_wins, total_coach_game)
        coach_win_percentages = coach_win_percentage_calculator(coach_wins, total_coach_game)
        coach_win_percentages.max_by { |coach, win_percentage| win_percentage}.first
    end

    def worst_coach(season)
        season_games = games_by_season(season)
        coach_wins = Hash.new(0)
        total_coach_game = Hash.new(0)
        coach_wins_in_season(season_games, coach_wins, total_coach_game)
        coach_win_percentages = coach_win_percentage_calculator(coach_wins, total_coach_game)
        coach_win_percentages.min_by { |coach, win_percentage| win_percentage}.first
    end

    def most_accurate_team(season)
        team_id = best_ratio(team_ratios(team_season_shot_goals(games_by_season(season))))
        return team_name_from_id(team_id)
    end

    def least_accurate_team(season)
        team_id = worst_ratio(team_ratios(team_season_shot_goals(games_by_season(season))))
        return team_name_from_id(team_id)
    end

    # Returns the name of the team with the most tackles for a given season
    def most_tackles(season_id)
        tackles_by_team = calculate_tackles(season_id)
        team_with_most_tackles = find_team_with_most_tackles(tackles_by_team)
        team_name_from_id(team_with_most_tackles)
    end

    # calls on calculate_tackles to get a hash with team:id as the key 
    # and the total number of tackles.
    # Itll also find the team w/ the highest number of tackles and using the 
    # find_team_with_most_tackles. OR the ..least_tackles.
    # Returns the name of the team with the fewest tackles for a given season
    def fewest_tackles(season_id)
        tackles_by_team = calculate_tackles(season_id)
        team_with_least_tackles = find_team_with_fewest_tackles(tackles_by_team)
        team_name_from_id(team_with_least_tackles)
    end

    ####### Helper Methods ########

    def coach_wins_in_season(season_games, coach_wins, total_coach_game)
        season_games.each do |game_id|
            coach_team = @game_teams.select { |game_team_id, game_team| game_team.game_id == game_id}

            coach_team.each do |game_team_id, game_team|
                total_coach_game[game_team.head_coach] += 1
                
                if game_team.result == 'WIN'
                    coach_wins[game_team.head_coach] += 1
                else
                    coach_wins[game_team.head_coach] += 0
                end
            end
        end
    end

    def coach_win_percentage_calculator(coach_wins, total_coach_game)
        coach_wins.map do |coach, wins|
            total_games = total_coach_game[coach]
            win_percentage = (wins.to_f / total_games) * 100
            [coach, win_percentage]
        end.to_h
    end


    # Helper method to find the team with the most tackles
    def find_team_with_most_tackles(tackles_by_team)
        tackles_by_team.max_by { |_, tackles| tackles }&.first
    end

    # Helper method to find the team with the least tackles
    def find_team_with_fewest_tackles(tackles_by_team)
        tackles_by_team.min_by { |_, tackles| tackles }&.first
    end

    # Helper method to convert team_id to team name
    def team_name_from_id(team_id)
        @teams[team_id].name
    end

    # Helper method, returns an array of game_id's for the given season
    def games_by_season(season)
        season_games = []
        @games.find_all do |game|
            if game[1].season == season
                season_games << game[1].game_id
            end
        end
        return season_games
    end

    # Helper method, returns a hash with the team_id as keys and their total shots and goals for the provided season as an array value.
    def team_season_shot_goals(season_games)
        team_shot_goal_count = Hash.new do |team_shot_goal_count, team_id| 
            team_shot_goal_count[team_id] = [0, 0]
        end
        season_games.each do |game|
            @game_teams.each do |game_id|
                if game_id[1].game_id == game
                    team_shot_goal_count[game_id[1].team_id][0] += game_id[1].goals
                    team_shot_goal_count[game_id[1].team_id][1] += game_id[1].shots
                end
            end
        end
        return team_shot_goal_count
    end

    # Helper method, returns a hash with the team_id as the keys with their shots to goals ratio percentage.
    def team_ratios(team_shot_goal_count)
        team_ratios = Hash.new(0)
        team_shot_goal_count.each do |team|
            team_ratios[team[0]] = team[1][0].to_f / team[1][1].to_f
        end
        return team_ratios
    end

      # Helper method to calculate tackles for each team for a given season
    def calculate_tackles(season_id)
        tackles_by_team = Hash.new(0)
        # creates a new hash called tackles_by_team with a default value of 0
        # iterate over all game teams, using season_id as the hash 
        @game_teams.each_value do |game_team|
        game = @games[game_team.game_id]
        next unless game && game.season == season_id  # Filter by season

        team_id = game_team.team_id
        tackles = game_team.tackles
        tackles_by_team[team_id] += tackles
        end

        tackles_by_team
    end

    def best_ratio(team_ratios)
        team_ratios.max_by do |team|
            team[1]
        end[0]
    end

    def worst_ratio(team_ratios)
        team_ratios.min_by do |team|
            team[1]
        end[0]
    end
end