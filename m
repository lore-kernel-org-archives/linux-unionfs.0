From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v7 11/14] ovl: Set OVL_UPPERDATA flag during ovl_lookup()
Date: Fri, 17 Nov 2017 11:22:01 +0200
Message-ID: <CAOQ4uxjaGUWJw47BCez2EECCKv6qjNKFtXRWS8hBAcp-F89hbA@mail.gmail.com>
References: <20171116220335.13448-1-vgoyal@redhat.com> <20171116220335.13448-12-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb0-f196.google.com ([209.85.213.196]:34688 "EHLO
        mail-yb0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757449AbdKQJWC (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 17 Nov 2017 04:22:02 -0500
Received: by mail-yb0-f196.google.com with SMTP id k40so475729ybj.1
        for <linux-unionfs@vger.kernel.org>; Fri, 17 Nov 2017 01:22:01 -0800 (PST)
In-Reply-To: <20171116220335.13448-12-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Fri, Nov 17, 2017 at 12:03 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> During lookup, check for presence of OVL_XATTR_METACOPY and if not present,
> set OVL_UPPERDATA bit in flags. This is only done for upper inode with a
> corresponding lower dentry and file needs to be a regular file. Basically
> any file which is eligible for metadata only copy up.

It is not completely clear that "this is only done" refers to the
xattr check and
not to setting the flag. Suggest to add text like this:

"... For the rest of the files, OVL_UPPERDATA flag is set unconditionally
if upper inode exists."

>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Reviewed-by: Amir Goldstein <amir73il@gmail.com>
