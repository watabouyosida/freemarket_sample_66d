require 'rails_helper'

describe User do
  describe '#create' do
    # 1. nicknameとemail、passwordとpassword_confirmationが存在すれば登録できること
    it "is valid with a nickname, email, password, password_confirmation" do
      user = build(:user)
      expect(user).to be_valid
    end

    # 2. nicknameが空では登録できないこと
    it "is invalid without a nickname" do
      user = build(:user, nickname: nil)
      user.valid?
      expect(user.errors[:nickname]).to include("can't be blank")
    end

    # 3. emailが空では登録できないこと
    it "is invalid without a email" do
      user = build(:user, email: nil)
      user.valid?
      expect(user.errors[:email]).to include("can't be blank")
    end

    # 4. passwordが空では登録できないこと
    it "is invalid without a password" do
      user = build(:user, password: nil)
      user.valid?
      expect(user.errors[:password]).to include("can't be blank")
    end

    # 5. passwordが存在してもpassword_confirmationが空では登録できないこと
    it "is invalid without a password_confirmation although with a password" do
      user = build(:user, password_confirmation: "")
      user.valid?
      expect(user.errors[:password_confirmation]).to include("doesn't match Password")
    end

    # 6. nicknameが10文字以上であれば登録できないこと
    it "is invalid with a nickname that has more than 10 characters " do
      user = build(:user, nickname: "aaaaaaaaaaa")
      user.valid?
      expect(user.errors[:nickname]).to include("is too long (maximum is 10 characters)")
    end

    # 7. nicknameが10文字以下では登録できること
    it "is valid with a nickname that has less than 6 characters " do
      user = build(:user, nickname: "aaaaaaaaaa")
      expect(user).to be_valid
    end

    # 8. 重複したemailが存在する場合登録できないこと
    it "is invalid with a duplicate email address" do
      user = create(:user)
      another_user = build(:user, email: user.email)
      another_user.valid?
      expect(another_user.errors[:email]).to include("has already been taken")
    end

    # 9. passwordが7文字以上で英数字が最低1文字ずつあれば登録できること
    it "is valid with a password that has more than 7 characters " do
      user = build(:user, password: "123456a", password_confirmation: "123456a")
      user.valid?
      expect(user).to be_valid
    end

    # 10. passwordが6文字以下であれば登録できないこと
    it "is invalid with a password that has less than 6 characters " do
      user = build(:user, password: "12345a", password_confirmation: "12345a")
      user.valid?
      expect(user.errors[:password]).to include("is too short (minimum is 7 characters)")
    end
    
    # 11. passwordが7文字以上で数字のみの場合登録できないこと
    it "is invalid with a password that has more than 7 characters without englich letter" do
      user = build(:user, password: "1234567", password_confirmation: "1234567")
      user.valid?
      expect(user.errors[:password]).to include("is invalid")
    end
    
    # 12. passwordが7文字以上で数字のみの場合登録できないこと
    it "is invalid with a password that has more than 7 characters without number" do
      user = build(:user, password: "abcdefg", password_confirmation: "abcdefg")
      user.valid?
      expect(user.errors[:password]).to include("is invalid")
    end
  end
end