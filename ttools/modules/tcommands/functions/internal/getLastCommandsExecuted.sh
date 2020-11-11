# the output of this sh depends on the shell it is called in!
# it outputs the nth to the last command before this call in the current shell

getCommandHistory(){
	history | awk '{$1="";print substr($0,2)}'
}

amount=$1

if [ ! $amount ]; then
	amount=1
fi

getCommandHistory | tail --lines=$(($amount+1)) | head -n$amount
