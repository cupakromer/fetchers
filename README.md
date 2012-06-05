Web API Fetchers Project
========================

[![Build
Status](https://secure.travis-ci.org/cupakromer/fetchers.png?branch=master)](http://travis-ci.org/cupakromer/fetchers)
[![Build
Status](https://secure.travis-ci.org/cupakromer/fetchers.png?branch=develop)](http://travis-ci.org/cupakromer/fetchers)


Tasks
-----
1. Look through http://programmableweb.com for publicly-accessible APIs
   that I'd like to experiment with. Write a class like the sample
`Fetchers::Stock` provided that pulls data from them and converts the
results into a hash.

2. If I'm feeling really ambitious, sign up for a Microsoft Bing Maps
   Key, and write a class that counts the number of severe traffic
incidents occurring in and around Baltimore, MD. The Bing traffic API is
documented here:
> http://msdn.microsoft.com/en-us/library/hh441726.aspx


Chosen APIs (Fetchers)
----------------------
* #### Vimeo ####

  Chosen as it has a public API that does not require registration. Also
allows for requesting data in JSON format.

* #### Etsy ####

  Requires registration and an API key. Wanted to try my hand at using an
API key at the same time creating something my wife could potentially use.

* #### URL Status ####

  A simple fetcher that attempts to connect to a URL and returns:
    * Code 20x: { available: true }
    * Anything Else: { available: false }
      - This includes handling timeouts
      - Rescuing any exceptions

* #### MapQuest Traffic ####


* #### Travis-CI ####


Addtional Features
------------------
* Support HTTPS
  - Fetcher::Base#fetch should fully support an HTTPS url passed in
  - Ammend Fetcher::Base to provide a 'secure_fetch' which forces HTTPS
* Support handling timeouts after 30 seconds by default (but leave
  configurable)

