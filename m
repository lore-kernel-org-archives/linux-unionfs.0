From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: procfs reports unexpected mnt_id and path for overlayfs files
Date: Wed, 15 Apr 2015 17:07:26 +0200
Message-ID: <CAJfpegvKvuu7mtxz+nV1qxpEddf2ZMroBaz+rkFTFVQZ2PoQRw@mail.gmail.com>
References: <20150415085013.GA8907@odin.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-vn0-f43.google.com ([209.85.216.43]:41425 "EHLO
	mail-vn0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754621AbbDOPH2 (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Wed, 15 Apr 2015 11:07:28 -0400
Received: by vnbg190 with SMTP id g190so16109585vnb.8
        for <linux-unionfs@vger.kernel.org>; Wed, 15 Apr 2015 08:07:27 -0700 (PDT)
In-Reply-To: <20150415085013.GA8907@odin.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Andrew Vagin <avagin@odin.com>
Cc: criu@openvz.org, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, saied@google.com

On Wed, Apr 15, 2015 at 10:50 AM, Andrew Vagin <avagin@odin.com> wrote:
> Hello Miklos and Everyone else,
>
> We have a report that a container with overlayfs can't be checkpointed.
>
> To dump file descriptors we get information from /proc/pid/fd/ and /proc/pid/fdinfo.
>
> But in case of overlayfs we see unexpected values there.
>
> /proc/PID/fdinfo/FD contains mnt_id which isn't presented in /proc/pid/mountinfo.
> /proc/PID/fd/FD does not contain an absolute path to the opened file.
>
> Can someone help to fix these issues?

See this:

https://lkml.org/lkml/2015/3/20/372

Al didn't like that patch.  But it definitely will be fixed, one way
or the other, in the near future.

Thanks,
Miklos
