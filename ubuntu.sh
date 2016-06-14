#!/usr/bin/env nash

UBUNTU_URL = "http://archive.ubuntu.com/ubuntu/"

fn ns_ubuntu_prepare(outDir, destDir) {
    sudo cp /etc/resolv.conf $outDir+"/etc/resolv.conf"
    sudo cp -R $outDir $destDir
    sudo chown -R $USER+":"+$USER $destDir
}

fn ns_ubuntu_clean(release) {
    rm -rf $HOME + "/.nash/images/ubuntu/" + $release
}

fn ns_ubuntu_fsbuild(release) {
    outDir = $HOME + "/.nash/images/ubuntu/" + $release
    destDir <= mktemp -d | xargs echo -n
    output = $destDir+"/"+$release

    -test -d $outDir+"/etc/resolv.conf"

    if $status == "0" {
            ns_ubuntu_prepare($outDir, $destDir)

            return $output
    }

    sudo rm -rf $outDir
    mkdir -p $outDir

    sudo debootstrap --no-check-gpg --variant=buildd --arch amd64 $release $outDir $UBUNTU_URL

    ns_ubuntu_prepare($outDir, $destDir)
    return $output
}

bindfn ns_ubuntu_fsbuild ns_ubuntu_fsbuild
