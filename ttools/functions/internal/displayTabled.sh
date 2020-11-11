echo $@

while [ "$#" -gt 0 ]
do
	echo "$# $1"
	shift
done

#for num in 1 10 100 1000 10000 100000 1000000; do printf "%10s %s\n" $num "foobar"; done
#         1 foobar
#        10 foobar
#       100 foobar
#      1000 foobar
#     10000 foobar
#    100000 foobar
#   1000000 foobar
#
#$ for((i=0;i<array_size;i++));
#do
#    printf "%10s %10d %10s" stringarray[$i] numberarray[$i] anotherfieldarray[%i]
#done