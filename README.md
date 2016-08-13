###########           HELO SIGN API

Step 1> create account free on https://www.hellosign.com/api   or login with gmail account.
step 2> select "ME & OTHERS".
step 3> click on 'Integration' on left side bar.
step 4> on navbar select API.
step 5> review KEy ('api key....') and create an application. as 'demohellosign'.
step 6> write your application callback your as 'application_name.com/contrller_name/callback_action'
 for example.

https://demosign.herokuapp.com/home/callbacks

then controller'home' and action 'callbacks'
as => class HomeController < ApplicationController
        def index
        end
      
        def callbacks
           render :text => 'Hello API Event Received'
        end
      end
      
step 7> in your demo app add gem 'hellosign-ruby-sdk'  and run bundle.
step 8> in config/initializers/hello_sign.rb

  require 'hello_sign'
  HelloSign.configure do |config|
  config.api_key = '8fcfb140f42716b88afadfb74930d72d2c4c7ef2520950272e5fd6f874afcb07'
  config.client_id = 'b0350215c8258b386d0efd63bc6d9e18'
  config.client_secret = 'ea2294cebb18f38f2b3109288bee4333'
   # You can use email_address and password instead of api_key. But api_key is recommended
  # If api_key, email_address and password are all present, api_key will be used
  # config.email_address = 'email_address'
  # config.password = 'pas
  end

  PDF_FILE = ['https://bitcoin.org/bitcoin.pdf']
  
  
  step 9> in your main controller for 'signing_request'
  
  class EmbeddedController < ApplicationController

  def signing
  end

  def create_signing

    begin
      embedded_request = HelloSign.create_embedded_signature_request(
        :test_mode => 1,
        :client_id=> 'b0350215c8258b386d0efd63bc6d9e18',
        :title => 'NDA with Acme Co.',
        :subject => 'The NDA we talked about',
        :message => 'Please sign this NDA and then we can discuss more. Let me know if you have any questions.',
        :signers => [{
            :email_address => params[:email],
            :name => params[:name]
          }
        ],
        :file_urls => PDF_FILE
      )

      signature_id = embedded_request.signatures[0].signature_id

      embedded = HelloSign.get_embedded_sign_url :signature_id => signature_id
      @sign_url = embedded.sign_url

      render 'signing'
    rescue => e
      render :text => e
    end
  end

  def requesting
  end

  def create_requesting
    begin
      data = {
        :test_mode => 1,
        :type => "request_signature",
        :subject => "Embedded Signature Request",
        :requester_email_address => "testuser@example.com",
        :message => "This is the message that goes along with your request."
      }

      if params[:requester_email_address]
        data[:requester_email_address] = params[:requester_email_address]
      end

      data[:files] = params[:files]

      resp = HelloSign.create_embedded_unclaimed_draft data
      claim_url = resp.claim_url;

      @sign_url = claim_url
      render 'requesting'
    rescue => e
      render :text => e
    end
  end

  def template_requesting
    @templates = HelloSign.get_templates(:page => 1)
    @data = (@templates.map {|t| t.data }).to_json
  end

  def create_template_requesting
    signers = []
    params[:signers].each_with_index do |signer, index|
      signer[1][:role] = signer[0]
      signers << signer[1]
    end
    ccs = []
    params[:ccs].each_with_index do |cc, index|
      cc[1][:role] = cc[0]
      ccs << cc[1]
    end
    begin
      request = HelloSign.create_embedded_signature_request_with_reusable_form(
        :test_mode => 1,
        :reusable_form_id => params[:template],
        :title => 'Purchase Order',
        :subject => 'Purchase Order',
        :message => 'Glad we could come to an agreement.',
        :signers => signers,
        :ccs => ccs,
        :custom_fields => params[:custom_fields]
      )
      signature_id = request.signatures[0].signature_id

      embedded = HelloSign.get_embedded_sign_url :signature_id => signature_id
      @sign_url = embedded.sign_url
      render 'template_requesting'
    rescue => e
      render :text => e
    end
  end

  def oauth_demo
  end

  def create_oauth_demo
    begin
      if cookies[:access_token]
        client = HelloSign::Client.new :auth_token => cookies[:access_token]
      else
        raise 'do not have auth token yet'
      end
      #make sure it not use config account
      client.email_address = nil
      client.password = nil

      request = client.send_signature_request(
        :test_mode => 1,
        :title => 'NDA with Acme Co.',
        :subject => 'The NDA we talked about',
        :message => 'Please sign this NDA and then we can discuss more. Let me know if you have any questions.',
        :signers => [{
            :email_address => params[:email],
            :name => params[:name],
          }
        ],
        :file_urls => PDF_FILE
      )
      flash[:notice] = "Sent Signature Request to #{params[:email]} successful"
      render 'oauth_demo'
    rescue => e
      render :text => e
    end
  end
end


step 10> create a partial page '_embedded_view.html.erb' in embedded folder

Embedded View


<!-- <script type="text/javascript" src="//cdn.dev-hellosign.com/js/embedded.js"></script> -->
<script type="text/javascript" src="https://s3.amazonaws.com/cdn.hellosign.com/public/js/hellosign-embedded.LATEST.min.js"></script>
<script type="text/javascript">

  HelloSign.init("<%= HelloSign.client_id %>");
  HelloSign.open({
      url: "<%=raw @sign_url %>",
      allowCancel: true,
      skipDomainVerification: true,
      messageListener: function(eventData) {
          alert("HelloSign event received");
      }
  });
</script>


step 11> create page 'signing.html.erb' in embedded folder. 
<h1> Embedded Signing Demo  </h1>
<%="#{@sign_url}"%>
<div class="embeddedSigning">

  <p class="intro">  This page demonstrates how you can add an embedded signature request to your Ruby-based web application. </p>
  <br>

  <div class="part">
    <h2> Try it out </h2>
    <p> Please sign our NDA. </p>

    <%=form_tag('signing', :method => :POST, :html => {:class => 'form-horizontal'}) do %>
      <input type='text' name='name' class='form-control' placeholder='Your name'>
      <input type='email' name='email' class='form-control' placeholder='Your email'>
    
      <input class="btn btn-primary" id="startButton" type="submit" value="Launch Demo">
      <%end%>

<% if @sign_url %>
  <%= render 'embedded_view'%>
  <% end%>


step 12> create page 'request.html.erb' in embedded folder

<h1> Embedded Request Demo
</h1>
<div class="embeddedSigning">
  <p class="intro"> Request signatures for documents directly from your website with HelloSign's embedded request capability.</p>

  <br>

  
  <div class="part">
    <h2> Try it out</h2>

    <%= form_tag('requesting', :method => :POST, :multipart => true, :class => 'form-horizontal') do%>
      <div class="control-group">
        <label class="control-label" for='files[]'> File
        <div class="controls">
          <input multiple="multiple" name="files[]" type="file">

      <div class="control-group">
        <label class="control-label" for='requester_email_address'> Your email
        <div class="controls">
          <input type='email' name='requester_email_address' placeholder='Your email'>
      <br>

      <div class="control-group">
       
        <input class="btn btn-primary" id="startButton" type="submit" value="Launch Demo">
        <% end%>

<%if @sign_url %>
  <%= render 'embedded_view'%>
  <% end%>


  


