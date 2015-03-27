From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 12/15] VFS: Add owner-filesystem positive/negative dentry checks
Date: Fri, 27 Mar 2015 16:27:28 +0100
Message-ID: <CAJfpegvjFUbigpp+kj2grnp8msHmsUkT5STvPDs1Yizj_tFzUw@mail.gmail.com>
References: <20150325144330.17670.6959.stgit@warthog.procyon.org.uk>
	<20150325144524.17670.21070.stgit@warthog.procyon.org.uk>
	<CAJfpegue3OvFwxCUiRuGJxCMQV_jrtYoGoZywRz_kLykKbQU4w@mail.gmail.com>
	<12393.1427467357@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qg0-f53.google.com ([209.85.192.53]:35304 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826AbbC0P13 (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Fri, 27 Mar 2015 11:27:29 -0400
Received: by qgh3 with SMTP id 3so120676882qgh.2
        for <linux-unionfs@vger.kernel.org>; Fri, 27 Mar 2015 08:27:28 -0700 (PDT)
In-Reply-To: <12393.1427467357@warthog.procyon.org.uk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: viro@ftp.linux.org.uk, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, Kernel Mailing List <linux-kernel@vger.kernel.org>

On Fri, Mar 27, 2015 at 3:42 PM, David Howells <dhowells@redhat.com> wrote:
> Miklos Szeredi <miklos@szeredi.hu> wrote:
>
>> I think this is confusing as hell, there needs to be more consistency
>> in the naming.  E.g. d_backing_is_positive() vs. d_is_positive().   I
>> know it's the other way round now, but only with a few users.
>
> Yeah.  The problem is that all of:
>
>         __d_entry_type()
>         d_is_miss()
>         d_is_whiteout()
>         d_can_lookup()
>         d_is_autodir()
>         d_is_dir()
>         d_is_symlink()
>         d_is_reg()
>         d_is_special()
>         d_is_file()
>         d_is_negative()
>         d_is_positive()
>
> refer to the 'backing' inode (if there is one) in the case that you have a
> unionmount and the top dentry's ->d_inode is NULL.  (Well, technically, that
> doesn't happen in the case of directories)

Looks to me we actually need two variants of all of the above, since
most filesystems never want to refer to the backing inode.

>
> Of course, if we decide we aren't going to do unionmount, certain things
> become simpler.
>
>> Also a separate include file might help, that needs explicit including to
>> get the "backing" variants
>
> I would like to see a 'for fs implementer' header and a 'for fs user' header
> but Al didn't like that last time I suggested it.
>
> However, it doesn't help with the naming since there are situations where you
> need *both* - eg. overlayfs.

Not sure what you mean, the naming *must* be different even if we have
two headers and overlayfs can just include both.

Thanks,
Miklos
