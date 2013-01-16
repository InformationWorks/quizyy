#require 'openssl'
#require 'rack'

module Zaakpay  
  Key = ENV["GRE340_ZAAKPAY_KEY"]

  # This is where the checksum generation happens
  # arguements: a parameters hash.  
  # return value: HMAC-SHA-256 checksum usign the Key
  def self.generate_checksum(params_hash)
    
    paramsstring = ""
    params_hash.each {|key, value|
      paramsstring += "'" + value.to_s + "'"    
    }
    
    checksum = OpenSSL::HMAC.hexdigest('sha256', Zaakpay::Key, paramsstring)
  end
  
  # This is a helper method for generating Zaakpay checksum
  # It sorts the parameters hash in ascending order of the keys
  # arguments: a parameters hash
  # return value: a hash with sorted in ascending order of keys
  def self.sort_params(params_hash)
    sorted_params_hash = {}
    sorted_keys = params_hash.keys.sort{|x,y| x <=> y}
    sorted_keys.each do |k|
      sorted_params_hash[k] = params_hash[k]  
    end
    sorted_params_hash
  end
  
  # This is a helper method for removing extra params that
  # are not required by Zaakpay.
  # arguments: a parameters hash
  # return value: a hash with only required params.
  def self.remove_extra_params(params_hash)
    
    supported_params = [
                      "amount",
                      "buyerAddress",
                      "buyerCity",
                      "buyerCountry",
                      "buyerEmail",
                      "buyerFirstName",
                      "buyerLastName",
                      "buyerPhoneNumber",
                      "buyerPincode",
                      "buyerState",
                      "currency",
                      "merchantIdentifier",
                      "merchantIpAddress",
                      "mode",
                      "orderId",
                      "product1Description",
                      "product2Description",
                      "product3Description",
                      "product4Description",
                      "productDescription",
                      "purpose",
                      "returnUrl",
                      "shipToAddress",
                      "shipToCity",
                      "shipToCountry",
                      "shipToFirstname",
                      "shipToLastname",
                      "shipToPhoneNumber",
                      "shipToPincode",
                      "shipToState",
                      "showMobile",
                      "txnDate",
                      "txnType",
                      "zpPayOption"]
    
    filtered_params_hash = {}
    params_hash.each {|key, value|
      if supported_params.include? key.to_s
        filtered_params_hash[key] = params_hash[key]
      end
    }
    filtered_params_hash
  end

  #
  # This class is for wrappers around the Zaakpay request.
  #
  # Checksum is generated in the constructor, so
  #  once instantiated, object.checksum gives the value of the checksum
  #
  # Exposed attributes:
  #  params:     paramters hash, w/o the checksum
  #  all_params: paramters hash w/ the checksum
  #  checksum:   checksume generated for the params
  #
  class Request
    attr_reader :params, :all_params, :checksum
    
    def initialize(args_hash)
      @filtered_params = Zaakpay.remove_extra_params(args_hash)
      @sorted_params = Zaakpay.sort_params(@filtered_params)
      @checksum = Zaakpay.generate_checksum(@sorted_params)
      @all_params = {}.merge(@sorted_params).merge({'checksum' => @checksum })
    end

  end
  
  
  
  #
  # This class creates wrappers around the Zaakpay response
  #
  # Checksum validation takes place within the `valid?` method.
  #
  #  Exposed attributes:
  #  all_params:      POST from Zaakpay as a hash
  #  params:          all_params minus checksum
  #  posted_checksum: checksume POSTed from Zaakpay
  #  checksum:        checksum generated using the POSTed params and secret
  class Response
    attr_reader :params, :all_params, :posted_checksum, :checksum
    
    def initialize(args_str)
      @all_params = Rack::Utils.parse_query(args_str)
      @posted_checksum = @all_params['checksum']
      @params = @all_params.reject{|k,v| k=='checksum'}
    end
    
    def valid?
      @checksum = Zaakpay.generate_checksum(@params)
      @posted_checksum == @checksum
    end
    
  end
end

