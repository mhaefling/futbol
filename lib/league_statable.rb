module LeagueStatable

    # Method to determine count of unique teams in a CSV file
    def count_of_teams
        team_ids = []

        @game_teams.each_value do |game_team|
            team_ids << game_team.team_id
        end
        unique_team_count = team_ids.uniq.count
        unique_team_count  # Return the count as an integer
    end

    def best_offense 
        team_goals = Hash.new { |hash, key| hash[key] = { total_goals: 0, games_played: 0}}

        game_teams.each do |_, game_team|
            team_goals[game_team.team_id][:total_goals] += game_team.goals
            team_goals[game_team.team_id][:games_played] += 1
        end

        max_team_id, max_stats = team_goals.max_by { |_, stats| stats[:total_goals].to_f / stats[:games_played]}

        team_name = teams[max_team_id].name

        return "#{team_name}"
    end

    def worst_offense
        team_goals_2 = Hash.new { |hash, key| hash[key] = {total_goals: 0, games_played: 0}}

        game_teams.each do |_, game_team|
            team_goals_2[game_team.team_id][:total_goals] += game_team.goals
            team_goals_2[game_team.team_id][:games_played] += 1
        end

        min_team_id, min_stats = team_goals_2.min_by { |_, stats| stats[:total_goals].to_f / stats[:games_played]}

        team_name_2 = teams[min_team_id].name

        return "#{team_name_2}"
    end

    def highest_scoring_visitor
        return highest_scoring_hoa("away")
    end

    def highest_scoring_home_team
        return highest_scoring_hoa("home")
    end

    def lowest_scoring_visitor
        return lowest_scoring_hoa("away")
    end

    def lowest_scoring_home_team
        return lowest_scoring_hoa("home")
    end
 
    ####### Helper Methods ########

    def games_per_team
        team_count = Hash.new(0)
        @games.each do |game|
            team_count[game[1].away_team] += 1
        end
    end

    def total_games_per_team_hoa(team_id, hoa)
        
        total = @game_teams.count do |id, game_team|
            game_team.team_id == team_id && game_team.hoa == hoa
        end
        total
    end

    def sum_of_team_scores_hoa(team_id, hoa)
        sum = 0
       
        @game_teams.each do |id, game_team|
            if game_team.team_id == team_id && game_team.hoa == hoa
                sum += game_team.goals
            end
        end
        sum
    end
    
    def average_score_hoa(team_id, hoa)
        return (sum_of_team_scores_hoa(team_id, hoa).to_f / total_games_per_team_hoa(team_id, hoa).to_f).round(5)
    end

    def highest_scoring_hoa(hoa)
        highest = @teams.values.max_by do |team|
            average_score_hoa(team.team_id, hoa)
        end
        return highest.name
    end

    def lowest_scoring_hoa(hoa)
        lowest = @teams.values.min_by do |team|
            average_score_hoa(team.team_id, hoa)
        end
        return lowest.name
    end
end


