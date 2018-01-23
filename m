From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v10 07/18] ovl: Add mechanism to create a chain of origin
 dentries
Date: Tue, 23 Jan 2018 08:40:18 -0500
Message-ID: <20180123134018.GB2755@redhat.com>
References: <20180122184004.26026-1-vgoyal@redhat.com>
 <20180122184004.26026-8-vgoyal@redhat.com>
 <CAOQ4uxiAbz479QygqeJGcbZdO2y1apJo3SqXAXby05c9z2Q85Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50004 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751318AbeAWNkT (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 23 Jan 2018 08:40:19 -0500
Content-Disposition: inline
In-Reply-To: <CAOQ4uxiAbz479QygqeJGcbZdO2y1apJo3SqXAXby05c9z2Q85Q@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Mon, Jan 22, 2018 at 09:34:20PM +0200, Amir Goldstein wrote:
> On Mon, Jan 22, 2018 at 8:39 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > There is a need to support metacopy dentry in midlayer. That means there
> > could be a chain of metacopy dentries.
> >
> > For example, upper could be metacopy, midlayer lower could be metacopy and
> > lowest layer could be actual data inode. This means when we copy up actual
> > data, we should be able to reach to lowest data inode and copy up data from
> > there. And that means we should keep track of all the dentries in origin
> > chain which lead to data inode.
> >
> > Current ovl_check_origin() logic only looks for one origin dentry. This patch
> > enhances ovl_check_origin() to continue to follow origin chain and return
> > all the origin entries found. This is done only if caller of the function
> > set "follow_chain" argument.
> >
> 
> We don't really need to keep the entire chain do we?
> We can follow chain but keep only the one inode that is not a metacopy inode.
> All the rest are useless, no?
> Then we don't create a new type of object - non-dir with numlower > 1.

Hi Amir,

I think we will have to keep atleast 2. One is actual data inode and
other is top most lower metacopy inode. This top most metacopy inode
will be used for copy up operation and upper file will use this metadata.
We can't use metadata of data inode.

Vivek
