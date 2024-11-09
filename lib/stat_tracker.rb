require 'csv'
require_relative './game'
require_relative './team'
require_relative './game_teams'
require_relative './game_statable'
require_relative './league_statable'
require_relative './season_statable'
require_relative './displayable'

class StatTracker
    include GameStatable
    include LeagueStatable
    include SeasonStatable
    include Displayable

    attr_reader :teams, 
                :games, 
                :game_teams

    def initialize
        @teams = {}
        @games = {}
        @game_teams = {}
    end

    def self.from_csv(locations)
        stat_tracker = new
        stat_tracker.load_teams_data(locations[:teams])
        stat_tracker.load_games_data(locations[:games])
        stat_tracker.load_game_teams_data(locations[:game_teams])
        stat_tracker.display_stats
        return stat_tracker
    end

    def load_teams_data(location)
        CSV.foreach(location, headers: true, header_converters: :symbol) do |row|
            new_team = Team.new(row[:team_id], row[:teamname])
            @teams[new_team.team_id] = new_team
        end
    end
    
    def load_games_data(location)
        CSV.foreach(location, headers: true, header_converters: :symbol) do |row|
            new_game = Game.new(row[:game_id], row[:season], row[:away_team_id], row[:home_team_id], row[:away_goals].to_i, row[:home_goals].to_i)
            @games[new_game.game_id] = new_game
        end
    end

    def load_game_teams_data(location)
        CSV.foreach(location, headers: true, header_converters: :symbol) do |row|    
            new_game_team = GameTeams.new(row[:game_id], row[:team_id], row[:hoa], row[:result], row[:head_coach], row[:goals].to_i, row[:shots].to_i, row[:tackles].to_i)
            @game_teams[new_game_team.game_team_id] = new_game_team
        end
    end

    def inspect
        "#<#{self.class.name}:#{self.object_id}"
    end
end

