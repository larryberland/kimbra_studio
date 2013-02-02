class StudioHelper
  def initialize
    @studio = create(:studio, :with_session)
    @studio.should be_persisted
    self
  end
end