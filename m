Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <trinity-cf8cc163-74dd-4b20-8372-28cbce5bfa47-1520427171633@3c-app-mailcom-bs03>
References: <trinity-cf8cc163-74dd-4b20-8372-28cbce5bfa47-1520427171633@3c-app-mailcom-bs03>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 7 Mar 2018 15:28:14 +0200
Message-ID: <CAOQ4uxji73iSXeS-keVrH264iXZs6-4XkGS2rQYU2AsjT6JikQ@mail.gmail.com>
Subject: Re: "quota-df" feature
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Chengguang Xu <cgxu519@gmx.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, Mar 7, 2018 at 2:52 PM, Chengguang Xu <cgxu519@gmx.com> wrote:
> Hello folks,
>
> Recently I'm trying to implement a feature on overlayfs for our users.
> I'd like to call it "quota-df" which means when calling statfs(2),
> override/update some fields(e.g., total/used/avail of both block/inode co=
unts=EF=BC=89
> using proper project quota information if the quota has already set to
> underlying directories of overlayfs.
>

Do you mean project quota setting on underlying fs directories or
something else?


> This feature is probably useful for most of container users and there is
> no serious side effect to the other parts. We can also provide a new
> mount option to enable/disable the function according to different use ca=
ses.
>
> Although I'm still working on it but I'll post the RFC patch here for rev=
iew
> in recent days and hope to get some feedback from you. Any kind of sugges=
tions
> are welcomed.
>

I was asked about quota accounting for the merged content of overalyfs,
so quota would display a number resembling du -s on the overlay mount.
This means that "covered" lower files are not accounted for in the merge.
Is that what you aim to achieve? If not, would that also be an interesting =
case
for you to explore?
Basically, the index directory could be used to reconstruct the entire quot=
a
information for upper and lower (and copied up) files if full indexing
is enabled
with nfs_export=3Don.

>
> Here are some test examples share with you (based on ext4):
>
> 1) project quota enabled && without hard-limit
>
> $ df -h /mnt/test3 /mnt/test3/df/merged
> Filesystem      Size  Used Avail Use% Mounted on
> /dev/vdb3        99G  2.5G   91G   3% /mnt/test3
> overlay          92G  201M   91G   1% /mnt/test3/df/merged
>
> $ df -hi /mnt/test3 /mnt/test3/df/merged
> Filesystem     Inodes IUsed IFree IUse% Mounted on
> /dev/vdb3        6.3M  2.4K  6.3M    1% /mnt/test3
> overlay          6.3M     8  6.3M    1% /mnt/test3/df/merged
>
> 2) project quota enabled && with hard-limit
>
> $ df -h /mnt/test3 /mnt/test3/df/merged
> Filesystem      Size  Used Avail Use% Mounted on
> /dev/vdb3        99G  2.5G   91G   3% /mnt/test3
> overlay         1.0G  201M  824M  20% /mnt/test3/df/merged
>
> $ df -hi /mnt/test3 /mnt/test3/df/merged
> Filesystem     Inodes IUsed IFree IUse% Mounted on
> /dev/vdb3        6.3M  2.4K  6.3M    1% /mnt/test3
> overlay          1000     8   992    1% /mnt/test3/df/merged
>
>

I can't follow from the example below what is the expected result and why
if you add the quota setup commands that could be useful.

Thanks,
Amir.
