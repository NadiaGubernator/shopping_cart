require 'rails_helper'

RSpec.describe ApiController, type: :controller do
  describe '#grab' do
    context 'no table param passed' do
      it 'returns no object error' do
        expected_response = { message: ApiController::NO_OBJECT, value: [] }

        get :grab

        expect(response.body).to eq(expected_response.to_json)
      end
    end

    context 'no verb param passed' do
      it 'returns no object error' do
        expected_response = { message: ApiController::NO_VERB, value: [] }

        get :grab, params: { table: 'products' }

        expect(response.body).to eq(expected_response.to_json)
      end
    end

    context 'no class was found' do
      it 'returns no class error' do
        expected_response = { message: ApiController::NO_CLASS, value: [] }

        get :grab, params: { table: 'article', verb: 'count' }

        expect(response.body).to eq(expected_response.to_json)
      end
    end

    context 'incorrect method' do
      it 'returns unknown error' do
        expected_response = { message: ApiController::UNKNOWN, value: [] }

        get :grab, params: { table: 'product', verb: 'wrong' }

        expect(response.body).to eq(expected_response.to_json)
      end
    end

    context 'errors during method execution' do
      it 'returns list of errors' do
        object = Product.create
        expected_response = { message: ApiController::ERRORS, value: object.errors.full_messages }

        get :grab, params: { table: 'product', verb: 'create' }

        expect(response.body).to eq(expected_response.to_json)
      end
    end

    describe 'success' do
      before do
        (1..3).each do |num|
          Product.create(title: "long long title#{num}", description: 'description', image_url: "image#{num}.jpg", price: 100)
        end
      end

      context 'number param is passed' do
        it 'returns correct number of last objects' do
          expected_response = { message: ApiController::SUCCESS, value: Product.last(2) }

          get :grab, params: { table: 'product', verb: 'find', number: '2' }

          expect(response.body).to eq(expected_response.to_json)
        end
      end

      context 'date param is passed' do
        it 'returns objects created after set date' do
          Product.last.update(created_at: (Time.now - 2.days))

          expected_response = { message: ApiController::SUCCESS, value: { scope: Product.where(created_at: Time.now - 1.day..Time.now) } }

          get :grab, params: { table: 'product', verb: 'where', date: Time.now - 1.day }

          expect(response.body).to eq(expected_response.to_json)
        end
      end

      context 'date param, verb :count' do
        it 'returns number of objects created after set date' do
          Product.last.update(created_at: (Time.now - 2.days))

          expected_response = { message: ApiController::SUCCESS, value: 2 }

          get :grab, params: { table: 'product', verb: 'count', date: Time.now - 1.day }

          expect(response.body).to eq(expected_response.to_json)
        end
      end

      context 'no params, verb :all' do
        it 'returns all objects of requested model' do
          expected_response = { message: ApiController::SUCCESS, value: Product.all }

          get :grab, params: { table: 'product', verb: 'all' }

          expect(response.body).to eq(expected_response.to_json)
        end
      end

      context 'no params, verb :count' do
        it 'returns number of objects of requested model' do
          expected_response = { message: ApiController::SUCCESS, value: Product.all.count }

          get :grab, params: { table: 'product', verb: 'count' }

          expect(response.body).to eq(expected_response.to_json)
        end
      end

      context 'date param, number param' do
        it 'returns correct number of objects created after set date' do
          expected_response = { message: ApiController::SUCCESS, value: [Product.last] }

          get :grab, params: { table: 'product', verb: 'where', date: Time.now - 1.day, number: 1 }

          expect(response.body).to eq(expected_response.to_json)
        end
      end

      context 'verb :create' do
        it 'creates new object of requested model' do
          expect{
                  get :grab,
                  params: {
                            table:      'product',
                            verb:       'create',
                            parameters: {
                                          title:       'Title for totally new book',
                                          description: 'Description',
                                          image_url:   'new_image.jpg',
                                          price:       100500
                                        }
                          }
                }.to change(Product, :count).by(1)
        end
      end

      context 'verb :update' do
        it 'updates object' do
          new_title = 'Title without typos'

          get :grab,
            params: {
                      table:      'product',
                      verb:       'update',
                      id:         Product.last.id,
                      parameters: { title: new_title }
                    }

          expect(Product.last.title).to eq(new_title)
        end
      end

      context 'verb :destroy' do
        it 'destroys object' do
          expect{
                  get :grab,
                  params: {
                            table: 'product',
                            verb:  'destroy',
                            id:    Product.last.id
                          }
                }.to change(Product, :count).by(-1)
        end
      end
    end
  end
end
