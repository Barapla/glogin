require 'google/api_client/client_secrets.rb'
require 'google/apis/calendar_v3'
class EventsController < ApplicationController
  def create
    # Get the current user
    client = get_google_calendar_client current_user
    #task = params[:task]
    event = get_event 
    client.insert_event('primary', event)
    flash[:notice] = 'Task was successfully added.'
    redirect_to root_path
  end

  def get_google_calendar_client current_user
    client = Google::Apis::CalendarV3::CalendarService.new
    return unless (current_user.present? && current_user.access_token.present? && current_user.refresh_token.present?)
    secrets = Google::APIClient::ClientSecrets.new({
      "web" => {
        "access_token" => current_user.access_token,
        "refresh_token" => current_user.refresh_token,
        "client_id" => ENV["GOOGLE_API_KEY"],
        "client_secret" => ENV["GOOGLE_API_SECRET"]
      }
    })
    begin
      client.authorization = secrets.to_authorization
      client.authorization.grant_type = "refresh_token"

      if !current_user.present?
        client.authorization.refresh!
        current_user.update_attributes(
          access_token: client.authorization.access_token,
          refresh_token: client.authorization.refresh_token,
          expires_at: client.authorization.expires_at.to_i
        )
      end
    rescue => e
      flash[:error] = 'Your token has been expired. Please login again with google.'
      redirect_to :back
    end
    client
  end

  private

  def get_event 
    #attendees = task[:members].split(',').map{ |t| {email: t.strip} }
    event = Google::Apis::CalendarV3::Event.new(
      summary: "Sample Event created by #{current_user.name}",
      location: '800 Howard St., San Francisco, CA 94103',
      description: "This is a sample description for the event created by #{current_user.name}",
      start: {
        date_time: "2019-09-07T09:00:00-07:00",
        #Time.new(task['start_date(1i)'],task['start_date(2i)'],task['start_date(3i)'],task['start_date(4i)'],task['start_date(5i)']).to_datetime.rfc3339,
        time_zone: "Asia/Kolkata"
        # date_time: '2019-09-07T09:00:00-07:00',
        # time_zone: 'Asia/Kolkata',
      },
      end: {
        date_time: "2019-09-07T11:00:00-07:00",
        #Time.new(task['end_date(1i)'],task['end_date(2i)'],task['end_date(3i)'],task['end_date(4i)'],task['end_date(5i)']).to_datetime.rfc3339,
        time_zone: "Asia/Kolkata"
      },
      reminders: {
        use_default: false,
        overrides: [
          Google::Apis::CalendarV3::EventReminder.new(reminder_method:"popup", minutes: 10),
          Google::Apis::CalendarV3::EventReminder.new(reminder_method:"email", minutes: 20)
        ]
      },
      notification_settings: {
        notifications: [
                        {type: 'event_creation', method: 'email'},
                        {type: 'event_change', method: 'email'},
                        {type: 'event_cancellation', method: 'email'},
                        {type: 'event_response', method: 'email'}
                       ]
      }, 'primary': true
    )
  end
end