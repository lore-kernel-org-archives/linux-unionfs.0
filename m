From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: LXC+overlayfs in unprivileged mode
Date: Sun, 1 Jan 2017 10:51:26 +0200
Message-ID: <CAOQ4uxi51_0C_-YVz_UYUbOWW3rSjmKv4NUkyxq0oCaWexZ6hw@mail.gmail.com>
References: <CAHrUA37sR6ea6UNJZjbAHPWwkoTbtEg7Uq8Z1war9ODA23qcSw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:34126 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751350AbdAAIv1 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 1 Jan 2017 03:51:27 -0500
In-Reply-To: <CAHrUA37sR6ea6UNJZjbAHPWwkoTbtEg7Uq8Z1war9ODA23qcSw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linasvepstas@gmail.com
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Vivek Goyal <vgoyal@redhat.com>, Seth Forshee <seth.forshee@canonical.com>, "Eric W. Biederman" <ebiederm@xmission.com>

On Sat, Dec 31, 2016 at 7:42 PM, Linas Vepstas <linasvepstas@gmail.com> wrote:
> Hi,
>
> I tripped across an LXC bug that actually appears to be an overlayfs
> security feature (maybe) and was wondering how to clarify the status
> of the code. Apparently, Ubuntu is carrying patches that enable this
> function, and so the question is if these or something more appropriate
> can be pulled into the mainline kernel or into overlayfs (or perhaps they
> have been already; the situation is confusing).
>

The foundations for mount from unprivileged user namespace were merged
to kernel v4.8, you can read more about it in Eric's pull request:
https://lkml.org/lkml/2016/7/26/297

Seth Forshee was working on these vfs changes to allow fuse mount in
unprivileged user namespace:
https://lwn.net/Articles/685239/

Not sure about the status of the work on fuse mount?

> The issue is that LXC+overlayfs seems to not work in an unprivileged
> container. A more detailed description, with a particularly simple test
> case is given in https://github.com/lxc/lxc/issues/1370#issuecomment269845311
> Based on searches through google, it seems likely that the reason it
> does not work is due to one or more privilege-escalation exploits,
> except that these may or may not be patched already... thus this email.
>
> Any advice on how to proceed?

Not sure what you want to achieve?
If you just want to enable overlayfs mount in unprivileged container on
your own kernel at your own risk (i.e. of exposure to exploits), you should
probably use latest kernel and carry this (untested!) patch:

static struct file_system_type ovl_fs_type = {
        .owner          = THIS_MODULE,
        .name           = "overlay",
+       .fs_flags       = FS_USERNS_MOUNT,
        .mount          = ovl_mount,
        .kill_sb        = kill_anon_super,
};

If you want to get this patch up-streamed, you "only" need to prove
there are no more privilege-escalation exploits in overlayfs, like the one
you referenced above...

Because it is going be quite hard to provide that proof, it is much more
likely to see this patch in a distribution (e.g. Ubuntu) that is willing to
compromise security for a feature, then to see this feature enabled upstream.

On the bright side, sanitizing overlayfs for unprivileged container mount
is probably a much closer goal then sanitizing a blockdev filesystem for
unprivileged container (loop) mount.

I hope my brief was accurate. Seth/Eric/Miklos, please correct me if it wasn't.

Amir.
