From: Josh England <jjengla@gmail.com>
Subject: Re: overlayfs: allowing for changes to lowerdir
Date: Wed, 1 Mar 2017 10:22:42 -0800
Message-ID: <CA+ZH+jFa=3CeE_SotGBZ6-NGQnaKiKhLPX25LAS9sRgphrWo_A@mail.gmail.com>
References: <CA+ZH+jFBAaRi6VPmf3PBdDZQQMOaT6WUByATqaw1QL5M9+-dxg@mail.gmail.com>
 <CAOQ4uxiBmFdcueorKV7zwPLCDq4DE+H8x=8H1f7+3v3zysW9qA@mail.gmail.com>
 <CA+ZH+jH9yoB5_wxyff088Fsm2-g5=oO1ECimHVo7u2SKVK4AAw@mail.gmail.com>
 <CAOQ4uxh5OVadTPLM-jw5J_6sRKBFv0WB_CTMdy68fe3dxtYsKA@mail.gmail.com>
 <CA+ZH+jE0k2hKoWTMZ2g-5vfU95OFxbW=WxGEC-umQM51vcC1gQ@mail.gmail.com> <20170228194457.GU29622@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-ot0-f194.google.com ([74.125.82.194]:35959 "EHLO
        mail-ot0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752492AbdCASXF (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 1 Mar 2017 13:23:05 -0500
In-Reply-To: <20170228194457.GU29622@ZenIV.linux.org.uk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Amir Goldstein <amir73il@gmail.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-unionfs@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>

Directory /foo/bar
Client (overlay) creates /foo/bar/biz
/foo/bar gets deleted from lower (on NFS server)
All of /foo/bar (including biz) still exists on client because it had
been copied up.

This is actually the behavior I'd expect given the nature of overlayfs.

-JE


On Tue, Feb 28, 2017 at 11:44 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Tue, Feb 28, 2017 at 11:08:31AM -0800, Josh England wrote:
>
>> The behavior I've noted so far from this patch seems to be very well
>> defined and follows the rule of least surprise (at least for me).  I
>> can change files/directories in the shared root and the changes are
>> instantly visible to all clients.  If a file/directory has been copied
>> up on the client that change takes precedence over changes in the
>> lower.  Deletes work as expected.  I haven't found a downside yet.
>
> Try to do something that invalidates a directory in underlying layer
> with stuff in overlay on its subdirectories.
