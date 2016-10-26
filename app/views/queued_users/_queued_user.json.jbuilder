json.extract! queued_user, :id, :name, :number, :confirmed, :confirm_token, :created_at, :updated_at
json.url queued_user_url(queued_user, format: :json)