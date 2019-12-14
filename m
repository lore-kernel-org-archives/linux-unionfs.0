Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:55955 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725895AbfLNL46 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 14 Dec 2019 06:56:58 -0500
Date: Sat, 14 Dec 2019 12:56:54 +0100
From: Christian Brauner <christian.brauner@ubuntu.com>
Subject: Re: [PATCH 0/1] preparatory patch for a uid/gid shifting bind mount
Message-ID: <20191214115653.sciufxtj7ynwa7vy@wittgenstein>
References: <1575148763.5563.28.camel@HansenPartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1575148763.5563.28.camel@HansenPartnership.com>
Sender: linux-unionfs-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-fsdevel@vger.kernel.org, dhowells@redhat.com, Al Viro <viro@ZenIV.linux.org.uk>, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, Seth Forshee <seth.forshee@canonical.com>, =?utf-8?B?U3TDqXBoYW5l?= Graber <stgraber@ubuntu.com>, Eric Biederman <ebiederm@xmission.com>, Aleksa Sarai <cyphar@cyphar.com>, Christian Brauner <christian.brauner@ubuntu.com>
List-ID: <linux-unionfs@vger.kernel.org>

On Sat, Nov 30, 2019 at 01:19:23PM -0800, James Bottomley wrote:
> I had another look at what it would take to reimplement shiftfs as a
> true bind mount.  It turns out we do have struct path threaded in
> almost enough places to make it work.  There really is only one API
> that needs updating and that's notify_change(), so the following patch
> fixes that and pulls do_truncate() along as well.  The updates are
> mostly smooth and pretty obvious because the path was actually already
> present, except for in overlayfs where trying to sort out what the path
> should be is somewhat of a nightmare.  If the overlayfs people could
> take a look and make sure I got it right, I'd be grateful.
> 
> I think this is the only needed change, but I've only just got a
> functional implementation of a uid/gid shifting bind mount, so there
> might be other places that need rethreading as I find deficiencies in
> the current implementation.  I'll send them along as additional patches
> if I find them

Thanks for the patch. Can you please make sure to Cc the following
people who attended the dedicated shiftfs session together with you at
LPC in Lisbon for v2? They're all major stackholders in this:

Stéphane Graber <stgraber@ubuntu.com>
Eric Biederman <ebiederm@xmission.com>
David Howells <dhowells@redhat.com>
Aleksa Sarai <cyphar@cyphar.com>
Christian Brauner <christian.brauner@ubuntu.com>

(I haven't gotten around to looking at the initial bind mount patchset
you sent out about two weeks ago. Pre-holidays it's always tricky to
find time for proper reviews...)

Christian
