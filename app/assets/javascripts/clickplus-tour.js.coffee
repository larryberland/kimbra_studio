$ ->
  if currentUserName? and currentUserName isnt 'Super Admin'
    tour = new Tour()
    tour.addStep
      element: "#PhotoSessions"
      placement: "bottom"
      title: "Welcome!"
      content: "This is the page you'll use most often.<br>" +
      "Here you'll create a new Session for each photo shoot you do and upload portraits."

    tour.addStep
      element: "#HowItWorks"
      placement: "bottom"
      title: "How It Works"
      content: "Probably a good place to start - it explains how the whole process works with lots of examples."

    tour.addStep
      element: "#Branding"
      placement: "bottom"
      title: "Your Studio Brand"
      content: "Your studio branding is already setup for you. Go here to make changes if you update your logo or website colors."

    tour.addStep
      element: "#Dashboard"
      placement: "bottom"
      title: "The Dashboard"
      content: "This shows you the activity generated from your clients. Reading their offer email, clicking-through, purchasing offers."

    tour.addStep
      element: "#FAQ"
      placement: "bottom"
      title: "Frequently Asked Questions"
      content: "and lots of answers.<br>Please shoot us an email if you have more questions!"

    tour.addStep
      element: "#Blog"
      placement: "bottom"
      title: "Blog"
      content: "Get insight on the different ways you can use ClickPLUS to expand your business and gain repeat clients."

    tour.start();