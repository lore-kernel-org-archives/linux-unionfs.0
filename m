From: Tycho Andersen <tycho@tycho.ws>
Subject: Re: [PATCH v2 2/3] fs: introduce uid/gid shifting bind mount
Date: Fri, 17 Jan 2020 13:19:40 -0800
Message-ID: <20200117211940.GA22062@cisco>
References: <20200104203946.27914-1-James.Bottomley@HansenPartnership.com>
 <20200104203946.27914-3-James.Bottomley@HansenPartnership.com>
 <20200113034149.GA27228@mail.hallyn.com>
 <1579112360.3249.17.camel@HansenPartnership.com>
 <20200116064430.GA32763@mail.hallyn.com>
 <1579192173.3551.38.camel@HansenPartnership.com>
 <20200117154402.GA16882@mail.hallyn.com>
 <1579278342.3227.36.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-pj1-f65.google.com ([209.85.216.65]:32883 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726752AbgAQVTn (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 17 Jan 2020 16:19:43 -0500
Received: by mail-pj1-f65.google.com with SMTP id u63so4506794pjb.0
        for <linux-unionfs@vger.kernel.org>; Fri, 17 Jan 2020 13:19:43 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1579278342.3227.36.camel@HansenPartnership.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Miklos Szeredi <miklos@szeredi.hu>, containers@lists.linux-foundation.org, linux-unionfs@vger.kernel.org, David Howells <dhowells@redhat.com>, Seth Forshee <seth.forshee@canonical.com>, Eric Biederman <ebiederm@xmission.com>, linux-fsdevel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>

On Fri, Jan 17, 2020 at 08:25:42AM -0800, James Bottomley wrote:
> On Fri, 2020-01-17 at 09:44 -0600, Serge E. Hallyn wrote:
> > On Thu, Jan 16, 2020 at 08:29:33AM -0800, James Bottomley wrote:
> > I guess I figured we would have privileged task in the owning
> > namespace (presumably init_user_ns) mark a bind mount as shiftable 
> 
> Yes, that's what I've got today in the prototype.  It mirrors the
> original shiftfs mechanism.  However, I have also heard people say they
> want a permanent mark, like an xattr for this.

Please, no. mount() failures are already hard to reason about, I would
rather not add another temporary (or worse, permanent) non-obvious
failure mode.

What if we make shifted bind mounts always readonly? That will force
people to use an overlay (or something else) on top, but they probably
want to do that anyway so they can avoid tainting the original
container image with writes.

> > Oh - I consider the detail of whether we pass a userid or userns nsfd
> > as more of an implementation detail which we can hash out after the
> > more general shift-mount api is decided upon.  Anyway, passing nsfds
> > just has a cool factor :)
> 
> Well, yes, won't aruge on the cool factor-ness.

It's not just the cool factor: if you're doing this, it's presumably
because you want to use it with a container in a user namespace.
Specifying the same parameters twice leaves room for error, causing
CVEs and more work.

Tycho
