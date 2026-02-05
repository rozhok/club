class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy, inverse_of: :post
  has_rich_text :content
  has_one_attached :og_image_blob

  validates :title, presence: true
  validates :content, presence: true

  # rubocop:disable Style/WordArray
  POST_TYPES = [["Пост", "post"], ["Посилання", "link"], ["Проєкт", "project"], ["Запитання", "question"], ["Путівник", "guide"]].freeze
  # rubocop:enable Style/WordArray

  def replies
    post_comments = comments.includes(user: { avatar_attachment: :blob }).order(:id).with_rich_text_content_and_embeds
    parent_to_children = {}
    post_comments.each do |comment|
      if comment.parent_id.present?
        parent_to_children[comment.parent_id] ||= []
        parent_to_children[comment.parent_id] << comment
      end
    end

    sorted_comments = []
    post_comments.each do |comment|
      if comment.parent_id.nil?
        sorted_comments << comment
        add_children(comment, parent_to_children, sorted_comments)
      end
    end
    sorted_comments
  end

  def add_children(comment, parent_to_children, result)
    child_comments = parent_to_children[comment.id]
    if child_comments.present?
      child_comments.each do |child|
        result << child
        add_children(child, parent_to_children, result)
      end
    end
  end

  def comments_count_text
    if comments_count.zero?
      "Немає коментарів"
    elsif comments_count == 1
      "1 коментар"
    elsif comments_count <= 4
      "#{comments_count} коментарі"
    else
      "#{comments_count} коментарів"
    end
  end

  def approve
    update(state: :approved)
    if intro? && user.newcomer?
      user.approve
    end
  end

  def reject
    update(state: :rejected)
  end

  def intro?
    post_type == "intro"
  end

  def draft?
    state == "draft"
  end

  def rejected?
    state == "rejected"
  end

  def pending?
    state == "pending"
  end

  def publish_or_send_to_review
    # if post was rejected, send it to review
    # if post was in draft, send it to review
    if rejected? || draft?
      update(state: "pending")
    end
    # do nothing if post was already approved
  end

  def full_title
    title_with_type
  end

  def title_with_type
    case post_type
    when "project"
      "Проєкт: #{title}"
    when "link"
      "🔗 #{title}"
    when "question"
      "Запитання: #{title}"
    when "guide"
      "Путівник: #{title}"
    else
      title
    end
  end

  def generate_og_image
    image = Vips::Image.new_from_file("app/assets/images/og-template.jpg")

    text = Vips::Image.text("<span foreground='white'>#{title_with_type}</span>",
                            width: 1100,
                            font: "Arial Bold 52",
                            align: :centre,
                            dpi: 150,
                            rgba: true)

    output = image.composite(text, :over, x: 100, y: 100)
    buffer = output.write_to_buffer(".jpg")
    og_image_blob.attach(io: StringIO.new(buffer), filename: "#{SecureRandom.uuid}.jpg", content_type: "image/jpeg")

    image_url = "https://#{ENV.fetch("CDN_URL")}/#{og_image_blob.key}"
    update(og_image: image_url)
  end

  def og_description
    plain_text = content.to_plain_text.strip

    max_length = 155

    if plain_text.length <= max_length
      return plain_text
    end

    truncated = plain_text[0...(max_length - 3)]
    last_space_idx = truncated.rindex(" ")

    if last_space_idx && last_space_idx > max_length * 0.8
      "#{truncated[0...last_space_idx]}..."
    else
      "#{truncated}..."
    end
  end
end
