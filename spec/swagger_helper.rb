# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |config|
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's configured to serve Swagger from the same folder
  config.openapi_root = Rails.root.join('swagger').to_s

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:swaggerize' rake task, the complete Swagger will
  # be generated at the provided relative path under openapi_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a openapi_spec tag to the
  # the root example_group in your specs, e.g. describe '...', openapi_spec: 'v2/swagger.json'
  config.openapi_specs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'API V1',
        version: 'v1'
      },
      components: {
        securitySchemes: {
          bearerAuth: {
            type: :http,
            scheme: :bearer,
            bearerFormat: 'JWT'
          }
        },
        schemas: {
          StatusMessage: {
            type: :object,
            required: %w[code message],
            properties: {
              code: { type: :integer, example: 200 },
              message: { type: :string, example: 'Operation completed successfully.' }
            }
          },
          ErrorResponse: {
            type: :object,
            required: ['status'],
            properties: {
              status: { '$ref' => '#/components/schemas/StatusMessage' }
            }
          },
          UserAttributes: {
            type: :object,
            required: %w[id username email created_at],
            properties: {
              id: { type: :string, example: '1' },
              username: { type: :string, example: 'winston' },
              email: { type: :string, format: :email, example: 'winston@churp.app' },
              created_at: { type: :string, format: :'date-time' },
              created_date: { type: :string, example: '01/31/2025' }
            }
          },
          UserResponse: {
            type: :object,
            required: %w[status data],
            properties: {
              status: { '$ref' => '#/components/schemas/StatusMessage' },
              data: { '$ref' => '#/components/schemas/UserAttributes' }
            }
          },
          PaginationMeta: {
            type: :object,
            properties: {
              page: { type: :integer, example: 1 },
              items: { type: :integer, example: 15 },
              count: { type: :integer, example: 125 },
              pages: { type: :integer, example: 9 }
            }
          },
          ChurpAttributes: {
            type: :object,
            required: %w[body churp_type rechurp_count created_at updated_at],
            properties: {
              body: { type: :string, example: 'Building Churp v2.' },
              churp_type: { type: :string, example: 'churp' },
              rechurp_count: { type: :integer, example: 0 },
              churp_id: { type: :integer, nullable: true, example: nil },
              user_id: { type: :integer, example: 42 },
              created_at: { type: :string, format: :'date-time' },
              updated_at: { type: :string, format: :'date-time' }
            }
          },
          ChurpResource: {
            type: :object,
            required: %w[id type attributes],
            properties: {
              id: { type: :string, example: '1' },
              type: { type: :string, example: 'churp' },
              attributes: { '$ref' => '#/components/schemas/ChurpAttributes' }
            }
          },
          ChurpCollectionResponse: {
            type: :object,
            required: %w[data meta],
            properties: {
              data: {
                type: :array,
                items: { '$ref' => '#/components/schemas/ChurpResource' }
              },
              meta: { '$ref' => '#/components/schemas/PaginationMeta' }
            }
          },
          ChurpResponse: {
            type: :object,
            required: ['data'],
            properties: {
              data: { '$ref' => '#/components/schemas/ChurpResource' }
            }
          },
          ChurpMutationResponse: {
            type: :object,
            required: %w[status data],
            properties: {
              status: { '$ref' => '#/components/schemas/StatusMessage' },
              data: { '$ref' => '#/components/schemas/ChurpResource' }
            }
          },
          StatusOnlyResponse: {
            type: :object,
            required: ['status'],
            properties: {
              status: { '$ref' => '#/components/schemas/StatusMessage' }
            }
          },
          UserRegistrationPayload: {
            type: :object,
            required: ['user'],
            properties: {
              user: {
                type: :object,
                required: %w[email username password password_confirmation],
                properties: {
                  email: { type: :string, format: :email },
                  username: { type: :string },
                  password: { type: :string, format: :password },
                  password_confirmation: { type: :string, format: :password },
                  profile_attributes: {
                    type: :object,
                    properties: {
                      name: { type: :string }
                    }
                  }
                }
              }
            }
          },
          UserSignInPayload: {
            type: :object,
            required: ['user'],
            properties: {
              user: {
                type: :object,
                required: %w[email password],
                properties: {
                  email: { type: :string, format: :email },
                  password: { type: :string, format: :password }
                }
              }
            }
          },
          ChurpPayload: {
            type: :object,
            required: ['churp'],
            properties: {
              churp: {
                type: :object,
                required: ['body'],
                properties: {
                  body: { type: :string, description: 'The text contents of the churp.' },
                  churp_id: { type: :integer, nullable: true, description: 'Original churp id when rechurping.' },
                  churp_pic: { type: :string, description: 'Base64 string or Active Storage attachment reference.' }
                }
              }
            }
          }
        }
      },
      paths: {},
      servers: [
        {
          url: 'https://{defaultHost}',
          variables: {
            defaultHost: {
              default: 'www.example.com'
            }
          }
        }
      ]
    }
  }

  # Specify the format of the output Swagger file when running 'rswag:specs:swaggerize'.
  # The openapi_specs configuration option has the filename including format in
  # the key, this may want to be changed to avoid putting yaml in json files.
  # Defaults to json. Accepts ':json' and ':yaml'.
  config.openapi_format = :yaml
end
