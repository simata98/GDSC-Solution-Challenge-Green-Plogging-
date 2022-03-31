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
  - Main
  - Start Running
  - Start Plogging
    - ML Part
  - Finish
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

- **Disign**
  - [Adobe XD](https://www.adobe.com/products/xd.html)
- **ML** **(** [Python](https://www.python.org/) : `3.7.12` **)**
  - [tensorflow](https://www.tensorflow.org/?hl=ko) & [keras](https://keras.io/) : `2.6.0`
- **Back**
  - [Firebase](https://firebase.google.com/?hl=ko&gclid=CjwKCAjwopWSBhB6EiwAjxmqDeP1h2srS6otlbc3_ubdqsEzdhZ7f5ZvhsOcXqbTeyyw_d9Kq2XPQxoCElgQAvD_BwE&gclsrc=aw.ds)
- **Front** **(** [Dart](https://dart.dev/) : `2.16.1` **)**
  - [Flutter](https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_2.10.3-stable.zip) : `2.10.3`
- **Device**
  - Android Virtual Device
    - Pixel 3a API 29
  - Galaxy S8 ( Android 9 )

## Main_Function

### Plogging

<p align="center">
  <img width="250" alt="스크린샷 2022-03-30 오후 10 54 04" src="https://user-images.githubusercontent.com/78309388/160851377-19092005-9590-49f8-82a9-9811b124eabd.png">
  &nbsp;&nbsp;
<img width="250" alt="스크린샷 2022-03-30 오후 10 52 48" src="https://user-images.githubusercontent.com/78309388/160851418-74aebe41-596e-44b2-a038-fe72552f87bd.png">
  &nbsp;&nbsp;

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
  <img width="250" alt="post_total" src="https://user-images.githubusercontent.com/78309388/160839959-bdb0348e-6e84-437c-a475-5c59508fb72e.png">
  &nbsp;&nbsp;
  <img width="250" alt="스크린샷 2022-03-31 오후 1 35 19" src="https://user-images.githubusercontent.com/78309388/160977541-73a8fd74-a0e5-4cb9-936e-62bfad36620d.png">
  &nbsp;&nbsp;
<img width="250" alt="post_detail" src="https://user-images.githubusercontent.com/78309388/160978597-d92b1158-8a68-4046-927c-77890725384c.gif">
</p>

After the plogging activity, you can share photos of you running activities, surrounding landscapes, or your trash to the community. Check out the records of your friends or people in the same area and leave feedback!

```
Lets share and brag!
```

### Ranking

<p align="center">
  <img width="250" alt="rank_friends" src="https://user-images.githubusercontent.com/78309388/160846291-9fe27542-b8c1-4b2d-a9e7-57a8083200ee.png">
  &nbsp;&nbsp;&nbsp;&nbsp;
<img width="250" alt="rank_total" src="https://user-images.githubusercontent.com/78309388/160846351-9521fba7-050e-405b-9c32-e0c64b74250a.png">
  &nbsp;&nbsp;&nbsp;&nbsp;
<img width="250" alt="rank_region_list" src="https://user-images.githubusercontent.com/78309388/160846409-a84b736d-0b29-4283-9647-919e1f222728.png">

</p>

You can also share your plogging activities by region or friends.

### Donation

<p align="center">
  <img width="250" alt="donate" src="https://user-images.githubusercontent.com/78309388/160847056-6378ee13-279c-4af8-8330-0713cdb43939.png">
  &nbsp;&nbsp;&nbsp;&nbsp;
<img width="250" alt="스크린샷 2022-03-30 오후 10 35 09" src="https://user-images.githubusercontent.com/78309388/160847209-bea54409-f45a-4d55-b197-44c90c2c2088.png">

</p>

You can donate with points collected through plogging activities.

## Sub_Function

### Environment News

<p align="center">
  <img width="250" alt="news" src="https://user-images.githubusercontent.com/78309388/160847780-d48380ef-90d0-47fa-80e6-b3e743a0661c.png">
&nbsp;&nbsp;&nbsp;&nbsp;
  <img width="250" alt="news_detail" src="https://user-images.githubusercontent.com/78309388/160847810-333afafa-f667-44a5-90c1-770b1d23f5c5.png">
</p>

You can view the latest environmental news on the News tab through the News API.

### Cumulation of plogging activities

<p align="center">
  <img width="250" alt="running_weekly" src="https://user-images.githubusercontent.com/78309388/160847933-caa85f8e-e800-4068-9fc9-ff8413a6aa1e.png">
&nbsp;&nbsp;&nbsp;&nbsp;
  <img width="250" alt="running_cumu" src="https://user-images.githubusercontent.com/78309388/160847969-ad74591b-6cc6-4ed3-a94b-c400ae392f62.png">
  &nbsp;&nbsp;&nbsp;&nbsp;
  <img width="250" alt="running_cumu" src="https://user-images.githubusercontent.com/78309388/160854223-dbb3b0bd-12da-4f98-9964-c5fc5a3a805e.gif">
</p>

You can see the progress of the accumulated plogging activity as a percentage

### Subscription ranking

<p align="center">
  <img width="250" alt="ranking" src="https://user-images.githubusercontent.com/78309388/160849446-46dc4f0d-db61-45f5-9a9e-839e29e0333b.gif">
  &nbsp;&nbsp;&nbsp;&nbsp;
  <img width="250" alt="ranking" src="https://user-images.githubusercontent.com/78309388/160979519-72dafdf7-e51f-43d8-92b7-ac7918d41468.gif">
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
