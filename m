From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: Overlayfs reverse mapping
Date: Thu, 20 Apr 2017 12:22:00 +0300
Message-ID: <CAOQ4uxhTaY4N5_02kg+5fK0nYLFyEKVVFfWtO5AeC33Qc7CNDw@mail.gmail.com>
References: <CAOQ4uxid0C3PLnfopBWAtWkNqyuMkickoUrZzDmj6-bEOWCDcA@mail.gmail.com>
 <CAJfpegtWH0P87mYMRB+sLpa0RSOVjvo4Ph1DH8E41UJiyJjiKw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:32875 "EHLO
        mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941662AbdDTJWH (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 20 Apr 2017 05:22:07 -0400
Received: by mail-oi0-f47.google.com with SMTP id y11so10100256oie.0
        for <linux-unionfs@vger.kernel.org>; Thu, 20 Apr 2017 02:22:01 -0700 (PDT)
In-Reply-To: <CAJfpegtWH0P87mYMRB+sLpa0RSOVjvo4Ph1DH8E41UJiyJjiKw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Wed, Apr 19, 2017 at 4:15 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Wed, Apr 19, 2017 at 1:34 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>
>> I am contemplating a scheme similar to your suggestion, but instead of
>> a shadow directory tree, index forward redirects by stable inode number
>> and store upper and lower redirects as xattr, e.g.:
>>
>> workdir/inodes/#100
>
> Interesting idea.

I wanted to run another idea by you.
Instead of storing the overlay inode index under workdir/inodes,
store it under upperdir/lost+found.

Crazy? think about it..
- User applications won't touch that dir, because it is already reserved
  for use by mkfs/fsck tools.
- It is actually going to be used by a future fsck.overlay tool, to reindex
  after layers migration.
- Taking the analogy to traditional lost+found even further, the
   files found in traditional lost+found are also named #<ino> and
   when you open them you get an fd to the inode.
   In case of hardlinked #<ino> (non-dir) you will actually get the
   same behavior as the traditional lost+found, except that inodes
   could have nlink > 1. directory inode entries could appear as
   empty dir to user or they could be stored as whiteouts, so user
   doesn't see them.
- This keeps workdir content volatile (and not only workdir/work)
   it may matter because container managers would pack upper
   dir when committing changes to an image, but they would not
   pack workdir (I think).


>
>> contains xattrs:
>> overlay.fh - fh of lower inode (whose ino is 100)
>> overlay.redirect - path of lower inode (so fh and stale ino can be
>> fixed after copying layers)
>> overlay.upper - fh of upper inode
>> overlay.path - path (*) of upper (so upper fh can be fixed after copying layers)
>
> I get ".redirect" and ".upper" but not the others.  In fact the lower
> fh can actually be used to generate the name of the file, so we don't
> have to encode lower ino separately into the overlay fh.
>

Forgot to CC the list when I wrote that you are right.
We don't need overlay.fh on the inode entry and
overlay.path may be needed for a later "commit before migrate"
tool, but don't need to worry about that now.

Amir.
