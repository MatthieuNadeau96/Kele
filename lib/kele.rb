require "httparty"
require "json"

class Kele
    include HTTParty
    
    
    def initialize(email, password)
        response = self.class.post(api_url("sessions"), body: {"email": email, "password": password })
        # puts response
        raise "invalid email or password" if response.code == 401
        @auth_token = response["auth_token"]
    end
    
    def get_me
        response = self.class.get(api_url("users/me"), headers: { "authorization" => @auth_token })
        @user_data = JSON.parse(response.body)
        # @user_data.keys.each do |key|
        #     self.class.send(:define_method, key.to_sym) do 
        #         @user_data[key]
        #     end 
        # end
    end
    
    def get_mentor_availability(mentor_id)
        response = self.class.get(api_url("mentors/#{mentor_id}/student_availability"), headers: {"authorization" => @auth_token })
        @mentor_availability = JSON.parse(response.body)
    end
    
    def get_roadmap(roadmap_id)
        response = self.class.get(api_url("roadmaps/#{roadmap_id}"), headers: { "authorization" => @auth_token })
        @roadmap = JSON.parse(response.body)
    end
    
    def get_checkpoints(checkpoint_id)
        response = self.class.get(api_url("checkpoints/#{checkpoint_id}"), headers: { "authorization" => @auth_token })
        @checkpoint = JSON.parse(response.body)
    end
    
    def get_messages(page)
        response = self.class.get(api_url("message_threads?page=#{page}"), headers: { "authorization" => @auth_token })
        @get_messages = JSON.parse(response.body)
    end
    
    def create_messages(recipient_id, subject, message)
        response = self.class.post(api_url("messages"), body: { "user_id": id, "recipient_id": recipient_id, "subject": subject, "stripped-text": message }, headers: {"authorization" => @auth_token })
        puts response
    end
    
    def create_submission(checkpoint_id, assignment_branch, assignment_commit_link, comment)
        response = self.class.post(api_url("checkpoint_submissions"), body: { "checkpoint_id": checkpoint_id, "assignment_branch": assignment_branch, "assignment_commit_link": assignment_commit_link, "comment": comment }, headers: { "authorization" => @auth_token })
        puts response
    end
    
    private
    
    def api_url(endpoint)
        "https://www.bloc.io/api/v1/#{endpoint}"
    end
    
end
