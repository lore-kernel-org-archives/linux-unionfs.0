Return-Path: <cgxu519@gmx.com>
MIME-Version: 1.0
Message-ID: <trinity-cf8cc163-74dd-4b20-8372-28cbce5bfa47-1520427171633@3c-app-mailcom-bs03>
From: "Chengguang Xu" <cgxu519@gmx.com>
Subject: "quota-df" feature
Content-Type: text/plain; charset=UTF-8
Date: Wed, 7 Mar 2018 13:52:51 +0100
Content-Transfer-Encoding: quoted-printable
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com
List-ID: <linux-unionfs@vger.kernel.org>

Hello folks,

Recently I'm trying to implement a feature on overlayfs for our users=2E
I'd like to call it "quota-df" which means when calling statfs(2),
override/update some fields(e=2Eg=2E, total/used/avail of both block/inode=
 counts=EF=BC=89
using proper project quota information if the quota has already set to
underlying directories of overlayfs=2E

This feature is probably useful for most of container users and there is
no serious side effect to the other parts=2E We can also provide a new
mount option to enable/disable the function according to different use cas=
es=2E

Although I'm still working on it but I'll post the RFC patch here for revi=
ew
in recent days and hope to get some feedback from you=2E Any kind of sugge=
stions
are welcomed=2E


Here are some test examples share with you (based on ext4):

1) project quota enabled && without hard-limit

$ df -h /mnt/test3 /mnt/test3/df/merged
Filesystem      Size  Used Avail Use% Mounted on
/dev/vdb3        99G  2=2E5G   91G   3% /mnt/test3
overlay          92G  201M   91G   1% /mnt/test3/df/merged

$ df -hi /mnt/test3 /mnt/test3/df/merged
Filesystem     Inodes IUsed IFree IUse% Mounted on
/dev/vdb3        6=2E3M  2=2E4K  6=2E3M    1% /mnt/test3
overlay          6=2E3M     8  6=2E3M    1% /mnt/test3/df/merged

2) project quota enabled && with hard-limit

$ df -h /mnt/test3 /mnt/test3/df/merged
Filesystem      Size  Used Avail Use% Mounted on
/dev/vdb3        99G  2=2E5G   91G   3% /mnt/test3
overlay         1=2E0G  201M  824M  20% /mnt/test3/df/merged

$ df -hi /mnt/test3 /mnt/test3/df/merged
Filesystem     Inodes IUsed IFree IUse% Mounted on
/dev/vdb3        6=2E3M  2=2E4K  6=2E3M    1% /mnt/test3
overlay          1000     8   992    1% /mnt/test3/df/merged


Thanks,
Chengguang=2E
