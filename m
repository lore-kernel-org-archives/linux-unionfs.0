From: "J. R. Okajima" <hooanon05g@gmail.com>
Subject: Re: [PATCH 0/6] ovl: consistent_fd feature
Date: Sat, 08 Apr 2017 12:03:24 +0900
Message-ID: <19134.1491620604@jrobl>
References: <1490798166-22310-1-git-send-email-amir73il@gmail.com> <CAOQ4uxgcOD0DEZse2hWRWopDdBPsb+f=XX0SPQirbX_WGmLR-w@mail.gmail.com> <CAJfpegsidjjP_DPpAGAjUtOZEw70nu5jnoTO5E+yzPkONG4X9A@mail.gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail02-md.ns.itscom.net ([175.177.155.112]:47213 "EHLO
        mail02-md.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750717AbdDHDDd (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 7 Apr 2017 23:03:33 -0400
In-Reply-To: <CAJfpegsidjjP_DPpAGAjUtOZEw70nu5jnoTO5E+yzPkONG4X9A@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Amir Goldstein <amir73il@gmail.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

Miklos Szeredi:
> The other idea is to store the database separately from the upper tree
> (this is what aufs does, apparently).  This works for reverse mapping
> as well.  Makes all operations (except rename) more complicated.
> Keeping whole mapping in kernel memory is prone to resource hogging
> and DoS.   Could have a bitmap created by hashing the ino's that are
	:::

I am afraid you are misunderstanding a little.
Aufs XINO (external inode number translation table) is a simple regular
file.
- created and unlinked in mounting aufs, kept in-use.
- the default path is "<first writable layer>/.aufs.xino".
- users can change the path by a mount option "xino=..."
- users can change the path on the fly by remounting anytime.
- users can stop using XINO by a mount/remount option "noxino"

It should not be a kernel memory pressure (unless users put XINO on
tmpfs or something).

XINO is not a so complicated operation. Receiving the inum on the layer
fs, returns the aufs inum. Its maintenance simply follows the lifetime of
aufs inode.
- in creating aufs inode, the mapping of the layer fs inum and the aufs
  inum is added.
- in destroying aufs inode, if the link count of the layer fs inode is
  zero, then the mapping is removed.
- in copy-up, the mapping is added obviously.


J. R. Okajima
