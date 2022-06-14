git init -b master
git remote add origin git@github.com:dwx82/study.git
git status
git add .
git status
git commit -m 'added README.md files'
git push origin -u master
git branch -a
git checkout -b dev
git status
git add .
git status
git commit -m 'added anytestfile'
git push -u origin dev
git checkout -b %USERNAME-new_feature
git status
git add .
git status
git commit -m 'added .gitignore and README.md'
git push -u origin %USERNAME-new_feature 

git pull

git checkout %USERNAME-new_feature 
git add .
git commit -m 'added somechanges to README.md'
git log
git revert ead73a23343b61879c36e5a53c4274b435a2f6ce

git log > ~/log.txt
git checkout master 
git pull

git add .
git commit -m 'added log'
git push origin master 

git branch -d %USERNAME-new_feature
git branch -D %USERNAME-new_feature
git push origin -d %USERNAME-new_feature
