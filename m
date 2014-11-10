From: Paul Moore <paul@paul-moore.com>
Subject: Re: [PATCH 1/7] Security: Provide copy-up security hooks for unioned files
Date: Mon, 10 Nov 2014 10:28:02 -0500
Message-ID: <1598563.E145j9ZHLH@sifl>
References: <2455443.WUExuKDC0I@sifl> <20141105154228.2555.55814.stgit@warthog.procyon.org.uk> <3206.1415398234@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qg0-f52.google.com ([209.85.192.52]:64689 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752910AbaKJP2F (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Mon, 10 Nov 2014 10:28:05 -0500
Received: by mail-qg0-f52.google.com with SMTP id a108so5544287qge.39
        for <linux-unionfs@vger.kernel.org>; Mon, 10 Nov 2014 07:28:04 -0800 (PST)
In-Reply-To: <3206.1415398234@warthog.procyon.org.uk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: linux-unionfs@vger.kernel.org, selinux@tycho.nsa.gov, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org

On Friday, November 07, 2014 10:10:34 PM David Howells wrote:
> Paul Moore <paul@paul-moore.com> wrote:
> > This didn't occur to me earlier, but we may want to pick a different
> > phrase to use instead of "copy_up" as that has a special meaning for some
> > security/MLS folks...
> 
> It does?

Yep, think upgrading the sensitivity level, e.g. relabeling a "secret" file up 
to a "top secret".

> security_inode_make_union()?

Actually, after thinking on this some more, forget I mentioned anything.  The 
existing "copy_up" makes the most sense for the LSM hook (it matches the 
naming of the caller in overlayfs, which is a nice thing) and the number of 
times any MLS will look that closely at the kernel code is going to be very 
few.

-- 
paul moore
www.paul-moore.com

