require 'spec_helper'

describe 'devise/registrations/new.html.haml' do
  let(:user) do
    stub_model(User).as_new_record
  end
  
  before do
    assign(:user, user)
    # Devise provides resource and resource_name helpers and
    # mappings so stub them here.
    @view.stub(:resource).and_return(user)
    @view.stub(:resource_name).and_return('user')
    @view.stub(:devise_mapping).and_return(Devise.mappings[:user])
  end

  before(:each) do
    render
  end
  
  it "includes a User Name field in the form" do
    rendered.should have_selector('input', :id => 'user_user_name')
  end

end
