# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/v1/accounts', type: :request do
  path '/api/v1/accounts' do
    get('list accounts') do
      response(200, 'successful') do
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end
  end

  path '/api/v1/accounts/deposit' do
    post('deposit account') do
      consumes 'application/json'

      parameter name: 'user_id', in: :query, type: :integer, description: 'ID of user'
      parameter name: 'account_id', in: :query, type: :integer, description: 'ID of account'
      parameter name: 'amount', in: :query, type: :decimal, description: 'Amount to be debited'

      response(200, 'successful') do
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end
  end

  path '/api/v1/accounts/withdraw' do
    post('withdraw account') do
      response(200, 'successful') do
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end
  end
end
