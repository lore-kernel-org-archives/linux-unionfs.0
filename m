From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 3/4] Overlayfs: Wrap accesses to ->d_inode on subordinate filesystems
Date: Fri, 17 Apr 2015 10:53:46 +0200
Message-ID: <CAJfpegta6LDU+pVDA1ShcdxTpMmkGuFz7-dbJ7YiuJs9opwkuQ@mail.gmail.com>
References: <20150416144241.12620.85836.stgit@warthog.procyon.org.uk>
	<20150416144309.12620.38093.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qk0-f173.google.com ([209.85.220.173]:35856 "EHLO
	mail-qk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbbDQIxr (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Fri, 17 Apr 2015 04:53:47 -0400
Received: by qku63 with SMTP id 63so148786431qku.3
        for <linux-unionfs@vger.kernel.org>; Fri, 17 Apr 2015 01:53:46 -0700 (PDT)
In-Reply-To: <20150416144309.12620.38093.stgit@warthog.procyon.org.uk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Thu, Apr 16, 2015 at 4:43 PM, David Howells <dhowells@redhat.com> wrote:
> Convert ->d_inode to d_backing_inode() or d_is_xxx() when it is being used to
> access an inode on a subordinate filesystem of an overlay - even if that
> subordinate is itself an overlay.

Why?

What if foo is on another overlay and there's a copy-up between
mutex_lock(d_backing_inode(foo)) and
mutex_unlock(d_backing_inode(foo))? Copy-up is currently not
serialized on lower inode's i_mutex in overlayfs, and I don't see why
it would need to be.

To be honest, I find any use of d_backing_inode() outside of LSM's
highly dubious.  And each of those need would need careful scrutiny.

Why not start out simple and switch everything mindlessly to d_inode(), etc?

Then add the infrastructure for d_backing_inode() to make it actually
work, and e.g. convert selinux to use it.   Keeping everything else
unconverted will result in much less likelihood of something
accidentally breaking, like the above.

Thanks,
Miklos
