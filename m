From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v9 04/15] ovl: Create origin xattr on copy up for all
 files
Date: Mon, 8 Jan 2018 10:58:28 -0500
Message-ID: <20180108155828.GA13708@redhat.com>
References: <20171129155448.32721-1-vgoyal@redhat.com>
 <20171129155448.32721-5-vgoyal@redhat.com>
 <CAJfpegvL1ZvSq3gm5oqHR_AzeW4XHOP2V=PUyuY0ubUrxYO4cA@mail.gmail.com>
 <CAOQ4uxg1K_EA+kYzMB8LMP4B-VLxStRT3yworjMJhHWAHNTxWg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40710 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752093AbeAHP63 (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 8 Jan 2018 10:58:29 -0500
Content-Disposition: inline
In-Reply-To: <CAOQ4uxg1K_EA+kYzMB8LMP4B-VLxStRT3yworjMJhHWAHNTxWg@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>

On Mon, Jan 08, 2018 at 01:18:05PM +0200, Amir Goldstein wrote:
> On Mon, Jan 8, 2018 at 12:16 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> > On Wed, Nov 29, 2017 at 4:54 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> >> Right now my understanding is that origin xattr is created for all copied
> >> up files if index=on. And if index=off, then we create it for all type
> >> of files except hardlinks (nlink != 1).
> >>
> >> With metadata only copy up, I will still require origin xattr to copy up
> >> data later, so create it even for hardlinks even with index=off.
> >
> > This doesn't look right.  Without index we can't do hard links
> > properly, doing metacopy in that case will complicate the situation
> > further and can result in weirdness (e.g. two files that have
> > different attributes but same inode number).
> 
> But ovl_getattr() does not return lower st_ino for non-indexed
> upper with lowerstat.nlink != 1.

Hi Miklos,

Thanks Amir for ovl_gettr() behavior.

So there are 3 ways to deal with this.

A. Keep ORIGIN but do not report lower inode number if index=off, instead
   report upper inode number.

B. Do not create ORIGIN to begin with if index=off and disable metacopy
   for hardlinked files.

C. Make metacopy dependent on index=on.

currently I take approach A. That is always create ORIGIN xattr but
do not use it when we think this might be a problem. (Like for the
cases of broken hardlinks).

If you still don't like this approach, please let me know and I will
change it. And switch to say approach B?

Thanks
Vivek

> 
> >
> > So I think we should either require index for metacopy, or disable
> > metacopy only for nlink != 1 files, but otherwise enable it even in
> > case of index=off.
> >
> 
> IIRC, commit 6eaf011144af ("ovl: fix EIO from lookup of non-indexed
> upper") was a result of a conversation about this very patch and this
> very issue. After this commit, the situation of non-indexed upper with
> origin is handled correctly on lookup (hash by upper inode) and I
> couldn't find a reason why setting origin for metacopy with index=off
> is wrong. Or anything that could go wrong for setting origin on every
> copy up.
> 
> Am I missing something?
> 
> Amir.
