From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 3/3] ovl: redirect on rename-dir
Date: Sun, 13 Nov 2016 12:00:58 +0200
Message-ID: <CAOQ4uxiC+O93=Dbgogc-GpL_7rF-qCRXeGzy3epVfpZRHNQf=A@mail.gmail.com>
References: <1477380887-21333-1-git-send-email-mszeredi@redhat.com>
 <1477380887-21333-4-git-send-email-mszeredi@redhat.com> <20161025115748.ydhkkp5cfcdnjzwn@home.ouaza.com>
 <CAJfpegu97ce6LtMeKSHqDxZGAtCJUGgYUwOwYm9P6p8XtNXf_A@mail.gmail.com>
 <CALYGNiN_Hj+4Kf4HJihu5OEkNFU+zzioz5Cc1oHpJ8Wggi0M8Q@mail.gmail.com>
 <20161107110319.7goz3ym3e6fu5lag@home.ouaza.com> <CALYGNiP=BjxrU9YLL=bGJ5yXSefGMWEAU8ni23mUipL3frjhzA@mail.gmail.com>
 <20161107134215.2v5leafss2mamim5@home.ouaza.com> <CAJfpeguvHgWuefxfB76qPh8xGW74tuB1q3kgXvEBw5qY80xz-w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35118 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932954AbcKMKBB (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 13 Nov 2016 05:01:01 -0500
In-Reply-To: <CAJfpeguvHgWuefxfB76qPh8xGW74tuB1q3kgXvEBw5qY80xz-w@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Raphael Hertzog <hertzog@debian.org>, Konstantin Khlebnikov <koct9i@gmail.com>, Miklos Szeredi <mszeredi@redhat.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, Guillem Jover <guillem@debian.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

On Fri, Nov 11, 2016 at 12:39 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> New version is at:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git #redirect
>
> News:
> - it actually should work in all cases
> - when rename is not cross directory, just store the new name instead
> of a full path, as suggested by Amir
> - when redirect path is too long fall back to EXDEV (the max length
> should probably be a module param)
>

Looks goods, except for the case of change from relative to absolute
redirect of the victim dentry. IIUC, ovl_set_redirect() will return immediately
because ovl_dentry_is_redirect() and will not get to setting the absolute
redirect.

It passed my sanity tests (including recycle test) and on top of my copy up
lock changes.

You can add Reviewed-by/Tested-by me to
  1380846 ovl: redirect on rename-dir

> About turning the feature on or off.  Yes, maybe the empty checking is
> too complicated.  Going one simpler:
>
>  - default to old behavior, turn on with mount option
>  - add module option and kernel compile option to turn on the feature by default
>

I don't see these changes on your branch.
Are these your plans for a future version?

Thanks,
Amir.
