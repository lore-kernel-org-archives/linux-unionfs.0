From: Miklos Szeredi <mszeredi@redhat.com>
Subject: Re: [RFC PATCH] locks: fix file locking on overlayfs
Date: Tue, 19 Jul 2016 16:46:14 +0200
Message-ID: <CAOssrKdrSbS8=BO2rLPEOip8Cg3NgNbCGX6s_J933hRKYBEEfg@mail.gmail.com>
References: <1468931264-25837-1-git-send-email-mszeredi@redhat.com> <20160719140114.GA3335@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-lf0-f45.google.com ([209.85.215.45]:34429 "EHLO
	mail-lf0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278AbcGSOqR (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Tue, 19 Jul 2016 10:46:17 -0400
Received: by mail-lf0-f45.google.com with SMTP id l69so16460188lfg.1
        for <linux-unionfs@vger.kernel.org>; Tue, 19 Jul 2016 07:46:16 -0700 (PDT)
In-Reply-To: <20160719140114.GA3335@fieldses.org>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Jeff Layton <jlayton@poochiereds.net>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Tue, Jul 19, 2016 at 4:01 PM, J. Bruce Fields <bfields@fieldses.org> wrote:
> On Tue, Jul 19, 2016 at 02:27:44PM +0200, Miklos Szeredi wrote:
>> This patch allows flock, posix locks, ofd locks and leases to work
>> correctly on overlayfs.
>>
>> Instead of using the underlying inode for storing lock context use the
>> overlay inode.  This allows locks to be persistent across copy-up.
>
> Remind me when the overlay inode is created--is it immediately on any
> (even read-only) open?

So basically overlay has three types of inodes:  lower, upper (these
are called underlying or real inodes) and overlay inode.

Overlay inode is created on lookup, just like any other filesystem.
Overlayfs's own lookup then it proceeds to look up underlying dentry
and stores ref in the overlay dentry.

Copy-up happens on read-write open (or other modifying operation),
which creates inode on upper and copies data/metadata from lower inode
to upper inode.

Thanks,
Miklos
