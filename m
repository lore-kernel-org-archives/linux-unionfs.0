From: Josh England <jjengla@gmail.com>
Subject: Re: overlayfs: allowing for changes to lowerdir
Date: Tue, 28 Feb 2017 11:08:31 -0800
Message-ID: <CA+ZH+jE0k2hKoWTMZ2g-5vfU95OFxbW=WxGEC-umQM51vcC1gQ@mail.gmail.com>
References: <CA+ZH+jFBAaRi6VPmf3PBdDZQQMOaT6WUByATqaw1QL5M9+-dxg@mail.gmail.com>
 <CAOQ4uxiBmFdcueorKV7zwPLCDq4DE+H8x=8H1f7+3v3zysW9qA@mail.gmail.com>
 <CA+ZH+jH9yoB5_wxyff088Fsm2-g5=oO1ECimHVo7u2SKVK4AAw@mail.gmail.com> <CAOQ4uxh5OVadTPLM-jw5J_6sRKBFv0WB_CTMdy68fe3dxtYsKA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:36689 "EHLO
        mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751026AbdB1TLN (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 28 Feb 2017 14:11:13 -0500
In-Reply-To: <CAOQ4uxh5OVadTPLM-jw5J_6sRKBFv0WB_CTMdy68fe3dxtYsKA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-unionfs@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>

On Mon, Feb 27, 2017 at 2:40 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> It may be easier if you can argue for a use case which does have
> defined behavior,
> for example, lower fs has some directory subtrees that are not
> modified via overlayfs
> and only modified directry via lower fs.
> I think this *may* result in defined behavior over lower remote fs,
> but can't tell for sure.
> Anyway, you will have to argue why such a setup is useful.

My use case is actually one that involves very little (but necessary)
writes to the overlayfs, and the vast majority of changes happen
directly to the lower fs.  I maintain cluster management software that
has been used on some of the largest clusters in the world.  The
premise is to network boot and mount a shared NFS root on an
arbitrarily large number of cluster nodes.  It has always been an
annoyance to have to find the little bits and pieces in the OS (think
of a full RHEL/CentOS distro) that require the ability to write
somewhere and so we've always had to play silly tricks to get around
that.  Using a ram overlay as the upper allows these minor writes to
happen transparently and save end users massive amounts of time having
to track down and handle each one individually.

The behavior I've noted so far from this patch seems to be very well
defined and follows the rule of least surprise (at least for me).  I
can change files/directories in the shared root and the changes are
instantly visible to all clients.  If a file/directory has been copied
up on the client that change takes precedence over changes in the
lower.  Deletes work as expected.  I haven't found a downside yet.  In
fact I've bundled a release of my software that configures this mode
of operation as on option.  The given patch is included with that
release, but it would be 1000 times cleaner as a stock kernel module
parameter with no patches required.

-JE
