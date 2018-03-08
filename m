Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <trinity-4ed0aac2-30d8-4778-94d5-a954ba0dcacf-1520501014692@3c-app-mailcom-bs01>
References: <trinity-cf8cc163-74dd-4b20-8372-28cbce5bfa47-1520427171633@3c-app-mailcom-bs03>
 <CAOQ4uxji73iSXeS-keVrH264iXZs6-4XkGS2rQYU2AsjT6JikQ@mail.gmail.com>
 <trinity-c4776725-d637-418a-a2f1-b317c3ed3144-1520475704072@3c-app-mailcom-bs01>
 <CAOQ4uxgcz4sAwQ6iD2dAE1aRJ6ddeJDJSLOh4g3SteKDhW6ZRA@mail.gmail.com> <trinity-4ed0aac2-30d8-4778-94d5-a954ba0dcacf-1520501014692@3c-app-mailcom-bs01>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 8 Mar 2018 13:06:22 +0200
Message-ID: <CAOQ4uxhg0wanMESYcTdR0PFX3vdic_kT9VUWs-vqOaaJpB9sCw@mail.gmail.com>
Subject: Re: "quota-df" feature
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Chengguang Xu <cgxu519@gmx.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Mar 8, 2018 at 11:23 AM, Chengguang Xu <cgxu519@gmx.com> wrote:
>> Sent: Thursday, March 08, 2018 at 3:23 PM
>> From: "Amir Goldstein" <amir73il@gmail.com>
>> To: "Chengguang Xu" <cgxu519@gmx.com>
>> Cc: overlayfs <linux-unionfs@vger.kernel.org>, "Miklos Szeredi" <miklos@=
szeredi.hu>
>> Subject: Re: "quota-df" feature
>>
>> On Thu, Mar 8, 2018 at 4:21 AM, Chengguang Xu <cgxu519@gmx.com> wrote:
>> >> Sent: Wednesday, March 07, 2018 at 9:28 PM
>> >> From: "Amir Goldstein" <amir73il@gmail.com>
>> >> To: "Chengguang Xu" <cgxu519@gmx.com>
>> >> Cc: overlayfs <linux-unionfs@vger.kernel.org>, "Miklos Szeredi" <mikl=
os@szeredi.hu>
>> >> Subject: Re: "quota-df" feature
>> >>
>> >> On Wed, Mar 7, 2018 at 2:52 PM, Chengguang Xu <cgxu519@gmx.com> wrote=
:
>> >> > Hello folks,
>> >> >
>> >> > Recently I'm trying to implement a feature on overlayfs for our use=
rs.
>> >> > I'd like to call it "quota-df" which means when calling statfs(2),
>> >> > override/update some fields(e.g., total/used/avail of both block/in=
ode counts=EF=BC=89
>> >> > using proper project quota information if the quota has already set=
 to
>> >> > underlying directories of overlayfs.
>> >> >
>> >>
>> >> Do you mean project quota setting on underlying fs directories or
>> >> something else?
>> >
>> > Underlying fs directories, more accurately the directory include
>> > upperdir && workdir.
>> >
>> >>
>> >> > This feature is probably useful for most of container users and the=
re is
>> >> > no serious side effect to the other parts. We can also provide a ne=
w
>> >> > mount option to enable/disable the function according to different =
use cases.
>> >> >
>> >> > Although I'm still working on it but I'll post the RFC patch here f=
or review
>> >> > in recent days and hope to get some feedback from you. Any kind of =
suggestions
>> >> > are welcomed.
>> >> >
>> >>
>> >> I was asked about quota accounting for the merged content of overalyf=
s,
>> >> so quota would display a number resembling du -s on the overlay mount=
.
>> >> This means that "covered" lower files are not accounted for in the me=
rge.
>> >> Is that what you aim to achieve? If not, would that also be an intere=
sting case
>> >> for you to explore?
>> >> Basically, the index directory could be used to reconstruct the entir=
e quota
>> >> information for upper and lower (and copied up) files if full indexin=
g
>> >> is enabled
>> >> with nfs_export=3Don.
>> >
>> > To be honest, our use case is standard docker container with overlayfs=
 and
>> > our requirement of quota-df is accurately counting usage/avail inside =
container.
>> >
>>
>> My confusion is because I thought this was working correctly today.
>> When I posted docker support for project quota over year ago I remeber
>> the tests inside container showed reasonable behavior:
>> https://github.com/moby/moby/pull/24771
>>
>> So what I am missing is "what is wrong now?".
>
> Seems OK except I'm not fully satisfied the adjusting mechanism in specif=
ic fs.
>
>> > Lowerdirs could be share with different overlayfs, so I'm not sure cou=
nting
>> > the contents of lowerdirs is proper behavior or not. If lowerdirs are =
dedicated
>> > to one overlayfs then maybe setting same project id with upperdir can =
resolve
>> > "covered" problem that you mentioned above. Counting usage information=
 without
>> > quota might be a hard work when having plenty of files.
>> >
>>
>> Well, its a different use case, but a very well known use case -
>> When dealing with cloned files (e.g. btrfs, xfs) many files can share th=
e same
>> blocks, but each clone is fully accounted to the user/group/project.
>> This is the "thin provisioning" use case - every user gets accounted by =
files
>> that the user can reference, but the host does not pay the cost of sum o=
f all
>> user quotas.
>>
>> Without accounting of "covered" files to begin with, is it possible to
>> get to a state
>> where 'touch' on a big file gets ENOSPC/EQUOTA. This is indeed a situati=
on that
>> can happen in "thin provisioned" filesystems (e.g. btrfs) or on thin
>> provisioned block,
>> but a situation that filesystems and administrators try really hard to a=
void.
>
> Let me make clear about the term of "covered", is it meaning hidden file =
in lowerdir
> because of same named file exists in upperdir? or is it meaning the conte=
nts in
> lowerdir but in the merged dir of overlayfs?
>
>

The former. "covered" file size does not show up in du -s, so the
merged disk usage
is <upper used> + <lower used> - <covered used>

>> All I am saying is that it is "not hard" (TM) to keep track of
>> "covered" files disk usage
>> and "not hard" to re-calculate "covered" files disk usage when full
>> indexing is enabled.
>> > I don't know exactly what will happen when combining index and nfs_exp=
ort options,
>> > I need to read and understand related code later.
>> >
>>
>> nfs_export REQUIRES index and implies indexing of all files on copy up, =
not
>> only lower hardlinks.
>>
>> >>
>> >> >
>> >> > Here are some test examples share with you (based on ext4):
>> >> >
>> >> > 1) project quota enabled && without hard-limit
>> >> >
>> >> > $ df -h /mnt/test3 /mnt/test3/df/merged
>> >> > Filesystem      Size  Used Avail Use% Mounted on
>> >> > /dev/vdb3        99G  2.5G   91G   3% /mnt/test3
>> >> > overlay          92G  201M   91G   1% /mnt/test3/df/merged
>> >> >
>> >> > $ df -hi /mnt/test3 /mnt/test3/df/merged
>> >> > Filesystem     Inodes IUsed IFree IUse% Mounted on
>> >> > /dev/vdb3        6.3M  2.4K  6.3M    1% /mnt/test3
>> >> > overlay          6.3M     8  6.3M    1% /mnt/test3/df/merged
>> >> >
>> >> > 2) project quota enabled && with hard-limit
>> >> >
>> >> > $ df -h /mnt/test3 /mnt/test3/df/merged
>> >> > Filesystem      Size  Used Avail Use% Mounted on
>> >> > /dev/vdb3        99G  2.5G   91G   3% /mnt/test3
>> >> > overlay         1.0G  201M  824M  20% /mnt/test3/df/merged
>> >> >
>> >> > $ df -hi /mnt/test3 /mnt/test3/df/merged
>> >> > Filesystem     Inodes IUsed IFree IUse% Mounted on
>> >> > /dev/vdb3        6.3M  2.4K  6.3M    1% /mnt/test3
>> >> > overlay          1000     8   992    1% /mnt/test3/df/merged
>> >> >
>> >> >
>> >>
>> >> I can't follow from the example below what is the expected result and=
 why
>> >> if you add the quota setup commands that could be useful.
>> >
>> > Underlying fs using ext4 and mkfs/mount with project quota option and
>> > all needed directories(lowerdir, upperdir, workdir, merged) are set sa=
me
>> > project quota. Current quota-df implementation only adjust the couting
>> > information when having upperdir.
>> >
>>
>> Really? why is lowerdir on the same project id? For containers quota
>> only upper/work should be on the same project id. lowerdir should belong
>> to a shared project or no project at all.
>> In current docker implementation, every overlay2 driver root dir
>> is assigned a different project id, but lowerdir are symlinks to another
>> image root dir.
>
> For the setting of docker, you are completely right. My description of te=
sing
> environment in previous email is only for simple kernel testing and expla=
ining
> the condition of testing result above, not specific to docker.
>
>>
>> > In case 1:
>> > There is no hardlimit/softlimit, so the expected result as below.
>> > Used:  The used count in project quota which set to the directory
>> >        include upperdir && workdir.
>> > Avail: The avail of underlying fs
>> > Total: Used + Avail
>> >
>> > #upperdir used 201M and /mnt/test3 used 2.5G
>> >
>> > In case 2:
>> > Project quota hardlimits are block count =3D 1G, inode count =3D 1000.
>> > So the expected result as below.
>> >
>> > Used:  The used count in project quota which set to the directory
>> >        include upperdir && workdir.
>> > Avail: (a)Hardlimit - Used or (b)The avail of underlying fs(when a > b=
)
>> > Total: Used + Avail
>> >
>>
>> Are those "expected" results inline with what df shows on project quota
>> directories without overlayfs? If not, and the new behavior makes sense,
>> why change overlayfs and not change 'df'?
>
> No, those results are based on my change of overlayfs. At the first,
> I didn't notice that underlying filesystems had already implemented
> 'quota-df' function. So I plan to do something in overlayfs because
> it's better than doing same things in every low level filesystems.
> But now, I'm more willing to persuade xfs/ext4 people to midify the
> detail mechanism of 'quota-df' in specific filesystems.
>
> 'df', hmm... Both solutions could work I think.
>

I don't thing it is the underlying filesystem that implements quota-df
I think it is 'df' itself. I was also surprised to learn than, but at least=
 when
you set project quota with xfs_quota via /etc/projects /etc/projid
df just shows you the project directories as if they were mount points.
I tested with xfs on Ubuntu, but suppose with ext4 and other distro it
is no different.

Thanks,
Amir.
