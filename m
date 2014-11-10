From: Paul Moore <paul@paul-moore.com>
Subject: Re: [PATCH 2/7] Overlayfs: Use copy-up security hooks
Date: Mon, 10 Nov 2014 10:45:37 -0500
Message-ID: <3253042.xfZ6VF8OvX@sifl>
References: <4109261.WfcAOoSvNG@sifl> <20141105154238.2555.85960.stgit@warthog.procyon.org.uk> <3148.1415397940@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qc0-f179.google.com ([209.85.216.179]:32943 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbaKJPpl (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Mon, 10 Nov 2014 10:45:41 -0500
Received: by mail-qc0-f179.google.com with SMTP id o8so5764975qcw.38
        for <linux-unionfs@vger.kernel.org>; Mon, 10 Nov 2014 07:45:40 -0800 (PST)
In-Reply-To: <3148.1415397940@warthog.procyon.org.uk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: linux-unionfs@vger.kernel.org, selinux@tycho.nsa.gov, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org

On Friday, November 07, 2014 10:05:40 PM David Howells wrote:
> Paul Moore <paul@paul-moore.com> wrote:
> > So the LSM must modify the xattr in place?  I suppose that since the
> > @value is allocated to the max size it shouldn't be a problem.  Just
> > checking ...
> 
> ... And the caller must provide a maximally sized buffer (which it likely
> has to allocate anyway).
> 
> I'm not sure I really need to provide the modification thing.  I suspect a
> binary keep or discard decision is sufficient.

The docker use case we've been talking about in this thread doesn't really 
care about the on-disk file labels (xattrs) because the docker folks want to 
use context= mounts; however if someone did care about on-disk file labels for 
the upper layer in the overlayfs then they might want to modify the xattr.

-- 
paul moore
www.paul-moore.com

