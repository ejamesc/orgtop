class User
  include DataMapper::Resource

  property :id,         Serial
  property :name,       String  
  property :email,      String
  property :username,   String
  property :role,       String
  property :created_at, DateTime
  property :updated_at, DateTime

  validates_presence_of :name, :username
  validates_uniqueness_of :username

  has n, :responses
end
