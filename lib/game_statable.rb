module GameStatable

    # Helper Method
    ## Returns the sum of home and away teams' goals
    def total_score(game_data)
        return game_data.away_goals + game_data.home_goals
    end

    # Iterates through games hash looking for the game with the highest totals
    # returned from inject game data into total_score helper method 
    # and then returns the highest number of scores of a game
    def highest_total_score
        highest_total_score  = @games.max_by do |id, data|
            total_score(data)
        end
        total_score(highest_total_score[1])
    end    

    # Iterates through games hash looking for the game with the lowest totals
    # returned from inject game data into total_score helper method 
    # and then returns the lowest number of scores of a game
    def lowest_total_score
        lowest_total_score  = @games.min_by do |id, data|
            total_score(data)
        end
        total_score(lowest_total_score[1])
    end 

    # Counts all of the keys in the game_teams hash and divides them by 2
    # Divides them by two because each game is entered twice with the team id 
    # concatenated to the end of the game_id
    # => Integer: 7441
    def total_game_count
        @game_teams.count / 2
    end

    # Counts all the key values in the game_teams hash comparing the hoa value to confirm
    # it was a home game, and the result value to confirm it was a win and then converts the total
    # count to a float.
    # => Float: 3237.0
    def total_home_wins
        home_games = @game_teams.count do |game|
            game[1].hoa == "home" && game[1].result == "WIN"
        end.to_f
    end

    # Counts all the key values in the game_teams hash comparing the hoa value to confirm
    # it was a away game, and the result value to confirm it was a win and then converts the total
    # count to a float.
    # => Float: 2687.0
    def total_visitor_wins
        visitor_games = @game_teams.count do |game|
            game[1].hoa == "away" && game[1].result == "WIN"
        end.to_f
    end

    # Counts all the key values in the game_teams hash confirming that the result value is a tie.
    # Divides the total by two because each game is entered twice with the team id 
    # concatenated to the end of the game_id
    # => Float: 1517.0
    def total_ties
        ties = @game_teams.count do |game|
            game[1].result == "TIE"
        end.to_f
        ties /= 2
    end

    
    # Determines the percent of home wins by taking the result of the total_home_wins method (3237.0)
    # and dividing it by the result of the total_game_count method (7441) and then rounding the return
    # value down to 2 decimal places.
    # => Float: 0.44
    def percentage_home_wins
        home_wins_percent = total_home_wins / total_game_count
        home_wins_percent.round(2)
    end

    # Determines the percent of visitor wins by taking the result of the total_visitor_wins method (2687.0)
    # and dividing it by the result of the total_game_count method (7441) and then rounding the return
    # value down to 2 decimal places.
    # => Float: 0.36
    def percentage_visitor_wins
        visitor_wins_percent = total_visitor_wins / total_game_count
        visitor_wins_percent.round(2)
    end

     # Determines the percent of tie games by taking the result of the total_ties method (1517.0) and dividing it by the result
    # of theh total_game_count method (7441) and then rounding the return value down to 2 decimal places.
    def percentage_ties
        ties_percent = total_ties / total_game_count
        ties_percent.round(2)

    end
    
    # makes an empty hash then iterates over the games hash to find the game
    def count_of_games_by_season
        season_counts = {} 
        
        games.each do |game_id, game|
            season = game.season

            season_counts[season] = season_counts.fetch(season, 0) + 1
        end
        season_counts
    end
end