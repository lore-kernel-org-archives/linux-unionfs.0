Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <trinity-974e4490-4aff-47c5-bab5-9b62491f0303-1520514601365@3c-app-mailcom-bs03>
References: <trinity-cf8cc163-74dd-4b20-8372-28cbce5bfa47-1520427171633@3c-app-mailcom-bs03>
 <CAOQ4uxji73iSXeS-keVrH264iXZs6-4XkGS2rQYU2AsjT6JikQ@mail.gmail.com>
 <trinity-c4776725-d637-418a-a2f1-b317c3ed3144-1520475704072@3c-app-mailcom-bs01>
 <CAOQ4uxgcz4sAwQ6iD2dAE1aRJ6ddeJDJSLOh4g3SteKDhW6ZRA@mail.gmail.com>
 <trinity-4ed0aac2-30d8-4778-94d5-a954ba0dcacf-1520501014692@3c-app-mailcom-bs01>
 <CAOQ4uxhg0wanMESYcTdR0PFX3vdic_kT9VUWs-vqOaaJpB9sCw@mail.gmail.com> <trinity-974e4490-4aff-47c5-bab5-9b62491f0303-1520514601365@3c-app-mailcom-bs03>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 8 Mar 2018 16:36:09 +0200
Message-ID: <CAOQ4uxggkzDMGUO0e-_a_XSOShQJF5ikFVGxT1XEGAAz_85Uwg@mail.gmail.com>
Subject: Re: "quota-df" feature
Content-Type: text/plain; charset="UTF-8"
To: Chengguang Xu <cgxu519@gmx.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Mar 8, 2018 at 3:10 PM, Chengguang Xu <cgxu519@gmx.com> wrote:
[...]
>> >> > Lowerdirs could be share with different overlayfs, so I'm not sure counting
>> >> > the contents of lowerdirs is proper behavior or not. If lowerdirs are dedicated
>> >> > to one overlayfs then maybe setting same project id with upperdir can resolve
>> >> > "covered" problem that you mentioned above. Counting usage information without
>> >> > quota might be a hard work when having plenty of files.
>> >> >
>> >>
>> >> Well, its a different use case, but a very well known use case -
>> >> When dealing with cloned files (e.g. btrfs, xfs) many files can share the same
>> >> blocks, but each clone is fully accounted to the user/group/project.
>> >> This is the "thin provisioning" use case - every user gets accounted by files
>> >> that the user can reference, but the host does not pay the cost of sum of all
>> >> user quotas.
>> >>
>> >> Without accounting of "covered" files to begin with, is it possible to
>> >> get to a state
>> >> where 'touch' on a big file gets ENOSPC/EQUOTA. This is indeed a situation that
>> >> can happen in "thin provisioned" filesystems (e.g. btrfs) or on thin
>> >> provisioned block,
>> >> but a situation that filesystems and administrators try really hard to avoid.
>> >
>> > Let me make clear about the term of "covered", is it meaning hidden file in lowerdir
>> > because of same named file exists in upperdir? or is it meaning the contents in
>> > lowerdir but in the merged dir of overlayfs?
>> >
>> >
>>
>> The former. "covered" file size does not show up in du -s, so the
>> merged disk usage
>> is <upper used> + <lower used> - <covered used>
>
> Thanks, got it.
> But IIUC, "covered" file does not have chance to copy-up, so
> I'm wondering is it the real reason for getting ENOSPC/EQUOTA error?

Suppose your "image" (i.e. total disk usage of lower) is 1GB
and you want to allow user to touch all the files in the image and
create 1GB of new files.

If your only tool is project quota on upper then you need to set project
quota hard limit to 2GB, but then user can create 2GB of new files and
later when touching a lower file, will get EQUOTA on copy up.

If you account lower uncovered files to overlay merged quota then
you set the merged quota to 2GB and start with 50% used.
- Copy up will not change used
- Remove of lower will reduce used
- You can never get EQUOTA from touching a file

>
>>
>> >> All I am saying is that it is "not hard" (TM) to keep track of
>> >> "covered" files disk usage
>> >> and "not hard" to re-calculate "covered" files disk usage when full
>> >> indexing is enabled.
>> >> > I don't know exactly what will happen when combining index and nfs_export options,
>> >> > I need to read and understand related code later.
>> >> >
>> >>
>> >> nfs_export REQUIRES index and implies indexing of all files on copy up, not
>> >> only lower hardlinks.
>> >>
>> >> >>
>> >> >> >
>> >> >> > Here are some test examples share with you (based on ext4):
>> >> >> >
>> >> >> > 1) project quota enabled && without hard-limit
>> >> >> >
>> >> >> > $ df -h /mnt/test3 /mnt/test3/df/merged
>> >> >> > Filesystem      Size  Used Avail Use% Mounted on
>> >> >> > /dev/vdb3        99G  2.5G   91G   3% /mnt/test3
>> >> >> > overlay          92G  201M   91G   1% /mnt/test3/df/merged
>> >> >> >
>> >> >> > $ df -hi /mnt/test3 /mnt/test3/df/merged
>> >> >> > Filesystem     Inodes IUsed IFree IUse% Mounted on
>> >> >> > /dev/vdb3        6.3M  2.4K  6.3M    1% /mnt/test3
>> >> >> > overlay          6.3M     8  6.3M    1% /mnt/test3/df/merged
>> >> >> >
>> >> >> > 2) project quota enabled && with hard-limit
>> >> >> >
>> >> >> > $ df -h /mnt/test3 /mnt/test3/df/merged
>> >> >> > Filesystem      Size  Used Avail Use% Mounted on
>> >> >> > /dev/vdb3        99G  2.5G   91G   3% /mnt/test3
>> >> >> > overlay         1.0G  201M  824M  20% /mnt/test3/df/merged
>> >> >> >
>> >> >> > $ df -hi /mnt/test3 /mnt/test3/df/merged
>> >> >> > Filesystem     Inodes IUsed IFree IUse% Mounted on
>> >> >> > /dev/vdb3        6.3M  2.4K  6.3M    1% /mnt/test3
>> >> >> > overlay          1000     8   992    1% /mnt/test3/df/merged
>> >> >> >
>> >> >> >
>> >> >>
>> >> >> I can't follow from the example below what is the expected result and why
>> >> >> if you add the quota setup commands that could be useful.
>> >> >
>> >> > Underlying fs using ext4 and mkfs/mount with project quota option and
>> >> > all needed directories(lowerdir, upperdir, workdir, merged) are set same
>> >> > project quota. Current quota-df implementation only adjust the couting
>> >> > information when having upperdir.
>> >> >
>> >>
>> >> Really? why is lowerdir on the same project id? For containers quota
>> >> only upper/work should be on the same project id. lowerdir should belong
>> >> to a shared project or no project at all.
>> >> In current docker implementation, every overlay2 driver root dir
>> >> is assigned a different project id, but lowerdir are symlinks to another
>> >> image root dir.
>> >
>> > For the setting of docker, you are completely right. My description of tesing
>> > environment in previous email is only for simple kernel testing and explaining
>> > the condition of testing result above, not specific to docker.
>> >
>> >>
>> >> > In case 1:
>> >> > There is no hardlimit/softlimit, so the expected result as below.
>> >> > Used:  The used count in project quota which set to the directory
>> >> >        include upperdir && workdir.
>> >> > Avail: The avail of underlying fs
>> >> > Total: Used + Avail
>> >> >
>> >> > #upperdir used 201M and /mnt/test3 used 2.5G
>> >> >
>> >> > In case 2:
>> >> > Project quota hardlimits are block count = 1G, inode count = 1000.
>> >> > So the expected result as below.
>> >> >
>> >> > Used:  The used count in project quota which set to the directory
>> >> >        include upperdir && workdir.
>> >> > Avail: (a)Hardlimit - Used or (b)The avail of underlying fs(when a > b)
>> >> > Total: Used + Avail
>> >> >
>> >>
>> >> Are those "expected" results inline with what df shows on project quota
>> >> directories without overlayfs? If not, and the new behavior makes sense,
>> >> why change overlayfs and not change 'df'?
>> >
>> > No, those results are based on my change of overlayfs. At the first,
>> > I didn't notice that underlying filesystems had already implemented
>> > 'quota-df' function. So I plan to do something in overlayfs because
>> > it's better than doing same things in every low level filesystems.
>> > But now, I'm more willing to persuade xfs/ext4 people to midify the
>> > detail mechanism of 'quota-df' in specific filesystems.
>> >
>> > 'df', hmm... Both solutions could work I think.
>> >
>>
>> I don't thing it is the underlying filesystem that implements quota-df
>> I think it is 'df' itself. I was also surprised to learn than, but at least when
>> you set project quota with xfs_quota via /etc/projects /etc/projid
>> df just shows you the project directories as if they were mount points.
>> I tested with xfs on Ubuntu, but suppose with ext4 and other distro it
>> is no different.
>
> That sounds really interesting and that must be special version of df command.
> On CentOS I have never seen that. :-(

I donno, maybe I dreamed of seeing it... most likely I am confusing seeing
the correct df usage on overlayfs mount with upper that has project quota.

> In any case if you take a quick look at below functions in the code, you will probably
> believe what I said before. If you stop calling those functions in the kernel code,
> then I guess all magic will be gone and never turn back again. :-)
>
> xfs:
> xfs_qm_statvfs
>
> ext4:
> ext4_statfs_project
>
> f2fs:
> f2fs_statfs_project
>
>

I see. so I'll wait for your RFC patch to see what ovl_statfs_project brings
to the table.

Cheers,
Amir.
