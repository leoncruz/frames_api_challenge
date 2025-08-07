require 'swagger_helper'

RSpec.describe 'Frames API', type: :request do
  path '/api/v1/frames' do
    post 'Create a Frame' do
      tags 'Frames'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :frame, in: :body, schema: {
        type: :object,
        properties: {
          frame: {
            type: :object,
            required: %w[center_x center_y width height],
            properties: {
              center_x: { type: :number },
              center_y: { type: :number },
              width: { type: :number },
              height: { type: :number },
              circles_attributes: {
                type: :array,
                items: {
                  type: :object,
                  required: %w[center_x center_y diameter],
                  properties: {
                    center_x: { type: :number },
                    center_y: { type: :number },
                    diameter: { type: :number }
                  }
                }
              }
            }
          }
        },
        required: [ 'frame' ]
      }

      response '201', 'frame created' do
        let(:frame) do
          {
            frame: {
              center_x: 100,
              center_y: 100,
              width: 200,
              height: 200,
              circles_attributes: [
                { center_x: 120, center_y: 120, diameter: 30 },
                { center_x: 160, center_y: 140, diameter: 20 }
              ]
            }
          }
        end

        run_test!
      end

      response '422', 'invalid frame' do
        let(:frame) do
          {
            frame: {
              center_x: nil,
              center_y: nil,
              width: nil,
              height: nil,
              circles_attributes: [
                { center_x: nil, center_y: nil, diameter: nil }
              ]
            }
          }
        end

        run_test!
      end
    end
  end

  path '/api/v1/frames/{id}' do
    get 'Show a Frame' do
      tags 'Frames'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string

      response '200', 'frame found' do
        let(:frame) { Frame.create(center_x: 100, center_y: 100, width: 200, height: 200) }
        let(:id) { frame.id }

        before do
          frame.circles.create(center_x: 90, center_y: 50, diameter: 20)
          frame.circles.create(center_x: 110, center_y: 150, diameter: 20)
        end

        run_test!
      end

      response '404', 'frame not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end

    delete 'Delete a Frame' do
      tags 'Frames'
      parameter name: :id, in: :path, type: :string

      response '204', 'frame deleted' do
        let(:id) { Frame.create(center_x: 100, center_y: 100, width: 200, height: 200).id }
        run_test!
      end

      response '422', 'cannot delete frame with circles' do
        let(:frame) { Frame.create(center_x: 100, center_y: 100, width: 200, height: 200) }
        let(:id) do
          frame.circles.create(center_x: 100, center_y: 100, diameter: 20)
          frame.id
        end

        run_test!
      end
    end
  end
end
