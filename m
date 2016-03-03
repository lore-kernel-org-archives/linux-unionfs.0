From: Sedat Dilek <sedat.dilek@gmail.com>
Subject: Re: [PATCH] ovl: copy new uid/gid into overlayfs runtime inode
Date: Thu, 3 Mar 2016 19:58:23 +0100
Message-ID: <CA+icZUXuOnsq0XU+QvkFw4SEX=AJmLME6hVOQ7sxz64GMHKthQ@mail.gmail.com>
References: <145424648900.10573.4331586687947621230.stgit@zurg>
	<CAJfpegvssUL0cq+PFzh69mTVVs7CJnqBWsRg+Oxo+Tzx5Gf1Vw@mail.gmail.com>
Reply-To: sedat.dilek@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-vk0-f48.google.com ([209.85.213.48]:33323 "EHLO
	mail-vk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756683AbcCCS6Y (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Thu, 3 Mar 2016 13:58:24 -0500
In-Reply-To: <CAJfpegvssUL0cq+PFzh69mTVVs7CJnqBWsRg+Oxo+Tzx5Gf1Vw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, Kernel Mailing List <linux-kernel@vger.kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>

On 3/3/16, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Sun, Jan 31, 2016 at 2:21 PM, Konstantin Khlebnikov <koct9i@gmail.com>
> wrote:
>> Overlayfs must update uid/gid after chown, otherwise functions
>> like inode_owner_or_capable() will check user against stale uid.
>> Catched by xfstests generic/087, it chowns file and calls utimes.
>
> Queued up patch.  Thanks.
>

In which Git tree you do that?
[1] points to [2], still true?

- Sedat -

[1] http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/MAINTAINERS#n8110
[2] http://git.kernel.org/cgit/linux/kernel/git/mszeredi/vfs.git/

> Miklos
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
