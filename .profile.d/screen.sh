# create some screen.project aliases
if [ -d ~/.screen.d ]; then
  for i in `ls ~/.screen.d`; do
    alias screen.${i}="title ${i}; screen -list | grep ${i} && screen -D -r ${i} || (sleep 5; screen -S ${i} -c ~/.screen.d/${i})"
  done

  for i in `ls ~/.screen.d`; do
    alias ssh.${i}.list="grep '[s]creen -t' ~/.screen.d/${i}"
    alias ssh.${i}="ssh.${i}.list"
    alias ssh.${i}.ip="ssh.${i}.list | awk '{ print \$6 }'"
  done

fi
