Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <trinity-c4776725-d637-418a-a2f1-b317c3ed3144-1520475704072@3c-app-mailcom-bs01>
References: <trinity-cf8cc163-74dd-4b20-8372-28cbce5bfa47-1520427171633@3c-app-mailcom-bs03>
 <CAOQ4uxji73iSXeS-keVrH264iXZs6-4XkGS2rQYU2AsjT6JikQ@mail.gmail.com> <trinity-c4776725-d637-418a-a2f1-b317c3ed3144-1520475704072@3c-app-mailcom-bs01>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 8 Mar 2018 09:23:17 +0200
Message-ID: <CAOQ4uxgcz4sAwQ6iD2dAE1aRJ6ddeJDJSLOh4g3SteKDhW6ZRA@mail.gmail.com>
Subject: Re: "quota-df" feature
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Chengguang Xu <cgxu519@gmx.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Mar 8, 2018 at 4:21 AM, Chengguang Xu <cgxu519@gmx.com> wrote:
>> Sent: Wednesday, March 07, 2018 at 9:28 PM
>> From: "Amir Goldstein" <amir73il@gmail.com>
>> To: "Chengguang Xu" <cgxu519@gmx.com>
>> Cc: overlayfs <linux-unionfs@vger.kernel.org>, "Miklos Szeredi" <miklos@=
szeredi.hu>
>> Subject: Re: "quota-df" feature
>>
>> On Wed, Mar 7, 2018 at 2:52 PM, Chengguang Xu <cgxu519@gmx.com> wrote:
>> > Hello folks,
>> >
>> > Recently I'm trying to implement a feature on overlayfs for our users.
>> > I'd like to call it "quota-df" which means when calling statfs(2),
>> > override/update some fields(e.g., total/used/avail of both block/inode=
 counts=EF=BC=89
>> > using proper project quota information if the quota has already set to
>> > underlying directories of overlayfs.
>> >
>>
>> Do you mean project quota setting on underlying fs directories or
>> something else?
>
> Underlying fs directories, more accurately the directory include
> upperdir && workdir.
>
>>
>> > This feature is probably useful for most of container users and there =
is
>> > no serious side effect to the other parts. We can also provide a new
>> > mount option to enable/disable the function according to different use=
 cases.
>> >
>> > Although I'm still working on it but I'll post the RFC patch here for =
review
>> > in recent days and hope to get some feedback from you. Any kind of sug=
gestions
>> > are welcomed.
>> >
>>
>> I was asked about quota accounting for the merged content of overalyfs,
>> so quota would display a number resembling du -s on the overlay mount.
>> This means that "covered" lower files are not accounted for in the merge=
.
>> Is that what you aim to achieve? If not, would that also be an interesti=
ng case
>> for you to explore?
>> Basically, the index directory could be used to reconstruct the entire q=
uota
>> information for upper and lower (and copied up) files if full indexing
>> is enabled
>> with nfs_export=3Don.
>
> To be honest, our use case is standard docker container with overlayfs an=
d
> our requirement of quota-df is accurately counting usage/avail inside con=
tainer.
>

My confusion is because I thought this was working correctly today.
When I posted docker support for project quota over year ago I remeber
the tests inside container showed reasonable behavior:
https://github.com/moby/moby/pull/24771

So what I am missing is "what is wrong now?".

> Lowerdirs could be share with different overlayfs, so I'm not sure counti=
ng
> the contents of lowerdirs is proper behavior or not. If lowerdirs are ded=
icated
> to one overlayfs then maybe setting same project id with upperdir can res=
olve
> "covered" problem that you mentioned above. Counting usage information wi=
thout
> quota might be a hard work when having plenty of files.
>

Well, its a different use case, but a very well known use case -
When dealing with cloned files (e.g. btrfs, xfs) many files can share the s=
ame
blocks, but each clone is fully accounted to the user/group/project.
This is the "thin provisioning" use case - every user gets accounted by fil=
es
that the user can reference, but the host does not pay the cost of sum of a=
ll
user quotas.

Without accounting of "covered" files to begin with, is it possible to
get to a state
where 'touch' on a big file gets ENOSPC/EQUOTA. This is indeed a situation =
that
can happen in "thin provisioned" filesystems (e.g. btrfs) or on thin
provisioned block,
but a situation that filesystems and administrators try really hard to avoi=
d.

All I am saying is that it is "not hard" (TM) to keep track of
"covered" files disk usage
and "not hard" to re-calculate "covered" files disk usage when full
indexing is enabled.

> I don't know exactly what will happen when combining index and nfs_export=
 options,
> I need to read and understand related code later.
>

nfs_export REQUIRES index and implies indexing of all files on copy up, not
only lower hardlinks.

>>
>> >
>> > Here are some test examples share with you (based on ext4):
>> >
>> > 1) project quota enabled && without hard-limit
>> >
>> > $ df -h /mnt/test3 /mnt/test3/df/merged
>> > Filesystem      Size  Used Avail Use% Mounted on
>> > /dev/vdb3        99G  2.5G   91G   3% /mnt/test3
>> > overlay          92G  201M   91G   1% /mnt/test3/df/merged
>> >
>> > $ df -hi /mnt/test3 /mnt/test3/df/merged
>> > Filesystem     Inodes IUsed IFree IUse% Mounted on
>> > /dev/vdb3        6.3M  2.4K  6.3M    1% /mnt/test3
>> > overlay          6.3M     8  6.3M    1% /mnt/test3/df/merged
>> >
>> > 2) project quota enabled && with hard-limit
>> >
>> > $ df -h /mnt/test3 /mnt/test3/df/merged
>> > Filesystem      Size  Used Avail Use% Mounted on
>> > /dev/vdb3        99G  2.5G   91G   3% /mnt/test3
>> > overlay         1.0G  201M  824M  20% /mnt/test3/df/merged
>> >
>> > $ df -hi /mnt/test3 /mnt/test3/df/merged
>> > Filesystem     Inodes IUsed IFree IUse% Mounted on
>> > /dev/vdb3        6.3M  2.4K  6.3M    1% /mnt/test3
>> > overlay          1000     8   992    1% /mnt/test3/df/merged
>> >
>> >
>>
>> I can't follow from the example below what is the expected result and wh=
y
>> if you add the quota setup commands that could be useful.
>
> Underlying fs using ext4 and mkfs/mount with project quota option and
> all needed directories(lowerdir, upperdir, workdir, merged) are set same
> project quota. Current quota-df implementation only adjust the couting
> information when having upperdir.
>

Really? why is lowerdir on the same project id? For containers quota
only upper/work should be on the same project id. lowerdir should belong
to a shared project or no project at all.
In current docker implementation, every overlay2 driver root dir
is assigned a different project id, but lowerdir are symlinks to another
image root dir.

> In case 1:
> There is no hardlimit/softlimit, so the expected result as below.
> Used:  The used count in project quota which set to the directory
>        include upperdir && workdir.
> Avail: The avail of underlying fs
> Total: Used + Avail
>
> #upperdir used 201M and /mnt/test3 used 2.5G
>
> In case 2:
> Project quota hardlimits are block count =3D 1G, inode count =3D 1000.
> So the expected result as below.
>
> Used:  The used count in project quota which set to the directory
>        include upperdir && workdir.
> Avail: (a)Hardlimit - Used or (b)The avail of underlying fs(when a > b)
> Total: Used + Avail
>

Are those "expected" results inline with what df shows on project quota
directories without overlayfs? If not, and the new behavior makes sense,
why change overlayfs and not change 'df'?

Thanks,
Amir.
