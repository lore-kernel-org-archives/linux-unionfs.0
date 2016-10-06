From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [GIT PULL] overlayfs update for 4.9
Date: Thu, 6 Oct 2016 10:01:35 +0200
Message-ID: <CAJfpegv3TxLbp9TsbXaPdjCFmVDKpvx2y0phSCfjd3B1jcgx4w@mail.gmail.com>
References: <20161005195210.GC31239@veci.piliscsaba.szeredi.hu> <20161005234928.GJ19539@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:36847 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751594AbcJFIBh (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 6 Oct 2016 04:01:37 -0400
Received: by mail-oi0-f65.google.com with SMTP id h186so780362oia.3
        for <linux-unionfs@vger.kernel.org>; Thu, 06 Oct 2016 01:01:37 -0700 (PDT)
In-Reply-To: <20161005234928.GJ19539@ZenIV.linux.org.uk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Thu, Oct 6, 2016 at 1:49 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Wed, Oct 05, 2016 at 09:52:10PM +0200, Miklos Szeredi wrote:
>> Hi Al,
>>
>> Please pull from:
>>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs-viro
>>
>> This has an assortment of fixes and cleanups for overlayfs.
>>
>> It also touches the VFS:
>>
>>  - add the vfs_get_link() helper for calling i_op->get_link();
>>  - fix mnt_want_write_file() to freeze protect the underlying sb instead of
>>    overlay sb;
>>  - allow vfs_clone_file_range() to be called by overlayfs.
>
> Could you explain why e.g. fsetxattr() needs a different treatment in
> "vfs: mnt_want_write_file() should freeze protect underlying sb"?

Because setxattr is an i_op, not a f_op, so it's overlayfs that's
going to be called and will do the freeze protect on underlying layer
(not to mention, that it might be a different underlying sb that will
get the freeze protection in the end, due to copy up)

Thanks,
Miklos
