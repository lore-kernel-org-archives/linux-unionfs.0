From: David Howells <dhowells@redhat.com>
Subject: Re: Optional switching off cow in overlayfs
Date: Tue, 23 Jun 2015 10:27:39 +0100
Message-ID: <29219.1435051659@warthog.procyon.org.uk>
References: <55882AA5.10908@samsung.com> <5582C6C1.8080602@samsung.com> <13405.1434634748@warthog.procyon.org.uk> <5582D8F7.1060700@samsung.com> <CAJfpegsP-_MAKybYZ=uS3UCxsxL9Hv-cJ-GYrVL4h3B+tWZF9A@mail.gmail.com> <5588116E.20509@samsung.com> <CAJfpegsVqzVhq8BjCwqA+6dEZey0aNb4amnnOT_JVDfzki9v1g@mail.gmail.com> <55881B2A.7090106@samsung.com> <CAJfpegtcUt6jR7t_2Ca1osu6+-BKGtnTVVTVXEcWrqBtY0fCzA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34878 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752870AbbFWJ1n (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Tue, 23 Jun 2015 05:27:43 -0400
In-Reply-To: <55882AA5.10908@samsung.com>
Content-ID: <29218.1435051659.1@warthog.procyon.org.uk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Jan Olszak <j.olszak@samsung.com>
Cc: dhowells@redhat.com, Miklos Szeredi <miklos@szeredi.hu>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

Jan Olszak <j.olszak@samsung.com> wrote:

> >>>    But what should happen on rename or unlink?
> >> Both would operate on the original inode.
> > And that would make this hugely complex.
> Are you sure?

Unlink would be the same as now - you just whiteout over the lower layer.

Rename, though, would be complex - unless you go for the trivial option and
just error out.

The problem is that the only connection between the upper layer and lower
layer is coincidence governed by filename.  If you move the upper layer
object, the lower layer object is no longer coincident and is effectively
lost.  You cannot move the lower layer object because the lower layer may be
shared between multiple overlays.

At the moment, rename deals

You could, I suppose, store a "fall through" inode in the upper layer that has
the NFS fh of the lower layer object attached in some fashion (eg. xattr), but
it's messy.

Hard linking would be even more complex - you'd have to hard link the "fall
through" inodes on the upper layer.

David
