go-package-start() {
	pathway=/tmp/tmp/golang
	[ -d $pathway ] && rm -rfv ${pathway:?pathway no set!}/ && {
		mkdir -pv $pathway
		cd $pathway
		echo "pwd: `pwd`"
		touch ./main.go
		go mod init golang
		go mod tidy
	}
}
