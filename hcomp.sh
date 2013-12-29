_hcomp()
{

        local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
        local DIR=${COMP_WORDS[1]%/*}/


        local HADOOP_TREE=~/.hadoop_tree_structure

#if the cache file is still being written , use the backup
if [ -f ~/.hadoop_tree_structure ] &&  \
        (( $((`stat -c %Y ${HADOOP_TREE}` + 2)) > $((`date +%s` +0)) ))
then
        HADOOP_TREE=~/.hadoop_tree_structure.bck
fi
                # check that the cache exists , is not still updated (not changed in last 2 seconds) and not too out of date (not more then 24 hours old)
        if [ -f ${HADOOP_TREE} ] &&  \
        (( $((`stat -c %Y ${HADOOP_TREE}` + 2)) < $((`date +%s` )) )) && \
        (( $((`stat -c %Y ${HADOOP_TREE}` + 86400)) > $((`date +%s` )) ))

then
        ## get completion info from the cache
		local names1=$(for x in `grep   "^${DIR}" ${HADOOP_TREE} | sed "s#\(${DIR}[^/]*/\).*#\1#" | uniq | grep -v "^${DIR}$"`;do echo $x;done)
       
		COMPREPLY=( $(compgen -W "${names1}" -- ${cur})  )

        # recompute the cache ( in bg)only if 600 secs passed the create a bckup
        if        [ -f ~/.hadoop_tree_structure ] &&  \
        (( $((`stat -c %Y ~/.hadoop_tree_structure` + 600)) < $((`date +%s` )) ))
        then
                
				(hadoop fs -lsr / | awk '{print $8"completetmpahretzzkk"$1}' | sed 's/completetmpahretzzkkd.*$/\//' | sed 's/completetmpahretzzkk-.*$//' | sed 's/completetmpahretzzkkFound//' > ~/.hadoop_tree_structure &  cp -f ~/.hadoop_tree_structure ~/.hadoop_tree_structure.bck &)
        fi

        #create a backup if there is none
        if        [ ! -f ~/.hadoop_tree_structure.bck ]
        then
                
				(cp -f ~/.hadoop_tree_structure ~/.hadoop_tree_structure.bck &)
        fi

  
else
    # get completion info straight from  hdfs
	echo "getting data from hdfs"
        local names1=$(for x in `hadoop fs -ls ${DIR} | awk '{print $8"completetmpahretzzkk"$1}' | sed 's/completetmpahretzzkkd.*$/\//' | sed 's/completetmpahretzzkk-.*$//' | sed 's/completetmpahretzzkkFound//'`;do echo $x;done)
        COMPREPLY=( $(compgen -W "${names1}" -- ${cur})  )
        # create cache(in bg)
        (hadoop fs -lsr / | awk '{print $8"completetmpahretzzkk"$1}' | sed 's/completetmpahretzzkkd.*$/\//' | sed 's/completetmpahretzzkk-.*$//' | sed 's/completetmpahretzzkkFound//' > ~/.hadoop_tree_structure & cp -f ~/.hadoop_tree_structure ~/.hadoop_tree_structure.bck &)

fi

    return 0
}
complete  -o filenames -o nospace -F _hcomp hls
complete  -o filenames -o nospace -F _hcomp hcat
complete  -o filenames -o nospace -F _hcomp hless
complete  -o filenames -o nospace -F _hcomp hrm
complete  -o filenames -o nospace -F _hcomp hmkdir
complete  -o filenames -o nospace -F _hcomp hrmr
complete  -o filenames -o nospace -F _hcomp hcp
complete  -o filenames -o nospace -F _hcomp hmv

# compute hash for first time

(hadoop fs -lsr / | awk '{print $8"completetmpahretzzkk"$1}' | sed 's/completetmpahretzzkkd.*$/\//' | sed 's/completetmpahretzzkk-.*$//' | sed 's/completetmpahretzzkkFound//' > ~/.hadoop_tree_structure & cp -f ~/.hadoop_tree_structure ~/.hadoop_tree_structure.bck &)

 alias hls='hadoop fs -ls'
 alias hcat='hadoop fs -cat'
 alias hless='_(){ hadoop fs -cat $1 | less ;}; _'
 alias hrm='hadoop fs -rm'
 alias hmkdir='hadoop fs -mkdir'
 alias hrmr='hadoop fs -rmr'
 alias hkill='hadoop job -kill'
 alias hwc='_(){ hadoop fs -cat $1 | wc -l ;}; _'
 alias hcp='hadoop fs -cp'
 alias hmv='hadoop fs -mv'
