From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [RFC PATCH v8 00/15] overlayfs: Delayed copy up of data
Date: Tue, 28 Nov 2017 13:22:01 -0500
Message-ID: <20171128182200.GE4101@redhat.com>
References: <20171128155959.20114-1-vgoyal@redhat.com>
 <CAOQ4uxidkS6=M9M55Tss1mWQdxdvSp0ZLQ5_5XtUqZhiSr_FhA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43360 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751781AbdK1SWB (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 28 Nov 2017 13:22:01 -0500
Content-Disposition: inline
In-Reply-To: <CAOQ4uxidkS6=M9M55Tss1mWQdxdvSp0ZLQ5_5XtUqZhiSr_FhA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Tue, Nov 28, 2017 at 07:04:33PM +0200, Amir Goldstein wrote:
> On Tue, Nov 28, 2017 at 5:59 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > Hi,
> >
> > Here is the V8 of the patches. Primarily I have taken care of comments
> > from Amir.
> >
> > This applies on top of the fix I posted with subject "ovl: Pass
> > ovl_get_nlink() parameters in right order"
> >
> > Amir, I have added one more patch int series where I pass index dentry
> > to ovl_get_nlink() to get rid of a warning during testing.

Amir, can you please have a look at patch 1 in the series. That's new patch
as compared to V7.

> >
> > I think only outstanding concern with this patch series now is how to
> > detect that metacopy feature was ever enabled and there are some
> > metacopy only files present. In that case we probably don't want to
> > allow user to mount with metacopy=off. We currently don't seem to have
> > a generic infrastructure which keeps track of features and backward
> > compatibility stuff etc. Discussion still seems to be on upstream.
> >
> > Is this a blocker for this patch series or this is something we can
> > live with? Only downside of mounting a file system which has metacopied
> > files (with metacopy=off), is that user will see truncated files.
> 
> IMO it is fine to mount with metacopy=off, but user should not see
> truncated file. IMO if metacopy=off, overlayfs still needs to copy up
> data from origin if origin can be decoded and if origin cannot be decoded
> user should get -EIO.

Right. That's the current behavior with the patch. I forgot to mention
that user will see truncated files only with old kernels.

> Mounting an overlayfs with metacopies with kernel that does not support
> metacopy will have unexpected results, same as with redirect_dir.

Right. As of now old kernel should see truncated files.

Vivek
