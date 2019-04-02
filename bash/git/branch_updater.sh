# masterにブランチを変更
git checkout master
# ローカルのgitを最新化する（不要なリモートブランチの削除）
git fetch -p
# remoteに存在するブランチリストを取得する
remote_branchs=$(git branch -r | grep -v -e HEAD -e master | sed "s/origin\///g" | while read line; do echo $line; done;)
remote_branch_array=()
for branch in `echo $remote_branchs`
do
  remote_branch_array+=($branch)
done

# ローカルにcheckoutしたブランチリストを取得する
local_branchs=$(git branch | grep -v -e HEAD -e master -e \* | while read line; do echo $line; done;)
local_branch_array=()
for branch in `echo $local_branchs`
do
  local_branch_array+=($branch)
done

# remotesから削除されているものは削除する。（現在のbranchは除く）
for local_branch in ${local_branch_array[@]}; do
  if ! `echo ${remote_branch_array[@]} | grep -q $local_branch` ; then
    git branch -D $local_branch
  fi
done

# masterを最新化
git pull origin master

