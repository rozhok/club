require "test_helper"

class UserMailerTest < ActionMailer::TestCase
  setup do
    @user = users(:lazaro_nixon)
  end

  test "password_reset" do
    mail = UserMailer.with(user: @user).password_reset
    assert_equal "Reset your password", mail.subject
    assert_equal [@user.email], mail.to
  end
end
