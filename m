Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B0E843C05F;
	Thu, 30 Jul 2026 13:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785419866; cv=none; b=Z7CJiyOznFBWZXp9TJO4YuM76F+KQS1UBNqz8LQ+sNV2yQJIHara/yKim4V+aB/s0sN722kKU2Aq9sJju692pxKr02NMgMxNCY0RhxYVqQTq8SW4keQm2eZbZrXbKjT1MVzCb+URw/+zGFDSup+MzA6TYKywpOASs8u2CcdKGX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785419866; c=relaxed/simple;
	bh=2oUqXrJBrUSAW81GOPAYq1YFLd+s+3pMz3/WFFP9Uq4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PbW/1XAPgi3JQwia8s2KvUntJ32Ugo1uU3rn3+/dXiSZnrYCTrclG/ZsdxvWiKpY0g1KPBJagYraMhy27S1X2dIDFeZHKRzMGz5/vhTSAOPnOlxnpt028bsSN26RQ79ZsjkAnkKXBlcU58i4eWhlcdErob5YFpN6qB6Tm5JFBVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LQdH+7OV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LQdH+7OV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C50981F000E9;
	Thu, 30 Jul 2026 13:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785419863;
	bh=Oz4ni0SjIgyNOKjMms23AjFfChPcr687pUNnZOhDNiU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LQdH+7OVwpD5K5PFll7+cMZ/zkdcnC8rrqvUd5QCrSMPMFLsaTjY4JD8IvC/k+lL0
	 M5h/ls8lB70tE8dGkOcBsuafwnLo26cXwEQCiZc7+stA3uq2wHgQnr8rDvq3y4uFX+
	 o8t3Sl6slP5vlNAiJmoP5e2KKXhUrfrpAOD7T8f/cLKM/Bs7Xxd1U4QfsK57ZBUy0w
	 EZQ+hqgfJOu5NwLpvr2FXM/AS/Ca27liMWuzIyt88onqnqoX/w1pO4wbUuNk1ng6wd
	 D/bW9TlMRWV+MxQJJL3SdMXzJnPoQT0Ms/vbObQfOUvIf2yO6FX4eb8EUNQA2OB8Mw
	 B6+11xIphVEeg==
Date: Thu, 30 Jul 2026 15:57:39 +0200
From: Christian Brauner <brauner@kernel.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Miklos Szeredi <mszeredi@redhat.com>, 
	Giuseppe Scrivano <gscrivan@redhat.com>, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	linux-api@vger.kernel.org, linux-erofs@lists.ozlabs.org, 
	Amir Goldstein <amir73il@gmail.com>, Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: Re: [RFC PATCH] fs: allow opening overlayfs/erofs layers through
 O_ALT
Message-ID: <20260730-abwesend-raumgewinn-teppich-12ac54467d14@brauner>
References: <20260715101107.973997-1-mszeredi@redhat.com>
 <20260722-fundort-zogen-kormoran-09fb867f1b59@brauner>
 <CALCETrU9KdLsvZzUE-5sh7KkP5-cPh=hwErGmN=THsDatFJLfA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALCETrU9KdLsvZzUE-5sh7KkP5-cPh=hwErGmN=THsDatFJLfA@mail.gmail.com>

On Wed, Jul 22, 2026 at 09:29:22AM -0700, Andy Lutomirski wrote:
> On Wed, Jul 22, 2026 at 9:06 AM Christian Brauner <brauner@kernel.org> wrote:
> 
> > Like I said before: I'm fine with an API where we can use open_tree() to
> > see through into underlying layers, and given the right permission pull
> > a mount out of it. That is a narrow, checkable primitive and it needs
> > none of this. No new open flag, no second ->show_options, no metafs, no
> > mnt_devname surgery. That part we can potentially do.
> 
> What, exactly, do you mean as the distinction between "[seeing]
> through into underlying layers" and "[pulling] a mount out of it".  I
> have a guess, but I'm not convinced that my guess is right.

Two operations that the proposal merges into one.

Seeing through is introspection. You want to know that the overlay has
three lower layers, that lower[0] is an erofs, which image it came
from, what its fsid is. That's information. It should come back as
data, from statmount(), the way every other mount property does. It
hands out no new reachability, so it needs no new permission model, and
it's roughly what Amir is arguing for in this thread. I think he's
right that this half covers most of the actual use case.

Pulling a mount out is acquisition. You want a usable mount for that
lower layer. That's a capability transfer and the layer is an internal
mount with no mountpoint anywhere, and afterwards you can walk it. That
needs to be an explicit, privileged operation with a single call site,
and what it hands back should be a detached mount fd, which is exactly
what open_tree(OPEN_TREE_CLONE) already gives you. Same lifetime rules,
same move_mount() to attach it, nothing new to reason about.

The reason to keep them apart is that they have entirely different
security answers, and merging them into one path walk is precisely what
forces "whose creds" to be answered per node instead of once. Split,
the introspection half never has to ask, and the acquisition half
answers it at the top, before anything is reachable.

And neither half needs O_ALT. Introspection is statmount() with more
fields. Acquisition is a flag on open_tree()/open_tree_attr(), or an
operation on a mount fd. No new resolution mode, no second namespace
hanging off every fd, nothing for a symlink to accidentally point into.
That is the whole of my objection to the RFC, and dropping the mount
options half doesn't address any of it.

Which I think is close to your capability-fd sketch minus the tree. You
wanted privilege captured by the call that hands you the fd rather than
rechecked on use. If the only thing that call returns is a mount fd,
that's already how it behaves. And we don't have to invent a per-node
cred model or a new set of rules about what a dirfd is and isn't
allowed to do.

Giuseppe, this is also your requirement. What you actually
need is something persistable, so a restarted daemon can find the erofs
mount again without anyone having to hold an fd open for it. That's the
introspection half producing a stable identifier and the acquisition
half consuming one. Much narrower to specify than a generic metadata
tree, and it doesn't require settling anything about O_ALT first.

> Other than that question, I think I generally agree with you.  The
> interesting operations here (getting an fd to something that was
> previously inaccessible) are different enough from normal path lookups
> that I think they deserve to be explicit syscalls or syscall modes,
> not magic links.

Yes.
