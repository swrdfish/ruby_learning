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

        render json: { status: "SUCCESS", message: "#{count} keys generated"}
    end

    def getRandom
        if KeyStoreHelper::AVAILABLE_KEYS.length() <= 0
            render json: { status: "ERROR", message: "No keys available"}, status: 404
        else
            randomKey = KeyStoreHelper::AVAILABLE_KEYS.getRandom
            KeyStoreHelper::BLOCKED_KEYS.add(randomKey[:key], randomKey[:createdAt])
            KeyStoreHelper::AVAILABLE_KEYS.remove(randomKey[:key])

            render json: { status: "SUCCESS", key: randomKey[:key], createdAt: randomKey[:createdAt]}
        end
    end
end
