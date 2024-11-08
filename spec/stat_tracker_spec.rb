require './spec/spec_helper'

RSpec.describe StatTracker do
    describe '#instantiate' do
        it 'is a StatTracker' do
            stat_tracker = StatTracker.new

            expect(stat_tracker).to be_a(StatTracker)
        end
    end

    describe '#from_csv' do
        it 'pulls in data from csv' do

            game_path = './data/games.csv'
            team_path = './data/teams.csv'
            game_teams_path = './data/game_teams.csv'

            locations = {
                games: game_path,
                teams: team_path,
                game_teams: game_teams_path
            }
            
            stat_tracker = StatTracker.from_csv(locations)
            expect(stat_tracker.teams).to_not be_empty
            expect(stat_tracker.games).to_not be_empty
            expect(stat_tracker.game_teams).to_not be_empty
        end
    end
end
