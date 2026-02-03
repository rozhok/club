class GeneratePostOgImageJob < ApplicationJob
  queue_as :default

  def perform(post_id)
    Post.find(post_id).generate_og_image
  end
end
