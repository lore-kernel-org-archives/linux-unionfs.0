From: "L. A. Walsh" <lkml@tlinx.org>
Subject: Re: Metadata,  source and security concerns (was is Documentation/filesystems/overlayfs.txt
 current?)
Date: Sun, 17 Dec 2017 18:50:09 -0800
Message-ID: <5A372CE1.9000906@tlinx.org>
References: <5A3700C7.2010602@tlinx.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from ishtar.tlinx.org ([173.164.175.65]:38656 "EHLO
        Ishtar.sc.tlinx.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753105AbdLRCuM (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 17 Dec 2017 21:50:12 -0500
Received: from [192.168.3.12] (Athenae [192.168.3.12])
        by Ishtar.sc.tlinx.org (8.14.7/8.14.4/SuSE Linux 0.8) with ESMTP id vBI2o9RI004664
        for <linux-unionfs@vger.kernel.org>; Sun, 17 Dec 2017 18:50:11 -0800
In-Reply-To: <5A3700C7.2010602@tlinx.org>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: overlayfs <linux-unionfs@vger.kernel.org>

L A Walsh wrote:
> Re meta data source.
Maybe I'm not expressing my concern clearly or maybe a different
definition of metadata is being used?  Strictly speaking, I consider
meta data to be any data that is NOT the data in a file (or directory)
and would normally include ownership, permissions and extended attributes.

 From an ease-of-access and implementation point of view, some may not
consider information in the inode, strictly, 'metadata', but the line
becomes blurry when file access information is stored not only in the
inode, but also in the, potentially separate, extended attribute area(s)
of a file system, for example, AFAIK, AC lists are stored in extended
attributes with some file system implementations -- especially if they
are longer (or larger) lists. 

It seems that access information would have to be read from the lower
file system (and, implicitly, meta data) or would otherwise be
unavailable or ignored.  Certainly an overlay can't ignore the
security information contained in the metadata in the lower layers and
would have to, it seems, inspect the metadata associated with an inode
if for no other reason to read ACL and/or fscap's set in the lower
filesystem. 

I don't see any mention of how setuid/setgid bits are set, but one would
assume that if such are supported, then FS-based capabilities would
also need to be read from the lower filesystem. 

It _may_ not be necessary, but it seems prudent, that the upper level
file system would (or should?) have the same "features" as the lower
file system so a merged-view would be consistent with the isolated view
of the lower filesystem, no?  It seems it would be problematic if the
upper filesystem didn't support the same features as the lower.

Could it be clarified if the overlayfs ignores lower FS metadata like
ACL's and set-capability info?
