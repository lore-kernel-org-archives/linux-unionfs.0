From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH] overlayfs: Warn on copy up if a process has a R/O fd open
 to the lower file
Date: Mon, 7 Mar 2016 11:06:14 +0100
Message-ID: <CAJfpegtXhpEBOxzS=HRirZ-har6jc0TX+Fp0VkjebGqtOr3ooA@mail.gmail.com>
References: <9569.1436277884@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-ob0-f178.google.com ([209.85.214.178]:35793 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532AbcCGKGR (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Mon, 7 Mar 2016 05:06:17 -0500
Received: by mail-ob0-f178.google.com with SMTP id xx9so100750384obc.2
        for <linux-unionfs@vger.kernel.org>; Mon, 07 Mar 2016 02:06:15 -0800 (PST)
In-Reply-To: <9569.1436277884@warthog.procyon.org.uk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Tue, Jul 7, 2015 at 4:04 PM, David Howells <dhowells@redhat.com> wrote:
>
> Print a warning when overlayfs copies up a file if the process that triggered
> the copy up has a R/O fd open to the lower file being copied up.
>
> This can help catch applications that do things like the following:
>
>         fd1 = open("foo", O_RDONLY);
>         fd2 = open("foo", O_RDWR);
>
> where they expect fd1 and fd2 to refer to the same file - which will no longer
> be the case post-copy up.
>
> With this patch, the following commands:
>
>         bash 5</mnt/a/foo128
>         6<>/mnt/a/foo128
>
> assuming /mnt/a/foo128 to be an un-copied up file on an overlay will produce
> the following warning in the kernel log:
>
>         overlayfs: Copying up foo129, but open R/O on fd 5 which will cease to
>         be coherent [pid=3818 bash]
>
> This is enabled by setting:
>
>         /sys/module/overlay/parameters/check_copy_up
>
> to 1.
>
> The warnings are ratelimited and are also limited to one warning per file -
> assuming the copy up completes in each case.
>

Queued.

Thanks,
Miklos
