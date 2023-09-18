require "rails_helper"

RSpec.configure do |c|
  c.include Helpers::InvitationHelper
end

RSpec.describe Invitation do
  describe "callbacks" do
    describe "after_save" do
      context "with valid data" do
        it "invites the user" do
          new_user = create(:user)
          invitation_for_new_user = build(:invitation, user: new_user, team: new_user.team)

          invitation_for_new_user.save

          expect(new_user).to be_invited
        end
      end

      context "with invalid data" do
        it "does not save the invitation" do
          invalid_invitation = build(:invitation, team: nil)

          invalid_invitation.save

          expect(invalid_invitation).not_to be_valid
          expect(invalid_invitation).to be_new_record
        end

        it "does not mark the user as invited" do
          new_user = create(:user)
          invalid_invitation_for_new_user = build(:invitation, user: new_user, team: nil)

          invalid_invitation_for_new_user.save

          expect(new_user).not_to be_invited
        end
      end
    end
  end

  describe "#event_log_statement" do
    context "when the record is saved" do
      it "includes the name of the team" do
        invitation = build_invitation_with(team_name: "A fine team")

        log_statement = invitation.event_log_statement

        expect(log_statement).to include("A fine team")
      end

      it "includes the email of the invitee" do
        invitation = build_invitation_with(user_email: "rookie@example.com")

        log_statement = invitation.event_log_statement

        expect(log_statement).to include("rookie@example.com")
      end
    end

    context "when the record is not saved but valid" do
      it "includes the name of the team" do
        invitation = build_invitation_with(team_name: "A fine team")

        log_statement = invitation.event_log_statement

        expect(log_statement).to include("A fine team")
      end

      it "includes the email of the invitee" do
        invitation = build_invitation_with(user_email: "rookie@example.com")

        log_statement = invitation.event_log_statement

        expect(log_statement).to include("rookie@example.com")
      end

      it "includes the word 'PENDING'" do
        invitation = build(:invitation)

        log_statement = invitation.event_log_statement

        expect(log_statement).to include("PENDING")
      end
    end

    context "when the record is not saved and not valid" do
      it "includes INVALID" do
        invalid_invitation = build(:invitation, user: nil)

        log_statement = invalid_invitation.event_log_statement

        expect(log_statement).to include("INVALID")
      end
    end
  end
end
