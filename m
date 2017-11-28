From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [RFC PATCH v8 00/15] overlayfs: Delayed copy up of data
Date: Tue, 28 Nov 2017 19:04:33 +0200
Message-ID: <CAOQ4uxidkS6=M9M55Tss1mWQdxdvSp0ZLQ5_5XtUqZhiSr_FhA@mail.gmail.com>
References: <20171128155959.20114-1-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb0-f176.google.com ([209.85.213.176]:37857 "EHLO
        mail-yb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750835AbdK1REf (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 28 Nov 2017 12:04:35 -0500
Received: by mail-yb0-f176.google.com with SMTP id 5so224819ybp.4
        for <linux-unionfs@vger.kernel.org>; Tue, 28 Nov 2017 09:04:35 -0800 (PST)
In-Reply-To: <20171128155959.20114-1-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Tue, Nov 28, 2017 at 5:59 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> Hi,
>
> Here is the V8 of the patches. Primarily I have taken care of comments
> from Amir.
>
> This applies on top of the fix I posted with subject "ovl: Pass
> ovl_get_nlink() parameters in right order"
>
> Amir, I have added one more patch int series where I pass index dentry
> to ovl_get_nlink() to get rid of a warning during testing.
>
> I think only outstanding concern with this patch series now is how to
> detect that metacopy feature was ever enabled and there are some
> metacopy only files present. In that case we probably don't want to
> allow user to mount with metacopy=off. We currently don't seem to have
> a generic infrastructure which keeps track of features and backward
> compatibility stuff etc. Discussion still seems to be on upstream.
>
> Is this a blocker for this patch series or this is something we can
> live with? Only downside of mounting a file system which has metacopied
> files (with metacopy=off), is that user will see truncated files.

IMO it is fine to mount with metacopy=off, but user should not see
truncated file. IMO if metacopy=off, overlayfs still needs to copy up
data from origin if origin can be decoded and if origin cannot be decoded
user should get -EIO.
Mounting an overlayfs with metacopies with kernel that does not support
metacopy will have unexpected results, same as with redirect_dir.

Amir.
