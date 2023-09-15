class KeyStoreController < ApplicationController
    def generate
        count = params[:count]
        if count == nil
            count = 10 #default to 10
        else
            count = count.to_i
        end

        count.times do
            key = SecureRandom.uuid
            timestamp = Time.now
            KeyStoreHelper::AVAILABLE_KEYS.add(key, timestamp)
        end

        render json: { status: "success", message: "#{count} keys generated"}
    end

end
