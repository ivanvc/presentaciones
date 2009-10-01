class FrutiLupi
  include DataMapper::Resource

  property :id, Serial
  property :nombre, String
  property :tamano, Integer
  property :color, String
  property :created_at, DateTime, :nullable => false
  property :updated_at, DateTime, :nullable => false

  before :save, :update_timestamps
  before :update, :update_timestamps
  
  def to_param
    "#{id}"
  end
  
  private
    def update_timestamps
      self.created_at = Time.now.utc if new_record?
      self.updated_at = Time.now.utc
    end
end
