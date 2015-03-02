From: Atom2 <ariel.atom2@web2web.at>
Subject: Re: stat inconsistency with overlayfs
Date: Mon, 02 Mar 2015 21:45:39 +0100
Message-ID: <54F4CBF3.802@web2web.at>
References: <54E779BB.8030209@web2web.at> <54EEAE3A.5000006@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from grace.univie.ac.at ([131.130.3.115]:58623 "EHLO
	grace.univie.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754002AbbCBUpp (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Mon, 2 Mar 2015 15:45:45 -0500
In-Reply-To: <54EEAE3A.5000006@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: hujianyang <hujianyang@huawei.com>
Cc: linux-unionfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>

Hi Hu,
thanks for looking into this.

Am 26.02.15 um 06:25 schrieb hujianyang:
> Hi Atom2,
>
> I didn't notice this before, but I had reproduced the situation as yo=
u
> described. I'm not sure if it is a real problem.
My take on this is that stat, under all circumstances, should reliably=20
provide information about the device the queried entry resides on. In=20
case the entry only exists on the upperdir-device, overlayfs should not=
=20
fool the user that it instead resides in the r/o lowerdir when in fact=20
no such entry exists there.

In my view that's the only viable option to back-up (empty) directories=
=20
(from a running system) which only reside in the upperdir provided that=
=20
no backup is requested for the r/o (lower) file layer.
>
> The performing of 'stat' in Overlayfs are different between files and
> directories. Files directly call upper/lower getattr function but
> directories will set @dev and @ino by Overlayfs superblock itself.
In my view that then seems to defeat the purpose of the device field fo=
r=20
the stat sys-calls for overlayfs.
>
> See line 135 in fs/overlayfs/dir.c
>
> """
> static int ovl_dir_getattr(struct vfsmount *mnt, struct dentry *dentr=
y,
>                           struct kstat *stat)
> {
>          int err;
>          enum ovl_path_type type;
>          struct path realpath;
>
>          type =3D ovl_path_real(dentry, &realpath);
>          err =3D vfs_getattr(&realpath, stat);
>          if (err)
>                  return err;
>
>          stat->dev =3D dentry->d_sb->s_dev;        // I think it's th=
e cause.
>          stat->ino =3D dentry->d_inode->i_ino;
>
>          /*
>           * It's probably not worth it to count subdirs to get the
>           * correct link count.  nlink=3D1 seems to pacify 'find' and
>           * other utilities.
>           */
>          if (OVL_TYPE_MERGE(type))
>                  stat->nlink =3D 1;
>
>          return 0;
> }
> """
>
> I don't have the Overlayfs code on 3.11 or 3.13. I've lookup the v11
> code in Miklos's git tree:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git
>
> and found the code had been changed since the earliest code I could
> get. So I don't know the reason of this behavior. I guess it is used
> for filesystem consistence: directories in the same superblock have
> same device number?
=46ollowing that argument, why would that then be different for plain=20
files? In my understanding a directory in linux is not really different=
=20
from a file (both are just an abstraction of blocks from the underlying=
=20
block device) with the main difference being that the former's content=20
is interpreted by the file system code to allow traversal of=20
directories. So all operations that can be applied likewise to both=20
should provide consistent results between files and directories.

Probably there's a reason behind that difference, but it currently is=20
beyond me.

Thanks and regards Atom2
>
> On 2015/2/21 2:15, Atom2 wrote:
>> I am using find with its printf "%D" option (provides the same infor=
mation as stats device information "%d" - device number in decimal) to =
figure out whether a file system entry resides in the r/o lowerdir or t=
he r/w upperdir of an overlayfs mounted filesystem. I distinguish betwe=
en the two by getting the device number from a (plain) file know to be =
in the upperdir.
>>
>> The use case behind that is to be able to backup only files from the=
 upperdir for several systems sharing a common lowerdir filesystem. I h=
ave used that (scripted approach via rsync) now for quiet some time and=
 a few kernels back and it seemed to have worked very well.
>>
>
> I think your requirement need to be reconsidering. Maybe we could kee=
p
> the @dev for a lower-only directory?
>
> Add Cc Miklos.
>
> Thanks,
> Hu
>
>> Currently I am using kernel 3.17.7 on gentoo and I seem to observe a=
 strange behaviour (which I do not recall to have seen before on 3.13 a=
nd 3.11) with my approach as follows:
>>
>> .) plain files still work and the device number is correct
>> .) directories, however, always seem to reside in the lowerdir - eve=
n thoguh they do not exist there; in fact there's not a single file in =
the whole filesystem hierarchy that, according to stat/find, seems to r=
eside in the upperdir:
>>
>> please see the stat output for a file and a directory, both residing=
 in the same (parent) directory which is completely located in the uppe=
rdir (and does not at all exist in the lowerdir):
>> # stat serial
>>    File: =E2=80=98serial=E2=80=99
>>    Size: 17              Blocks: 8          IO Block: 4096   regular=
 file
>> Device: ca03h/51715d    Inode: 88          Links: 1
>> Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    r=
oot)
>> Access: 2014-02-19 19:01:56.278161346 +0100
>> Modify: 2014-02-19 19:01:56.278161346 +0100
>> Change: 2014-02-19 19:01:56.278161346 +0100
>>   Birth: -
>> #
>> # stat certs/
>>    File: =E2=80=98certs/=E2=80=99
>>    Size: 4096            Blocks: 8          IO Block: 4096   directo=
ry
>> Device: dh/13d  Inode: 331140      Links: 2
>> Access: (0700/drwx------)  Uid: (    0/    root)   Gid: (    0/    r=
oot)
>> Access: 2014-04-26 14:08:47.337968562 +0200
>> Modify: 2014-02-19 18:55:58.458161346 +0100
>> Change: 2014-02-19 18:55:58.458161346 +0100
>>   Birth: -
>>
>> For comparision, please see the stat of /bin which only resides in t=
he lowerdir and does not exist in the upperdir:
>> # stat /bin
>>    File: =E2=80=98/bin=E2=80=99
>>    Size: 4096            Blocks: 8          IO Block: 4096   directo=
ry
>> Device: dh/13d  Inode: 401777      Links: 2
>> Access: (0755/drwxr-xr-x)  Uid: (    0/    root)   Gid: (    0/    r=
oot)
>> Access: 2015-02-20 17:50:24.066368607 +0100
>> Modify: 2015-02-09 17:51:18.000000000 +0100
>> Change: 2015-02-09 23:58:06.011825328 +0100
>>   Birth: -
>>
>> I do not think that this is the expected behaviour and I am pretty c=
onfident that this was different on older kernels - or am I missing any=
thing/doing anything wrong here?
--
To unsubscribe from this list: send the line "unsubscribe linux-unionfs=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
