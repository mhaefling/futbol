require './spec/spec_helper'

RSpec.describe Game do
  before(:each) do
    @game = Game.new(2012030221, 20122013, 3, 6, 2, 3)
  end

  describe "#initialize" do
    it 'exists' do
      expect(@game).to be_a(Game)
    end

    it 'has a game_id' do
      expect(@game.game_id).to eq(2012030221)
    end

    it 'has a season' do
      expect(@game.season).to eq(20122013)
    end

    it 'has a away_team id' do
      expect(@game.away_team).to eq(3)
    end

    it 'has a home_team id' do
      expect(@game.home_team).to eq(6)
    end

    it 'has a aways_goals' do
      expect(@game.away_goals).to eq(2)
    end

    it 'has a home_goals' do
      expect(@game.home_goals).to eq(3)
    end
  end
 end