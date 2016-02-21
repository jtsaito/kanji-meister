class Spa

  def self.client
    @client ||= Aws::DynamoDB::Client.new(
      region: SinglePageAssetConfig.dynamo_table_region,
    )
  end

  def css
    url_string(:css)
  end

  def js
    url_string(:js)
  end

  private

  def client
    self.class.client
  end

  def url_string(css_or_js)
    @url ||= [
       "https://s3.#{SinglePageAssetConfig.s3_bucket_region}.amazonaws.com",
       SinglePageAssetConfig.s3_bucket_name,
       assets[css_or_js]
    ].join('/')
  end

  def assets
    @assets ||= client.query(query_arguments).items
                                             .first
                                             .with_indifferent_access
  end

  def query_arguments
    {
      table_name: SinglePageAssetConfig.dynamo_table_name,
      limit: 1,
      scan_index_forward: false,
      key_conditions: {
        "deployed" => {
           attribute_value_list: ["true"],
           comparison_operator: "EQ"
        }
      }
    }
  end

end
