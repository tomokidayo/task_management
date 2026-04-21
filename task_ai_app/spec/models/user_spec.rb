require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーション' do
    let(:user) { build(:user) }

    context '正常系' do
      it '名前・メール・パスワードがあれば有効' do
        expect(user).to be_valid
      end
    end

    context '異常系' do
      it '名前が空だと無効' do
        user.name = ''
        expect(user).to be_invalid
        expect(user.errors[:name]).to include('ユーザー名を入力してください')
      end

      it 'メールが空だと無効' do
        user.email = ''
        expect(user).to be_invalid
        expect(user.errors[:email]).to include('メールアドレスを入力してください')
      end

      it 'メールが重複していると無効' do
        create(:user, email: 'test@example.com')
        user.email = 'test@example.com'
        expect(user).to be_invalid
        expect(user.errors[:email]).to include('このメールアドレスは既に使用されています')
      end

      it 'パスワードが6文字未満だと無効' do
        user.password = '12345'
        expect(user).to be_invalid
        expect(user.errors[:password]).to include('パスワードは6文字以上で入力してください')
      end
    end
  end
end
