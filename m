From: David Howells <dhowells@redhat.com>
Subject: Re: Can ovl_drop_write() be called earlier in ovl_dentry_open()
Date: Mon, 01 Jun 2015 16:53:49 +0100
Message-ID: <17015.1433174029@warthog.procyon.org.uk>
References: <CAJfpegsaZvTuSu3WBO8jABA1bA4VJuNEK30dCdNQGrZe68CqSg@mail.gmail.com> <21902.1433166736@warthog.procyon.org.uk> <CAJfpegsuVxOAGenfxeSsQEKZR+_+OfR6uOxm2USGvbAuCWRhvg@mail.gmail.com> <16823.1433173503@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45665 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751479AbbFAPxy (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Mon, 1 Jun 2015 11:53:54 -0400
In-Reply-To: <CAJfpegsaZvTuSu3WBO8jABA1bA4VJuNEK30dCdNQGrZe68CqSg@mail.gmail.com>
Content-ID: <17014.1433174029.1@warthog.procyon.org.uk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: dhowells@redhat.com, Al Viro <viro@zeniv.linux.org.uk>, Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

Miklos Szeredi <miklos@szeredi.hu> wrote:

> >> Hmm,  that could result in a race where remount r/o of upper fs comes
> >> in between copy-up and vfs_open() so copy-up succeeds but the actual
> >> open fails.  It's harmless, though, and not  very likely.  So I guess
> >> your patch is OK.
> >
> > That race is there anyway if there's no copy up, right?
> 
> No.  The race I'm talking about is that with your patch it's possible
> that the file will be copied up, but open will return -EROFS.

Ah, I see what you're getting at.

> Without your patch, that is not possible since holding write counter
> for the mnt over both the copy-up and the open ensures that the
> filesystem cannot become read-only in the middle.
> 
> So your patch changes behavior, but the new behavior is acceptable,
> because there's no major change in semantics (it should only be
> detectable by the increased disk usage in the rare case of the failed
> open).

Okay.

David
