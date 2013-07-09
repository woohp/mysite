require "test_helper"

describe Todo do
  it "must be valid" do
    todo = create(:todo)
    todo.valid?.must_equal true
    todo.user.valid?.must_equal true
  end

  it 'fails when neither title nor description is present' do
    todo = build(:todo, title: nil, description: nil)
    todo.valid?.must_equal false
  end

  it 'is valid when title or description (but not both) is missing' do
    todo = build(:todo, title: nil)
    todo.valid?.must_equal true
    todo = build(:todo, description: nil)
    todo.valid?.must_equal true
  end

  it 'can build from an existing user' do
    user = create(:user)
    user.todos.must_be_empty

    todo = user.todos.create(title: 'foo')
    todo.valid?.must_equal true
    todo.user.must_equal user
  end
end
