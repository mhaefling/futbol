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

    # calls the goals_by_team method which is a hash of team ids with how many goals theyve had
    # then iterates over that hash to find the the team id with the max goals
    # than finds the name of that team and returns it
    def best_offense 
        goals_by_team
        max_team_goals = goals_by_team.max_by { |_, stats| stats[:total_goals].to_f / stats[:games_played] }
        max_team_id = max_team_goals.first
        team_name = teams[max_team_id].name
        team_name
    end

    # calls the goals_by_team method which is a hash of team ids with how many goals theyve had
    # then iterates over that hash to find the the team id with the min goals
    # than finds the name of that team and returns it
    def worst_offense
        goals_by_team
        min_team_goals = goals_by_team.min_by { |_, stats| stats[:total_goals].to_f / stats[:games_played] }
        min_team_id = min_team_goals.first
        team_name_2 = teams[min_team_id].name
        team_name_2
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

     # method to make a hash with team ids and how many goals they have made over all seasons
    def goals_by_team
        team_goals = Hash.new { |hash, key| hash[key] = { total_goals: 0, games_played: 0}}

        game_teams.each do |_, game_team|
            team_goals[game_team.team_id][:total_goals] += game_team.goals
            team_goals[game_team.team_id][:games_played] += 1
        end
        team_goals
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

