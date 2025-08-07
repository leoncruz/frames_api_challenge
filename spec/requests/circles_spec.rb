require 'swagger_helper'

RSpec.describe 'Circles API', type: :request do
  path '/circles' do
    get 'List circles filtered by optional radius and center' do
      tags 'Circles'
      produces 'application/json'
      parameter name: :frame_id, in: :query, type: :string, description: 'Frame ID'
      parameter name: :center_x, in: :query, type: :number, format: :float, description: 'X center of search'
      parameter name: :center_y, in: :query, type: :number, format: :float, description: 'Y center of search'
      parameter name: :radius, in: :query, type: :number, format: :float, description: 'Search radius'

      response '200', 'circles listed' do
        schema type: :object,
               properties: {
                 circles: {
                   type: :array,
                   items: {
                     type: :object,
                     properties: {
                       id: { type: :integer },
                       center_x: { type: :number },
                       center_y: { type: :number },
                       diameter: { type: :number },
                       frame_id: { type: :integer }
                     },
                     required: %w[id center_x center_y diameter frame_id]
                   }
                 }
               }

        let!(:frame) { Frame.create!(center_x: 10, center_y: 10, width: 100, height: 100) }
        let!(:circle) { frame.circles.create!(center_x: 12, center_y: 12, diameter: 5) }

        let(:frame_id) { frame.id }
        let(:center_x) { 10 }
        let(:center_y) { 10 }
        let(:radius)   { 10 }

        run_test!
      end
    end
  end

  path '/frames/{frame_id}/circles' do
    post 'Create a circle in the given frame' do
      tags 'Circles'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :frame_id, in: :path, type: :integer
      parameter name: :circle, in: :body, schema: {
        type: :object,
        properties: {
          circle: {
            type: :object,
            properties: {
              center_x: { type: :number },
              center_y: { type: :number },
              diameter: { type: :number }
            },
            required: %w[center_x center_y diameter]
          }
        }
      }

      response '201', 'circle created' do
        let!(:frame_id) { Frame.create!(center_x: 10, center_y: 10, width: 100, height: 100).id }
        let(:circle) do
          {
            circle: {
              center_x: 12,
              center_y: 15,
              diameter: 10
            }
          }
        end

        run_test!
      end

      response '422', 'invalid parameters' do
        let!(:frame_id) { Frame.create!(center_x: 10, center_y: 10, width: 100, height: 100).id }
        let(:circle) do
          {
            circle: {
              center_x: nil,
              center_y: 15,
              diameter: 10
            }
          }
        end

        run_test!
      end
    end
  end

  path '/circles/{id}' do
    patch 'Update a circle' do
      tags 'Circles'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer
      parameter name: :circle, in: :body, schema: {
        type: :object,
        properties: {
          circle: {
            type: :object,
            properties: {
              center_x: { type: :number },
              center_y: { type: :number },
              diameter: { type: :number }
            }
          }
        }
      }

      response '200', 'circle updated' do
        let!(:circle_record) do
          Frame.create!(center_x: 10, center_y: 10, width: 100, height: 100)
               .circles.create!(center_x: 12, center_y: 15, diameter: 10)
        end

        let(:id) { circle_record.id }
        let(:circle) do
          {
            circle: {
              center_x: 20
            }
          }
        end

        run_test!
      end

      response '422', 'invalid update' do
        let!(:circle_record) do
          Frame.create!(center_x: 10, center_y: 10, width: 100, height: 100)
               .circles.create!(center_x: 12, center_y: 15, diameter: 10)
        end

        let(:id) { circle_record.id }
        let(:circle) do
          {
            circle: {
              diameter: nil
            }
          }
        end

        run_test!
      end
    end

    delete 'Delete a circle' do
      tags 'Circles'
      parameter name: :id, in: :path, type: :integer

      response '204', 'circle deleted' do
        let!(:circle_record) do
          Frame.create!(center_x: 10, center_y: 10, width: 100, height: 100)
               .circles.create!(center_x: 12, center_y: 15, diameter: 10)
        end
        let(:id) { circle_record.id }

        run_test!
      end

      response '404', 'circle not found or could not be deleted' do
        let(:id) { -1 }
        run_test!
      end
    end
  end
end
