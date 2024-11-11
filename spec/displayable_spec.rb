require './spec/spec_helper'

RSpec.describe Displayable do
  before(:each) do
    game_path = './data/games.csv'
    team_path = './data/teams.csv'
    game_teams_path = './data/game_teams.csv'

    locations = {
        games: game_path,
        teams: team_path,
        game_teams: game_teams_path
    }
    
    @stat_tracker = StatTracker.from_csv(locations)
  end

  describe "#display_stats" do
    it 'displays futbol stat data' do
      expect(@stat_tracker.display_stats).to be true
    end
  end

  describe "#season_hash_display" do
    it 'organize season data into a table' do
      expect(@stat_tracker.season_hash_display(:count_of_games_by_season, "games")).to be true
    end
  end
end