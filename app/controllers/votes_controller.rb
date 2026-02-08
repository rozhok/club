class VotesController < ApplicationController
  def create
    authorize! :create, Vote
    @votable = Current.user.cast_vote(params[:votable_id])
  rescue ActiveRecord::RecordNotUnique
    head :unprocessable_content
  end

  def destroy
    authorize! :destroy, Vote
    @votable = Current.user.retract_vote(votable_id: params[:votable_id], votable_type: params[:votable_type])
  end
end
