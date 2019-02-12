Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20190211165323.9369-1-iforster@suse.com>
In-Reply-To: <20190211165323.9369-1-iforster@suse.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 12 Feb 2019 05:29:30 +0200
Message-ID: <CAOQ4uxhyk7BEmQYf8D6j8FvYJGaxPoa2oJePeF42jbdp__=PSA@mail.gmail.com>
Subject: Re: [RFC PATCH 0/5] Fix overlayfs on EVM
Content-Type: text/plain; charset="UTF-8"
To: Ignaz Forster <iforster@suse.com>
Cc: Mimi Zohar <zohar@linux.ibm.com>, linux-integrity <linux-integrity@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, Fabian Vogt <fvogt@suse.com>, Ignaz Forster <iforster@suse.de>
List-ID: <linux-unionfs@vger.kernel.org>

On Mon, Feb 11, 2019 at 10:28 PM Ignaz Forster <iforster@suse.com> wrote:
>
> From: Ignaz Forster <iforster@suse.de>
>
> This patch series tries to solve several problems found when using
> EVM on an overlay file system.
>
> Especially patch 4 and 5 will need further discussion; patch 4 will
> introduce follow up problems, patch 5 can be considered a workaround
> at best.
>

I think maybe the entire series (short of vfs_create hook) is a workaround.

Let's stop and think. What is IMA/EVM meant to do?
Provide tamper proof protection for persistent storage. Right?

Overlayfs uses other filesystems to store persistent data/metadata,
so if IMA/EVM already protect those other filesystems, we got
tamper proof already don't we?

The issue with overlayfs and security hooks is often credentials
because underlying filesystems are accessed with different
credentials (mounter credentials) than the overlay file access.
Is that an issue for IMA/EVM?
Or is it an issue that IMA policy is path based and may only
apply to the overlay path and not underlying path??

I had already suggested once to mark overlay inodes with
NOIMA flag:
https://marc.info/?l=linux-unionfs&m=154529013929472&w=2
and there was a similar suggestion for FUSE:
https://marc.info/?l=linux-fsdevel&m=151871326115716&w=2

If my assumptions so far are correct, then the effort for making
IMA/EVM work with overlayfs should focus around finding the
places where overlayfs uses lower level vfs interface (often
vfs_xxx helpers) and make sure that the IMA hooks are place
in those lower vfs interfaces, just like vfs_create() patch does
and like vfs_tmpfile() patch did before it.

Thanks,
Amir.
