# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::DogWalkingController do
  before { Timecop.freeze(Time.now.to_date) }
  after { Timecop.return }

  describe 'GET index' do
    context 'when retrieving the scheduled ones' do
      it 'returns a 200 http status code' do
        get :index, params: { only_scheduleds: true }

        expect(response).to have_http_status(200)
      end

      it 'returns the body' do
        create(:dog_walking, scheduled_at: Time.now.yesterday)
        dog_walking = create(:dog_walking, scheduled_at: Time.now.tomorrow)

        get :index, params: { only_scheduleds: true }

        json = JSON.parse(response.body)

        body = {
          'data' => [
            {
              'id' => dog_walking.id.to_s,
              'type' => 'dog_walking',
              'attributes' => {
                'status' => 'scheduled',
                'scheduled_at' => '2018-11-21T00:00:00.000Z',
                'price_value' => '10.0',
                'scheduled_duration' => 0,
                'latitude' => nil,
                'longitude' => nil,
                'started_at' => nil,
                'ended_at' => nil
              }
            }
          ]
        }
        expect(json).to match(body)
      end
    end

    context 'when retrieving all dogwalkings' do
      it 'returns a 200 http status code' do
        get :index

        expect(response).to have_http_status(200)
      end

      it 'returns the body' do
        dog_walking = create(:dog_walking, scheduled_at: Time.now.tomorrow)

        get :index

        json = JSON.parse(response.body)

        body = {
          'data' => [
            {
              'id' => dog_walking.id.to_s,
              'type' => 'dog_walking',
              'attributes' => {
                'status' => 'scheduled',
                'scheduled_at' => '2018-11-21T00:00:00.000Z',
                'price_value' => '10.0',
                'scheduled_duration' => 0,
                'latitude' => nil,
                'longitude' => nil,
                'started_at' => nil,
                'ended_at' => nil
              }
            }
          ]
        }
        expect(json).to match(body)
      end
    end
  end
end
