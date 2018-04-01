Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <C96B2B6F-3E2F-4E09-B634-C184311C8D67@gmx.com>
References: <trinity-cf8cc163-74dd-4b20-8372-28cbce5bfa47-1520427171633@3c-app-mailcom-bs03>
 <CAOQ4uxji73iSXeS-keVrH264iXZs6-4XkGS2rQYU2AsjT6JikQ@mail.gmail.com>
 <trinity-c4776725-d637-418a-a2f1-b317c3ed3144-1520475704072@3c-app-mailcom-bs01>
 <CAOQ4uxgcz4sAwQ6iD2dAE1aRJ6ddeJDJSLOh4g3SteKDhW6ZRA@mail.gmail.com>
 <trinity-4ed0aac2-30d8-4778-94d5-a954ba0dcacf-1520501014692@3c-app-mailcom-bs01>
 <CAOQ4uxhg0wanMESYcTdR0PFX3vdic_kT9VUWs-vqOaaJpB9sCw@mail.gmail.com>
 <trinity-974e4490-4aff-47c5-bab5-9b62491f0303-1520514601365@3c-app-mailcom-bs03>
 <CAOQ4uxggkzDMGUO0e-_a_XSOShQJF5ikFVGxT1XEGAAz_85Uwg@mail.gmail.com>
 <trinity-8980c52f-6054-4ad0-b49e-d17f6d9139d2-1520663870763@3c-app-mailcom-bs10>
 <6127BC91-8E03-4237-9AC9-C25E80FF49A2@gmx.com> <CAOQ4uxgtJ2DectfPvtvd=JdfHZgPo+8SAEcOTaMm6cbisLnazQ@mail.gmail.com>
 <CAOQ4uxiGC+FeYg47Jmh2mBSoQyhg3q3en++s-bgXWy++aQW5DQ@mail.gmail.com> <C96B2B6F-3E2F-4E09-B634-C184311C8D67@gmx.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sun, 1 Apr 2018 12:45:51 +0300
Message-ID: <CAOQ4uxhOLbnVW70+WhRgDSgUxYjWMb0KNVHBE3KeykMyX_kbUA@mail.gmail.com>
Subject: Re: "quota-df" feature
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Chengguang Xu <cgxu519@gmx.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Sun, Apr 1, 2018 at 10:49 AM,  <cgxu519@gmx.com> wrote:
> =E5=9C=A8 2018=E5=B9=B44=E6=9C=881=E6=97=A5=EF=BC=8C=E4=B8=8B=E5=8D=883:0=
0=EF=BC=8CAmir Goldstein <amir73il@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
>>
>> On Sun, Apr 1, 2018 at 9:53 AM, Amir Goldstein <amir73il@gmail.com> wrot=
e:
>>> On Sun, Apr 1, 2018 at 9:35 AM,  <cgxu519@gmx.com> wrote:
>>>> =E5=9C=A8 2018=E5=B9=B43=E6=9C=8810=E6=97=A5=EF=BC=8C=E4=B8=8B=E5=8D=
=882:37=EF=BC=8CChengguang Xu <cgxu519@gmx.com> =E5=86=99=E9=81=93=EF=BC=9A
>>>>>
>>>>>> Sent: Thursday, March 08, 2018 at 10:36 PM
>>>>>> From: "Amir Goldstein" <amir73il@gmail.com>
>>>>>> To: "Chengguang Xu" <cgxu519@gmx.com>
>>>>>> Cc: overlayfs <linux-unionfs@vger.kernel.org>, "Miklos Szeredi" <mik=
los@szeredi.hu>
>>>>>> Subject: Re: "quota-df" feature
>>>>>>
>>>>>> On Thu, Mar 8, 2018 at 3:10 PM, Chengguang Xu <cgxu519@gmx.com> wrot=
e:
>>>>>> [...]
>>>>>>>>>>> Lowerdirs could be share with different overlayfs, so I'm not s=
ure counting
>>>>>>>>>>> the contents of lowerdirs is proper behavior or not. If lowerdi=
rs are dedicated
>>>>>>>>>>> to one overlayfs then maybe setting same project id with upperd=
ir can resolve
>>>>>>>>>>> "covered" problem that you mentioned above. Counting usage info=
rmation without
>>>>>>>>>>> quota might be a hard work when having plenty of files.
>>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>> Well, its a different use case, but a very well known use case -
>>>>>>>>>> When dealing with cloned files (e.g. btrfs, xfs) many files can =
share the same
>>>>>>>>>> blocks, but each clone is fully accounted to the user/group/proj=
ect.
>>>>>>>>>> This is the "thin provisioning" use case - every user gets accou=
nted by files
>>>>>>>>>> that the user can reference, but the host does not pay the cost =
of sum of all
>>>>>>>>>> user quotas.
>>>>>>>>>>
>>>>>>>>>> Without accounting of "covered" files to begin with, is it possi=
ble to
>>>>>>>>>> get to a state
>>>>>>>>>> where 'touch' on a big file gets ENOSPC/EQUOTA. This is indeed a=
 situation that
>>>>>>>>>> can happen in "thin provisioned" filesystems (e.g. btrfs) or on =
thin
>>>>>>>>>> provisioned block,
>>>>>>>>>> but a situation that filesystems and administrators try really h=
ard to avoid.
>>>>>>>>>
>>>>>>>>> Let me make clear about the term of "covered", is it meaning hidd=
en file in lowerdir
>>>>>>>>> because of same named file exists in upperdir? or is it meaning t=
he contents in
>>>>>>>>> lowerdir but in the merged dir of overlayfs?
>>>>>>>>>
>>>>>>>>>
>>>>>>>>
>>>>>>>> The former. "covered" file size does not show up in du -s, so the
>>>>>>>> merged disk usage
>>>>>>>> is <upper used> + <lower used> - <covered used>
>>>>>>>
>>>>>>> Thanks, got it.
>>>>>>> But IIUC, "covered" file does not have chance to copy-up, so
>>>>>>> I'm wondering is it the real reason for getting ENOSPC/EQUOTA error=
?
>>>>>>
>>>>>> Suppose your "image" (i.e. total disk usage of lower) is 1GB
>>>>>> and you want to allow user to touch all the files in the image and
>>>>>> create 1GB of new files.
>>>>>>
>>>>>> If your only tool is project quota on upper then you need to set pro=
ject
>>>>>> quota hard limit to 2GB, but then user can create 2GB of new files a=
nd
>>>>>> later when touching a lower file, will get EQUOTA on copy up.
>>>>>>
>>>>>> If you account lower uncovered files to overlay merged quota then
>>>>>> you set the merged quota to 2GB and start with 50% used.
>>>>>> - Copy up will not change used
>>>>>> - Remove of lower will reduce used
>>>>>> - You can never get EQUOTA from touching a file
>>>>>
>>>>> I get your point, I'd like to think it as "reservation" feature we ca=
n implement
>>>>> in overlay for uncovered files, so that we can get rid of EQUOTA erro=
r during copy-up.
>>>>> Even might get rid of ENOSPC error during copy-up when underlying fil=
esystem supports
>>>>> block reservation? Are there many people hope to have this kind of fu=
nction?
>>>>>
>>>>>
>>>>>>>>>> All I am saying is that it is "not hard" (TM) to keep track of
>>>>>>>>>> "covered" files disk usage
>>>>>>>>>> and "not hard" to re-calculate "covered" files disk usage when f=
ull
>>>>>>>>>> indexing is enabled.
>>>>>>>>>>> I don't know exactly what will happen when combining index and =
nfs_export options,
>>>>>>>>>>> I need to read and understand related code later.
>>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>> nfs_export REQUIRES index and implies indexing of all files on c=
opy up, not
>>>>>>>>>> only lower hardlinks.
>>>>>>>>>>
>>>>>>>>>>>>
>>>>>>>>>>>>>
>>>>>>>>>>>>> Here are some test examples share with you (based on ext4):
>>>>>>>>>>>>>
>>>>>>>>>>>>> 1) project quota enabled && without hard-limit
>>>>>>>>>>>>>
>>>>>>>>>>>>> $ df -h /mnt/test3 /mnt/test3/df/merged
>>>>>>>>>>>>> Filesystem      Size  Used Avail Use% Mounted on
>>>>>>>>>>>>> /dev/vdb3        99G  2.5G   91G   3% /mnt/test3
>>>>>>>>>>>>> overlay          92G  201M   91G   1% /mnt/test3/df/merged
>>>>>>>>>>>>>
>>>>>>>>>>>>> $ df -hi /mnt/test3 /mnt/test3/df/merged
>>>>>>>>>>>>> Filesystem     Inodes IUsed IFree IUse% Mounted on
>>>>>>>>>>>>> /dev/vdb3        6.3M  2.4K  6.3M    1% /mnt/test3
>>>>>>>>>>>>> overlay          6.3M     8  6.3M    1% /mnt/test3/df/merged
>>>>>>>>>>>>>
>>>>>>>>>>>>> 2) project quota enabled && with hard-limit
>>>>>>>>>>>>>
>>>>>>>>>>>>> $ df -h /mnt/test3 /mnt/test3/df/merged
>>>>>>>>>>>>> Filesystem      Size  Used Avail Use% Mounted on
>>>>>>>>>>>>> /dev/vdb3        99G  2.5G   91G   3% /mnt/test3
>>>>>>>>>>>>> overlay         1.0G  201M  824M  20% /mnt/test3/df/merged
>>>>>>>>>>>>>
>>>>>>>>>>>>> $ df -hi /mnt/test3 /mnt/test3/df/merged
>>>>>>>>>>>>> Filesystem     Inodes IUsed IFree IUse% Mounted on
>>>>>>>>>>>>> /dev/vdb3        6.3M  2.4K  6.3M    1% /mnt/test3
>>>>>>>>>>>>> overlay          1000     8   992    1% /mnt/test3/df/merged
>>>>>>>>>>>>>
>>>>>>>>>>>>>
>>>>>>>>>>>>
>>>>>>>>>>>> I can't follow from the example below what is the expected res=
ult and why
>>>>>>>>>>>> if you add the quota setup commands that could be useful.
>>>>>>>>>>>
>>>>>>>>>>> Underlying fs using ext4 and mkfs/mount with project quota opti=
on and
>>>>>>>>>>> all needed directories(lowerdir, upperdir, workdir, merged) are=
 set same
>>>>>>>>>>> project quota. Current quota-df implementation only adjust the =
couting
>>>>>>>>>>> information when having upperdir.
>>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>> Really? why is lowerdir on the same project id? For containers q=
uota
>>>>>>>>>> only upper/work should be on the same project id. lowerdir shoul=
d belong
>>>>>>>>>> to a shared project or no project at all.
>>>>>>>>>> In current docker implementation, every overlay2 driver root dir
>>>>>>>>>> is assigned a different project id, but lowerdir are symlinks to=
 another
>>>>>>>>>> image root dir.
>>>>>>>>>
>>>>>>>>> For the setting of docker, you are completely right. My descripti=
on of tesing
>>>>>>>>> environment in previous email is only for simple kernel testing a=
nd explaining
>>>>>>>>> the condition of testing result above, not specific to docker.
>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>>> In case 1:
>>>>>>>>>>> There is no hardlimit/softlimit, so the expected result as belo=
w.
>>>>>>>>>>> Used:  The used count in project quota which set to the directo=
ry
>>>>>>>>>>>      include upperdir && workdir.
>>>>>>>>>>> Avail: The avail of underlying fs
>>>>>>>>>>> Total: Used + Avail
>>>>>>>>>>>
>>>>>>>>>>> #upperdir used 201M and /mnt/test3 used 2.5G
>>>>>>>>>>>
>>>>>>>>>>> In case 2:
>>>>>>>>>>> Project quota hardlimits are block count =3D 1G, inode count =
=3D 1000.
>>>>>>>>>>> So the expected result as below.
>>>>>>>>>>>
>>>>>>>>>>> Used:  The used count in project quota which set to the directo=
ry
>>>>>>>>>>>      include upperdir && workdir.
>>>>>>>>>>> Avail: (a)Hardlimit - Used or (b)The avail of underlying fs(whe=
n a > b)
>>>>>>>>>>> Total: Used + Avail
>>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>> Are those "expected" results inline with what df shows on projec=
t quota
>>>>>>>>>> directories without overlayfs? If not, and the new behavior make=
s sense,
>>>>>>>>>> why change overlayfs and not change 'df'?
>>>>>>>>>
>>>>>>>>> No, those results are based on my change of overlayfs. At the fir=
st,
>>>>>>>>> I didn't notice that underlying filesystems had already implement=
ed
>>>>>>>>> 'quota-df' function. So I plan to do something in overlayfs becau=
se
>>>>>>>>> it's better than doing same things in every low level filesystems=
.
>>>>>>>>> But now, I'm more willing to persuade xfs/ext4 people to midify t=
he
>>>>>>>>> detail mechanism of 'quota-df' in specific filesystems.
>>>>>>>>>
>>>>>>>>> 'df', hmm... Both solutions could work I think.
>>>>>>>>>
>>>>>>>>
>>>>>>>> I don't thing it is the underlying filesystem that implements quot=
a-df
>>>>>>>> I think it is 'df' itself. I was also surprised to learn than, but=
 at least when
>>>>>>>> you set project quota with xfs_quota via /etc/projects /etc/projid
>>>>>>>> df just shows you the project directories as if they were mount po=
ints.
>>>>>>>> I tested with xfs on Ubuntu, but suppose with ext4 and other distr=
o it
>>>>>>>> is no different.
>>>>>>>
>>>>>>> That sounds really interesting and that must be special version of =
df command.
>>>>>>> On CentOS I have never seen that. :-(
>>>>>>
>>>>>> I donno, maybe I dreamed of seeing it... most likely I am confusing =
seeing
>>>>>> the correct df usage on overlayfs mount with upper that has project =
quota.
>>>>>>
>>>>>>> In any case if you take a quick look at below functions in the code=
, you will probably
>>>>>>> believe what I said before. If you stop calling those functions in =
the kernel code,
>>>>>>> then I guess all magic will be gone and never turn back again. :-)
>>>>>>>
>>>>>>> xfs:
>>>>>>> xfs_qm_statvfs
>>>>>>>
>>>>>>> ext4:
>>>>>>> ext4_statfs_project
>>>>>>>
>>>>>>> f2fs:
>>>>>>> f2fs_statfs_project
>>>>>> =3D=E3=80=90--07
>>>>>>>
>>>>>>
>>>>>> I see. so I'll wait for your RFC patch to see what ovl_statfs_projec=
t brings
>>>>>> to the table.
>>>>>
>>>>> Seems there is nothing more to do unless we add more features like 'r=
eservation' we discussed above.
>>>>> In this case I think we should consider adding 'reservation amount' t=
o bfree, and bavail represents
>>>>> the real free space amount that can be utilized by new files.
>>>>
>>>>
>>>> Most of time underlying filesystem=E2=80=99s quota-df works well, but =
when real filesystem=E2=80=99s avail is lower than
>>>> project quota=E2=80=99s avail then the result is quite confusing. I=E2=
=80=99ve only tested on xfs but I think ext4 is
>>>> similar because they have same quota-df logic.
>>>>
>>>> For example, if we have 100GB xfs filesystem(/mnt/test2) and we have
>>>> 3 directories(pq1, pq2, pq3) inside it, each directory sets project qu=
ota.
>>>> (block hard limit up to 10GB)
>>>>
>>>> When avail space of real filesystem is only left 3.2MB, but when runni=
ng df for
>>>> pg1,pg2,pg3 then avail space is 9.5GB, this is much more than real fil=
esystem.
>>>>
>>>>
>>>> Detail output:
>>>>
>>>> $ df -h /mnt/test2
>>>> Filesystem      Size  Used Avail Use% Mounted on
>>>> /dev/vdb2       100G  100G  3.2M 100% /mnt/test2
>>>>
>>>> $ df -h /mnt/test2/pq1
>>>> Filesystem      Size  Used Avail Use% Mounted on
>>>> /dev/vdb2        10G  570M  9.5G   6% /mnt/test2
>>>>
>>>> $ df -h /mnt/test2/pq2
>>>> Filesystem      Size  Used Avail Use% Mounted on
>>>> /dev/vdb2        10G  570M  9.5G   6% /mnt/test2
>>>>
>>>> $ df -h /mnt/test2/pq3
>>>> Filesystem      Size  Used Avail Use% Mounted on
>>>> /dev/vdb2        10G  570M  9.5G   6% /mnt/test2
>>>>
>>>>
>>>> So I just think if we can adjust size/used/avail in overlayfs layer li=
ke below,
>>>> it maybe a little bit more helpful for our users. What do you think fo=
r this?
>>>>
>>>>
>>>> $ df -h /mnt/test2
>>>> Filesystem      Size  Used Avail Use% Mounted on
>>>> /dev/vdb2       100G  100G  3.2M 100% /mnt/test2
>>>>
>>>> $ df -h /mnt/test2/pq1
>>>> Filesystem      Size  Used Avail Use% Mounted on
>>>> /dev/vdb2       574M  570M  3.2M 100% /mnt/test2
>>>>
>>>> $ df -h /mnt/test2/pq2
>>>> Filesystem      Size  Used Avail Use% Mounted on
>>>> /dev/vdb2       574M  570M  3.2M 100% /mnt/test2
>>>>
>>>> $ df -h /mnt/test2/pq3
>>>> Filesystem      Size  Used Avail Use% Mounted on
>>>> /dev/vdb2       574M  570M  3.2M 100% /mnt/test2
>>>>
>>>>
>>
>> OOPS sent by mistake.
>>
>> Chengguang,
>>
>> People on this list may have not been following the similar thread on xf=
s list
>> and will wonder why the heck total size 574M
>>
>> You did not explain that is is a limitation of the current statfs() API =
and how
>> df presents the information.
>
> Sorry for lack of detail information. Because statfs(2) only collects siz=
e/avail
> information for df and calculate used by size - avail. So here we have to=
 adjust
> flowing size to meet the df mechanism.
>
>
>>
>> My opinion is that at least for overlayfs use case, it is better to chan=
ge 'df'
>> then to work around its current limitation and present another missleadi=
ng
>> type of information.
>>
>> It was the same story with btrfs. 'df' was just to simple to meet the de=
mands
>> of reporting to user the real status of btrfs disk space, so btrfs tools=
 needed
>> to provide a better 'df'.
>>
>> IMO, the best course of action is to integrate 'df' with quota tools
>> information,
>> so that 'df' has more information and can display more accurate data.
>>
>> Overlayfs users are used to work in a container environment where not al=
l
>> utilities work out of the box and may need to use alternative tools or h=
acks
>> inside the container, so it won't be a bug hurdle, even if this needs a =
special
>> flavor of 'df=E2=80=99.
>
> All right, I get your point and I agree with your proposal.
> Only one thing, I really hope put real avail info into quota-tool instead=
 of df. :)
>

Of course. Makes sense.

Thanks,
Amir.
