require_relative "prelude"

class Post < Ohm::Model
  attribute :title
end

class Comment < Ohm::Model
  attribute :body

  reference :post, :Post
end

scope do
  setup do
    post = Post.create(title: "How to create an Identity Map in Ruby")

    Comment.create(post_id: post.id, body: "Great article!")
    Comment.create(post_id: post.id, body: "Not so great...")
  end

  test "Model#[] - identity map disabled" do
    assert Comment[1].object_id != Comment[1].object_id
  end

  test "Model#[] - identity map enabled" do
    comments = Ohm::Model.identity_map do
      [Comment[1], Comment[1]]
    end

    assert_equal 1, comments.map(&:object_id).uniq.size

    assert Comment[1].object_id != Comment[1].object_id
  end

  test "Model#fetch - identity map disabled" do
    comments = Comment.fetch([1, 2])

    assert_equal 2, comments.map(&:object_id).uniq.size
  end

  test "Model#fetch - identity map enabled" do
    comments = Ohm::Model.identity_map { Comment.fetch([1]) + Comment.fetch([1]) }

    assert_equal 1, comments.map(&:object_id).uniq.size

    comments = Ohm::Model.identity_map { Comment.fetch([1]) + Comment.fetch([2]) }

    assert_equal 2, comments.map(&:object_id).uniq.size

    comments = Ohm::Model.identity_map { Comment.fetch([1]) + Comment.fetch([1, 2]) }

    assert_equal 2, comments.map(&:object_id).uniq.size
  end

  test "Model#reference - identity map disabled" do
    assert Comment[1].post.object_id != Comment[2].post.object_id
  end

  test "Model#reference - identity map enabled" do
    posts = Ohm::Model.identity_map { [Comment[1].post, Comment[2].post] }

    assert_equal 1, posts.map(&:object_id).uniq.size

    orphan = Comment.create(body: "No post.")

    assert_equal nil, orphan.post
  end

  test "does not confuse models" do
    models = Ohm::Model.identity_map { [Comment[1], Post[1]] }

    assert_equal 2, models.map(&:object_id).uniq.size

    models = Ohm::Model.identity_map { Comment.fetch([1]) + Post.fetch([1]) }

    assert_equal 2, models.map(&:object_id).uniq.size
  end
end
