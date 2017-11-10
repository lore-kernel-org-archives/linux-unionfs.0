From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v6 07/15] ovl: A new xattr OVL_XATTR_METACOPY for file on upper
Date: Fri, 10 Nov 2017 10:38:21 +0200
Message-ID: <CAOQ4uxjbU_3ro8tvCB5CUfXHT3C94Fmr4C_tAe_MkXwr4odBbw@mail.gmail.com>
References: <20171109205019.11409-1-vgoyal@redhat.com> <20171109205019.11409-8-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.161.194]:44148 "EHLO
        mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751994AbdKJIiW (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 10 Nov 2017 03:38:22 -0500
Received: by mail-yw0-f194.google.com with SMTP id k11so7577631ywh.1
        for <linux-unionfs@vger.kernel.org>; Fri, 10 Nov 2017 00:38:21 -0800 (PST)
In-Reply-To: <20171109205019.11409-8-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Thu, Nov 9, 2017 at 10:50 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> Now we will have the capability to have upper inodes which might be only
> metadata copy up and data is still on lower inode. So add a new xattr
> OVL_XATTR_METACOPY to distinguish between two cases.
>
> Presence of OVL_XATTR_METACOPY reflects that file has been copied up metadata
> only and and data will be copied up later from lower origin.
> So this xattr is set when a metadata copy takes place and cleared when
> data copy takes place.
>
> We also use a bit in ovl_inode->flags to cache OVL_UPPERDATA which reflects
> whether ovl inode has data or not (as opposed to metadata only copy up).
>
> Note, OVL_UPPERDATA is set only on those upper inodes which can possibly
> be metacopy only inodes. For example, inode should be a regular file and
> there needs to be a lower dentry.
>

Sorry, not buying and I bet Miklos won't buy it either.
I just introduced OVL_WHITEOUTS for directories that are non-merge
but have origin xattr, to know that we need to create dir cache using
ovl_dir_read_merged() to filter out whiteouts.

Miklos tweaked my patch to set OVL_WHITEOUTS on all merge dirs
on copy up and on lookup, so the test is uniform and doesn't need to check
if dir is eligible to OVL_WHITEOUTS.

Same logic applied to OVL_UPPERDATA: if flag is not set, need to
copy up data. If that requires another memory barrier when creating
pure upper then it is not hurting performance to add it, but I doubt that
it is needed anyway.

Amir.
