# cmpe321-Boun-Registration

3rd project of the CMPE321 lecture. Simple Boun Registration System

Firstly, you should be sure that you get all necessary packages. You can simply type "flutter packages get" to ensure that all packages are ready to go.

We have already enabled flutter web in our project and local configuration. However, if you get any error related to this, you can simply type "flutter config --enable-web". (please be sure that all sky_engine and sdk tools are downloaded). You can read more about the details [here](https://docs.flutter.dev/get-started/web).

After all this pre-steps, what you should to to run the app is just writing the following command to the terminal:
"flutter run -d chrome".
Alternatively, you can use the ui of the IDE you prefer (e.g. run --> run without debugging in VSCode).

Firstly, you should run the back-end application and you should be sure that "http://localhost:3000" is working. You can also test this by sending example requests with some tools like Postman by using this base url.

For implementing back-end operations, we used Node.js. We used "mysql" module for connecting to our mysql database. We wrote all SQL queries, tables, triggers and stored procedures we need and used "mysql" module just to execute those queries. We also implemented necessary APIs and used those APIs with corresponding routings.

In the front-end of our application, we chose to use Flutter Web. We used Flutter widgets and integrated APIs we created in our back-end application to complete our project. After starting the back-end app, you can directly use the web app opened by Flutter with the command you entered in the previous steps.
