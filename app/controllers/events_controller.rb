class EventsController < ApplicationController
	def new
		@event=Event.new
	end

        def index
          @events = Event.all
        end
        
	def create
	  p=params[:event].permit(:title, :description)
	  @event=Event.new(p)


	  needed_id=params[:event][:users]
	  user_obj=User.find(needed_id)

          # This user is the owner of the event.
	  @event.owner=user_obj
	  @event.save
          # Take all the lines in the results of the text area tag
          input = params[:Participants_Info]
          all_lines=input.split("\n")
          # all_lines  should be an array
          # For each line:

          #initialize flash[:errors] to be an array
          flash[:errors] = []

          all_lines.each do |line|

            data=line.split(',')
            if data.size==3  
              data_array=data.map do |data_strip|
                data_strip.strip
              end
              email=data_array[0]
              if email.include?('@')
                name=data_array[1]
                phone=data_array[2] # get email from line somehow

                # if there is a user by that email - associate that user to the event
                user_obj = User.find_by_email(email)
                # else create a user and associate to that user.
                if user_obj != nil then
                	user_obj.events << @event
                  # There is such a user
                else
                	@user=User.new(name: name, email: email, phone: phone, user_type: 'guest', password: '11111111')
                	@user.save
                	@user.events << @event
                  # No user with that email
                end
              else
                flash[:errors] << "Line #{line} doesn't have a valid email."
              end
            else
              flash[:errors] << "Line #{line} doesn't have 3 entries"
            end
          end
          

          # Do something after creating the event
          # If we saw no errors, let's render the show
          if flash[:errors].size == 0

            # Homework - Ideally, we should save all participants in the database here, and not earlier in the action.
            
            render 'show' # meaning: use the show view in the views/events folder
          else
            # There were some errors - let's undo the event creation.
            Event.last.delete
	    p=params[:event].permit(:title, :description)
	    @event=Event.new(p)

            render 'new'
          end
	end

	def show
          #	  @events=Event.all
          @event = Event.find(params[:id])
	end


end
