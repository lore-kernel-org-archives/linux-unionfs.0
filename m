Return-Path: <James.Bottomley@hansenpartnership.com>
Message-ID: <1575148763.5563.28.camel@HansenPartnership.com>
Subject: [PATCH 0/1] preparatory patch for a uid/gid shifting bind mount
From: James Bottomley <James.Bottomley@HansenPartnership.com>
Date: Sat, 30 Nov 2019 13:19:23 -0800
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org
Cc: dhowells@redhat.com, Al Viro <viro@ZenIV.linux.org.uk>, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, Seth Forshee <seth.forshee@canonical.com>
List-ID: <linux-unionfs@vger.kernel.org>

I had another look at what it would take to reimplement shiftfs as a
true bind mount.  It turns out we do have struct path threaded in
almost enough places to make it work.  There really is only one API
that needs updating and that's notify_change(), so the following patch
fixes that and pulls do_truncate() along as well.  The updates are
mostly smooth and pretty obvious because the path was actually already
present, except for in overlayfs where trying to sort out what the path
should be is somewhat of a nightmare.  If the overlayfs people could
take a look and make sure I got it right, I'd be grateful.

I think this is the only needed change, but I've only just got a
functional implementation of a uid/gid shifting bind mount, so there
might be other places that need rethreading as I find deficiencies in
the current implementation.  I'll send them along as additional patches
if I find them

James
