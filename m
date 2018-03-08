Return-Path: <cgxu519@gmx.com>
MIME-Version: 1.0
Message-ID: <trinity-974e4490-4aff-47c5-bab5-9b62491f0303-1520514601365@3c-app-mailcom-bs03>
From: "Chengguang Xu" <cgxu519@gmx.com>
Subject: Re: "quota-df" feature
Content-Type: text/plain; charset=UTF-8
Date: Thu, 8 Mar 2018 14:10:01 +0100
In-Reply-To: <CAOQ4uxhg0wanMESYcTdR0PFX3vdic_kT9VUWs-vqOaaJpB9sCw@mail.gmail.com>
References: <trinity-cf8cc163-74dd-4b20-8372-28cbce5bfa47-1520427171633@3c-app-mailcom-bs03>
 <CAOQ4uxji73iSXeS-keVrH264iXZs6-4XkGS2rQYU2AsjT6JikQ@mail.gmail.com>
 <trinity-c4776725-d637-418a-a2f1-b317c3ed3144-1520475704072@3c-app-mailcom-bs01>
 <CAOQ4uxgcz4sAwQ6iD2dAE1aRJ6ddeJDJSLOh4g3SteKDhW6ZRA@mail.gmail.com>
 <trinity-4ed0aac2-30d8-4778-94d5-a954ba0dcacf-1520501014692@3c-app-mailcom-bs01>
 <CAOQ4uxhg0wanMESYcTdR0PFX3vdic_kT9VUWs-vqOaaJpB9sCw@mail.gmail.com>
Content-Transfer-Encoding: quoted-printable
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

> Sent: Thursday, March 08, 2018 at 7:06 PM
> From: "Amir Goldstein" <amir73il@gmail=2Ecom>
> To: "Chengguang Xu" <cgxu519@gmx=2Ecom>
> Cc: overlayfs <linux-unionfs@vger=2Ekernel=2Eorg>, "Miklos Szeredi" <mik=
los@szeredi=2Ehu>
> Subject: Re: "quota-df" feature
>
> On Thu, Mar 8, 2018 at 11:23 AM, Chengguang Xu <cgxu519@gmx=2Ecom> wrote=
:
> >> Sent: Thursday, March 08, 2018 at 3:23 PM
> >> From: "Amir Goldstein" <amir73il@gmail=2Ecom>
> >> To: "Chengguang Xu" <cgxu519@gmx=2Ecom>
> >> Cc: overlayfs <linux-unionfs@vger=2Ekernel=2Eorg>, "Miklos Szeredi" <=
miklos@szeredi=2Ehu>
> >> Subject: Re: "quota-df" feature
> >>
> >> On Thu, Mar 8, 2018 at 4:21 AM, Chengguang Xu <cgxu519@gmx=2Ecom> wro=
te:
> >> >> Sent: Wednesday, March 07, 2018 at 9:28 PM
> >> >> From: "Amir Goldstein" <amir73il@gmail=2Ecom>
> >> >> To: "Chengguang Xu" <cgxu519@gmx=2Ecom>
> >> >> Cc: overlayfs <linux-unionfs@vger=2Ekernel=2Eorg>, "Miklos Szeredi=
" <miklos@szeredi=2Ehu>
> >> >> Subject: Re: "quota-df" feature
> >> >>
> >> >> On Wed, Mar 7, 2018 at 2:52 PM, Chengguang Xu <cgxu519@gmx=2Ecom> =
wrote:
> >> >> > Hello folks,
> >> >> >
> >> >> > Recently I'm trying to implement a feature on overlayfs for our =
users=2E
> >> >> > I'd like to call it "quota-df" which means when calling statfs(2=
),
> >> >> > override/update some fields(e=2Eg=2E, total/used/avail of both b=
lock/inode counts=EF=BC=89
> >> >> > using proper project quota information if the quota has already =
set to
> >> >> > underlying directories of overlayfs=2E
> >> >> >
> >> >>
> >> >> Do you mean project quota setting on underlying fs directories or
> >> >> something else?
> >> >
> >> > Underlying fs directories, more accurately the directory include
> >> > upperdir && workdir=2E
> >> >
> >> >>
> >> >> > This feature is probably useful for most of container users and =
there is
> >> >> > no serious side effect to the other parts=2E We can also provide=
 a new
> >> >> > mount option to enable/disable the function according to differe=
nt use cases=2E
> >> >> >
> >> >> > Although I'm still working on it but I'll post the RFC patch her=
e for review
> >> >> > in recent days and hope to get some feedback from you=2E Any kin=
d of suggestions
> >> >> > are welcomed=2E
> >> >> >
> >> >>
> >> >> I was asked about quota accounting for the merged content of overa=
lyfs,
> >> >> so quota would display a number resembling du -s on the overlay mo=
unt=2E
> >> >> This means that "covered" lower files are not accounted for in the=
 merge=2E
> >> >> Is that what you aim to achieve? If not, would that also be an int=
eresting case
> >> >> for you to explore?
> >> >> Basically, the index directory could be used to reconstruct the en=
tire quota
> >> >> information for upper and lower (and copied up) files if full inde=
xing
> >> >> is enabled
> >> >> with nfs_export=3Don=2E
> >> >
> >> > To be honest, our use case is standard docker container with overla=
yfs and
> >> > our requirement of quota-df is accurately counting usage/avail insi=
de container=2E
> >> >
> >>
> >> My confusion is because I thought this was working correctly today=2E
> >> When I posted docker support for project quota over year ago I remebe=
r
> >> the tests inside container showed reasonable behavior:
> >> https://github=2Ecom/moby/moby/pull/24771
> >>
> >> So what I am missing is "what is wrong now?"=2E
> >
> > Seems OK except I'm not fully satisfied the adjusting mechanism in spe=
cific fs=2E
> >
> >> > Lowerdirs could be share with different overlayfs, so I'm not sure =
counting
> >> > the contents of lowerdirs is proper behavior or not=2E If lowerdirs=
 are dedicated
> >> > to one overlayfs then maybe setting same project id with upperdir c=
an resolve
> >> > "covered" problem that you mentioned above=2E Counting usage inform=
ation without
> >> > quota might be a hard work when having plenty of files=2E
> >> >
> >>
> >> Well, its a different use case, but a very well known use case -
> >> When dealing with cloned files (e=2Eg=2E btrfs, xfs) many files can s=
hare the same
> >> blocks, but each clone is fully accounted to the user/group/project=
=2E
> >> This is the "thin provisioning" use case - every user gets accounted =
by files
> >> that the user can reference, but the host does not pay the cost of su=
m of all
> >> user quotas=2E
> >>
> >> Without accounting of "covered" files to begin with, is it possible t=
o
> >> get to a state
> >> where 'touch' on a big file gets ENOSPC/EQUOTA=2E This is indeed a si=
tuation that
> >> can happen in "thin provisioned" filesystems (e=2Eg=2E btrfs) or on t=
hin
> >> provisioned block,
> >> but a situation that filesystems and administrators try really hard t=
o avoid=2E
> >
> > Let me make clear about the term of "covered", is it meaning hidden fi=
le in lowerdir
> > because of same named file exists in upperdir? or is it meaning the co=
ntents in
> > lowerdir but in the merged dir of overlayfs?
> >
> >
>=20
> The former=2E "covered" file size does not show up in du -s, so the
> merged disk usage
> is <upper used> + <lower used> - <covered used>

Thanks, got it=2E
But IIUC, "covered" file does not have chance to copy-up, so=20
I'm wondering is it the real reason for getting ENOSPC/EQUOTA error?

>=20
> >> All I am saying is that it is "not hard" (TM) to keep track of
> >> "covered" files disk usage
> >> and "not hard" to re-calculate "covered" files disk usage when full
> >> indexing is enabled=2E
> >> > I don't know exactly what will happen when combining index and nfs_=
export options,
> >> > I need to read and understand related code later=2E
> >> >
> >>
> >> nfs_export REQUIRES index and implies indexing of all files on copy u=
p, not
> >> only lower hardlinks=2E
> >>
> >> >>
> >> >> >
> >> >> > Here are some test examples share with you (based on ext4):
> >> >> >
> >> >> > 1) project quota enabled && without hard-limit
> >> >> >
> >> >> > $ df -h /mnt/test3 /mnt/test3/df/merged
> >> >> > Filesystem      Size  Used Avail Use% Mounted on
> >> >> > /dev/vdb3        99G  2=2E5G   91G   3% /mnt/test3
> >> >> > overlay          92G  201M   91G   1% /mnt/test3/df/merged
> >> >> >
> >> >> > $ df -hi /mnt/test3 /mnt/test3/df/merged
> >> >> > Filesystem     Inodes IUsed IFree IUse% Mounted on
> >> >> > /dev/vdb3        6=2E3M  2=2E4K  6=2E3M    1% /mnt/test3
> >> >> > overlay          6=2E3M     8  6=2E3M    1% /mnt/test3/df/merged
> >> >> >
> >> >> > 2) project quota enabled && with hard-limit
> >> >> >
> >> >> > $ df -h /mnt/test3 /mnt/test3/df/merged
> >> >> > Filesystem      Size  Used Avail Use% Mounted on
> >> >> > /dev/vdb3        99G  2=2E5G   91G   3% /mnt/test3
> >> >> > overlay         1=2E0G  201M  824M  20% /mnt/test3/df/merged
> >> >> >
> >> >> > $ df -hi /mnt/test3 /mnt/test3/df/merged
> >> >> > Filesystem     Inodes IUsed IFree IUse% Mounted on
> >> >> > /dev/vdb3        6=2E3M  2=2E4K  6=2E3M    1% /mnt/test3
> >> >> > overlay          1000     8   992    1% /mnt/test3/df/merged
> >> >> >
> >> >> >
> >> >>
> >> >> I can't follow from the example below what is the expected result =
and why
> >> >> if you add the quota setup commands that could be useful=2E
> >> >
> >> > Underlying fs using ext4 and mkfs/mount with project quota option a=
nd
> >> > all needed directories(lowerdir, upperdir, workdir, merged) are set=
 same
> >> > project quota=2E Current quota-df implementation only adjust the co=
uting
> >> > information when having upperdir=2E
> >> >
> >>
> >> Really? why is lowerdir on the same project id? For containers quota
> >> only upper/work should be on the same project id=2E lowerdir should b=
elong
> >> to a shared project or no project at all=2E
> >> In current docker implementation, every overlay2 driver root dir
> >> is assigned a different project id, but lowerdir are symlinks to anot=
her
> >> image root dir=2E
> >
> > For the setting of docker, you are completely right=2E My description =
of tesing
> > environment in previous email is only for simple kernel testing and ex=
plaining
> > the condition of testing result above, not specific to docker=2E
> >
> >>
> >> > In case 1:
> >> > There is no hardlimit/softlimit, so the expected result as below=2E
> >> > Used:  The used count in project quota which set to the directory
> >> >        include upperdir && workdir=2E
> >> > Avail: The avail of underlying fs
> >> > Total: Used + Avail
> >> >
> >> > #upperdir used 201M and /mnt/test3 used 2=2E5G
> >> >
> >> > In case 2:
> >> > Project quota hardlimits are block count =3D 1G, inode count =3D 10=
00=2E
> >> > So the expected result as below=2E
> >> >
> >> > Used:  The used count in project quota which set to the directory
> >> >        include upperdir && workdir=2E
> >> > Avail: (a)Hardlimit - Used or (b)The avail of underlying fs(when a =
> b)
> >> > Total: Used + Avail
> >> >
> >>
> >> Are those "expected" results inline with what df shows on project quo=
ta
> >> directories without overlayfs? If not, and the new behavior makes sen=
se,
> >> why change overlayfs and not change 'df'?
> >
> > No, those results are based on my change of overlayfs=2E At the first,
> > I didn't notice that underlying filesystems had already implemented
> > 'quota-df' function=2E So I plan to do something in overlayfs because
> > it's better than doing same things in every low level filesystems=2E
> > But now, I'm more willing to persuade xfs/ext4 people to midify the
> > detail mechanism of 'quota-df' in specific filesystems=2E
> >
> > 'df', hmm=2E=2E=2E Both solutions could work I think=2E
> >
>=20
> I don't thing it is the underlying filesystem that implements quota-df
> I think it is 'df' itself=2E I was also surprised to learn than, but at =
least when
> you set project quota with xfs_quota via /etc/projects /etc/projid
> df just shows you the project directories as if they were mount points=
=2E
> I tested with xfs on Ubuntu, but suppose with ext4 and other distro it
> is no different=2E

That sounds really interesting and that must be special version of df comm=
and=2E
On CentOS I have never seen that=2E :-(
In any case if you take a quick look at below functions in the code, you w=
ill probably
believe what I said before=2E If you stop calling those functions in the k=
ernel code,=20
then I guess all magic will be gone and never turn back again=2E :-)

xfs:
xfs_qm_statvfs

ext4:
ext4_statfs_project

f2fs:
f2fs_statfs_project


Thanks,
Chengguang=2E
