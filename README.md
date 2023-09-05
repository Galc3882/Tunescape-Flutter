# Tunescape WebApp

## Introduction
Tunescape is a web and mobile application designed to provide users with a visually appealing and user-friendly interface for connecting to backend endpoints that offer recommended songs and a similarity score. This repository contains the code for the Tunescape web application, built using the Flutter framework.

## Purpose
The Tunescape WebApp serves as the user interface for connecting to backend endpoints (located in a different repository) that provide recommended songs and a similarity score. It offers an intuitive and visually appealing graphical user interface (GUI) that works seamlessly on both web and mobile platforms. The primary goal of Tunescape is to enhance the user's music discovery experience by providing highly specific song recommendations tailored to individual musical preferences.

## What It Is and How It Works (Overview)
The Tunescape web application acts as a client to a separate backend service (not included in this repository) that provides song recommendations and similarity scores based on user queries. Here is an overview of how the application works:

1. **Search**: Users enter a search query, and the application sends a request to the backend API to fetch song recommendations related to the query.

2. **Display**: The retrieved song recommendations are displayed in a visually appealing format, including song details and options for user interaction.

3. **Song Interactions**: Users can interact with the displayed song recommendations, including saving songs to their playlist and accessing additional song details.

4. **Playlist**: The application allows users to save songs to their playlist, which is stored locally on their device.

## Detailed Walkthrough of the Code and Features
The Tunescape web application is built using the Flutter framework and consists of several Dart files. The file architecture of the project is organized into various Dart files, each serving a specific purpose. Here's a brief overview of the key files and their functionalities:

- **`main.dart`**: The entry point of the app, responsible for setting up the initial environment and rendering the home screen.

- **`recommend_songs.dart`**: Handles recommending songs based on user selections.

- **`search_bar.dart`**: Implements the search bar where users can input their queries to search for songs.

- **`search_results.dart`**: This file contains the main logic for fetching search results from the backend API and displaying them in the user interface. It includes animations for adding and removing songs from the playlist.

- **`song_list.dart`**: This file defines the user's playlist and provides features for managing saved songs. Users can edit their playlist and recommend songs based on their saved selections.

- **`theme.dart`**: This file defines the visual theme and color scheme used throughout the application, providing a consistent and visually appealing user interface.

## Conclusion
The Tunescape WebApp is designed to provide users with a personalized and intuitive music recommendation experience. By focusing on underlying musical characteristics, Tunescape aims to help users discover music that aligns with their preferences. This README has provided an overview of the app's purpose, functionality, code structure, and requirements.

## Next Steps
Here are the next steps and potential enhancements for the Tunescape web application:

- [ ] Implement user authentication and user-specific playlists.
- [ ] Implement user feedback and rating features for recommended songs.
- [ ] Optimize the application for better performance on both web and mobile platforms.
- [ ] Add support for different music streaming services for song playback.


<a rel="license" href="http://creativecommons.org/licenses/by-nc-nd/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-nc-nd/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc-nd/4.0/">Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License</a>.
