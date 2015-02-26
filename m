From: hujianyang <hujianyang@huawei.com>
Subject: Re: stat inconsistency with overlayfs
Date: Thu, 26 Feb 2015 13:25:14 +0800
Message-ID: <54EEAE3A.5000006@huawei.com>
References: <54E779BB.8030209@web2web.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([119.145.14.64]:2136 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762AbbBZFZh (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Thu, 26 Feb 2015 00:25:37 -0500
In-Reply-To: <54E779BB.8030209@web2web.at>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Atom2 <ariel.atom2@web2web.at>
Cc: linux-unionfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>

Hi Atom2,

I didn't notice this before, but I had reproduced the situation as you
described. I'm not sure if it is a real problem.

The performing of 'stat' in Overlayfs are different between files and
directories. Files directly call upper/lower getattr function but
directories will set @dev and @ino by Overlayfs superblock itself.

See line 135 in fs/overlayfs/dir.c

"""
static int ovl_dir_getattr(struct vfsmount *mnt, struct dentry *dentry,
                         struct kstat *stat)
{
        int err;
        enum ovl_path_type type;
        struct path realpath;

        type =3D ovl_path_real(dentry, &realpath);
        err =3D vfs_getattr(&realpath, stat);
        if (err)
                return err;

        stat->dev =3D dentry->d_sb->s_dev;        // I think it's the c=
ause.
        stat->ino =3D dentry->d_inode->i_ino;

        /*
         * It's probably not worth it to count subdirs to get the
         * correct link count.  nlink=3D1 seems to pacify 'find' and
         * other utilities.
         */
        if (OVL_TYPE_MERGE(type))
                stat->nlink =3D 1;

        return 0;
}
"""

I don't have the Overlayfs code on 3.11 or 3.13. I've lookup the v11
code in Miklos's git tree:

git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git

and found the code had been changed since the earliest code I could
get. So I don't know the reason of this behavior. I guess it is used
for filesystem consistence: directories in the same superblock have
same device number?

On 2015/2/21 2:15, Atom2 wrote:
> I am using find with its printf "%D" option (provides the same inform=
ation as stats device information "%d" - device number in decimal) to f=
igure out whether a file system entry resides in the r/o lowerdir or th=
e r/w upperdir of an overlayfs mounted filesystem. I distinguish betwee=
n the two by getting the device number from a (plain) file know to be i=
n the upperdir.
>=20
> The use case behind that is to be able to backup only files from the =
upperdir for several systems sharing a common lowerdir filesystem. I ha=
ve used that (scripted approach via rsync) now for quiet some time and =
a few kernels back and it seemed to have worked very well.
>=20

I think your requirement need to be reconsidering. Maybe we could keep
the @dev for a lower-only directory?

Add Cc Miklos.

Thanks,
Hu

> Currently I am using kernel 3.17.7 on gentoo and I seem to observe a =
strange behaviour (which I do not recall to have seen before on 3.13 an=
d 3.11) with my approach as follows:
>=20
> .) plain files still work and the device number is correct
> .) directories, however, always seem to reside in the lowerdir - even=
 thoguh they do not exist there; in fact there's not a single file in t=
he whole filesystem hierarchy that, according to stat/find, seems to re=
side in the upperdir:
>=20
> please see the stat output for a file and a directory, both residing =
in the same (parent) directory which is completely located in the upper=
dir (and does not at all exist in the lowerdir):
> # stat serial
>   File: =E2=80=98serial=E2=80=99
>   Size: 17              Blocks: 8          IO Block: 4096   regular f=
ile
> Device: ca03h/51715d    Inode: 88          Links: 1
> Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    ro=
ot)
> Access: 2014-02-19 19:01:56.278161346 +0100
> Modify: 2014-02-19 19:01:56.278161346 +0100
> Change: 2014-02-19 19:01:56.278161346 +0100
>  Birth: -
> #
> # stat certs/
>   File: =E2=80=98certs/=E2=80=99
>   Size: 4096            Blocks: 8          IO Block: 4096   directory
> Device: dh/13d  Inode: 331140      Links: 2
> Access: (0700/drwx------)  Uid: (    0/    root)   Gid: (    0/    ro=
ot)
> Access: 2014-04-26 14:08:47.337968562 +0200
> Modify: 2014-02-19 18:55:58.458161346 +0100
> Change: 2014-02-19 18:55:58.458161346 +0100
>  Birth: -
>=20
> For comparision, please see the stat of /bin which only resides in th=
e lowerdir and does not exist in the upperdir:
> # stat /bin
>   File: =E2=80=98/bin=E2=80=99
>   Size: 4096            Blocks: 8          IO Block: 4096   directory
> Device: dh/13d  Inode: 401777      Links: 2
> Access: (0755/drwxr-xr-x)  Uid: (    0/    root)   Gid: (    0/    ro=
ot)
> Access: 2015-02-20 17:50:24.066368607 +0100
> Modify: 2015-02-09 17:51:18.000000000 +0100
> Change: 2015-02-09 23:58:06.011825328 +0100
>  Birth: -
>=20
> I do not think that this is the expected behaviour and I am pretty co=
nfident that this was different on older kernels - or am I missing anyt=
hing/doing anything wrong here?
>=20
> Thanks and regards Atom2
> --=20
> To unsubscribe from this list: send the line "unsubscribe linux-union=
fs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
> .
>=20


--
To unsubscribe from this list: send the line "unsubscribe linux-unionfs=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
