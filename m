From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: Can ovl_drop_write() be called earlier in ovl_dentry_open()
Date: Mon, 1 Jun 2015 17:51:32 +0200
Message-ID: <CAJfpegsaZvTuSu3WBO8jABA1bA4VJuNEK30dCdNQGrZe68CqSg@mail.gmail.com>
References: <21902.1433166736@warthog.procyon.org.uk>
	<CAJfpegsuVxOAGenfxeSsQEKZR+_+OfR6uOxm2USGvbAuCWRhvg@mail.gmail.com>
	<16823.1433173503@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qg0-f43.google.com ([209.85.192.43]:34780 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753546AbbFAPvd (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Mon, 1 Jun 2015 11:51:33 -0400
Received: by qgdy38 with SMTP id y38so24027290qgd.1
        for <linux-unionfs@vger.kernel.org>; Mon, 01 Jun 2015 08:51:32 -0700 (PDT)
In-Reply-To: <16823.1433173503@warthog.procyon.org.uk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Mon, Jun 1, 2015 at 5:45 PM, David Howells <dhowells@redhat.com> wrote:
> Miklos Szeredi <miklos@szeredi.hu> wrote:
>
>> > In ovl_dentry_open(), ovl_drop_write() is called after vfs_open() - but is
>> > this actually necessary?  Can't we just drop it post-copyup?  After all,
>> > that's all we wanted the write lock for, right?
>>
>> Hmm,  that could result in a race where remount r/o of upper fs comes
>> in between copy-up and vfs_open() so copy-up succeeds but the actual
>> open fails.  It's harmless, though, and not  very likely.  So I guess
>> your patch is OK.
>
> That race is there anyway if there's no copy up, right?

No.  The race I'm talking about is that with your patch it's possible
that the file will be copied up, but open will return -EROFS.

Without your patch, that is not possible since holding write counter
for the mnt over both the copy-up and the open ensures that the
filesystem cannot become read-only in the middle.

So your patch changes behavior, but the new behavior is acceptable,
because there's no major change in semantics (it should only be
detectable by the increased disk usage in the rare case of the failed
open).

Thanks,
Miklos
