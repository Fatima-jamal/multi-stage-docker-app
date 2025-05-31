<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="ISO-8859-1" />
  <title>Welcome</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
</head>
<body class="bg-light">

  <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
    <div class="container">
      <a class="navbar-brand" href="#">Digital Payment Portal</a>
      <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
        <span class="navbar-toggler-icon"></span>
      </button>
      <div class="collapse navbar-collapse" id="navbarNav">
        <ul class="navbar-nav ms-auto">
          <li class="nav-item"><a class="nav-link" href="http://www.iwayq.com">Home</a></li>
          <li class="nav-item"><a class="nav-link" href="http://www.iwayq.com/gallery/gallery.html">Gallery</a></li>
          <li class="nav-item"><a class="nav-link" href="http://www.iwayq.com/videos/videos.html">Videos</a></li>
          <li class="nav-item"><a class="nav-link" href="http://www.iwayq.com/articles/articles.html">Articles</a></li>
          <li class="nav-item"><a class="nav-link" href="http://www.iwayq.com/tutorials/tutorials.html">Tutorials</a></li>
          <li class="nav-item"><a class="nav-link" href="http://www.iwayq.com/assessment/assessment.html">Assessment</a></li>
          <li class="nav-item"><a class="nav-link" href="http://www.iwayq.com/poll-survey/poll-survey.html">Poll & Survey</a></li>
          <li class="nav-item"><a class="nav-link" href="http://www.iwayq.com/chat/chat.html">Chat</a></li>
        </ul>
      </div>
    </div>
  </nav>

  <main class="container py-4">
    <h2 class="text-center mb-4">Welcome, ${username}!</h2>
  </main>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
