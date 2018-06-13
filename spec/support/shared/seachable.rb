shared_examples_for 'searchable' do
  it 'should respond to #search' do
    expect(subject.class).to respond_to(:search)
  end
end
