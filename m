From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 0/6] ovl: consistent_fd feature
Date: Thu, 6 Apr 2017 17:37:54 +0200
Message-ID: <CAJfpegugsV8Lzwwiz5BncAnTVc2tPdYcG7eGrVhChcfc6CtBfw@mail.gmail.com>
References: <1490798166-22310-1-git-send-email-amir73il@gmail.com>
 <CAOQ4uxgcOD0DEZse2hWRWopDdBPsb+f=XX0SPQirbX_WGmLR-w@mail.gmail.com> <CAJfpegsidjjP_DPpAGAjUtOZEw70nu5jnoTO5E+yzPkONG4X9A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:35725 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754908AbdDFPhz (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 6 Apr 2017 11:37:55 -0400
Received: by mail-oi0-f66.google.com with SMTP id d2so7615162oig.2
        for <linux-unionfs@vger.kernel.org>; Thu, 06 Apr 2017 08:37:55 -0700 (PDT)
In-Reply-To: <CAJfpegsidjjP_DPpAGAjUtOZEw70nu5jnoTO5E+yzPkONG4X9A@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Thu, Apr 6, 2017 at 5:20 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Thu, Mar 30, 2017 at 1:34 PM, Amir Goldstein <amir73il@gmail.com> wrote:

> Simplest solution is to keep mapping in the upper inode itself
> (xattr).  Takes care of removal automatically.  Can be cached in
> ovl_entry.  Makes readdir() really inefficient... need to cache
> whether mapping needed for any directory entries in directory, which
> complicates rename.
>
> The other idea is to store the database separately from the upper tree
> (this is what aufs does, apparently).  This works for reverse mapping
> as well.  Makes all operations (except rename) more complicated.
> Keeping whole mapping in kernel memory is prone to resource hogging
> and DoS.   Could have a bitmap created by hashing the ino's that are
> in the map and setting the bit for those.  Then only reach out to the
> disk db if there's a possibility of hit.  Would still need to design
> an efficient way to store and access the data in the db (and I have
> zero experience with that sort of thing).

Hmm, could actually combine the two ideas:

Store mapping just in upper inode, walk upper tree on mount and fill
in bitmap.  Update bitmap as we go.

Reverse mapping still needs out-of-band solution, since walking the
whole upper tree each time we need to find a reverse map doesn't look
like a good solution.

Thanks,
Miklos

>
> Thoughts?
>
> Thanks,
> Miklos
