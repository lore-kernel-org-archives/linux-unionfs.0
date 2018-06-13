From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 14/39] ovl: stack file ops
Date: Wed, 13 Jun 2018 11:21:30 +0200
Message-ID: <CAJfpegsnvxUNCaE4c1_UDKq169i8WBTMuWzyvyo8UvenqZCUXg@mail.gmail.com>
References: <20180529144339.16538-1-mszeredi@redhat.com> <20180529144339.16538-15-mszeredi@redhat.com>
 <20180610041243.GJ30522@ZenIV.linux.org.uk> <CAJfpegtEGuBqmJ+6Kzd0456o0xyebe3LBk66xWQcuzsenqKVeg@mail.gmail.com>
 <20180612022926.GY30522@ZenIV.linux.org.uk> <20180612024029.GZ30522@ZenIV.linux.org.uk>
 <CAJfpegvUkcUw0GXxFesT6V2f27EXW7jkvBpvnG4XB49BPdvjjA@mail.gmail.com>
 <20180612182423.GA30522@ZenIV.linux.org.uk> <20180612183123.GB30522@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180612183123.GB30522@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <mszeredi@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-unionfs@vger.kernel.org

On Tue, Jun 12, 2018 at 8:31 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Tue, Jun 12, 2018 at 07:24:23PM +0100, Al Viro wrote:

>> I hate it, but... consider path_open() objections withdrawn for now.

Is that an ACK for the pull if I follow up with fixes for mmap botch, etc?

>> Uses of ->vm_file (and rules for those) are too convoluted to untangle
>> at the moment.  I still would love to get that straightened out, but
>> it's not this cycle fodder, more's the pity...

Looked at some other options...  What coda mmap does looks very
dubious.  It only sets f_mapping, not vm_file.  That's going to get
into all sorts of trouble when underlying fs tries to look at
file_inode() or worse, ->private_data.  Looks like that should be
converted to what overlayfs does, to have a remote chance of actually
not crashing on most filesystems.  Does anybody actually use coda
still?

> PS: conversion of ->f_path.dentry is easy and that can probably go this
> cycle - it's a fairly trivial change, with no functional changes unless
> overlayfs is used with <filesystem>, fixing really bad shit if it ever
> gets used thus.  I'm not asking to put that into overlayfs pull *and*
> it's independent from the "want to kill that fucking kludge" stuff.
> The latter is too hard for this cycle, unfortunately.

So this is about adding a file_dentry_check() (or whatever we want to
call it) helper to be used by all filesystems when dereferecing
f_path.dentry, right?

Thanks,
Miklos
