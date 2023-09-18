module Helpers
  module InvitationHelper
    def build_invitation_with(team_name: nil, user_email: nil)
      invitation = build(:invitation)

      invitation.team = build(:team, name: team_name) if team_name
      invitation.user = build(:user, email: user_email) if user_email

      invitation
    end
  end
end
