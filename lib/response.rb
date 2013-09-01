class Response
  include DataMapper::Resource

  property :id,         Serial
  property :content,    Text  
  property :created_at, DateTime
  property :updated_at, DateTime

  belongs_to :user

  validates_presence_of :content
end
