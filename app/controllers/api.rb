Alegato.controllers :api do
  get :person, :with => [:id], :provides => [:html,:json] do
    p = {}
    data = Person.find(params[:id])

    if params[:milestones] # poor man's data.to_json(:include => :milestones) which do not seems to work..
      hash = data.attributes
      hash[:milestones] = data.milestones.map(&:attributes)
      data = hash
    end

    case content_type
      when :json then data.to_json(p)
    end
  end
  post :person, :with => [:id], :provides => [:html,:json] do
    halt 400, "Missing set param" unless params[:set]
    if params[:id].to_i == 0
      person = Person.filter_by_name(params[:id])
    else
      person = Person.find(params[:id])
    end
    if person
      new_milestone = params[:set].delete(:milestone)
      person.update_attributes(params[:set])
      if new_milestone
        person.add_milestone(Milestone.new(new_milestone))
      end
      person.save.to_json
    end
  end

  get :milestone, :with => [:id], :provides => [:html,:json] do
    p = {}
    data = Milestone.find(params[:id])
    if params[:person] # poor man's data.to_json(:include => :milestones) which do not seems to work..
      hash = data.attributes
      hash[:milestones] = data.person.attributes
      data = hash
    end

    case content_type
      when :json then data.to_json(p)
    end
  end
  post :milestone, :with => [:id], :provides => [:html,:json] do
    halt 400, "Missing set param" unless params[:set]
    milestone = Milestone.find(params[:id])
    if milestone
      milestone.update_attributes(params[:set])
      milestone.save.to_json
    end
  end

  delete :milestone, :with => [:id], :provides => [:html,:json] do
    milestone = Milestone.find(params[:id])
    if milestone
      milestone.delete.to_json
    end
  end

  get :milestones, :with => [:doc_id], :provides => [:html,:json] do
    p = {}
    data = Document.find(params[:doc_id]).milestones
    case content_type
      when :json then data.to_json(p)
    end
  end

end
