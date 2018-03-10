Return-Path: <cgxu519@gmx.com>
MIME-Version: 1.0
Message-ID: <trinity-8980c52f-6054-4ad0-b49e-d17f6d9139d2-1520663870763@3c-app-mailcom-bs10>
From: "Chengguang Xu" <cgxu519@gmx.com>
Subject: Re: "quota-df" feature
Content-Type: text/plain; charset=UTF-8
Date: Sat, 10 Mar 2018 07:37:50 +0100
In-Reply-To: <CAOQ4uxggkzDMGUO0e-_a_XSOShQJF5ikFVGxT1XEGAAz_85Uwg@mail.gmail.com>
References: <trinity-cf8cc163-74dd-4b20-8372-28cbce5bfa47-1520427171633@3c-app-mailcom-bs03>
 <CAOQ4uxji73iSXeS-keVrH264iXZs6-4XkGS2rQYU2AsjT6JikQ@mail.gmail.com>
 <trinity-c4776725-d637-418a-a2f1-b317c3ed3144-1520475704072@3c-app-mailcom-bs01>
 <CAOQ4uxgcz4sAwQ6iD2dAE1aRJ6ddeJDJSLOh4g3SteKDhW6ZRA@mail.gmail.com>
 <trinity-4ed0aac2-30d8-4778-94d5-a954ba0dcacf-1520501014692@3c-app-mailcom-bs01>
 <CAOQ4uxhg0wanMESYcTdR0PFX3vdic_kT9VUWs-vqOaaJpB9sCw@mail.gmail.com>
 <trinity-974e4490-4aff-47c5-bab5-9b62491f0303-1520514601365@3c-app-mailcom-bs03>
 <CAOQ4uxggkzDMGUO0e-_a_XSOShQJF5ikFVGxT1XEGAAz_85Uwg@mail.gmail.com>
Content-Transfer-Encoding: quoted-printable
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

> Sent: Thursday, March 08, 2018 at 10:36 PM
> From: "Amir Goldstein" <amir73il@gmail=2Ecom>
> To: "Chengguang Xu" <cgxu519@gmx=2Ecom>
> Cc: overlayfs <linux-unionfs@vger=2Ekernel=2Eorg>, "Miklos Szeredi" <mik=
los@szeredi=2Ehu>
> Subject: Re: "quota-df" feature
>
> On Thu, Mar 8, 2018 at 3:10 PM, Chengguang Xu <cgxu519@gmx=2Ecom> wrote:
> [=2E=2E=2E]
> >> >> > Lowerdirs could be share with different overlayfs, so I'm not su=
re counting
> >> >> > the contents of lowerdirs is proper behavior or not=2E If lowerd=
irs are dedicated
> >> >> > to one overlayfs then maybe setting same project id with upperdi=
r can resolve
> >> >> > "covered" problem that you mentioned above=2E Counting usage inf=
ormation without
> >> >> > quota might be a hard work when having plenty of files=2E
> >> >> >
> >> >>
> >> >> Well, its a different use case, but a very well known use case -
> >> >> When dealing with cloned files (e=2Eg=2E btrfs, xfs) many files ca=
n share the same
> >> >> blocks, but each clone is fully accounted to the user/group/projec=
t=2E
> >> >> This is the "thin provisioning" use case - every user gets account=
ed by files
> >> >> that the user can reference, but the host does not pay the cost of=
 sum of all
> >> >> user quotas=2E
> >> >>
> >> >> Without accounting of "covered" files to begin with, is it possibl=
e to
> >> >> get to a state
> >> >> where 'touch' on a big file gets ENOSPC/EQUOTA=2E This is indeed a=
 situation that
> >> >> can happen in "thin provisioned" filesystems (e=2Eg=2E btrfs) or o=
n thin
> >> >> provisioned block,
> >> >> but a situation that filesystems and administrators try really har=
d to avoid=2E
> >> >
> >> > Let me make clear about the term of "covered", is it meaning hidden=
 file in lowerdir
> >> > because of same named file exists in upperdir? or is it meaning the=
 contents in
> >> > lowerdir but in the merged dir of overlayfs?
> >> >
> >> >
> >>
> >> The former=2E "covered" file size does not show up in du -s, so the
> >> merged disk usage
> >> is <upper used> + <lower used> - <covered used>
> >
> > Thanks, got it=2E
> > But IIUC, "covered" file does not have chance to copy-up, so
> > I'm wondering is it the real reason for getting ENOSPC/EQUOTA error?
>=20
> Suppose your "image" (i=2Ee=2E total disk usage of lower) is 1GB
> and you want to allow user to touch all the files in the image and
> create 1GB of new files=2E
>=20
> If your only tool is project quota on upper then you need to set project
> quota hard limit to 2GB, but then user can create 2GB of new files and
> later when touching a lower file, will get EQUOTA on copy up=2E
>=20
> If you account lower uncovered files to overlay merged quota then
> you set the merged quota to 2GB and start with 50% used=2E
> - Copy up will not change used
> - Remove of lower will reduce used
> - You can never get EQUOTA from touching a file

I get your point, I'd like to think it as "reservation" feature we can imp=
lement
in overlay for uncovered files, so that we can get rid of EQUOTA error dur=
ing copy-up=2E=20
Even might get rid of ENOSPC error during copy-up when underlying filesyst=
em supports
block reservation? Are there many people hope to have this kind of functio=
n?


> >> >> All I am saying is that it is "not hard" (TM) to keep track of
> >> >> "covered" files disk usage
> >> >> and "not hard" to re-calculate "covered" files disk usage when ful=
l
> >> >> indexing is enabled=2E
> >> >> > I don't know exactly what will happen when combining index and n=
fs_export options,
> >> >> > I need to read and understand related code later=2E
> >> >> >
> >> >>
> >> >> nfs_export REQUIRES index and implies indexing of all files on cop=
y up, not
> >> >> only lower hardlinks=2E
> >> >>
> >> >> >>
> >> >> >> >
> >> >> >> > Here are some test examples share with you (based on ext4):
> >> >> >> >
> >> >> >> > 1) project quota enabled && without hard-limit
> >> >> >> >
> >> >> >> > $ df -h /mnt/test3 /mnt/test3/df/merged
> >> >> >> > Filesystem      Size  Used Avail Use% Mounted on
> >> >> >> > /dev/vdb3        99G  2=2E5G   91G   3% /mnt/test3
> >> >> >> > overlay          92G  201M   91G   1% /mnt/test3/df/merged
> >> >> >> >
> >> >> >> > $ df -hi /mnt/test3 /mnt/test3/df/merged
> >> >> >> > Filesystem     Inodes IUsed IFree IUse% Mounted on
> >> >> >> > /dev/vdb3        6=2E3M  2=2E4K  6=2E3M    1% /mnt/test3
> >> >> >> > overlay          6=2E3M     8  6=2E3M    1% /mnt/test3/df/mer=
ged
> >> >> >> >
> >> >> >> > 2) project quota enabled && with hard-limit
> >> >> >> >
> >> >> >> > $ df -h /mnt/test3 /mnt/test3/df/merged
> >> >> >> > Filesystem      Size  Used Avail Use% Mounted on
> >> >> >> > /dev/vdb3        99G  2=2E5G   91G   3% /mnt/test3
> >> >> >> > overlay         1=2E0G  201M  824M  20% /mnt/test3/df/merged
> >> >> >> >
> >> >> >> > $ df -hi /mnt/test3 /mnt/test3/df/merged
> >> >> >> > Filesystem     Inodes IUsed IFree IUse% Mounted on
> >> >> >> > /dev/vdb3        6=2E3M  2=2E4K  6=2E3M    1% /mnt/test3
> >> >> >> > overlay          1000     8   992    1% /mnt/test3/df/merged
> >> >> >> >
> >> >> >> >
> >> >> >>
> >> >> >> I can't follow from the example below what is the expected resu=
lt and why
> >> >> >> if you add the quota setup commands that could be useful=2E
> >> >> >
> >> >> > Underlying fs using ext4 and mkfs/mount with project quota optio=
n and
> >> >> > all needed directories(lowerdir, upperdir, workdir, merged) are =
set same
> >> >> > project quota=2E Current quota-df implementation only adjust the=
 couting
> >> >> > information when having upperdir=2E
> >> >> >
> >> >>
> >> >> Really? why is lowerdir on the same project id? For containers quo=
ta
> >> >> only upper/work should be on the same project id=2E lowerdir shoul=
d belong
> >> >> to a shared project or no project at all=2E
> >> >> In current docker implementation, every overlay2 driver root dir
> >> >> is assigned a different project id, but lowerdir are symlinks to a=
nother
> >> >> image root dir=2E
> >> >
> >> > For the setting of docker, you are completely right=2E My descripti=
on of tesing
> >> > environment in previous email is only for simple kernel testing and=
 explaining
> >> > the condition of testing result above, not specific to docker=2E
> >> >
> >> >>
> >> >> > In case 1:
> >> >> > There is no hardlimit/softlimit, so the expected result as below=
=2E
> >> >> > Used:  The used count in project quota which set to the director=
y
> >> >> >        include upperdir && workdir=2E
> >> >> > Avail: The avail of underlying fs
> >> >> > Total: Used + Avail
> >> >> >
> >> >> > #upperdir used 201M and /mnt/test3 used 2=2E5G
> >> >> >
> >> >> > In case 2:
> >> >> > Project quota hardlimits are block count =3D 1G, inode count =3D=
 1000=2E
> >> >> > So the expected result as below=2E
> >> >> >
> >> >> > Used:  The used count in project quota which set to the director=
y
> >> >> >        include upperdir && workdir=2E
> >> >> > Avail: (a)Hardlimit - Used or (b)The avail of underlying fs(when=
 a > b)
> >> >> > Total: Used + Avail
> >> >> >
> >> >>
> >> >> Are those "expected" results inline with what df shows on project =
quota
> >> >> directories without overlayfs? If not, and the new behavior makes =
sense,
> >> >> why change overlayfs and not change 'df'?
> >> >
> >> > No, those results are based on my change of overlayfs=2E At the fir=
st,
> >> > I didn't notice that underlying filesystems had already implemented
> >> > 'quota-df' function=2E So I plan to do something in overlayfs becau=
se
> >> > it's better than doing same things in every low level filesystems=
=2E
> >> > But now, I'm more willing to persuade xfs/ext4 people to midify the
> >> > detail mechanism of 'quota-df' in specific filesystems=2E
> >> >
> >> > 'df', hmm=2E=2E=2E Both solutions could work I think=2E
> >> >
> >>
> >> I don't thing it is the underlying filesystem that implements quota-d=
f
> >> I think it is 'df' itself=2E I was also surprised to learn than, but =
at least when
> >> you set project quota with xfs_quota via /etc/projects /etc/projid
> >> df just shows you the project directories as if they were mount point=
s=2E
> >> I tested with xfs on Ubuntu, but suppose with ext4 and other distro i=
t
> >> is no different=2E
> >
> > That sounds really interesting and that must be special version of df =
command=2E
> > On CentOS I have never seen that=2E :-(
>=20
> I donno, maybe I dreamed of seeing it=2E=2E=2E most likely I am confusin=
g seeing
> the correct df usage on overlayfs mount with upper that has project quot=
a=2E
>=20
> > In any case if you take a quick look at below functions in the code, y=
ou will probably
> > believe what I said before=2E If you stop calling those functions in t=
he kernel code,
> > then I guess all magic will be gone and never turn back again=2E :-)
> >
> > xfs:
> > xfs_qm_statvfs
> >
> > ext4:
> > ext4_statfs_project
> >
> > f2fs:
> > f2fs_statfs_project
> =3D=E3=80=90--07=20
> >
>=20
> I see=2E so I'll wait for your RFC patch to see what ovl_statfs_project =
brings
> to the table=2E

Seems there is nothing more to do unless we add more features like 'reserv=
ation' we discussed above=2E
In this case I think we should consider adding 'reservation amount' to bfr=
ee, and bavail represents
the real free space amount that can be utilized by new files=2E


Thanks,
Chengguang=2E
