From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: Overlayfs reverse mapping
Date: Fri, 21 Apr 2017 15:24:50 +0200
Message-ID: <CAJfpegv7kR-zDaE2wfD5e=_yUVnxDLMe28okMm3tTrURjLT1XQ@mail.gmail.com>
References: <CAOQ4uxid0C3PLnfopBWAtWkNqyuMkickoUrZzDmj6-bEOWCDcA@mail.gmail.com>
 <CAJfpegtWH0P87mYMRB+sLpa0RSOVjvo4Ph1DH8E41UJiyJjiKw@mail.gmail.com> <CAOQ4uxhTaY4N5_02kg+5fK0nYLFyEKVVFfWtO5AeC33Qc7CNDw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f52.google.com ([209.85.218.52]:35746 "EHLO
        mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1039803AbdDUNYw (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 21 Apr 2017 09:24:52 -0400
Received: by mail-oi0-f52.google.com with SMTP id j201so94939091oih.2
        for <linux-unionfs@vger.kernel.org>; Fri, 21 Apr 2017 06:24:52 -0700 (PDT)
In-Reply-To: <CAOQ4uxhTaY4N5_02kg+5fK0nYLFyEKVVFfWtO5AeC33Qc7CNDw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Thu, Apr 20, 2017 at 11:22 AM, Amir Goldstein <amir73il@gmail.com> wrote:

> I wanted to run another idea by you.
> Instead of storing the overlay inode index under workdir/inodes,
> store it under upperdir/lost+found.
>
> Crazy? think about it..
> - User applications won't touch that dir, because it is already reserved
>   for use by mkfs/fsck tools.

OTOH lost+found is just a plain old directory that is handled by
userspace tools only.  No kernel fs driver treats /lost+found
specially.  So putting this in upperdir would be a namespace pollution
issue and generally we'd like to avoid that.  Aufs has lived with that
sort of thing, and probably it wouldn't be a problem in practice.  But
I think that if we can avoid namespace confusion then we should.

Thanks,
Miklos
