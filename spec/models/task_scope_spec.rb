require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:user) { create(:user) }

  describe '.search' do
    let!(:task1) { create(:task, title: "買い物に行く", description: "スーパーで野菜を買う", user: user) }
    let!(:task2) { create(:task, title: "勉強する", description: "Rails の復習", user: user) }

    it 'キーワードに一致するタイトルを持つタスクを返す' do
      expect(Task.search("買い物")).to include(task1)
      expect(Task.search("買い物")).not_to include(task2)
    end

    it 'キーワードに一致する説明を持つタスクを返す' do
      expect(Task.search("Rails")).to include(task2)
      expect(Task.search("Rails")).not_to include(task1)
    end

    it 'キーワードが空の場合は全件返す' do
      expect(Task.search("")).to match_array([ task1, task2 ])
    end
  end

  describe '.with_status' do
    let!(:task1) { create(:task, status: :not_started, user: user) }
    let!(:task2) { create(:task, status: :completed, user: user) }

    it '指定したステータスのタスクを返す' do
      expect(Task.with_status("not_started")).to include(task1)
      expect(Task.with_status("not_started")).not_to include(task2)
    end

    it 'ステータスが空の場合は全件返す' do
      expect(Task.with_status("")).to match_array([ task1, task2 ])
    end
  end

  describe '.with_priority' do
    let!(:task1) { create(:task, priority: :low, user: user) }
    let!(:task2) { create(:task, priority: :high, user: user) }

    it '指定した優先度のタスクを返す' do
      expect(Task.with_priority("low")).to include(task1)
      expect(Task.with_priority("low")).not_to include(task2)
    end

    it '優先度が空の場合は全件返す' do
      expect(Task.with_priority("")).to match_array([ task1, task2 ])
    end
  end
end
