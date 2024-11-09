require './spec/spec_helper.rb'

RSpec.describe LeagueStatable do
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
        @stat_tracker.extend(GameStatable)
    end

    describe '#count_of_teams' do
        it 'returns the count of teams from the game_teams.csv file' do
            expect(@stat_tracker.count_of_teams).to eq 32

        end
    end

    describe "best_offense" do
        it "tells which team has the most goals per game for all games" do
            expect(@stat_tracker.best_offense).to eq("Reign FC")
        end
    end

    describe "worst_offense" do
        it "tells which team has the least goals per game for all season" do
            expect(@stat_tracker.worst_offense).to eq("Utah Royals FC")
        end
    end

    describe '#highest_scoring_visitor' do 
        it "#highest_scoring_visitor" do
            expect(@stat_tracker.highest_scoring_visitor).to eq "FC Dallas"
        end
    end

    describe '#highest_scoring_home_team' do
        it "#highest_scoring_home_team" do
            expect(@stat_tracker.highest_scoring_home_team).to eq "Reign FC"
        end
    end

    describe '#lowest_scoring_visitor' do
        it 'returns lowest scoring visitor in league' do
            expect(@stat_tracker.lowest_scoring_visitor).to eq("San Jose Earthquakes")
        end
    end

    describe '#lowest_scoring_home_team' do
        it 'returns lowest scoring visitor in league' do
            expect(@stat_tracker.lowest_scoring_home_team).to eq("Utah Royals FC")
        end
    end


    ####### Helper Method Tests ########

    # Returns the total number of games a team played either home or away
    describe '#total_games_per_team_hoa' do
        it 'returns the total number of games a team played away' do
            team_id = '27'
            hoa = 'away'

            expect(@stat_tracker.total_games_per_team_hoa(team_id, hoa)).to eq(65)
        end

        it 'returns the total number of games a team played at home' do
            team_id = '27'
            hoa = 'home'

            expect(@stat_tracker.total_games_per_team_hoa(team_id, hoa)).to eq(65)
        end
    end

    describe '#sum_of_team_scores_hoa' do
        it 'returns the sum of the scores a team made while away' do
            team_id = '27'
            hoa = 'away'

            expect(@stat_tracker.sum_of_team_scores_hoa(team_id, hoa)).to eq(120)
        end

        it 'returns the sum of the scores a team made while home' do
            team_id = '27'
            hoa = 'home'

            expect(@stat_tracker.sum_of_team_scores_hoa(team_id, hoa)).to eq(143)
        end
    end

    describe "#average_score_hoa" do
        it 'returns the average score of all a teams away games' do
            team_id = '27'
            hoa = 'away'

            expect(@stat_tracker.average_score_hoa(team_id, hoa)).to eq(1.84615)
        end

        it 'returns the average score of all a teams home game' do
            team_id = '27'
            hoa = 'home'

            expect(@stat_tracker.average_score_hoa(team_id, hoa)).to eq(2.2)
        end
    end

    describe "#highest_scoring_hoa" do
        it 'returns the away team with the highest average score' do
            expect(@stat_tracker.highest_scoring_hoa("away")).to eq("FC Dallas")
        end

        it 'returns the home team with the lowest average score' do 
            expect(@stat_tracker.highest_scoring_hoa("home")).to eq("Reign FC")
        end
    end

    describe "#lowest_scoring_hoa" do
        it 'returns the away team with the lowest average score' do
            expect(@stat_tracker.lowest_scoring_hoa("away")).to eq("San Jose Earthquakes")
        end

        it 'returns the home team with the lowest average score' do 
            expect(@stat_tracker.lowest_scoring_hoa("home")).to eq("Utah Royals FC")
        end
    end
end