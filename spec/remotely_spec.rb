require "spec_helper"

describe Remotely do
  before do
    Remotely.reset!
  end

  it "is configurable" do
    Remotely.configure { app :configapp, "localhost:2222" }
    Remotely.apps.should include(:configapp)
  end

  it "configures basic auth parameters" do
    Remotely.configure { basic_auth "user", "password" }
    Remotely.basic_auth.should == ["user", "password"]
  end
  
  it "configures default request parameters" do
    Remotely.configure { default_params({"a" => "b"}) }
    Remotely.default_params.should == {"a" => "b"}
  end

  it "is resetable" do
    Remotely.configure { app :configapp, "localhost:2222" }
    Remotely.reset!
    Remotely.apps.should be_empty
  end
end
