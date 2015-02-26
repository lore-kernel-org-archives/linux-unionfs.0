From: Xu Wang <xuw@redhat.com>
Subject: Re: stat inconsistency with overlayfs
Date: Thu, 26 Feb 2015 01:45:37 -0500 (EST)
Message-ID: <37851744.28042779.1424933137550.JavaMail.zimbra@redhat.com>
References: <54E779BB.8030209@web2web.at> <54EEAE3A.5000006@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx3-phx2.redhat.com ([209.132.183.24]:57177 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110AbbBZGpo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Thu, 26 Feb 2015 01:45:44 -0500
In-Reply-To: <54EEAE3A.5000006@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: hujianyang <hujianyang@huawei.com>, Atom2 <ariel.atom2@web2web.at>
Cc: linux-unionfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>

Hi, Hu, Atom2,

> I don't have the Overlayfs code on 3.11 or 3.13. I've lookup the v11
> code in Miklos's git tree:
=46ortunately I got the overlay fs code of kernel V3.18, which is mostl=
y
same to v11 code in Miklos's git.

135 static int ovl_dir_getattr(struct vfsmount *mnt, struct dentry *den=
try,
136              struct kstat *stat)
137 {
138     int err;
139     enum ovl_path_type type;
140     struct path realpath;
141=20
142     type =3D ovl_path_real(dentry, &realpath);
143     err =3D vfs_getattr(&realpath, stat);
144     if (err)
145         return err;
146=20
147     stat->dev =3D dentry->d_sb->s_dev;
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ here set dev number as Hu mention=
ed
148     stat->ino =3D dentry->d_inode->i_ino;
149=20
150     /*
151      * It's probably not worth it to count subdirs to get the
152      * correct link count.  nlink=3D1 seems to pacify 'find' and
153      * other utilities.
154      */
155     if (type =3D=3D OVL_PATH_MERGE)
156         stat->nlink =3D 1;
157=20
158     return 0;
159 }

And the d_sb->s_dev is coming from the super_block of overlayfs, which =
is fake.
The super block s_dev is initialized by the call trace=20
"mount_nodev->set_anon_super-->get_anon_bdev".

Either the dir exists in lower or exists in upper, the overlay fs fakes=
 it exits in
overlay, which holds the fake device number.

Thanks,

George
--=20
George Wang =E7=8E=8B=E6=97=AD

Kernel Quantity Engineer
Red Hat Software (Beijing) Co.,Ltd
IRC:xuw
Tel:+86-010-62608041
Phone:15901231579
9/F, Tower C, Raycom
--
To unsubscribe from this list: send the line "unsubscribe linux-unionfs=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
