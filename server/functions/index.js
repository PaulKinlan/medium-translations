/*
 * Copyright 2018 Google Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

const functions = require('firebase-functions');
const express = require('express');
const cors = require('cors');
const fetch = require('node-fetch');
const medium = require('./medium');
const app = express();

// Automatically allow cross-origin requests
app.use(cors({ origin: true }));

app.get('/', (req, res) => {
  const { medium_url } = req.query;
  console.log(medium_url);
  
  fetch(medium_url, {
    method: 'GET'
  }).then(() => {
    let result = processMediumArticle(medium_url);
    return result;
  })
  .then(story => {
    return res.json(story);
  }).catch((err) => {
    console.log(err);
    return res.json({})
  });
});

let processMediumArticle = (url) => {
  return new Promise((mediumResolve, mediumReject) => {
    return medium.loadMediumPost(url, (err, json) => {
      if(err) {
        console.error(err);
        return;
      }
      
      var storyResponse = json.payload.value;
      var story = {};
    
      story.title = storyResponse.title;
      story.date = new Date(storyResponse.createdAt);
      story.url = storyResponse.canonicalUrl;
      story.language = storyResponse.detectedLanguage;
      story.license = storyResponse.license;
      story.sections = storyResponse.content.bodyModel.sections;
      story.paragraphs = storyResponse.content.bodyModel.paragraphs;
    
      var sections = [];
      for(let i=0;i<story.sections.length;i++) {
        var s = story.sections[i];
        var section = medium.processSection(s);
        sections[s.startIndex] = section;
      }
    
      if(story.paragraphs.length > 1) {
        story.subtitle = story.paragraphs[1].text;
      }
    
      story.markdown = [];
      story.markdown.push("\n# "+story.title.replace(/\n/g,'\n# '));
      if (undefined !== story.subtitle) {
        story.markdown.push("\n"+story.subtitle.replace(/#+/,''));
      }
    
      var promises = [];
    
      for(let i=2;i<story.paragraphs.length;i++) {
        
        if(sections[i]) story.markdown.push(sections[i]);
    
        var promise = new Promise((resolve, reject) => {
          var p = story.paragraphs[i];
          medium.processParagraph(p, (err, text) => {
            if(err) return;
            // Avoid double title/subtitle
            if(text !== story.markdown[i])
              return resolve(text);
            else
              return resolve();
          });
        });
        promises.push(promise);
      }
    
      Promise.all(promises).then((results) => {
        results.map(text => {
          story.markdown.push(text);
        });

        mediumResolve(story);
      }).catch((err) => {
        mediumReject(err);
      });
    });
  });
}

// Expose Express API as a single Cloud Function:
exports.medium = functions.https.onRequest(app);