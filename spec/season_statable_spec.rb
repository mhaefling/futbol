require './spec/spec_helper.rb'

RSpec.describe SeasonStatable do
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

    describe "winnigest_coach" do
        it "returns the head_coach with the most wins per that season" do
            expect(@stat_tracker.winningest_coach("20132014")).to eq ("Claude Julien")
            expect(@stat_tracker.winningest_coach("20142015")).to eq ("Alain Vigneault")
        end
    end

    describe "worst_coach" do
        it "returns the head coach with the most losses per season" do
        expect(@stat_tracker.worst_coach("20132014")).to eq ("Peter Laviolette")
        expect(@stat_tracker.worst_coach("20142015")).to eq("Craig MacTavish").or(eq("Ted Nolan"))
        end
    end

    describe "#most_accurate_team" do
        it "#most_accurate_team" do
            expect(@stat_tracker.most_accurate_team("20132014")).to eq "Real Salt Lake"
            expect(@stat_tracker.most_accurate_team("20142015")).to eq "Toronto FC"
        end
    end

    describe "#least_accurate_team" do
        it "#least_accurate_team" do
            expect(@stat_tracker.least_accurate_team("20132014")).to eq "New York City FC"
            expect(@stat_tracker.least_accurate_team("20142015")).to eq "Columbus Crew SC"
        end
    end

    describe "#most_tackles" do
        it 'returns the team with the most tackles' do
            expect(@stat_tracker.most_tackles("20132014")).to eq "FC Cincinnati"
            expect(@stat_tracker.most_tackles("20142015")).to eq "Seattle Sounders FC"
        end
    end

    describe "#fewest_tackles" do
        it 'returns the team with the least tackles' do
            expect(@stat_tracker.fewest_tackles("20132014")).to eq "Atlanta United"
            expect(@stat_tracker.fewest_tackles("20142015")).to eq "Orlando City SC"
        end
    end

  
    
    ###### Helper Method Tests ########

    describe "coach_wins_in_season" do
        it "returns number of wins for a coach in a season" do
            season_games = @stat_tracker.games_by_season("20132014")
            coach_wins = Hash.new(0)
            total_coach_game = Hash.new(0)
            expect(@stat_tracker.coach_wins_in_season(season_games, coach_wins, total_coach_game)).to be_an(Array)
            expect(@stat_tracker.coach_wins_in_season(season_games, coach_wins, total_coach_game).size).to eq(1323)
            expect(@stat_tracker.coach_wins_in_season(season_games, coach_wins, total_coach_game).sample).to be_a(String)
            expect(@stat_tracker.coach_wins_in_season(season_games, coach_wins, total_coach_game).sample.length).to eq(10)
        end
    end

    describe "coach_win_percentage_calculator" do
        it "calculates the win percentage a coach has and puts the in an array" do
            season_games = @stat_tracker.games_by_season("20132014")
            coach_wins = Hash.new(0)
            total_coach_game = Hash.new(0)
            @stat_tracker.coach_wins_in_season(season_games, coach_wins, total_coach_game)
            expect(@stat_tracker.coach_win_percentage_calculator(coach_wins, total_coach_game)).to be_a(Hash)
            expect(@stat_tracker.coach_win_percentage_calculator(coach_wins, total_coach_game).size).to eq(34)
            expect(@stat_tracker.coach_win_percentage_calculator(coach_wins, total_coach_game).keys.sample).to be_a(String)
            expect(@stat_tracker.coach_win_percentage_calculator(coach_wins, total_coach_game).values.sample).to be_a(Float)
        end
    end

    describe '#find_team_with_most_tackles' do
        it 'returns the team_id of the team with the most tackles' do
            season_id = '20122013'
            tackles_by_team = @stat_tracker.calculate_tackles(season_id)
            team_with_most_tackles = @stat_tracker.find_team_with_most_tackles(tackles_by_team)

            expect(team_with_most_tackles).to be_a(String)
            expect(tackles_by_team[team_with_most_tackles]).to eq tackles_by_team.values.max
        end
    end

    describe '#find_team_with_fewest_tackles' do
        it 'returns the team_id of the team with the fewest tackles' do
            season_id = '20122013'
            tackles_by_team = @stat_tracker.calculate_tackles(season_id)
            team_with_fewest_tackles = @stat_tracker.find_team_with_fewest_tackles(tackles_by_team)

            expect(team_with_fewest_tackles).to be_a(String)
            expect(tackles_by_team[team_with_fewest_tackles]).to eq tackles_by_team.values.min
        end
    end

    describe '#team_name_from_id' do
        it 'returns the team name corresponding to a given team_id' do
            team_id = '1'
            team_name = @stat_tracker.team_name_from_id(team_id)
        
            expect(team_name).to be_a(String)
            expect(team_name).to eq('Atlanta United')  # Check against the expected name directly
        end
    end

    describe '#calculate_tackles' do
        it 'calculates the total tackles for each team in a given season' do
        season_id = '20122013'
        tackles_by_team = @stat_tracker.calculate_tackles(season_id)

            expect(tackles_by_team).to be_a(Hash)
            tackles_by_team.keys.each do |key|
                expect(key).to be_a(String)
            end
            
            tackles_by_team.values.each do |value|
                expect(value).to be_a(Integer)
            end
        end
    end

    describe "#games_by_season" do
        it 'returns an array of game ids based on a season id' do
            season = "20132014"
            expect(@stat_tracker.games_by_season(season)).to be_a(Array)
            expect(@stat_tracker.games_by_season(season)).to_not be_empty
            expect(@stat_tracker.games_by_season(season)).to be_all(String)
        end
    end 

    describe "#team_season_shot_goals" do
        it 'returns a hash of each teams total shots and goals for a given season' do
            season_games = ["2013030161", "2013030162", "2013030163", "2013030164", "2013030165", "2013030166", "2013030151", "2013030152", "2013030153", "2013030154"]
            expect(@stat_tracker.team_season_shot_goals(season_games)).to eq({"16"=>[16, 44], "19"=>[10, 52], "30"=>[7, 35], "21"=>[6, 22]})
        end
    end

    describe "#team_ratios" do
        it 'calculates shot to goal ratios per team' do
            team_shot_goal_count = {"16"=>[16, 44], "19"=>[10, 52], "30"=>[7, 35], "21"=>[6, 22]}
            expect(@stat_tracker.team_ratios(team_shot_goal_count)).to eq({"16"=>0.36363636363636365, "19"=>0.19230769230769232, "30"=>0.2, "21"=>0.2727272727272727})
        end
    end

    describe "#best_ratio" do
        it 'sorts team shot goals ratios by max value and returns the team_id with the best ratio' do
            team_ratios = {"16"=>0.36363636363636365, "19"=>0.19230769230769232, "30"=>0.2, "21"=>0.2727272727272727}
            expect(@stat_tracker.best_ratio(team_ratios)).to eq("16")
        end
    end

    describe "#worst_ratio" do
        it 'sorts team shot goals ratios by min value and returns the team_id with the worst ratio' do
            team_ratios = {"16"=>0.36363636363636365, "19"=>0.19230769230769232, "30"=>0.2, "21"=>0.2727272727272727}
            expect(@stat_tracker.worst_ratio(team_ratios)).to eq("19")
        end
    end

 
end