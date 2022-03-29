# Isak, green plogging flutter application
<img width="194" alt="image" src="https://user-images.githubusercontent.com/33146152/160340503-af84e553-2636-47cd-9523-317976090023.png">

[![license](https://img.shields.io/github/license/:user/:repo.svg)](LICENSE)
[![standard-readme compliant](https://img.shields.io/badge/readme%20style-standard-brightgreen.svg?style=flat-square)](https://github.com/RichardLitt/standard-readme)
[![All Contributors](https://img.shields.io/badge/all_contributors-4-orange.svg?style=flat-square)](#Contributors)

2022-GDSC-Solution-Challenge flutter project 


## Table of Contents
- [Getting_Started](#getting_started)
- [Components](#components)
- [Main_Function](#main_function)
- [Sub_Function](#sub_function)
- [API](#api)
- [Contributors](#contributors)


## Getting_Started

### What is Plogging?
Plogging is a combination of Jogging with picking up litter merging the Swedish verbs ***plocka*** upp (pick up) and ***jogga***(jog) gives the new Swedish verb ***plogga***, from which the workd plogging derives).


## What is Sustainable Development Goals?
![image](https://user-images.githubusercontent.com/33146152/160327143-e36bb1b9-ccea-4f96-b3b2-d92338dd56c5.png)

The Sustainable Development Goals (SGDs) or Global Goals are a collection of 17 interlinked global goals designed to be a "blueprint to achieve a better and more sustainable future for all.
As can be seen in the figure above, there are 17 goals.


### Our goal

We selected several of the UN's 17 sustainable development goals to create an flutter application. And we found activities that can take care of my health and help the environment. After that, we found the actrivity "plogging", and we thought it would be nice if we could add additional features to draw interest from users.


#### Good Health and Well-Being
<img width="143" alt="image" src="https://user-images.githubusercontent.com/33146152/160327288-21a43bdc-3de2-4d36-a26e-9953dc86bc4f.png">
Plogging is an activity to pick up trash while running. App users can improve their health while using this application. Also they can do "well-being" by sharing their progress with people around the world and friends.


#### Responsible consumption and production
<img width="146" alt="image" src="https://user-images.githubusercontent.com/33146152/160338918-1069a764-d3ce-43cb-ae23-2f597ae0d161.png">
As mentioned above, the positive aspects of the environment and sustainable consumption can ve derived through the action of picking up recycled waste.



### The reason why we named "Isak"
![image](https://user-images.githubusercontent.com/33146152/160325415-8deaab92-23fd-44fe-aa66-74c3d70f5181.png)

During the flogging process, you naturally bend your back. So we thought this posture was very similar to the prople from one of the famous paintings, "The Gleaners".
In Korean, "the Gleaners" sounds like "Isak". Therefore, our team decided the logo and application name in this way.



## Components
<img src="https://user-images.githubusercontent.com/33146152/160340776-616bc1a4-dd52-40a5-8e9f-dea06cd16952.png" width="200" height="100">  <img src="https://user-images.githubusercontent.com/33146152/160340848-f25eb360-157c-4988-a2c4-7e9e9034b0f4.png" width="200" height="100">  <img src="https://user-images.githubusercontent.com/33146152/160341014-57c3e47f-b268-40bb-bac0-b01bd03ca8c3.png" width="100" height="100">  <img src="https://user-images.githubusercontent.com/33146152/160341802-7eceab71-16af-46c9-a74f-840c030c3abc.png" width="150" height="100">



## Main_Function
### Plogging
<p align="center">
  <img src="https://user-images.githubusercontent.com/33146152/160342822-41b249ae-4e6d-4fcd-b72e-72cbb69a350c.png" alt="text" width="400" height="500" />
</p>
When a user starts plogging, app automatically marks the path you have walked. You can start plogging activity with just press the start button.
Then, when user enter a resting state or press the start plogging button, it switch to a trash pick-up state. 


```
Run as you long as you can!
```


### Trash Classification
<p align="center">
  <img src="https://user-images.githubusercontent.com/33146152/160343807-98ec65c3-ac39-4a5c-abef-d4644e7e94c4.png" alt="text" width="400" height="500" />
</p>
During trash pick-up state, you can take a picture of the trash you picked up.
Models learned with tensorflow automatically recognize garbage and qutomatically calssify which garbage user picked up. 


```
the application will take care of what you picked up
```


### Community
<p align="center">
  <img src="https://user-images.githubusercontent.com/33146152/160344724-f75219bf-25fb-4289-be94-df51b1654e97.png" alt="text" width="400" height="500" />
</p>
After the plogging activity, you can share photos of you running activities, surrounding landscapes, or your trash to the community.


```
Lets share and brag!
```

### Ranking
<p align="center">
  <img src="https://user-images.githubusercontent.com/33146152/160345879-a2063052-d7a2-4d9a-9a45-9546ac76b399.png" alt="text" width="400" height="500" />
</p>

You can also share your plogging activities by region or friends. 


### Donation
<p align="center">
  <img src="https://user-images.githubusercontent.com/33146152/160346160-1b37ba8b-6936-4c4d-9c7b-532d7531a9fb.png" alt="text" width="400" height="500" />
</p>

You can donate with points collected through plogging activities. 



## Sub_Function
### Environment News
<p align="center">
  <img src="https://user-images.githubusercontent.com/33146152/160410373-f6915ffa-9702-4abb-aa44-3300a33a61d4.png" alt="text" width="250" height="500" />
</p>

You can view the latest environmental news on the News tab through the News API.


### Cumulation of plogging activities
<p align="center">
  <img src="https://user-images.githubusercontent.com/33146152/160413298-f21fbc75-9402-40d0-bc76-60c45e5d9352.png" alt="text" width="250" height="500" />
</p>

You can see the progress of the accumulated plogging activity as a percentage


### Subscription ranking
<p align="center">
  <img src="https://user-images.githubusercontent.com/33146152/160526942-b9fb20b9-f266-496e-a523-f2a51e657523.png" alt="text" width="250" height="500" />
</p>

You can view the cumulative subscription order for this application. 
As the number of subscribers increases, you can see how many subscribers you are on the membership screen and how many subscribers you already have on the login screen.



## API
![image](https://user-images.githubusercontent.com/33146152/160411457-588efe7b-833b-48d8-9b19-cb614ba32b3b.png)

we used News API to continuously update new environmental news.



## Contributors
<table>
  <tr>
    <td align="center"><img src="https://avatars.githubusercontent.com/u/33146152?v=4" width="100px;" alt=""/><br /><b>Jeong Hyeong Lee</b><br/>📈📲🇰🇷</td>
    <td align="center"><img src="https://avatars.githubusercontent.com/u/87767242?v=4" width="100px;" alt=""/><br /><b>Chang Woo Choo</b><br/>🛠📲🇰🇷</td>
    <td align="center"><img src="https://pixsector.com/cache/edf30b98/avbbe2b2f7695f1d91628.png" width="100px;" alt=""/><br /><b>Hyun Wook Jang</b><br/>🛠🖼🇰🇷</td>
    <td align="center"><img src="https://avatars.githubusercontent.com/u/78309388?v=4" width="100px;" alt=""/><br /><b>Jeong Woo Han</b><br/>🛠📲🇰🇷</td>
  <tr>
<table>
