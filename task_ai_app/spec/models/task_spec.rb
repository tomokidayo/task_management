require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:user) { create(:user) }

  describe 'バリデーション' do
    let(:task) { build(:task, user: user) }

    context '正常系' do
      it 'タイトル・締切が正しければ有効' do
        task.title = 'テストタスク'
        task.deadline = 1.hour.from_now
        expect(task).to be_valid
      end
    end

    context '異常系' do
      it 'タイトルが空だと無効' do
        task.title = ''
        expect(task).to be_invalid
        expect(task.errors[:title]).to include('タイトルを入力してください')
      end

      it '締切が現在より前だと無効' do
        task.deadline = 1.hour.ago
        expect(task).to be_invalid
        expect(task.errors[:deadline]).to include('は現在より後の日時を設定してください')
      end

      it '締切が現在より後なら有効' do
        task.deadline = 1.hour.from_now
        expect(task).to be_valid
      end
    end
  end
end
