From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v9 10/15] ovl: A new xattr OVL_XATTR_METACOPY for file on
 upper
Date: Mon, 8 Jan 2018 11:17:45 -0500
Message-ID: <20180108161745.GB13708@redhat.com>
References: <20171129155448.32721-1-vgoyal@redhat.com>
 <20171129155448.32721-11-vgoyal@redhat.com>
 <CAJfpegtc-63zQS+_j1sKB48fXSz63nT4hH0Q09brLWHbaC5KKg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5953 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932349AbeAHQRp (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 8 Jan 2018 11:17:45 -0500
Content-Disposition: inline
In-Reply-To: <CAJfpegtc-63zQS+_j1sKB48fXSz63nT4hH0Q09brLWHbaC5KKg@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>

On Mon, Jan 08, 2018 at 04:50:00PM +0100, Miklos Szeredi wrote:
> On Wed, Nov 29, 2017 at 4:54 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > Now we will have the capability to have upper inodes which might be only
> > metadata copy up and data is still on lower inode. So add a new xattr
> > OVL_XATTR_METACOPY to distinguish between two cases.
> 
> Maybe I missed something, but I think there's a bug in this patch:
> truncate() is a metadata+data operation since it affects results of
> read().  So it should be handled by doing the data copy-up like we did
> before.

Hi Miklos,

For truncate operation, we don't do metadata only copy up and fall back
to regular operation.

ovl_need_meta_copy_up() {
        if (flags && ((OPEN_FMODE(flags) & FMODE_WRITE) || (flags & O_TRUNC)))
                return false;

}

So behavior should not change with metacopy for truncate operation.

Am I missing something?

Thanks
Vivek
