require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:user) { create(:user) }

  describe '#estimated_time_hhmm' do
    it '60分なら "01:00" を返す' do
      task = build(:task, estimated_time: 60)
      expect(task.estimated_time_hhmm).to eq("01:00")
    end

    it '5分なら "00:05" を返す' do
      task = build(:task, estimated_time: 5)
      expect(task.estimated_time_hhmm).to eq("00:05")
    end

    it 'nil なら nil を返す' do
      task = build(:task, estimated_time: nil)
      expect(task.estimated_time_hhmm).to be_nil
    end
  end

  describe '#actual_time_hhmm' do
    it '120分なら "02:00" を返す' do
      task = build(:task, actual_time: 120)
      expect(task.actual_time_hhmm).to eq("02:00")
    end
  end
end
