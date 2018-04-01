Return-Path: <cgxu519@gmx.com>
Content-Type: text/plain;
	charset=gb2312
Mime-Version: 1.0 (Mac OS X Mail 11.2 \(3445.5.20\))
Subject: Re: "quota-df" feature
From: cgxu519@gmx.com
In-Reply-To: <CAOQ4uxiGC+FeYg47Jmh2mBSoQyhg3q3en++s-bgXWy++aQW5DQ@mail.gmail.com>
Date: Sun, 1 Apr 2018 15:49:39 +0800
Content-Transfer-Encoding: quoted-printable
Message-Id: <C96B2B6F-3E2F-4E09-B634-C184311C8D67@gmx.com>
References: <trinity-cf8cc163-74dd-4b20-8372-28cbce5bfa47-1520427171633@3c-app-mailcom-bs03>
 <CAOQ4uxji73iSXeS-keVrH264iXZs6-4XkGS2rQYU2AsjT6JikQ@mail.gmail.com>
 <trinity-c4776725-d637-418a-a2f1-b317c3ed3144-1520475704072@3c-app-mailcom-bs01>
 <CAOQ4uxgcz4sAwQ6iD2dAE1aRJ6ddeJDJSLOh4g3SteKDhW6ZRA@mail.gmail.com>
 <trinity-4ed0aac2-30d8-4778-94d5-a954ba0dcacf-1520501014692@3c-app-mailcom-bs01>
 <CAOQ4uxhg0wanMESYcTdR0PFX3vdic_kT9VUWs-vqOaaJpB9sCw@mail.gmail.com>
 <trinity-974e4490-4aff-47c5-bab5-9b62491f0303-1520514601365@3c-app-mailcom-bs03>
 <CAOQ4uxggkzDMGUO0e-_a_XSOShQJF5ikFVGxT1XEGAAz_85Uwg@mail.gmail.com>
 <trinity-8980c52f-6054-4ad0-b49e-d17f6d9139d2-1520663870763@3c-app-mailcom-bs10>
 <6127BC91-8E03-4237-9AC9-C25E80FF49A2@gmx.com>
 <CAOQ4uxgtJ2DectfPvtvd=JdfHZgPo+8SAEcOTaMm6cbisLnazQ@mail.gmail.com>
 <CAOQ4uxiGC+FeYg47Jmh2mBSoQyhg3q3en++s-bgXWy++aQW5DQ@mail.gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: "cgxu519@gmx.com" <cgxu519@gmx.com>, overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

=D4=DA 2018=C4=EA4=D4=C21=C8=D5=A3=AC=CF=C2=CE=E73:00=A3=ACAmir =
Goldstein <amir73il@gmail.com> =D0=B4=B5=C0=A3=BA
>=20
> On Sun, Apr 1, 2018 at 9:53 AM, Amir Goldstein <amir73il@gmail.com> =
wrote:
>> On Sun, Apr 1, 2018 at 9:35 AM,  <cgxu519@gmx.com> wrote:
>>> =D4=DA 2018=C4=EA3=D4=C210=C8=D5=A3=AC=CF=C2=CE=E72:37=A3=ACChengguang=
 Xu <cgxu519@gmx.com> =D0=B4=B5=C0=A3=BA
>>>>=20
>>>>> Sent: Thursday, March 08, 2018 at 10:36 PM
>>>>> From: "Amir Goldstein" <amir73il@gmail.com>
>>>>> To: "Chengguang Xu" <cgxu519@gmx.com>
>>>>> Cc: overlayfs <linux-unionfs@vger.kernel.org>, "Miklos Szeredi" =
<miklos@szeredi.hu>
>>>>> Subject: Re: "quota-df" feature
>>>>>=20
>>>>> On Thu, Mar 8, 2018 at 3:10 PM, Chengguang Xu <cgxu519@gmx.com> =
wrote:
>>>>> [...]
>>>>>>>>>> Lowerdirs could be share with different overlayfs, so I'm not =
sure counting
>>>>>>>>>> the contents of lowerdirs is proper behavior or not. If =
lowerdirs are dedicated
>>>>>>>>>> to one overlayfs then maybe setting same project id with =
upperdir can resolve
>>>>>>>>>> "covered" problem that you mentioned above. Counting usage =
information without
>>>>>>>>>> quota might be a hard work when having plenty of files.
>>>>>>>>>>=20
>>>>>>>>>=20
>>>>>>>>> Well, its a different use case, but a very well known use case =
-
>>>>>>>>> When dealing with cloned files (e.g. btrfs, xfs) many files =
can share the same
>>>>>>>>> blocks, but each clone is fully accounted to the =
user/group/project.
>>>>>>>>> This is the "thin provisioning" use case - every user gets =
accounted by files
>>>>>>>>> that the user can reference, but the host does not pay the =
cost of sum of all
>>>>>>>>> user quotas.
>>>>>>>>>=20
>>>>>>>>> Without accounting of "covered" files to begin with, is it =
possible to
>>>>>>>>> get to a state
>>>>>>>>> where 'touch' on a big file gets ENOSPC/EQUOTA. This is indeed =
a situation that
>>>>>>>>> can happen in "thin provisioned" filesystems (e.g. btrfs) or =
on thin
>>>>>>>>> provisioned block,
>>>>>>>>> but a situation that filesystems and administrators try really =
hard to avoid.
>>>>>>>>=20
>>>>>>>> Let me make clear about the term of "covered", is it meaning =
hidden file in lowerdir
>>>>>>>> because of same named file exists in upperdir? or is it meaning =
the contents in
>>>>>>>> lowerdir but in the merged dir of overlayfs?
>>>>>>>>=20
>>>>>>>>=20
>>>>>>>=20
>>>>>>> The former. "covered" file size does not show up in du -s, so =
the
>>>>>>> merged disk usage
>>>>>>> is <upper used> + <lower used> - <covered used>
>>>>>>=20
>>>>>> Thanks, got it.
>>>>>> But IIUC, "covered" file does not have chance to copy-up, so
>>>>>> I'm wondering is it the real reason for getting ENOSPC/EQUOTA =
error?
>>>>>=20
>>>>> Suppose your "image" (i.e. total disk usage of lower) is 1GB
>>>>> and you want to allow user to touch all the files in the image and
>>>>> create 1GB of new files.
>>>>>=20
>>>>> If your only tool is project quota on upper then you need to set =
project
>>>>> quota hard limit to 2GB, but then user can create 2GB of new files =
and
>>>>> later when touching a lower file, will get EQUOTA on copy up.
>>>>>=20
>>>>> If you account lower uncovered files to overlay merged quota then
>>>>> you set the merged quota to 2GB and start with 50% used.
>>>>> - Copy up will not change used
>>>>> - Remove of lower will reduce used
>>>>> - You can never get EQUOTA from touching a file
>>>>=20
>>>> I get your point, I'd like to think it as "reservation" feature we =
can implement
>>>> in overlay for uncovered files, so that we can get rid of EQUOTA =
error during copy-up.
>>>> Even might get rid of ENOSPC error during copy-up when underlying =
filesystem supports
>>>> block reservation? Are there many people hope to have this kind of =
function?
>>>>=20
>>>>=20
>>>>>>>>> All I am saying is that it is "not hard" (TM) to keep track of
>>>>>>>>> "covered" files disk usage
>>>>>>>>> and "not hard" to re-calculate "covered" files disk usage when =
full
>>>>>>>>> indexing is enabled.
>>>>>>>>>> I don't know exactly what will happen when combining index =
and nfs_export options,
>>>>>>>>>> I need to read and understand related code later.
>>>>>>>>>>=20
>>>>>>>>>=20
>>>>>>>>> nfs_export REQUIRES index and implies indexing of all files on =
copy up, not
>>>>>>>>> only lower hardlinks.
>>>>>>>>>=20
>>>>>>>>>>>=20
>>>>>>>>>>>>=20
>>>>>>>>>>>> Here are some test examples share with you (based on ext4):
>>>>>>>>>>>>=20
>>>>>>>>>>>> 1) project quota enabled && without hard-limit
>>>>>>>>>>>>=20
>>>>>>>>>>>> $ df -h /mnt/test3 /mnt/test3/df/merged
>>>>>>>>>>>> Filesystem      Size  Used Avail Use% Mounted on
>>>>>>>>>>>> /dev/vdb3        99G  2.5G   91G   3% /mnt/test3
>>>>>>>>>>>> overlay          92G  201M   91G   1% /mnt/test3/df/merged
>>>>>>>>>>>>=20
>>>>>>>>>>>> $ df -hi /mnt/test3 /mnt/test3/df/merged
>>>>>>>>>>>> Filesystem     Inodes IUsed IFree IUse% Mounted on
>>>>>>>>>>>> /dev/vdb3        6.3M  2.4K  6.3M    1% /mnt/test3
>>>>>>>>>>>> overlay          6.3M     8  6.3M    1% =
/mnt/test3/df/merged
>>>>>>>>>>>>=20
>>>>>>>>>>>> 2) project quota enabled && with hard-limit
>>>>>>>>>>>>=20
>>>>>>>>>>>> $ df -h /mnt/test3 /mnt/test3/df/merged
>>>>>>>>>>>> Filesystem      Size  Used Avail Use% Mounted on
>>>>>>>>>>>> /dev/vdb3        99G  2.5G   91G   3% /mnt/test3
>>>>>>>>>>>> overlay         1.0G  201M  824M  20% /mnt/test3/df/merged
>>>>>>>>>>>>=20
>>>>>>>>>>>> $ df -hi /mnt/test3 /mnt/test3/df/merged
>>>>>>>>>>>> Filesystem     Inodes IUsed IFree IUse% Mounted on
>>>>>>>>>>>> /dev/vdb3        6.3M  2.4K  6.3M    1% /mnt/test3
>>>>>>>>>>>> overlay          1000     8   992    1% =
/mnt/test3/df/merged
>>>>>>>>>>>>=20
>>>>>>>>>>>>=20
>>>>>>>>>>>=20
>>>>>>>>>>> I can't follow from the example below what is the expected =
result and why
>>>>>>>>>>> if you add the quota setup commands that could be useful.
>>>>>>>>>>=20
>>>>>>>>>> Underlying fs using ext4 and mkfs/mount with project quota =
option and
>>>>>>>>>> all needed directories(lowerdir, upperdir, workdir, merged) =
are set same
>>>>>>>>>> project quota. Current quota-df implementation only adjust =
the couting
>>>>>>>>>> information when having upperdir.
>>>>>>>>>>=20
>>>>>>>>>=20
>>>>>>>>> Really? why is lowerdir on the same project id? For containers =
quota
>>>>>>>>> only upper/work should be on the same project id. lowerdir =
should belong
>>>>>>>>> to a shared project or no project at all.
>>>>>>>>> In current docker implementation, every overlay2 driver root =
dir
>>>>>>>>> is assigned a different project id, but lowerdir are symlinks =
to another
>>>>>>>>> image root dir.
>>>>>>>>=20
>>>>>>>> For the setting of docker, you are completely right. My =
description of tesing
>>>>>>>> environment in previous email is only for simple kernel testing =
and explaining
>>>>>>>> the condition of testing result above, not specific to docker.
>>>>>>>>=20
>>>>>>>>>=20
>>>>>>>>>> In case 1:
>>>>>>>>>> There is no hardlimit/softlimit, so the expected result as =
below.
>>>>>>>>>> Used:  The used count in project quota which set to the =
directory
>>>>>>>>>>      include upperdir && workdir.
>>>>>>>>>> Avail: The avail of underlying fs
>>>>>>>>>> Total: Used + Avail
>>>>>>>>>>=20
>>>>>>>>>> #upperdir used 201M and /mnt/test3 used 2.5G
>>>>>>>>>>=20
>>>>>>>>>> In case 2:
>>>>>>>>>> Project quota hardlimits are block count =3D 1G, inode count =
=3D 1000.
>>>>>>>>>> So the expected result as below.
>>>>>>>>>>=20
>>>>>>>>>> Used:  The used count in project quota which set to the =
directory
>>>>>>>>>>      include upperdir && workdir.
>>>>>>>>>> Avail: (a)Hardlimit - Used or (b)The avail of underlying =
fs(when a > b)
>>>>>>>>>> Total: Used + Avail
>>>>>>>>>>=20
>>>>>>>>>=20
>>>>>>>>> Are those "expected" results inline with what df shows on =
project quota
>>>>>>>>> directories without overlayfs? If not, and the new behavior =
makes sense,
>>>>>>>>> why change overlayfs and not change 'df'?
>>>>>>>>=20
>>>>>>>> No, those results are based on my change of overlayfs. At the =
first,
>>>>>>>> I didn't notice that underlying filesystems had already =
implemented
>>>>>>>> 'quota-df' function. So I plan to do something in overlayfs =
because
>>>>>>>> it's better than doing same things in every low level =
filesystems.
>>>>>>>> But now, I'm more willing to persuade xfs/ext4 people to midify =
the
>>>>>>>> detail mechanism of 'quota-df' in specific filesystems.
>>>>>>>>=20
>>>>>>>> 'df', hmm... Both solutions could work I think.
>>>>>>>>=20
>>>>>>>=20
>>>>>>> I don't thing it is the underlying filesystem that implements =
quota-df
>>>>>>> I think it is 'df' itself. I was also surprised to learn than, =
but at least when
>>>>>>> you set project quota with xfs_quota via /etc/projects =
/etc/projid
>>>>>>> df just shows you the project directories as if they were mount =
points.
>>>>>>> I tested with xfs on Ubuntu, but suppose with ext4 and other =
distro it
>>>>>>> is no different.
>>>>>>=20
>>>>>> That sounds really interesting and that must be special version =
of df command.
>>>>>> On CentOS I have never seen that. :-(
>>>>>=20
>>>>> I donno, maybe I dreamed of seeing it... most likely I am =
confusing seeing
>>>>> the correct df usage on overlayfs mount with upper that has =
project quota.
>>>>>=20
>>>>>> In any case if you take a quick look at below functions in the =
code, you will probably
>>>>>> believe what I said before. If you stop calling those functions =
in the kernel code,
>>>>>> then I guess all magic will be gone and never turn back again. =
:-)
>>>>>>=20
>>>>>> xfs:
>>>>>> xfs_qm_statvfs
>>>>>>=20
>>>>>> ext4:
>>>>>> ext4_statfs_project
>>>>>>=20
>>>>>> f2fs:
>>>>>> f2fs_statfs_project
>>>>> =3D=A1=BE--07
>>>>>>=20
>>>>>=20
>>>>> I see. so I'll wait for your RFC patch to see what =
ovl_statfs_project brings
>>>>> to the table.
>>>>=20
>>>> Seems there is nothing more to do unless we add more features like =
'reservation' we discussed above.
>>>> In this case I think we should consider adding 'reservation amount' =
to bfree, and bavail represents
>>>> the real free space amount that can be utilized by new files.
>>>=20
>>>=20
>>> Most of time underlying filesystem=A1=AFs quota-df works well, but =
when real filesystem=A1=AFs avail is lower than
>>> project quota=A1=AFs avail then the result is quite confusing. I=A1=AF=
ve only tested on xfs but I think ext4 is
>>> similar because they have same quota-df logic.
>>>=20
>>> For example, if we have 100GB xfs filesystem(/mnt/test2) and we have
>>> 3 directories(pq1, pq2, pq3) inside it, each directory sets project =
quota.
>>> (block hard limit up to 10GB)
>>>=20
>>> When avail space of real filesystem is only left 3.2MB, but when =
running df for
>>> pg1,pg2,pg3 then avail space is 9.5GB, this is much more than real =
filesystem.
>>>=20
>>>=20
>>> Detail output:
>>>=20
>>> $ df -h /mnt/test2
>>> Filesystem      Size  Used Avail Use% Mounted on
>>> /dev/vdb2       100G  100G  3.2M 100% /mnt/test2
>>>=20
>>> $ df -h /mnt/test2/pq1
>>> Filesystem      Size  Used Avail Use% Mounted on
>>> /dev/vdb2        10G  570M  9.5G   6% /mnt/test2
>>>=20
>>> $ df -h /mnt/test2/pq2
>>> Filesystem      Size  Used Avail Use% Mounted on
>>> /dev/vdb2        10G  570M  9.5G   6% /mnt/test2
>>>=20
>>> $ df -h /mnt/test2/pq3
>>> Filesystem      Size  Used Avail Use% Mounted on
>>> /dev/vdb2        10G  570M  9.5G   6% /mnt/test2
>>>=20
>>>=20
>>> So I just think if we can adjust size/used/avail in overlayfs layer =
like below,
>>> it maybe a little bit more helpful for our users. What do you think =
for this?
>>>=20
>>>=20
>>> $ df -h /mnt/test2
>>> Filesystem      Size  Used Avail Use% Mounted on
>>> /dev/vdb2       100G  100G  3.2M 100% /mnt/test2
>>>=20
>>> $ df -h /mnt/test2/pq1
>>> Filesystem      Size  Used Avail Use% Mounted on
>>> /dev/vdb2       574M  570M  3.2M 100% /mnt/test2
>>>=20
>>> $ df -h /mnt/test2/pq2
>>> Filesystem      Size  Used Avail Use% Mounted on
>>> /dev/vdb2       574M  570M  3.2M 100% /mnt/test2
>>>=20
>>> $ df -h /mnt/test2/pq3
>>> Filesystem      Size  Used Avail Use% Mounted on
>>> /dev/vdb2       574M  570M  3.2M 100% /mnt/test2
>>>=20
>>>=20
>=20
> OOPS sent by mistake.
>=20
> Chengguang,
>=20
> People on this list may have not been following the similar thread on =
xfs list
> and will wonder why the heck total size 574M
>=20
> You did not explain that is is a limitation of the current statfs() =
API and how
> df presents the information.

Sorry for lack of detail information. Because statfs(2) only collects =
size/avail
information for df and calculate used by size - avail. So here we have =
to adjust
flowing size to meet the df mechanism.


>=20
> My opinion is that at least for overlayfs use case, it is better to =
change 'df'
> then to work around its current limitation and present another =
missleading
> type of information.
>=20
> It was the same story with btrfs. 'df' was just to simple to meet the =
demands
> of reporting to user the real status of btrfs disk space, so btrfs =
tools needed
> to provide a better 'df'.
>=20
> IMO, the best course of action is to integrate 'df' with quota tools
> information,
> so that 'df' has more information and can display more accurate data.
>=20
> Overlayfs users are used to work in a container environment where not =
all
> utilities work out of the box and may need to use alternative tools or =
hacks
> inside the container, so it won't be a bug hurdle, even if this needs =
a special
> flavor of 'df=A1=AF.

All right, I get your point and I agree with your proposal.
Only one thing, I really hope put real avail info into quota-tool =
instead of df. :)

Thanks,
Chengguang.
