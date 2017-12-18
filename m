From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: Metadata, source and security concerns (was is
 Documentation/filesystems/overlayfs.txt current?)
Date: Mon, 18 Dec 2017 10:49:27 +0200
Message-ID: <CAOQ4uxipGrfSMvJ85cn2XFu3E66T6sL55tBk7GLje1wXT4ziuQ@mail.gmail.com>
References: <5A3700C7.2010602@tlinx.org> <5A372CE1.9000906@tlinx.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb0-f174.google.com ([209.85.213.174]:38800 "EHLO
        mail-yb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757897AbdLRIt2 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 18 Dec 2017 03:49:28 -0500
Received: by mail-yb0-f174.google.com with SMTP id 129so1285404ybe.5
        for <linux-unionfs@vger.kernel.org>; Mon, 18 Dec 2017 00:49:28 -0800 (PST)
In-Reply-To: <5A372CE1.9000906@tlinx.org>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: "L. A. Walsh" <lkml@tlinx.org>
Cc: overlayfs <linux-unionfs@vger.kernel.org>

On Mon, Dec 18, 2017 at 4:50 AM, L. A. Walsh <lkml@tlinx.org> wrote:
> L A Walsh wrote:
>>
>> Re meta data source.

Let's start from the top:

> is Documentation/filesystems/overlayfs.txt current?

Probably not, but it seems up-to-date w.r.t your concerns.

> I have a concern regarding something the doc says -- that metadata is only
> taken from the upper filesystem.
>
> But if the lower file system is the only one with the meta data, how does
> it propagate?  It seems to say it won't be copied, yet aren't things
> like ACL's file owner and permission bits all metadata?  Wouldn't
> that have to come from the lower file layer?

I think you misinterpret the doc, or did not read it throughout?
"The copy_up process ... It then creates the object with the same metadata
(owner, mode, mtime, ... Finally any extended attributes are copied up."

So from where did you get the impression that metadata is not being copied?
The sentence: "These attributes of the lower directory are hidden." means
that the new (copied and maybe modified) upper metadata overrides the
original lower metadata.

What the documentation doesn't say is that there is some metadata that
is not being copied to upper, but it is not any of the metadata you mentioned.
It's file system specific flags, which are normally get/set by
lsattr(1)/chattr(1).

>
> Maybe I'm not expressing my concern clearly or maybe a different
> definition of metadata is being used?  Strictly speaking, I consider
> meta data to be any data that is NOT the data in a file (or directory)
> and would normally include ownership, permissions and extended attributes.
>
> From an ease-of-access and implementation point of view, some may not
> consider information in the inode, strictly, 'metadata', but the line
> becomes blurry when file access information is stored not only in the
> inode, but also in the, potentially separate, extended attribute area(s)
> of a file system, for example, AFAIK, AC lists are stored in extended
> attributes with some file system implementations -- especially if they
> are longer (or larger) lists.
> It seems that access information would have to be read from the lower
> file system (and, implicitly, meta data) or would otherwise be
> unavailable or ignored.  Certainly an overlay can't ignore the
> security information contained in the metadata in the lower layers and
> would have to, it seems, inspect the metadata associated with an inode
> if for no other reason to read ACL and/or fscap's set in the lower
> filesystem.
> I don't see any mention of how setuid/setgid bits are set, but one would
> assume that if such are supported, then FS-based capabilities would
> also need to be read from the lower filesystem.

There may be bugs with setuid/setgid/ACL, but they should work as
expected, see:
fd3220d37b1f ovl: update S_ISGID when setting posix ACLs

I don't know about fs capabilities, because I don't use those.
Do you have any specific use case that is not working or are those
theoretical concerns?


> It _may_ not be necessary, but it seems prudent, that the upper level
> file system would (or should?) have the same "features" as the lower
> file system so a merged-view would be consistent with the isolated view
> of the lower filesystem, no?  It seems it would be problematic if the
> upper filesystem didn't support the same features as the lower.
>
> Could it be clarified if the overlayfs ignores lower FS metadata like
> ACL's and set-capability info?
>

All xattrs are copied from lower to upper with the exception of overlayfs
private xattr (trusted.overlay.*). Does that answer your question?

If you feel that documentation is not clear on that point, please feel free
to submit a patch to improve documentation, although I must that on
the specific concern you raised, I personally find the documentation adequate.

Thanks,
Amir.
